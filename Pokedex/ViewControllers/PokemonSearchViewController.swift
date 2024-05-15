//
//  PokemonSearchTableViewController.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import UIKit

class PokemonSearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    var pokemon = [Pokemon]()
    private var pageNumber = 0
    private var isFetchingPokemon = false
    private var hasMorePokemon = false
    private var hasSearchedForPokemon = false
    
    var dataSource: UITableViewDiffableDataSource<Int, Pokemon>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            FavoritePokemonViewController.favoritePokemon.append(contentsOf: PokemonPersistenceController.loadPokemon())
        }
        displayGenericPokemon(pageNumber: pageNumber)
        setUpDataSource()
        
        tabBarController?.tabBar.items?[2].title = "Teams"
    }
    
    func displayGenericPokemon(pageNumber: Int) {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 100)
        spinner.startAnimating()
        tableView.tableHeaderView = spinner
        Task {
            do {
                let pokemon = try await PokemonNetworkController.shared.getGenericPokemon(page: pageNumber)
                applySnapshot(from: pokemon)
                self.pokemon.append(contentsOf: pokemon)
                hasMorePokemon = true
                spinner.stopAnimating()
                tableView.tableHeaderView = nil
            } catch {
                print("error: \(error)")
                throw API.APIError.APIRequestFailed
            }
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
            
            
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex && self.segmentedControl.selectedSegmentIndex != 2 {
                let spinner = UIActivityIndicatorView(style: .large)
                spinner.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 70)
                if self.hasSearchedForPokemon {
                    spinner.stopAnimating()
                    tableView.tableFooterView = nil
                } else {
                    spinner.startAnimating()
                    tableView.tableFooterView = spinner
                }
            }
            
            
            if indexPath.row == self.pokemon.count - 1 && self.segmentedControl.selectedSegmentIndex != 2 {
                self.pageNumber += 1
                self.fetchMoreGenericPokemon(pageNumber: self.pageNumber)
            }
            
            cell.pokemon = pokemon
            cell.delegate = self
            cell.setup(pokemon: pokemon)
            cell.selectionStyle = .none
            
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
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([pokemon])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @IBSegueAction func pokemonDetailSegueAction(_ coder: NSCoder) -> UIViewController? {
        
        let pokemon = pokemon[tableView.indexPathForSelectedRow!.row]
        
        self.navigationItem.title = nil
        let destinationVC = PokemonDetailTableViewController(pokemon: pokemon, coder: coder)
        destinationVC?.delegate = self
        return destinationVC
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
            hasSearchedForPokemon = false
            return
        }
        
        // Display the searched pokemon
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            fetchPokemonByName(searchText: searchBar.text ?? "")
        case 1:
            searchBar.keyboardType = .numberPad
            fetchPokemonByNumber(searchNumber: Int(searchBar.text ?? "") ?? 1)
        case 2:
            searchBar.keyboardType = .numberPad
            fetchPokemonByGen(searchNumber: Int(searchBar.text ?? "") ?? 1)
        case 3:
            fetchPokemonByType(type: searchBar.text ?? "normal")
        default:
            break
        }
        
    }
    
    func fetchPokemonByGen(searchNumber: Int) {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 80)
        spinner.startAnimating()
        tableView.tableHeaderView = spinner
        
        Task {
            do {
                let searchedGenPokemonResults = try await PokemonNetworkController.shared.fetchGenerationPokemonResults(gen: searchNumber)
                
                
                let arrayOfGenPokemon = searchedGenPokemonResults.splitIntoEqualParts(numberOfParts: searchedGenPokemonResults.count / 10)
                
                var pokemonToAdd = [Pokemon]()
                self.pokemon = pokemonToAdd
                
                for batchArray in arrayOfGenPokemon {
                    Task {
                        pokemonToAdd = await PokemonNetworkController.shared.fetchGenerationBatch(genBatch: batchArray)
                        
                        spinner.stopAnimating()
                        self.tableView.tableHeaderView = nil
                        self.pokemon.append(contentsOf: pokemonToAdd)
                        self.applySnapshot(from: self.pokemon)
                    }
                }
                
                DispatchQueue.main.async {
                    self.navigationItem.title = nil
                }
                    
            } catch {
                // TODO: Handle errors
                DispatchQueue.main.async {
                    self.navigationItem.title = "No Results Found in this Generation"
                }
                print("Error: \(error)")
            }
        }
        
        hasSearchedForPokemon = true
        tableView.tableFooterView = nil
        isFetchingPokemon = true
    }
    
    func fetchPokemonByNumber(searchNumber: Int) {
        fetchPokemonByName(searchText: String(searchNumber))
    }
    
    func fetchPokemonByName(searchText: String) {
        Task {
            do {
                if let searchedPokemon = try await PokemonNetworkController.shared.getSpecificPokemon(pokemonName: searchText) {
                    applySnapshot(from: [searchedPokemon])
                    pokemon = [searchedPokemon]
                    
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
        
        isFetchingPokemon = true
        hasSearchedForPokemon = true
    }
    
    func fetchPokemonByType(type: String) {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 80)
        spinner.startAnimating()
        tableView.tableHeaderView = spinner
        
        Task {
            do {
                let searchedByTypePokemonResults = try await PokemonNetworkController.shared.fetchGenericPokemonByType(type: type)
                
                let arrayOfTypePokemon = searchedByTypePokemonResults.splitIntoEqualParts(numberOfParts: searchedByTypePokemonResults.count / 10)
                
                var pokemonToAdd = [Pokemon]()
                self.pokemon = pokemonToAdd
                
                for batchArray in arrayOfTypePokemon {
                    Task {
                        pokemonToAdd = try await PokemonNetworkController.shared.fetchGenericPokemonByTypeBatch(batch: batchArray)
                        
                        spinner.stopAnimating()
                        self.tableView.tableHeaderView = nil
                        self.pokemon.append(contentsOf: pokemonToAdd)
                        self.applySnapshot(from: self.pokemon)
                    }
                }
                
                DispatchQueue.main.async {
                    self.navigationItem.title = nil
                }
                    
            } catch {
                // TODO: Handle errors
                DispatchQueue.main.async {
                    self.navigationItem.title = "No Results Found in this Generation"
                }
                print("Error: \(error)")
            }
        }
        
        hasSearchedForPokemon = true
        tableView.tableFooterView = nil
        isFetchingPokemon = true
    }
}

extension PokemonSearchViewController: FavoritePokemon {
    func addPokemonToFavorite(pokemon: Pokemon) {
        for (index, eachPokemon) in self.pokemon.enumerated() {
            if eachPokemon.id == pokemon.id {
                self.pokemon[index] = pokemon
                self.applySnapshot(from: self.pokemon)
                self.reload(pokemon)
            }
        }
    }
}
