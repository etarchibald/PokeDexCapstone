//
//  TeamController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/22/24.
//

import Foundation
class TeamController {
    
    static let shared = TeamController()
    
    static var teams: [Team] = []
    
    static let teamDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let teamArchiveURL = teamDocumentsDirectory.appendingPathComponent("team").appendingPathExtension("json")
    
    static func saveTeams(teams: [Team]) {
        let jsonEncoder = JSONEncoder()
        do {
            let encodedTeams = try jsonEncoder.encode(teams)
            try encodedTeams.write(to: teamArchiveURL, options: .noFileProtection)
            
        } catch {
            print("errorSavingTeams: \(error)")
            
        }
    }
    
    static func loadTeams() -> [Team] {
        let jsonDecoder = JSONDecoder()
        do {
            let retrievedTeamsData = try Data(contentsOf: teamArchiveURL)
            let decodedTeams = try jsonDecoder.decode(Array<Team>.self, from: retrievedTeamsData)
            return decodedTeams
        } catch {
            print("errorLoadingTeams: \(error)")
            return []
        }
    }
    //old dummy data, probably needs updating and changed to team names
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
    
    func addTeam(_ someTeam: Team) {
        TeamController.teams.append(someTeam)
    }
    
    func addPokemonToTeam(pokemon: Pokemon, toTeam teamId: UUID) {
            // Find the team with the specified ID
        guard let teamIndex = TeamController.teams.firstIndex(where: { $0.id == teamId }) else {
                print("Team with ID \(teamId) not found")
                return
            }
            
            // Append the Pokemon to the found team
        TeamController.teams[teamIndex].pokemon.append(pokemon)
            
            // Optionally, you can save the updated team to persistent storage
        TeamController.saveTeams(teams: TeamController.teams)
        }
    
    
    
}
