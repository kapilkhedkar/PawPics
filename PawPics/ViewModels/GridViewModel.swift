//
//  GridViewModel.swift
//  PawPics
//
//  Created by Kapil Khedkar on 20/07/24.
//

import Foundation
import MyDogsGallery

class GridViewModel {
    private var dogImageFetcher = DogImageFetcher()
    private var images: [String] = []
    
    
    func fetchImages(count: Int, completion: @escaping () -> Void) {
        dogImageFetcher.getImages(number: count) { [weak self] result in
            switch result {
            case .success(let images):
                self?.images = images
                completion()
            case .failure(let error):
                print("Failed to fetch images: \(error.localizedDescription)")
            }
        }
    }
    
    func numberOfImages() -> Int {
        return images.count
    }
    
    func getImage(at index: Int) -> String? {
        guard index < images.count else { return nil }
        return images[index]
    }
}

