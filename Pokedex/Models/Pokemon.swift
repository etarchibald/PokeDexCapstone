//
//  Pokemon.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import Foundation

//decoding for the details
struct Pokemon {
    var id: Int
    var name: String
    var isFavorited: Bool?
    var types: [APIPokemonSlotType]
    var primaryType: PokemonType? {
        types.first?.type.name
    }
    var secondaryType: PokemonType? {
        types.last?.type.name
    }
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

extension Pokemon: Codable {
    
    enum PokemonCodingKeys: CodingKey {
        case id, name, isFavorited, primaryType, types, sprites, abilities, stats, height, weight, damageRelations, species, evolutionChain
    }
        
    enum PokemonTypeContainerCodingKeys: CodingKey {
        case slot
        case type
    }

    enum PokemonTypeCodingKeys: CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonCodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.isFavorited = try container.decodeIfPresent(Bool.self, forKey: .isFavorited)
        
        self.types = try container.decode([APIPokemonSlotType].self, forKey: .types)
        
        self.sprites = try container.decode(PokemonSprites.self, forKey: .sprites)
        self.abilities = try container.decode([PokemonAbilities].self, forKey: .abilities)
        self.stats = try container.decode([Stats].self, forKey: .stats)
        self.height = try container.decode(Int.self, forKey: .height)
        self.weight = try container.decode(Int.self, forKey: .weight)
        self.damageRelations = try container.decodeIfPresent(PokemonDamageRelations.self, forKey: .damageRelations)
        self.species = try container.decodeIfPresent(PokemonSpecies.self, forKey: .species)
        self.evolutionChain = try container.decodeIfPresent(PokemonEvolution.self, forKey: .evolutionChain)
    }
}

extension Pokemon: Identifiable, Hashable {
    var identifier: Int {
        return id
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
