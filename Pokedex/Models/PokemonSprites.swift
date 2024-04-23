//
//  PokemonSprites.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import Foundation

struct PokemonSprites {
    var frontDefault: URL
    var backDefault: URL
    var frontShiny: URL
    var backShiny: URL
    var other: OtherSprites
}

extension PokemonSprites: Codable {
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
        case frontShiny = "front_shiny"
        case backShiny = "back_shiny"
        case other = "other"
    }
}

struct OtherSprites: Codable {
    var dreamWorld: MoreSprites
    var home: MoreSprites
    var officialArtwork: MoreSprites
    var showdown: MoreSprites
    
    enum CodingKeys: String, CodingKey {
        case dreamWorld = "dream_world"
        case home = "home"
        case officialArtwork = "official-artwork"
        case showdown = "showdown"
    }
}

struct MoreSprites: Codable {
    var frontDefault: URL?
    var frontFemale: URL?
    var frontShiny: URL?
    var frontShinyFemale: URL?
    var backDefault: URL?
    var backFemale: URL?
    var backShiny: URL?
    var backShinyFemale: URL?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_ female"
    }
}
