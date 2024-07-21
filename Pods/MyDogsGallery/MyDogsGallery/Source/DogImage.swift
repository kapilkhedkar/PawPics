//
//  DogImage.swift
//  MyDogsGallery
//
//  Created by Kapil Khedkar on 20/07/24.
//

import RealmSwift

public class DogImage: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var url: String
}
