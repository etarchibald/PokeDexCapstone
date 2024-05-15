//
//  PokemonTypeSearch.swift
//  Pokedex
//
//  Created by Ethan Archibald on 5/15/24.
//

import Foundation

struct PokemonTypeSearch: Codable {
    var pokemon: [PokemonTypeSearchResults]
}

struct PokemonTypeSearchResults: Codable {
    var pokemon: PokemonGenericSearchResults
}
