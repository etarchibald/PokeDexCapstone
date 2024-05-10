//
//  PokemonMove.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/29/24.
//

import Foundation

struct PokemonMove: Codable {
    var move: Move
    var version_group_details: [VersionGroupDetails]
    var moveDetail: MoveDetail?
    var name: String? {
        moveDetail?.name
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
    var levelLearnedAt: Int? {
        version_group_details.last?.level_learned_at
    }
    var moveLearnedMethod: String? {
        version_group_details.last?.move_learn_method.name
    }
}


struct Move: Codable {
    var name: String
    var url: URL
}

struct VersionGroupDetails: Codable {
    var level_learned_at: Int
    var move_learn_method: MoveLearnMethod
}

struct MoveLearnMethod: Codable {
    var name: String
}

struct MoveDetail: Codable {
    var name: String
    var accuracy: Int? //in percent
    var effectChance: Int?
    var effectEntries: [EffectEntries]
    var damageClass: DamageClass
    var power: Int?
    var pp: Int //Power points. The number of times this move can be used.
    var priority: Int //A value between -8 and 8. Sets the order in which moves are executed during battle.
    var target: Target
    var type: APIPokemonType
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
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
    var language: Language
}

struct DamageClass: Codable {
    var name: String
}

struct Target: Codable {
    var name: String
}

struct Language: Codable {
    var name: String
}

extension PokemonMove: Equatable, Hashable {
    static func == (lhs: PokemonMove, rhs: PokemonMove) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(name)
    }
}
