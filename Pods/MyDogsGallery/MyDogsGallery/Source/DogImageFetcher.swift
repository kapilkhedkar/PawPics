//
//  DogImageFetcher.swift
//  MyDogsGallery
//
//  Created by Kapil Khedkar on 19/07/24.
//

import Foundation
import RealmSwift

public class DogImageFetcher {
    
    private var realm: Realm!
    private var images: Results<DogImage>!
    private var currentIndex = -1
    
    public init() {
        setupRealm()
        loadImagesFromDatabase()
    }
    
    private func setupRealm() {
        do {
            realm = try Realm()
        } catch {
            print("Error setting up Realm: \(error)")
        }
    }
    
    public func getImage(completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = Constants.baseUrl
        
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
                   let imageUrl = json["message"] as? String {
                    self.saveImageToDatabase(url: imageUrl)
                    self.currentIndex = self.images.count - 1
                    completion(.success(imageUrl))
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                }
            } catch let parseError {
                completion(.failure(parseError))
            }
        }
        
        task.resume()
    }
    
    public func getNextImage(completion: @escaping (Result<String, Error>) -> Void) {
        let nextIndex = currentIndex + 1
        if nextIndex < images.count {
            currentIndex = nextIndex
            let imageUrl = images[nextIndex].url
            completion(.success(imageUrl))
        } else {
            getImage(completion: completion)
        }
    }
    
    public func getPreviousImage(completion: @escaping (Result<String, Error>) -> Void) {
        let previousIndex = currentIndex - 1
        if previousIndex >= 0 {
            currentIndex = previousIndex
            let imageUrl = images[previousIndex].url
            completion(.success(imageUrl))
        } else {
            completion(.failure(NSError(domain: "No previous image", code: 0, userInfo: nil)))
        }
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
    
    private func saveImageToDatabase(url: String) {
        do {
            let image = DogImage()
            image.url = url
            try realm.write {
                realm.add(image)
            }
            loadImagesFromDatabase()
        } catch {
            print("Error saving image to database: \(error)")
        }
    }
    
    private func loadImagesFromDatabase() {
        images = realm.objects(DogImage.self)
    }
}
