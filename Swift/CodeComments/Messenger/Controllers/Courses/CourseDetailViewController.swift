//
//  CourseDetailViewController.swift
//  Pods
//
//  Created by Luke Yeo on 3/12/22.
//

import UIKit

class CourseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var imageName = ""
    var courseTitle = ""
    var courseDetail = ""
    
    var courseMaterials = ["main.dart", "pubspec.yaml"]
    
    @IBOutlet weak var materialsTableView: UITableView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(imageName)
        coverImage.image = UIImage(named: imageName)
        titleLabel.text = courseTitle
        detailLabel.text = courseDetail
        materialsTableView.delegate = self
        materialsTableView.dataSource = self
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
