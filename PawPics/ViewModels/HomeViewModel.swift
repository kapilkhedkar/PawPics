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
    
    func fetchPreviousImage() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            do {
                guard self.currentIndex > 0 else {
                    throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "No previous image available"])
                }
                self.currentIndex -= 1
                let previousImage = self.images[self.currentIndex]
                DispatchQueue.main.async {
                    self.imageUpdated?(previousImage)
                }
            } catch {
                print("Failed to fetch previous image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.imageUpdated?(nil)
                }
            }
        }
    }
    
    private func storeImage(_ image: DogImage) {
        DispatchQueue.global().async {
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
}
