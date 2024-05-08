//
//  PokemonTeam.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/18/24.
//

import Foundation

class Team: Codable {
    var pokemon: [Pokemon] = []
    var id: UUID = UUID()
    var typeOfTeam: String
    //var typesOfPokemon = [PokemonType]()
    var teamName: String
    //var typeImage: URL
    
    var numberOfCards: Int {
        pokemon.count
    }
    
    init(pokemon: [Pokemon], id: UUID, typeOfTeam: String, teamName: String) {
        self.pokemon = pokemon
        self.id = id
        self.typeOfTeam = typeOfTeam
        self.teamName = teamName
    }
}
