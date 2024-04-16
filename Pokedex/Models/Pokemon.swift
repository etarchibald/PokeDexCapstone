//
//  Pokemon.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import Foundation

//decoding for the details
struct Pokemon: Codable {
    var name: String
    var types: [PokemonTypeContainer]
    var sprites: PokemonSprites
    var abilities: [PokemonAbilities]
    
    var example: String
}
