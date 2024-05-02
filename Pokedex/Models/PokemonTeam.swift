//
//  PokemonTeam.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/18/24.
//

import Foundation

struct Team: Codable {
    var pokemon: [Pokemon] = []
    var id: UUID = UUID()
    var typeOfTeam: String
    var teamName: String
    
    var numberOfCards: Int {
        pokemon.count
    }
}
