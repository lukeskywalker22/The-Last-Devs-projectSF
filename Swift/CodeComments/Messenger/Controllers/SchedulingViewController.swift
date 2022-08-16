//
//  SchedulingViewController.swift
//  Messenger
//
//  Created by Luke Yeo on 6/8/22.
//

import EventKitUI
import EventKit
import WebKit
import UIKit

class SchedulingViewController: UIViewController, EKEventEditViewDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    let store = EKEventStore()
    
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true)
        presentCalendarDone()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        // Do any additional setup after loading the view.
        
        let myURL = URL(string:"https://www.icloud.com/calendar")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.frame = view.bounds
        
    }
    
    @objc func didTapAdd() {
        
        store.requestAccess(to: .event, completion: { [weak self] success, error in
            if success, error == nil {
                DispatchQueue.main.async {
                    guard let store = self?.store else { return }
                    
                    let newEvent = EKEvent(eventStore: store)
                    newEvent.title = ""
                    newEvent.startDate = Date()
                    newEvent.endDate = Date()
                    
                    let vc = EKEventEditViewController()
                    vc.editViewDelegate = self
                    vc.eventStore = store
                    vc.event = newEvent
                    self?.present(vc, animated: true)
                }
            }
        })
    }
    
    func presentCalendarDone() {
        let calendarAdded = UIAlertController(title: "Done", message: "Class scheduled successfully", preferredStyle: .alert)
        let done = UIAlertAction(title: "OK", style: .destructive)
        calendarAdded.addAction(done)
        present(calendarAdded, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
