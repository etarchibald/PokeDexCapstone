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
    
    enum PersistanceErrors: Error {
        case failedToLoadDecks
        case failedToLoadPokemon
        case failedToSaveDecks
        case failedToSavePokemon
    }
    
    static let shared = PokemonPersistenceController()
    
    static let pokemonDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let pokemonArchiveURL = pokemonDocumentsDirectory.appendingPathComponent("favoritePokemon").appendingPathExtension("json")
    
    //fix to use favortie pokemon
    static func savePokemon(favoritePokemons: [Pokemon]) {
        let jsonEncoder = JSONEncoder()
        do {
            let encodedPokemons = try jsonEncoder.encode(favoritePokemons)
            try encodedPokemons.write(to: pokemonArchiveURL, options: .noFileProtection)
        } catch {
            print("errorSavingPokemon: \(error)")
        }
    }
    
    //fix to use favortie pokemon
    static func loadPokemon() -> [Pokemon] {
        let jsonDecoder = JSONDecoder()
        do {
            let retrivedPokemonData = try Data(contentsOf: pokemonArchiveURL)
            let decodedPokemons = try jsonDecoder.decode([Pokemon].self, from: retrivedPokemonData)
            return decodedPokemons
        } catch {
            print("ErrorLoadingPokemon: \(error)")
            return []
        }
    }
    
}
