//
//  DogImageFetcher.swift
//  MyDogsGallery
//
//  Created by Kapil Khedkar on 19/07/24.
//

import Foundation

public class DogImageFetcher {
    
    public init() {
        
    }
    
    public func getImage(completion: @escaping (Result<DogImage, Error>) -> Void) {
        fetchData(from: Constants.baseUrl, completion: completion)
    }
    
    public func getNextImage(completion: @escaping (Result<DogImage, Error>) -> Void) {
        fetchData(from: Constants.baseUrl, completion: completion)
    }
    
    private func fetchData(from urlString: String, completion: @escaping (Result<DogImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(DogImageResponse.self, from: data)
                let dogImage = DogImage(url: response.message)
                completion(.success(dogImage))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getImages(number: Int, completion: @escaping (Result<[String], Error>) -> Void) {
        let urlString = "\(Constants.baseUrl)/\(number)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let status = json["status"] as? String, status == "success",
                   let imageUrls = json["message"] as? [String] {
                    completion(.success(imageUrls))
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                }
            } catch let parseError {
                completion(.failure(parseError))
            }
        }
        
        task.resume()
    }
}
