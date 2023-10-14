//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Eric Zheng on 10/13/23.
//

import Foundation
import UIKit

struct TriviaQuestionService {
    public static func FetchQuestions(completion: (([TriviaQuestion]) -> Void)? = nil) {
        
        let apiString = "https://opentdb.com/api.php?amount=5"
        guard let apiUrl = URL(string:apiString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: apiUrl) { data, response, error in
            // checks if error is defined, if it is an error occured
            guard error == nil else {
                assertionFailure("Error: \(error?.localizedDescription)")
                return
            }
            // validates if response is a HTTPURLResponse. If not, invalid response
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid Response")
                return
            }
            // validates if data is safe
            guard let data = data, httpResponse.statusCode == 200 else{
                assertionFailure("Invalid status code: \(httpResponse.statusCode)")
                return
            }
            let decoder = JSONDecoder()
            let response = try! decoder.decode(TriviaApiResponse.self, from: data)
            DispatchQueue.main.async {
                completion?(response.results)
            }
        }
        
        task.resume()
    }
}

struct TriviaApiResponse: Decodable {
    let results: [TriviaQuestion]
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
}
