//
//  NetworkManager.swift
//  MyNews
//
//  Created by Stas Boiko on 23.01.2023.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchData<T: Decodable>(from urlString: String, completion: @escaping (T?, Error?) -> Void ) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, resp, error in
            
            if let error = error {
                completion(nil, error)
                print("Failed to complete data task:", error)
                return
            }
            
            guard let data = data else { return }
                
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result, nil)
            } catch(let decodeError) {
                completion(nil, decodeError)
                print("Failed to decode JSON:", decodeError)
            }
            
        }.resume()
        
    }
    
    private init() {}
    
    
    
}
