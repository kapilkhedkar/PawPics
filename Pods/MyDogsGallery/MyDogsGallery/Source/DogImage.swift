//
//  DogImage.swift
//  MyDogsGallery
//
//  Created by Kapil Khedkar on 20/07/24.
//
import RealmSwift

public class DogImage: Object {
    @objc dynamic public var id: String = UUID().uuidString
    @objc dynamic public var url: String = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public convenience init(url: String) {
        self.init()
        self.url = url
    }
}

public struct DogImageResponse: Decodable {
    let message: String
    let status: String
}
