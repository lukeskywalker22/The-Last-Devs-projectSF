//
//  UserGuideViewController.swift
//  Messenger
//
//  Created by Luke Yeo on 8/8/22.
//

import UIKit
import WebKit

class UserGuideViewController: UIViewController {

    private let memeView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string: "https://tinyurl.com/rickroll")!
        let myRequest = URLRequest(url: myURL)
        view.addSubview(memeView)
        memeView.load(myRequest)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        memeView.frame = CGRect(x: view.center.x, y: view.center.y, width: view.width, height: view.height - 30)
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
