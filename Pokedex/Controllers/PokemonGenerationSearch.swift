//
//  PokemonGenerationSearch.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/25/24.
//

import Foundation

struct PokemonGenerationSearch: Codable {
    var results: [PokemonGenericSearchResults]
    
    enum CodingKeys: String, CodingKey {
        case results = "pokemon_species"
    }
}
