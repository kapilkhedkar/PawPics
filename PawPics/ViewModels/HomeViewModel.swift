//
//  HomeViewModel.swift
//  PawPics
//
//  Created by Kapil Khedkar on 20/07/24.
//

import Foundation
import MyDogsGallery

class HomeViewModel {
    private var dogImageFetcher : DogImageFetcher
    private var currentImage: String?
    private var images: [String] = []
    private var currentIndex: Int = -1
    
    var imageUpdated: ((String?) -> Void)?
    
    init(dogImageFetcher: DogImageFetcher = DogImageFetcher()) {
        self.dogImageFetcher = dogImageFetcher
    }
    
    func fetchImage() {
        dogImageFetcher.getImage { [weak self] result in
            switch result {
            case .success(let image):
                self?.currentImage = image
                self?.currentIndex = 0
                self?.images = [image]
                self?.imageUpdated?(image)
            case .failure(let error):
                print("Failed to fetch image: \(error.localizedDescription)")
                self?.imageUpdated?(nil)
            }
        }
    }
    
    func fetchNextImage() {
        dogImageFetcher.getNextImage { [weak self] result in
            switch result {
            case .success(let image):
                self?.currentImage = image
                if let currentIndex = self?.currentIndex, currentIndex + 1 < self?.images.count ?? 0 {
                    self?.images[currentIndex + 1] = image
                } else {
                    self?.images.append(image)
                }
                self?.currentIndex += 1
                self?.imageUpdated?(image)
            case .failure(let error):
                print("Failed to fetch next image: \(error.localizedDescription)")
                self?.imageUpdated?(nil)
            }
        }
    }
    
    func fetchPreviousImage() {
        guard currentIndex > 0 else {
            print("No previous images available")
            return
        }
        dogImageFetcher.getPreviousImage { [weak self] result in
            switch result {
            case .success(let image):
                self?.currentImage = image
                self?.currentIndex -= 1
                self?.imageUpdated?(image)
            case .failure(let error):
                print("Failed to fetch previous image: \(error.localizedDescription)")
                self?.imageUpdated?(nil)
            }
        }
    }
    
    func getImage(at index: Int) -> String? {
        guard index < images.count else { return nil }
        return images[index]
    }
    
    func numberOfImages() -> Int {
        return images.count
    }
}
