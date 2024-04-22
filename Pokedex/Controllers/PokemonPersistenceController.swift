//
//  PokemonPersistenceController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/22/24.
//
//file system save changes

//save deck
//save all favorite pokemon

import Foundation

class PokemonPersistenceController {
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("emojis").appendingPathExtension("json")
    
    //fix to use favortie pokemon
    static func saveToFile(favoritePokemons: [Pokemon]) {
        let jsonEncoder = JSONEncoder()
        let encodedPokemons = try? jsonEncoder.encode(favoritePokemons)
        try? encodedPokemons?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    //fix to use favortie pokemon
    static func loadFromFile() -> [Pokemon] {
        let jsonDecoder = JSONDecoder()
        if let retrievedPokemonData = try? Data(contentsOf: ArchiveURL),
           let decodedPokemons = try? jsonDecoder.decode(Array<Pokemon>.self, from: retrievedPokemonData) {
            return decodedPokemons
        } else {
            return []
        }
    }
    
    static func saveToFile(decks: [Deck]) {
        let jsonEncoder = JSONEncoder()
        let encodedDecks = try? jsonEncoder.encode(decks)
        try? encodedDecks?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [Deck] {
        let jsonDecoder = JSONDecoder()
        if let retrievedDecksData = try? Data(contentsOf: ArchiveURL),
           let decodedDecks = try? jsonDecoder.decode(Array<Deck>.self, from: retrievedDecksData) {
            return decodedDecks
        } else {
            return []
        }
    }


}
