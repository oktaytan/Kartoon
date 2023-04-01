//
//  DetailEntity.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 30.03.2023.
//

import Foundation

class DetailEntity {
    let id: Int
    let name: String
    let imageURL: String
    let films: [String]
    let shorts: [String]
    let shows, games, attractions: [String]
    let allies, enemies: [String]

    init(_ item: Character) {
        self.id = item.id
        self.name = item.name
        self.imageURL = item.imageURL
        self.films = item.films
        self.shorts = item.shortFilms
        self.shows = item.tvShows
        self.games = item.videoGames
        self.attractions = item.parkAttractions
        self.allies = item.allies
        self.enemies = item.enemies
    }
    
    var main: DetailMainPresentation {
        return DetailMainPresentation(imageURL: self.imageURL, name: self.name)
    }
    
    var details: [DetailItemPresentation] {
        var items = [DetailItemPresentation]()
        
        if !self.films.isEmpty {
            items.append(.init(header: "FILMS", items: self.films))
        } else {
            items.append(.init(header: "FILMS", items: ["No film"]))
        }
        
        if !self.shorts.isEmpty {
            items.append(.init(header: "SHORT FILMS", items: self.shorts))
        } else {
            items.append(.init(header: "SHORT FILMS", items: ["No short films"]))
        }
        
        if !self.shows.isEmpty {
            items.append(.init(header: "TV SHOWS", items: self.shows))
        } else {
            items.append(.init(header: "TV SHOWS", items: ["No TV shows"]))
        }
        
        if !self.games.isEmpty {
            items.append(.init(header: "VIDEO GAMES", items: self.games))
        } else {
            items.append(.init(header: "VIDEO GAMES", items: ["No video games"]))
        }
        
        if !self.attractions.isEmpty {
            items.append(.init(header: "ATTRACTIONS", items: self.attractions))
        } else {
            items.append(.init(header: "ATTRACTIONS", items: ["No attractions"]))
        }
        
        if !self.allies.isEmpty {
            items.append(.init(header: "ALLIES", items: self.allies))
        } else {
            items.append(.init(header: "ALLIES", items: ["No allies"]))
        }
        
        if !self.enemies.isEmpty {
            items.append(.init(header: "ENEMIES", items: self.enemies))
        } else {
            items.append(.init(header: "ENEMIES", items: ["No enemies"]))
        }
        
        return items
    }
}

struct DetailMainPresentation {
    let imageURL: String
    let name: String
}

struct DetailItemPresentation {
    let header: String
    let items: [String]
}

