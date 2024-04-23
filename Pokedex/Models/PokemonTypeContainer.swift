//
//  PokemonTypeContainer.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import Foundation

struct PokemonTypesObject: Codable {
    let types: [APIPokemonSlotType]
}

struct APIPokemonSlotType: Codable {
    var slot: Int
    var type: APIPokemonType
}

struct APIPokemonType: Codable {
    let name: PokemonType
}
