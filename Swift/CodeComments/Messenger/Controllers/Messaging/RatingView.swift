//
//  RatingView.swift
//  CodeComments
//
//  Created by Luke Yeo on 2/12/22.
//

import SwiftUI

struct RatingView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Rate your experience with this teacher")
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}
