//
//  SCGPTResponse.swift
//  Startup Creator
//
//  Created by Chris W on 1/4/25.
//

import Foundation

struct SCGPTResponse: Codable {
    let created: Int
    let model: String
    let usage: Usage
    let choices: [Choice]
    
    struct Usage: Codable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int
    }
    
    struct Choice: Codable {
        let message: Message
        let finishReason: String
        let index: Int
    }
    
    struct Message: Codable {
        let role: String
        let content: String
    }
}

func getSCGPTResponseMessage(response: SCGPTResponse) -> String? {
    //In our case there should only be one message response, so we get the first one in the choices array
    if let firstMessageResponse = response.choices.first {
        let message = firstMessageResponse.message
        return message.content
    }
    return nil
}
