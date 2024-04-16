//
//  PokemonStats.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/16/24.
//

import Foundation

struct Stats: Codable {
    var base_stat: Int
    var stat: Stat
}

struct Stat: Codable {
    var name: String
}
