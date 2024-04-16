//
//  PokemonDamageRelations.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/16/24.
//

import Foundation

struct PokemonDamageRelations: Codable {
    var damageRelations: DamageRelations
    
    enum CodingKeys: String, CodingKey {
        case damageRelations = "damage_Relations"
    }
}

struct DamageRelations: Codable {
    var doubleDamageFrom: [PokemonType]
    var doubleDamageTo: [PokemonType]
    var halfDamageFrom: [PokemonType]
    var halfDamageTo: [PokemonType]
    var noDamageFrom: [PokemonType]
    var noDamageTo: [PokemonType]
    
    enum CodingKeys: String, CodingKey {
        case doubleDamageFrom = "double_damage_from"
        case doubleDamageTo = "double_damage_to"
        case halfDamageFrom = "half_damage_from"
        case halfDamageTo = "half_damage_to"
        case noDamageFrom = "no_damage_from"
        case noDamageTo = "no_damage_to"
    }
}
