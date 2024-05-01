//
//  PokemonDeckViewController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/18/24.
//

import UIKit

class PokemonDeckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var deckTableView: UITableView!
    @IBOutlet weak var deckSearchBar: UISearchBar!
    
    var deckController = DeckController.shared
    var filteredDecks = [Deck]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deckTableView.dataSource = self
        deckTableView.delegate = self
        deckSearchBar.delegate = self
        
        DeckController.decks = DeckController.loadDecks()
        filteredDecks = DeckController.decks
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newDeckSegue" {
            if let nav = segue.destination as? UINavigationController, let first = nav.viewControllers.first as? AddDeckViewController {
                first.dismissCompletion = reload
            }
        }
    }
    
    func reload() {
        filteredDecks = DeckController.decks
        
        deckTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredDecks = DeckController.decks
        } else {
            isSearching = true
            filteredDecks = DeckController.decks.filter { $0.deckName.lowercased().contains(searchText.lowercased()) }
        }
        
        deckTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        deckTableView.reloadData()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let tableViewEdingMode = deckTableView.isEditing
        deckTableView.setEditing(!tableViewEdingMode, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredDecks.count
        } else {
            return DeckController.decks.count
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presentAlertForDeleting(indexPath: indexPath)
        }
    }
    
    func presentAlertForDeleting(indexPath: IndexPath) {
        let deckToDelete: Deck
        
        if isSearching {
            deckToDelete = filteredDecks[indexPath.row]
        } else {
            deckToDelete = DeckController.decks[indexPath.row]
        }
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete \(deckToDelete.deckName)?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            if self.isSearching {
                self.filteredDecks.remove(at: indexPath.row)
                
            } else {
                DeckController.decks.remove(at: indexPath.row)
                
            }
            
            DeckController.saveDecks(decks: DeckController.decks)
            
            self.deckTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        alert.addAction(yesAction)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedDeck = DeckController.decks.remove(at: fromIndexPath.row)
        DeckController.decks.insert(movedDeck, at: to.row)
        DeckController.saveDecks(decks: DeckController.decks)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = deckTableView.dequeueReusableCell(withIdentifier: "deckCell", for: indexPath) as! DeckTableViewCell
        
        let aDeck = filteredDecks[indexPath.row]
        
        cell.deck = aDeck
        
        cell.setup(deck: aDeck)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
}
//not searching, empty search, search with stuff
