//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Luke Yeo on 4/5/22.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import SDWebImage
import FirebaseCore
import FirebaseDatabase

final class OtherUserViewController: UIViewController {
    
    var chingchenghanji: DatabaseReference! = Database.database().reference()
    
    var pfpEmail: String = ""
    var otherUserName: String = ""
    var otherUserBio = ""
    
    var data = [ProfileViewModel]()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    init(with otherUserEmail: String, name: String, bio: String) {
        pfpEmail = otherUserEmail
        otherUserName = name
        otherUserBio = bio
        print(otherUserBio)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About"
        view.addSubview(tableView)
        getUserBio()
        view.backgroundColor = .systemBackground
        
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        data.append(ProfileViewModel(viewModelType: .info, title: "Name: \(otherUserName)", handler: nil))
        data.append(ProfileViewModel(viewModelType: .info, title: "About: \((otherUserBio))", handler: nil))
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
    }
    
    func getUserBio() {
        chingchenghanji.child("\(DatabaseManager.safeEmail(emailAddress: pfpEmail))").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.otherUserBio = value?["bio"] as? String ?? "nil"
            print(self.otherUserBio)
            
            // ...
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func createTableHeader() -> UIView? {
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: pfpEmail)
        let filename = safeEmail + "_profile_picture.png"
        
        let path = "images/"+filename
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 150))
        
        headerView.backgroundColor = .systemBackground
        
        let imageView = UIImageView(frame: CGRect(x: (headerView.width-150) / 2, y: 0, width: 150, height: 150))
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width/2
        headerView.addSubview(imageView)
        
        StorageManager.shared.downloadUrl(for: path, completion: { result in
            switch result {
            case.success(let url):
                imageView.sd_setImage(with: url, completed: nil)
            case.failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
        
        return headerView
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
}

extension OtherUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
        cell.setUp(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        data[indexPath.row].handler?()
    }
    
}
