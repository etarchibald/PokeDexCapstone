//
//  Pokemon.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import Foundation

//decoding for the details
struct Pokemon: Codable {
    var id: Int
    var name: String
    var isFavorited: Bool?
    var types: [PokemonTypeContainer]
    var sprites: PokemonSprites
    var abilities: [PokemonAbilities]
    var stats: [Stats]
    //Height in decimeters according to the API
    var height: Int
    //weight in hectograms according to the API
    var weight: Int
    
    var damageRelations: PokemonDamageRelations?
    var species: PokemonSpecies?
    var evolutionChain: PokemonEvolution?
}
