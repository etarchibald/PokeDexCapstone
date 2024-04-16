//
//  PokemonAbilities.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/16/24.
//

import Foundation

struct PokemonAbilities: Codable {
    var ability: Ability
    var slot: Int
}

struct Ability: Codable {
    var name: String
    var url: String
}
