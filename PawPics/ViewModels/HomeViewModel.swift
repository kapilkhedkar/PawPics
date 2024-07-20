//
//  HomeViewModel.swift
//  PawPics
//
//  Created by Kapil Khedkar on 20/07/24.
//

import Foundation
class HomeViewModel {
    var images: [String] = []
    
    func fetchImages(number: Int, completion: @escaping () -> Void) {
        guard number > 0, number <= 10 else {
            return
        }
        
        self.images = [
            "https://images.dog.ceo/breeds/pembroke/n02113023_6030.jpg",
            "https://images.dog.ceo/breeds/poodle-toy/n02113624_1801.jpg",
            "https://images.dog.ceo/breeds/groenendael/n02105056_6363.jpg",
            "https://images.dog.ceo/breeds/samoyed/n02111889_5738.jpg",
            "https://images.dog.ceo/breeds/greyhound-italian/n02091032_6979.jpg",
            "https://images.dog.ceo/breeds/pembroke/n02113023_6030.jpg",
            "https://images.dog.ceo/breeds/poodle-toy/n02113624_1801.jpg",
            "https://images.dog.ceo/breeds/groenendael/n02105056_6363.jpg",
            "https://images.dog.ceo/breeds/samoyed/n02111889_5738.jpg",
            "https://images.dog.ceo/breeds/greyhound-italian/n02091032_6979.jpg"
        ]
        completion()
    }
}
