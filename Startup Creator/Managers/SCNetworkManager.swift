//
//  SCNetworkManager.swift
//  Startup Creator
//
//  Created by Chris W on 1/3/25.
//

import UIKit

//Handles all network requests to the openai gpt-4o-mini model
class SCNetworkManager {
    static let shared = SCNetworkManager()
    let gpt4BaseURL = URL(string: "https://api.openai.com/v1/chat/completions")
    let maxTokens = 120
    
    private init() { }
    
    func makeRequest(prompt: String, completed: @escaping (Result<SCGPTResponse, SCNetworkError>) -> Void) {
        guard let url = gpt4BaseURL else {
            completed(.failure(.unableToComplete)) //failure case with message
            return
        }
        
        var request = URLRequest(url: url)
        //Set request headers
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Environment.apiKey)", forHTTPHeaderField: "Authorization")
        
        //Set request body
        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [ //array of message objects that define the conversation
                ["role" : "user", "content" : prompt]
            ],
            "temperature": 0.7,
            "top_p": 0.8, //temp and top_p determine creative randomness probability
            "max_tokens": maxTokens
        ]
        
        //Convert the body to json for it to be readable
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        }catch{
            print("Error serializing JSON: \(error)")
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            //if response is not nil and if the status code is Ok, set the variable, otherwise there was an error
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let response = try decoder.decode(SCGPTResponse.self, from: data)
                completed(.success(response))
            }catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
