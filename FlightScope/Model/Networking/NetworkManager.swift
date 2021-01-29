//
//  NetworkManager.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/28/21.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DETELE"
}

class NetworkManager {
    let api_key: String = "6011a238c206133fd8ccaa6f"
    let firestoreController = FirestoreController()
    
    let session = URLSession.shared
    var placesArray: [Places] = []
    
    func fetchData(cityName: String, completion: @escaping () -> Void) {
        let baseURL = URL(string: "https://api.flightapi.io/place/\(api_key)/\(cityName)")!
        
        session.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print("Error with fetchData: \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let data = data else {
                print("No data return from data task")
                completion()
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let source = try jsonDecoder.decode(Places.self, from: data)
                self.placesArray.append(source)
                print(source)
            } catch {
                print("Error decoding data")
            }
            
        }.resume()
    }
}
