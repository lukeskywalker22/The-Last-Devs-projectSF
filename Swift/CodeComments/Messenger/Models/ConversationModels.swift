//
//  ConversationModels.swift
//  Messenger
//
//  Created by Luke Yeo on 5/7/22.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
