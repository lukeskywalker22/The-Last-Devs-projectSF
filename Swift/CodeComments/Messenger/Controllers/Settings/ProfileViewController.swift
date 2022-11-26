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

final class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [ProfileViewModel]()
    var db: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = [ProfileViewModel]()
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        
        data.append(ProfileViewModel(viewModelType: .info, title: "Name: \(UserDefaults.standard.value(forKey: "name") as? String ?? "No name")", handler: nil))
        data.append(ProfileViewModel(viewModelType: .info, title: "Email: \(UserDefaults.standard.value(forKey: "email") as? String ?? "No email")", handler: nil))
        data.append(ProfileViewModel(viewModelType: .userData, title: "Bio: \(UserDefaults.standard.value(forKey: "bio") as? String ?? "No Bio")", handler: {
            
            let editAlert = UIAlertController(title: "Edit user data", message: "Enter new bio", preferredStyle: .alert)
            editAlert.addTextField()
            let cancel = UIAlertAction(title: "Cancel", style: .destructive)
            let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                let newBio = editAlert.textFields?[0]
                print(newBio?.text ?? "")
                self.db.child("\(DatabaseManager.safeEmail(emailAddress: UserDefaults.standard.value(forKey: "email") as! String))").updateChildValues(["bio": newBio?.text ?? ""])
                UserDefaults.standard.set(newBio?.text ?? "", forKey: "bio")
                self.viewDidLoad()
                self.reloadBioCell(index: 2)
            })
            editAlert.addAction(cancel)
            editAlert.addAction(confirm)
            self.present(editAlert, animated: true)
        }))
        data.append(ProfileViewModel(viewModelType: .info, title: "Occupation: \(UserDefaults.standard.value(forKey: "occupation") ?? "No occupation")", handler: nil))
        data.append(ProfileViewModel(viewModelType: .userData, title: "Coding Language: \(UserDefaults.standard.value(forKey: "codingLanguage") ?? "No coding language")", handler: {
            let editAlert = UIAlertController(title: "Edit user data", message: "Enter new coding language", preferredStyle: .alert)
            editAlert.addTextField()
            let cancel = UIAlertAction(title: "Cancel", style: .destructive)
            let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                let newCodingLanguage = editAlert.textFields?[0]
                print(newCodingLanguage?.text ?? "")
                self.db.child("\(DatabaseManager.safeEmail(emailAddress: UserDefaults.standard.value(forKey: "email") as! String))").updateChildValues(["codingLanguage": newCodingLanguage?.text ?? ""])
                UserDefaults.standard.set(newCodingLanguage?.text ?? "", forKey: "codingLanguage")
                self.viewDidLoad()
                self.reloadCodingLangCell(index: 4)
            })
            editAlert.addAction(cancel)
            editAlert.addAction(confirm)
            self.present(editAlert, animated: true)
        }))
        data.append(ProfileViewModel(viewModelType: .logout, title: "Log Out", handler: { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] _ in
                
                guard let strongSelf = self else {
                    return
                }
                
                UserDefaults.standard.setValue(nil, forKey: "email")
                UserDefaults.standard.setValue(nil, forKey: "name")
                
                FBSDKLoginKit.LoginManager().logOut()
                
                GIDSignIn.sharedInstance()?.signOut()
                
                do {
                    try FirebaseAuth.Auth.auth().signOut()
                    
                    let vc = LoginViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    strongSelf.present(nav, animated: true)
                }
                catch {
                    print("Failed to log out")
                }
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            strongSelf.present(actionSheet, animated: true)
        }))
        data.append(ProfileViewModel(viewModelType: .button, title: "Change password", handler: {
            let user = Auth.auth().currentUser
            
            let authAlert = UIAlertController(title: "Authentication", message: "Re-enter account password", preferredStyle: .alert)
            authAlert.addTextField{(textField:UITextField) in
                textField.placeholder = "Current Password"
            }
            authAlert.addTextField{(textField:UITextField) in
                textField.placeholder = "New Password"
            }
            let cancel = UIAlertAction(title: "Cancel", style: .destructive)
            let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                var credential = EmailAuthProvider.credential(withEmail: UserDefaults.standard.value(forKey: "email") as! String, password: (authAlert.textFields?[0].text)!)
                var newPassword = authAlert.textFields?[1].text
                /*user?.reauthenticate(with: credential) { error, _  in
                 if let error = error {
                 print("error authenticating user")
                 print("user: \(credential)")
                 print(error)
                 } else {
                 print("authentication successful")
                 }
                 }*/
                Auth.auth().currentUser?.updatePassword(to: newPassword!) { (error) in
                    print(error)
                }
                
                let successAlert = UIAlertController(title: "Success", message: "Password successfully changed", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .destructive)
                successAlert.addAction(ok)
                self.present(successAlert, animated: true
                )
            })
            authAlert.addAction(cancel)
            authAlert.addAction(confirm)
            self.present(authAlert, animated: true)
        }))
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
    }
    
    func reloadBioCell(index: Int) {
        print("reloading cell...")
        data.remove(at: index)
        data.insert(ProfileViewModel(viewModelType: .userData, title: "Bio: \(UserDefaults.standard.value(forKey: "bio") as? String ?? "No Bio")", handler: {
            
            let editAlert = UIAlertController(title: "Edit user data", message: "Enter new bio", preferredStyle: .alert)
            editAlert.addTextField()
            let cancel = UIAlertAction(title: "Cancel", style: .destructive)
            let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                let newBio = editAlert.textFields?[0]
                print(newBio?.text ?? "")
                self.db.child("\(DatabaseManager.safeEmail(emailAddress: UserDefaults.standard.value(forKey: "email") as! String))").updateChildValues(["bio": newBio?.text ?? ""])
                UserDefaults.standard.set(newBio?.text ?? "", forKey: "bio")
                self.reloadBioCell(index: 2)
            })
            editAlert.addAction(cancel)
            editAlert.addAction(confirm)
            self.present(editAlert, animated: true)
        }), at: index)
        tableView.reloadData()
    }
    
    func reloadCodingLangCell(index: Int) {
        print("reloading cell...")
        data.remove(at: index)
        data.insert(ProfileViewModel(viewModelType: .userData, title: "Coding Language: \(UserDefaults.standard.value(forKey: "codingLanguage") ?? "No coding language")", handler: {
            let editAlert = UIAlertController(title: "Edit user data", message: "Enter new coding language", preferredStyle: .alert)
            editAlert.addTextField()
            let cancel = UIAlertAction(title: "Cancel", style: .destructive)
            let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                let newCodingLanguage = editAlert.textFields?[0]
                print(newCodingLanguage?.text ?? "")
                self.db.child("\(DatabaseManager.safeEmail(emailAddress: UserDefaults.standard.value(forKey: "email") as! String))").updateChildValues(["codingLanguage": newCodingLanguage?.text ?? ""])
                UserDefaults.standard.set(newCodingLanguage?.text ?? "", forKey: "codingLanguage")
                self.viewDidLoad()
                self.reloadCodingLangCell(index: 4)
            })
            editAlert.addAction(cancel)
            editAlert.addAction(confirm)
            self.present(editAlert, animated: true)
        }), at: index)
        tableView.reloadData()
    }
    
    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
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
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
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

class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileTableViewCell"
    
    public func setUp(with viewModel: ProfileViewModel) {
        textLabel?.text = viewModel.title
        
        switch viewModel.viewModelType {
        case .info:
            textLabel?.textAlignment = .left
            selectionStyle = .none
            textLabel?.textColor = .white
            accessoryType = .none
        case .logout:
            textLabel?.textColor = .red
            textLabel?.textAlignment = .center
            accessoryType = .none
        case .button:
            textLabel?.textColor = .link
            textLabel?.textAlignment = .center
            accessoryType = .none
        case .userData:
            textLabel?.textColor = .white
            textLabel?.textAlignment = .left
            accessoryType = .disclosureIndicator
        }
    }
    
}
