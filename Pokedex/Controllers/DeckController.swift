//
//  DeckController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/22/24.
//
//appending and deleting decks for static dekcs
import Foundation
class DeckController {
    
    static let shared = DeckController()
    
    static var decks: [Deck] = []
    
    static let deckDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let deckArchiveURL = deckDocumentsDirectory.appendingPathComponent("deck").appendingPathExtension("json")
    
    static func saveDecks(decks: [Deck]) {
        let jsonEncoder = JSONEncoder()
        do {
            let encodedDecks = try jsonEncoder.encode(decks)
            try encodedDecks.write(to: deckArchiveURL, options: .noFileProtection)
            
        } catch {
            print("errorSavingDecks: \(error)")
            
        }
    }
    
    static func loadDecks() -> [Deck] {
        let jsonDecoder = JSONDecoder()
        do {
            let retrievedDecksData = try Data(contentsOf: deckArchiveURL)
            let decodedDecks = try jsonDecoder.decode(Array<Deck>.self, from: retrievedDecksData)
            return decodedDecks
        } catch {
            print("errorLoadingDecks: \(error)")
            return []
        }
    }
//    var dummyDeck = [Deck(pokemon: [Pokemon(id: 1, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56)], id: UUID(), typeOfDeck: "Water", deckName: "Water Boi's", numberOfCards: 60),
//
//        Deck(pokemon: [Pokemon(id: 2, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56)], id: UUID(), typeOfDeck: "fire", deckName: "fire", numberOfCards: 20),
//        Deck(pokemon: [Pokemon(id: 3, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56)], id: UUID(), typeOfDeck: "ground", deckName: "ground", numberOfCards: 20),
//
//        Deck(pokemon: [Pokemon(id: 3, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56)], id: UUID(), typeOfDeck: "flying", deckName: "flying", numberOfCards: 20),
//
//        Deck(pokemon: [Pokemon(id: 4, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56)], id: UUID(), typeOfDeck: "electric", deckName: "really long name for some reason because maybe someone wants to explain it as they type", numberOfCards: 20)
//
//    ]
    
    func addDeck(_ someDeck: Deck) {
        decks.append(someDeck)
    }
    
    
    
}
