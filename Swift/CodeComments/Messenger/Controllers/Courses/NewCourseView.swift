//
//  NewCourseView.swift
//  CodeComments
//
//  Created by Luke Yeo on 3/12/22.
//

import SwiftUI

struct NewCourseView: View {
    @State private var courseName: String = ""
    @State private var courseLanguage: String = ""
    @State private var courseDescription: String = ""
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Button(action: uploadCourseImage){
                        Image(systemName: "plus.circle")
                            .font(.system(size: 120))
                            .foregroundColor(.primary)
                    }
                    Text("Upload cover image")
                        .padding()
                }
                HStack {
                    Text("Course name")
                        .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                    TextField("Enter course name", text: $courseName).padding()
                }
                HStack {
                    Text("Primary language")
                        .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 10))
                    TextField("Enter primary language", text: $courseLanguage).padding()
                }
                HStack {
                    Text("Course description")
                        .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 0))
                    TextField("Enter description", text: $courseDescription, axis: .vertical)
                        .padding()
                        .lineLimit(6)
                }
                HStack {
                    Text("Course limit")
                        .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 55))
                    TextField("Enter a number", text: $courseLanguage).padding()
                }
                Button(action: createCourse){
                    Text("Create")
                }.padding()
            }
        }
    }
}

struct NewCourseView_Previews: PreviewProvider {
    static var previews: some View {
        NewCourseView()
    }
}

func uploadCourseImage(){}
func createCourse(){}
