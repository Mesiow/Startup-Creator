//
//  SCGPTPromptFilter.swift
//  Startup Creator
//
//  Created by Chris W on 1/4/25.
//

import Foundation

//Industries that can be used as a prompt
enum Industry: String, CaseIterable {
    case technology
    case healthcare
    case fintech = "financial tech"
    case ecommerce
    case education
    case sustainability
    case realestate = "real estate"
    case marketing
    case food
    case entertainment
    case travel
    case transportation
    case fashion
    case home
    case fitness
}

enum BusinessType: String {
    case saas = "software as a service"
    case physical = "physical product"
}

enum BusinessTarget: String {
    case b2b = "business to business"
    case b2c = "business to consumer"
}

struct SCGPTPromptFilter {
    var industry: Industry?
    var type: BusinessType?
    var target: BusinessTarget?
}

//Different keywords to use in the gpt prompts to vary the models' responses
enum SCGPTPromptKeyword{
    static let beginningKeywords: [String] = [
        "Generate me a startup idea",
        "Give me a business idea",
        "Create a startup idea",
        "Provide me with a business idea",
        "Create a unique startup idea",
        "Give me a unique business idea",
        "Generate me a business idea",
        "Come up with a startup idea",
        "Come up with a business idea",
        "Suggest me a business idea",
        "Suggest me a startup idea"
    ]
}

//Different prompts to test
enum SCPrompt{
    //Initial idea prompt
    static func createIdeaPrompt(filter: SCGPTPromptFilter, maxTokens: Int) -> String{
        let seed = Int.random(in: 0..<SCGPTPromptKeyword.beginningKeywords.count)
        let beginningKeyword = SCGPTPromptKeyword.beginningKeywords[seed]
        let prompt = "\(beginningKeyword) in the \(filter.industry!.rawValue) industry that is a \(filter.type!.rawValue) along with a business model that is \(filter.target!.rawValue). In your response, provide me with the idea itself, the target audience, and the product, all within \(maxTokens) words. Make sure the last sentence of your response is finished properly."
        return prompt
    }
    
    //Create prompt to ask gpt how to scale this type of business
    static func createIdeaScalePrompt(content: String, maxTokens: Int) -> String {
        let prompt = "Tell me how I could handle scaling this type of business in \(maxTokens) words: \n\(content)"
        return prompt
    }
    
    static func createIdeaEntryPrompt(content: String, maxTokens: Int) -> String {
        let prompt = "Tell me how difficult entry can be into this type of business in \(maxTokens) words: \n\(content)"
        return prompt
    }
}
