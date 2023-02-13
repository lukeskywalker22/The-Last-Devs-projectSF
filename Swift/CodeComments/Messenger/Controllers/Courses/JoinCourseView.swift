//
//  JoinCourseView.swift
//  CodeComments
//
//  Created by Luke Yeo on 4/2/23.
//

import SwiftUI

struct JoinCourseView: View {
    @State private var courseName: String = ""
    
    var dismissAction: (() -> Void)
    
    func initialiseJoin(){
        DatabaseManager.shared.joinCourse(email: DatabaseManager.safeEmail(emailAddress: UserDefaults.standard.value(forKey: "email") as! String), courseName: courseName)
        print("joined successfully")
        dismissAction()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter course name", text: $courseName)
                    .padding()
                Button(action: initialiseJoin) {
                    Text("Join")
                }
            }
        }
    }
}

struct JoinCourseView_Previews: PreviewProvider {
    static var previews: some View {
        JoinCourseView(dismissAction: {})
    }
}
