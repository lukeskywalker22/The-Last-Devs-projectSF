//
//  CourseAdminsViewController.swift
//  CodeComments
//
//  Created by Luke Yeo on 8/12/22.
//

import UIKit
import JGProgressHUD

class CourseAdminsViewController: UIViewController {

    public var query = ""
    
    public var completion: ((SearchResult) -> (Void))?
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var users = [[String: String]]()
    
    private var results = [SearchResult]()
    
    private var hasFetched = false
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(NewConversationCell.self, forCellReuseIdentifier: NewConversationCell.identifier)
        return table
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResultsLabel)
        view.addSubview(tableView)
        self.title = query
        tableView.delegate = self
        tableView.dataSource = self
    
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        
        searchUsersByLanguage(query: query)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultsLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CourseAdminsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: NewConversationCell.identifier, for: indexPath) as! NewConversationCell
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetUserData = results[indexPath.row]
        
        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(targetUserData)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension CourseAdminsViewController: UISearchBarDelegate {
    
    func searchUsersByLanguage(query: String) {
        
        if hasFetched {
            //if it does filter
            filterUsersByLanguage(with: query)
        }
        else {
            //if not fetch then filter
            DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
                switch result {
                case.success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsersByLanguage(with: query)
                case .failure(let error):
                    print("failed to get users: \(error)")
                }
            })
        }
    }
    
    func filterUsers(with term: String) {
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String, hasFetched else {
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        
        spinner.dismiss()
        
        let results: [SearchResult] = users.filter({
            guard let email = $0["email"],
                  email != safeEmail else {
                return false
            }
            
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            
            return name.hasPrefix(term.lowercased())
        }).compactMap({
            guard let email = $0["email"], let name = $0["name"], let bio = $0["bio"], let codingLanguage = $0["codingLanguage"] else {
                return nil
            }
            
            return SearchResult(name: name, email: email, bio: bio, codingLanguage: codingLanguage)
        })
        
        self.results = results
        
        updateUI()
    }
    
    func filterUsersByLanguage(with term: String) {
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String, hasFetched else {
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        
        spinner.dismiss()
        
        let results: [SearchResult] = users.filter({
            guard let email = $0["email"],
                  email != safeEmail else {
                return false
            }
            
            guard let codingLanguage = $0["codingLanguage"]?.lowercased() else {
                return false
            }
            
            return codingLanguage.hasPrefix(term.lowercased())
        }).compactMap({
            guard let email = $0["email"], let name = $0["name"], let bio = $0["bio"], let codingLanguage = $0["codingLanguage"] else {
                return nil
            }
            
            return SearchResult(name: name, email: email, bio: bio, codingLanguage: codingLanguage)
        })
        
        self.results = results
        print(self.results)
        
        updateUI()
    }

    
    func updateUI() {
        if results.isEmpty {
            noResultsLabel.isHidden = false
            tableView.isHidden = true
        }
        else {
            noResultsLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}
