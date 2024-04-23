//
//  PokemonSearchTableViewController.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import UIKit

class PokemonSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var pokemon = [Pokemon]()
    
    var datasource: UITableViewDiffableDataSource<Int, Pokemon>!

    override func viewDidLoad() {
        super.viewDidLoad()

        displayGenericPokemon()
        setUpDataSource()
    }
    
    func displayGenericPokemon() {
        Task {
            do {
                FavoritePokemonViewController.favoritePokemon.append(contentsOf: PokemonPersistenceController.loadPokemon())
                let pokemon = try await PokemonNetworkController.shared.getGenericPokemon()
                applySnapshot(from: pokemon)
                self.pokemon = pokemon
            } catch {
                print("error: \(error)")
            }
            
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    
    func setUpDataSource() {
        datasource = UITableViewDiffableDataSource<Int, Pokemon>(tableView: tableView) { tableView, indexPath, pokemon in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell") as! PokemonTableViewCell
            
            cell.pokemon = pokemon
            cell.delegate = self
            cell.setup(pokemon: pokemon)
            
            return cell
        }
    }
    
    func applySnapshot(from pokemon: [Pokemon]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Pokemon>()
        snapshot.appendSections([0])
        snapshot.appendItems(pokemon)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    func reload(_ pokemon: Pokemon) {
        var snapshot  = datasource.snapshot()
        snapshot.reloadItems([pokemon])
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    
    @IBSegueAction func pokemonDetailSegueAction(_ coder: NSCoder) -> UIViewController? {
        return PokemonDetailTableViewController(pokemon: pokemon[tableView.indexPathForSelectedRow!.row], coder: coder)
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
                    applySnapshot(from: [searchedPokemon])
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
