//
//  PokemonSearchTableViewController.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import UIKit

class PokemonSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var pokemon: [Pokemon] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        displayGenericPokemon()
    }
    
    func displayGenericPokemon() {
        Task {
            var pokemon = try? await PokemonController.getGenericPokemon()
            self.pokemon = pokemon!
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
        
        cell.setup(pokemon: pokemon[indexPath.row])

        return cell
    }
    
    
    @IBSegueAction func pokemonDetailSegueAction(_ coder: NSCoder) -> PokemonDetailViewController? {
        return PokemonDetailViewController(pokemon: pokemon[tableView.indexPathForSelectedRow!.row], coder: coder)
    }
    
    // MARK: - UISearchBar Delegate Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // If the text is empty bring the generic pokemon back to the screen
        if searchBar.text ?? "" == "" {
            displayGenericPokemon()
            return
        }
        
        // Display the searched pokemon
        Task {
            do {
                if let searchedPokemon = try await PokemonController.getSpecificPokemon(pokemonName: searchBar.text ?? "") {
                    pokemon = [searchedPokemon]
                    tableView.reloadData()
                }
            } catch {
                // TODO: Handle errors
                print(error)
            }
        }
    }
    

}
