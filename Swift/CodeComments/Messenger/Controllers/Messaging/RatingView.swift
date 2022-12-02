//
//  RatingView.swift
//  CodeComments
//
//  Created by Luke Yeo on 2/12/22.
//

import SwiftUI

struct RatingView: View {
    @State private var showingAlert = false
    var dismissAction: (() -> Void)
    
    func thumbsup(){
        showingAlert = true
    }
    func thumbsdown(){
        showingAlert = true
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Rate your experience with this teacher")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 30))
                    .padding()
                HStack {
                    Button(action: thumbsup) {
                        Image(systemName: "hand.thumbsup.circle")
                            .font(.system(size: 65))
                            .foregroundColor(.primary)
                            .padding()
                    }
                    .alert("Thank you for providing feedback!", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) {}
                    }
                    Button(action: thumbsdown) {
                        Image(systemName: "hand.thumbsdown.circle")
                            .font(.system(size: 65))
                            .foregroundColor(.primary)
                            .padding()
                    }
                    .alert("Thank you for providing feedback!", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) {}
                    }
                }
                Text("Information collected will be used to improve the user experience of our platform")
                    .padding(EdgeInsets(top: 10, leading: 30, bottom: 15, trailing: 30))
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20))
                Button(action: dismissAction) {
                        Text("Learn more...")
                    }
                .padding()
                Button(action: dismissAction) {
                        Text("Done")
                        .fontWeight(.bold)
                    }
                
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(dismissAction: {})
    }
}
