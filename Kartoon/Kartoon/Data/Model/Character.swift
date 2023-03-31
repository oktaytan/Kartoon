//
//  Character.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 30.03.2023.
//

import Foundation

// MARK: - Response
struct CharacterList: Codable {
    let data: [Character]
    let count, totalPages: Int
    let nextPage: String
}

// MARK: - Search Response
struct SearchList: Codable {
    let data: [Character]
    let count: Int
}

// MARK: - Datum
struct Character: Codable {
    let id: Int
    let name: String
    let imageURL: String
    let url: String
    let films: [String]
    let shortFilms: [String]
    let tvShows, videoGames, parkAttractions: [String]
    let allies, enemies: [String]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case imageURL = "imageUrl"
        case url, name, films, shortFilms, tvShows, videoGames, parkAttractions, allies, enemies
    }
}
