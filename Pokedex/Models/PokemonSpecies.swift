//
//  PokemonSpecies.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/18/24.
//

import Foundation

struct PokemonSpecies: Codable {
    var evolutionChain: EvolutionChain
    var generation: Generation
    var habitat: Habitat
    var isLegendary: Bool
    var isMythical: Bool
    
    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
        case generation = "generation"
        case habitat = "habitat"
        case isLegendary = "is_legendary"
        case isMythical = "is_mythical"
    }
}

struct EvolutionChain: Codable {
    var url: URL
}

struct Generation: Codable {
    var name: String
}

struct Habitat: Codable {
    var name: String
}
