//
//  PokemonMove.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/29/24.
//

import Foundation

struct PokemonMove: Codable {
    var move: Move
    var moveDetail: MoveDetail?
    var name: String? {
        move.name
    }
    var url: URL? {
        move.url
    }
    var accuarcy: Int? {
        moveDetail?.accuracy
    }
    var effectChance: Int? {
        moveDetail?.effectChance
    }
    var effectEntries: String? {
        moveDetail?.effectEntries.first?.effect ?? ""
    }
    var damageClass: String? {
        moveDetail?.damageClass.name ?? ""
    }
    var power: Int? {
        moveDetail?.power
    }
    var pp: Int? {
        moveDetail?.pp
    }
    var priority: Int? {
        moveDetail?.priority
    }
    var target: String? {
        moveDetail?.target.name
    }
    var type: PokemonType? {
        moveDetail?.type.name
    }
}


struct Move: Codable {
    var name: String
    var url: URL
}

struct MoveDetail: Codable {
    var accuracy: Int //in percent
    var effectChance: Int
    var effectEntries: [EffectEntries]
    var damageClass: DamageClass
    var power: Int
    var pp: Int //Power points. The number of times this move can be used.
    var priority: Int //A value between -8 and 8. Sets the order in which moves are executed during battle.
    var target: Target
    var type: APIPokemonType
    
    enum CodingKeys: String, CodingKey {
        case accuracy = "accuracy"
        case effectChance = "effect_chance"
        case effectEntries = "effect_entries"
        case damageClass = "damage_class"
        case power = "power"
        case pp = "pp"
        case priority = "priority"
        case target = "target"
        case type = "type"
    }
}

struct EffectEntries: Codable {
    var effect: String
}

struct DamageClass: Codable {
    var name: String
}

struct Target: Codable {
    var name: String
}
