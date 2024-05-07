//
//  PokemonAbilitiesTableViewController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/29/24.
//

import UIKit

class PokemonAbilitiesTableViewController: UITableViewController {
    
    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon?.abilities.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonAbility", for: indexPath) as! PokemonAbilityTableViewCell
        
        if pokemon?.abilities.first?.abilityDetails == nil {
            Task {
                do {
                    
                    pokemon = try await PokemonNetworkController.shared.fetchPokemonAbilites(pokemon: pokemon!)
                    let abilities = pokemon?.abilities[indexPath.row]
                    cell.setup(ability: abilities!)
                    cell.selectionStyle = .none
                    
                } catch {
                    throw error
                }
            }
        } else {
            
            let abilities = pokemon?.abilities[indexPath.row]
            cell.setup(ability: abilities!)
            cell.selectionStyle = .none
            
        }
        
        return cell
    }
    
}
