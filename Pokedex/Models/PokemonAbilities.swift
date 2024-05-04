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
    var abilityDetails: AbilityDetails?
    var name: String? {
        ability.name
    }
    var effect: String? {
        for each in abilityDetails!.effectEntries {
            if each.language.name == "en" {
                return each.effect
            }
        }
        return ""
    }
    var flavorText: String? {
        abilityDetails?.flavorTextEntries.first?.flavor_text ?? ""
    }
}

struct Ability: Codable {
    var name: String
    var url: URL
}

struct AbilityDetails: Codable {
    var effectEntries: [EffectEntries]
    var flavorTextEntries: [FlavorTextEntries]
    
    enum CodingKeys: String, CodingKey {
        case effectEntries = "effect_entries"
        case flavorTextEntries = "flavor_text_entries"
    }
}

struct FlavorTextEntries: Codable {
    var flavor_text: String
}
