//
//  PokemonDeck.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/18/24.
//

import Foundation

struct Deck: Codable {
    var pokemon: [Pokemon] = []
    var id: UUID = UUID()
    var typeOfDeck: String
    var deckName: String
    var numberOfCards: Int
}
