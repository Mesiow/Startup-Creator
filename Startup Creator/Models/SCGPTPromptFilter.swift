//
//  SCGPTPromptFilter.swift
//  Startup Creator
//
//  Created by Chris W on 1/4/25.
//

import Foundation

//Industries that can be used as a prompt
enum Industry: String, CaseIterable {
    case technology = "Tech"
    case healthcare = "Healthcare"
    case fintech = "Financial Tech"
    case ecommerce = "E-commerce"
    case education = "Education"
    case sustainability = "Sustainability"
    case realestate = "Real Estate"
    case marketing = "Marketing"
    case food = "Food"
    case entertainment = "Entertainment & media"
    case travel = "Travel"
    case transportation  = "Transportation"
    case fashion = "Fashion"
    case home = "Home"
    case fitness = "Health and Fitness"
}

enum MarketType: String, CaseIterable {
    case local = "Local"
    case global = "Global"
}

enum BusinessModel: String, CaseIterable {
    case subscription = "subscription"
    case marketplace = "marketplace"
    case saas = "SaaS"
    case dtc = "direct-to-consumer"
}

struct SCGPTPromptFilter {
    var industry: Industry?
    var market: MarketType?
    var businessModel: BusinessModel?
}

//Different keywords to use in the gpt prompts to vary the models' responses
enum SCGPTPromptKeyword{
    static let beginningKeywords: [String] = [
        "Generate me a startup idea",
        "Give me a business idea",
        "Create a startup idea",
        "Create a business idea",
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
        let prompt = "\(beginningKeyword) in the \(filter.industry!.rawValue) industry that targets a \(filter.market!.rawValue) market and that has a \(filter.businessModel!.rawValue) business model. In your response, provide me with the idea itself, the target audience, and the product each within their own paragraph and within \(maxTokens) words or less."
        print(prompt)
        return prompt
    }
    
    //Create prompt to ask gpt how to scale this type of business
    static func createIdeaScalePrompt(content: String) -> String {
        let prompt = "Tell me how I could handle scaling this type of business in two paragraphs: \n\(content)"
        return prompt
    }
    
    static func createIdeaEntryPrompt(content: String) -> String {
        let prompt = "Tell me how difficult entry can be into this type of business in two paragraphs: \n\(content)"
        return prompt
    }
}
