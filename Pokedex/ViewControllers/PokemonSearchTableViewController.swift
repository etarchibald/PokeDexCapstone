//
//  PokemonSearchTableViewController.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import UIKit

class PokemonSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var pokemon = [Pokemon]()

    override func viewDidLoad() {
        super.viewDidLoad()

        displayGenericPokemon()
    }
    
    func displayGenericPokemon() {
        Task {
            do {
                let pokemon = try await PokemonNetworkController.shared.getGenericPokemon()
                self.pokemon = pokemon
            } catch {
                print("error: \(error)")
            }
            
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pokemon.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonTableViewCell
        
        let pokemon = pokemon[indexPath.row]
        
        cell.pokemon = pokemon
        
        cell.delegate = self
        
        cell.setup(pokemon: pokemon)

        return cell
    }
    
    @IBSegueAction func pokemonDetailSegueAction(_ coder: NSCoder) -> UIViewController? {
        return (pokemon: pokemon[tableView.indexPathForSelectedRow!.row], coder: coder)
    }
    
    // MARK: - UISearchBar Delegate Methods
    //What I'm working on Error message for noResultsFound/ wrong spelling
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // If the text is empty bring the generic pokemon back to the screen
        if searchBar.text ?? "" == "" {
            displayGenericPokemon()
            return
        }
        
        // Display the searched pokemon
        Task {
            do {
                if let searchedPokemon = try await PokemonNetworkController.shared.getSpecificPokemon(pokemonName: searchBar.text ?? "") {
                    pokemon = [searchedPokemon]
                    tableView.reloadData()
                    
                    DispatchQueue.main.async {
                        self.navigationItem.title = nil
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Pokemon not Found"
                    }
                }
                    
            } catch {
                // TODO: Handle errors
                DispatchQueue.main.async {
                    self.navigationItem.title = "No Results Found or Wrong Spelling"
                }
                print("Error: \(error)")
            }
        }
    }
    

}

extension PokemonSearchTableViewController: FavoritePokemon {
    func addPokemonToFavorite(pokemon: Pokemon) {
        for (index, eachPokemon) in self.pokemon.enumerated() {
            if eachPokemon.name == pokemon.name {
                self.pokemon[index] = pokemon
            }
        }
    }
}
