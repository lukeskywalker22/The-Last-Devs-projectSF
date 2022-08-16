//
//  File.swift
//  Messenger
//
//  Created by Luke Yeo on 5/7/22.
//

import Foundation

enum ProfileViewModelType {
    case info, logout, button
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
