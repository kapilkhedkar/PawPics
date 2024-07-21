//
//  DogImage.swift
//  MyDogsGallery
//
//  Created by Kapil Khedkar on 20/07/24.
//

public struct DogImage: Decodable {
    public let url: String
}

public struct DogImageResponse: Decodable {
    let message: String
    let status: String
}
