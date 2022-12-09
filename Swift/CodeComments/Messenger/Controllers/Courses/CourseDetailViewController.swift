//
//  CourseDetailViewController.swift
//  Pods
//
//  Created by Luke Yeo on 3/12/22.
//

import UIKit

class CourseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var conversations = [Conversation]()
    
    var imageName = ""
    var courseTitle = ""
    var courseDetail = ""
    
    var courseMaterials = ["main.dart", "pubspec.yaml"]
    
    @IBOutlet weak var addMaterialButton: UIButton!
    
    @IBOutlet weak var materialsTableView: UITableView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    func startListeningForConversations() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        print("starting conversation fetch... ")
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] result in
            switch result {
            case .success(let conversations):
                
                print("successfully obtained conversation models")
                self?.conversations = conversations
                
            case .failure(let error):
                print("failed to get convos: \(error)")
            }
        })
    }
    
    @IBAction func showPeople(_ sender: Any) {
        let vc = CourseAdminsViewController()
        vc.query = courseTitle
        vc.completion = { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            let currentConversations = self?.conversations
                        
            if let targetConversation = currentConversations?.first(where: {
                $0.otherUserEmail == DatabaseManager.safeEmail(emailAddress: result.email)
            }) {
                print("fetching details")
                let vc = ChatViewController(with: targetConversation.otherUserEmail, id: targetConversation.id)
                vc.isNewConversation = false
                vc.title = targetConversation.name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                print("showing chat")
            } else {
                ConversationsViewController().createNewConversation(result: result)
            }
            
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(imageName)
        coverImage.image = UIImage(named: imageName)
        titleLabel.text = courseTitle
        detailLabel.text = courseDetail
        materialsTableView.delegate = self
        materialsTableView.dataSource = self
        
        startListeningForConversations()
        
        if UserDefaults.standard.value(forKey: "occupation") as! String == "teacher" {
            addMaterialButton.isHidden = false
            settingsButton.isHidden = false
        } else {
            addMaterialButton.isHidden = true
            settingsButton.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseMaterials.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "amogus", for: indexPath)
        cell.textLabel?.font = .systemFont(ofSize: 18)
        cell.textLabel?.text = courseMaterials[indexPath.row]
        return cell

    }
    
}
