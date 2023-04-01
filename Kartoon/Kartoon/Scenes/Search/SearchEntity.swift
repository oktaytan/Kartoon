//
//  SearchEntity.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 30.03.2023.
//

import Foundation

struct SearchEntity {
    let id: Int
    let name: String
    let imageURL: String
    
    init(data: Character) {
        id = data.id
        name = data.name
        imageURL = data.imageURL
    }
}
