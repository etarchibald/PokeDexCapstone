//
//  PokemonEvolution.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/17/24.
//

import Foundation

struct PokemonEvolution: Codable {
    var chain: Chain
}

struct Chain: Codable {
    var evolvesTo: [EvolvesToStage1]
    
    enum CodingKeys: String, CodingKey {
        case evolvesTo = "evolves_to"
    }
}

struct EvolvesToStage1: Codable {
    var species: Species
    var evolvesTo: [EvolvesToStage2]?
    
    enum CodingKeys: String, CodingKey {
        case species = "species"
        case evolvesTo = "evolves_to"
    }
}

struct EvolvesToStage2: Codable {
    var species: Species
}

struct Species: Codable {
    var name: String
}
