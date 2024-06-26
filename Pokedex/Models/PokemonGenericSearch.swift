//
//  PokemonGenericSearch.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import Foundation

struct PokemonGenericSearch: Codable {
    var count: Int
    var next: URL?
    var results: [PokemonGenericSearchResults]
}
