//
//  PokemonTypeContainer.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import Foundation
import UIKit

struct PokemonTypesObject: Codable {
    let types: [APIPokemonSlotType]
    
    var type1: PokemonType? {
        types.first?.type.name
    }
    var type2: PokemonType? {
        types.last?.type.name
    }
}

struct APIPokemonSlotType: Codable {
    var slot: Int
    var type: APIPokemonType
}

struct APIPokemonType: Codable {
    let name: PokemonType
}
