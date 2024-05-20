//
//  TeamController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/22/24.
//

import Foundation
import UIKit
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
            let decodedTeams = try jsonDecoder.decode([Team].self, from: retrievedTeamsData)
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

extension UITableViewCell {
    func addShadowAndCornerRadiusForTables(corner: CGFloat = 15, color: UIColor = .black, radius: CGFloat = 3, offset: CGSize = CGSize(width: 0, height: 0), opacity: Float = 0.5) {
        let cell = self
        cell.contentView.layer.cornerRadius = corner
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = color.cgColor
        cell.layer.shadowOffset = offset
        cell.layer.shadowRadius = radius
        cell.layer.shadowOpacity = opacity
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    }
}

