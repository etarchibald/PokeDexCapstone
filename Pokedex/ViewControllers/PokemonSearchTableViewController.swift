//
//  PokemonSearchTableViewController.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import UIKit

class PokemonSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var pokemon = [Pokemon]()
    private var pageNumber = 0
    private var isFetchingPokemon = false
    private var hasMorePokemon = false
    
    var dataSource: UITableViewDiffableDataSource<Int, Pokemon>!

    override func viewDidLoad() {
        super.viewDidLoad()

        FavoritePokemonViewController.favoritePokemon.append(contentsOf: PokemonPersistenceController.loadPokemon())
        displayGenericPokemon(pageNumber: pageNumber)
        setUpDataSource()
    }
    
    func displayGenericPokemon(pageNumber: Int) {
        Task {
            do {
                let pokemon = try await PokemonNetworkController.shared.getGenericPokemon(page: pageNumber)
                applySnapshot(from: pokemon)
                self.pokemon.append(contentsOf: pokemon)
                hasMorePokemon = true
            } catch {
                print("error: \(error)")
            }
            
            tableView.reloadData()
        }
    }
    
    private func fetchMoreGenericPokemon(pageNumber: Int) {
        guard !isFetchingPokemon, hasMorePokemon else { return }
        
        isFetchingPokemon = true
        
        Task {
            do {
                let newPokemon = try await PokemonNetworkController.shared.getGenericPokemon(page: pageNumber)
                print("page: \(pageNumber) with \(self.pokemon.count) many pokemon")
                
                if newPokemon.count < 20 {
                    hasMorePokemon = false
                }
                
                DispatchQueue.main.async {
                    if newPokemon.isEmpty {
                        self.hasMorePokemon = false
                    } else {
                        
                        self.pokemon.append(contentsOf: newPokemon)
                        self.applySnapshot(from: self.pokemon)
                        
                    }
                    self.isFetchingPokemon = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isFetchingPokemon = false
                    
                }
            }
        }
    }

    // MARK: - Table view data source
    
    func setUpDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Pokemon>(tableView: tableView) { tableView, indexPath, pokemon in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell") as! PokemonTableViewCell
            
            if indexPath.row == self.pokemon.count - 1 {
                self.pageNumber += 1
                self.fetchMoreGenericPokemon(pageNumber: self.pageNumber)
            }
            
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
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func reload(_ pokemon: Pokemon) {
        var snapshot  = dataSource.snapshot()
        snapshot.reloadItems([pokemon])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
    @IBSegueAction func pokemonDetailSegueAction(_ coder: NSCoder) -> UIViewController? {
        return PokemonDetailTableViewController(pokemon: pokemon[tableView.indexPathForSelectedRow!.row], coder: coder)
    }
    
    // MARK: - UISearchBar Delegate Methods
    //What I'm working on Error message for noResultsFound/ wrong spelling
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // If the text is empty bring the generic pokemon back to the screen
        
        if searchBar.text ?? "" == "" {
            pokemon = []
            pageNumber = 0
            displayGenericPokemon(pageNumber: pageNumber)
            isFetchingPokemon = false
            return
        }
        
        // Display the searched pokemon
        Task {
            do {
                if let searchedPokemon = try await PokemonNetworkController.shared.getSpecificPokemon(pokemonName: searchBar.text ?? "") {
                    applySnapshot(from: [searchedPokemon])
                    pokemon = [searchedPokemon]
                    isFetchingPokemon = true
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
