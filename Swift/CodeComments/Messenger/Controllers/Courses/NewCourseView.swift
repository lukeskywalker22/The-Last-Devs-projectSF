//
//  NewCourseView.swift
//  CodeComments
//
//  Created by Luke Yeo on 3/12/22.
//

import SwiftUI
import PhotosUI

struct NewCourseView: View {
    @State private var courseName: String = ""
    @State private var courseLanguage: String = ""
    @State private var courseDescription: String = ""
    @State private var courseLimit: String = ""
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingAlert: Bool = false
    
    var dismissAction: (() -> Void)
    
    func showCompletion(){
        showingAlert = true
    }
    
    func createCourse(){
        showCompletion()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    PhotosPicker(selection: $selectedItem, matching: .images){
                        VStack {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 120))
                                .foregroundColor(.white)
                            Text("Upload cover image")
                                .padding()
                        }
                    }
                }
                HStack {
                    TextField("Enter course name", text: $courseName).padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                }
                HStack {
                    TextField("Enter primary coding language", text: $courseLanguage).padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                }
                HStack {
                    TextField("Enter course description", text: $courseDescription, axis: .vertical)
                        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                        .lineLimit(6)
                }
                HStack {
                    TextField("Enter course limit", text: $courseLimit).padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                }
                Button(action: createCourse){
                    Text("Create")
                }
                .padding()
                .alert("Course created", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {
                        dismissAction()
                    }
                }
            }
        }
    }
}

struct NewCourseView_Previews: PreviewProvider {
    static var previews: some View {
        NewCourseView(dismissAction: {})
    }
}

func uploadCourseImage(){}
