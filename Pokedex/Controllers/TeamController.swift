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
        
        TeamController.saveTeams(teams: TeamController.teams)
    }
    
    
    func deletePokemonFromTeam(pokemon: Pokemon, fromTeam team: Team) {
        TeamController.teams.first(where: { $0.id == team.id })?.pokemon.removeAll(where: { $0.id == pokemon.id })
    }
}
