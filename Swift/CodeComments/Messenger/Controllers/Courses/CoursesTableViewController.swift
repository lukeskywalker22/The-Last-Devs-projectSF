//
//  CoursesTableViewController.swift
//  CodeComments
//
//  Created by Luke Yeo on 3/12/22.
//

import UIKit
import SwiftUI

class CoursesTableViewController: UITableViewController {

    var coursesList = ["Swift", "Flutter"]
    var coursesListDetail = ["Swift is a proprietary programming language developed by Apple for use on its systems", "Flutter is an open-source multiplatform UI solution based on Dart"]
    var imageNames = ["swift.png", "flutter.png"]

    @IBAction func createNewCourse(_ sender: Any) {
        let vc = UIHostingController(rootView: NewCourseView())
        self.present(vc, animated: true)
    }
    
    @IBOutlet weak var newCourseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        if UserDefaults.standard.value(forKey: "occupation") as! String == "teacher" {
            newCourseButton.isHidden = false
        } else {
            newCourseButton.isHidden = true
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return coursesList.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.font = .systemFont(ofSize: 20)
        cell.textLabel?.text = coursesList[indexPath.row]
        cell.detailTextLabel?.font = .systemFont(ofSize: 15)
        cell.detailTextLabel?.text = coursesListDetail[indexPath.row]
        cell.imageView?.image = UIImage(named: imageNames[indexPath.row])
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! CourseDetailViewController
        destination.imageName = imageNames[tableView.indexPathForSelectedRow!.row]
        destination.courseTitle = coursesList[tableView.indexPathForSelectedRow!.row]
        destination.courseDetail = coursesListDetail[tableView.indexPathForSelectedRow!.row]
    }
    
}
