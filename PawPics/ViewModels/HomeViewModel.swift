//
//  HomeViewModel.swift
//  PawPics
//
//  Created by Kapil Khedkar on 20/07/24.
//

import Foundation
import MyDogsGallery
import RealmSwift

class HomeViewModel {
    private var dogImageFetcher: DogImageFetcher
    private var realm: Realm
    private var currentImage: DogImage?
    private var images: [DogImage] = []
    private var currentIndex: Int = -1
    
    var imageUpdated: ((DogImage?) -> Void)?
    
    init(dogImageFetcher: DogImageFetcher = DogImageFetcher()) {
        self.dogImageFetcher = dogImageFetcher
        self.realm = try! Realm()
    }
    
    func fetchImage() {
        dogImageFetcher.getImage { [weak self] result in
            switch result {
            case .success(let image):
                self?.storeImage(image)
                DispatchQueue.main.async {
                    self?.currentImage = image
                    self?.currentIndex = 0
                    self?.images = [image]
                    self?.imageUpdated?(image)
                }
            case .failure(let error):
                print("Failed to fetch image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.imageUpdated?(nil)
                }
            }
        }
    }
    
    func fetchNextImage() {
        
        let nextIndex = currentIndex + 1
        
        // Check if the next image is available in the database
        if let nextImage = getImage(at: nextIndex) {
            // Load image from the database
            DispatchQueue.main.async { [weak self] in
                self?.currentIndex = nextIndex
                self?.currentImage = nextImage
                self?.imageUpdated?(nextImage)
            }
        } else {
            dogImageFetcher.getNextImage { [weak self] result in
                switch result {
                case .success(let image):
                    self?.storeImage(image)
                    DispatchQueue.main.async {
                        self?.currentImage = image
                        if let currentIndex = self?.currentIndex, currentIndex + 1 < self?.images.count ?? 0 {
                            self?.images[currentIndex + 1] = image
                        } else {
                            self?.images.append(image)
                        }
                        self?.currentIndex += 1
                        self?.imageUpdated?(image)
                    }
                case .failure(let error):
                    print("Failed to fetch next image: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self?.imageUpdated?(nil)
                    }
                }
            }
        }
        
    }
    
    func fetchPreviousImage() {
        guard self.currentIndex > 0 else {
            print("No previous image available")
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.currentIndex -= 1
            if let prevImage = self?.getImage(at: self!.currentIndex) {
                self?.imageUpdated?(prevImage)
            }
        }
    }
    
    private func storeImage(_ image: DogImage) {
        DispatchQueue.main.async {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(image, update: .modified)
                }
            } catch {
                print("Failed to store image: \(error.localizedDescription)")
            }
        }
    }
    
    func getImage(at index: Int) -> DogImage? {
        guard index < images.count else { return nil }
        return images[index]
    }
    
    func numberOfImages() -> Int {
        return images.count
    }
    
    func hasPrevious()->Bool {
        if self.currentIndex > 0 {
            return true
        } else {
            return false
        }
    }
}
