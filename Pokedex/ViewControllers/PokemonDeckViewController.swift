//
//  PokemonDeckViewController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/18/24.
//

import UIKit

class PokemonDeckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var deckTableView: UITableView!
    @IBOutlet weak var deckSearchBar: UISearchBar!
    
    var deckController = DeckController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deckTableView.dataSource = self
        deckTableView.delegate = self
        
        deckController.decks = PokemonPersistenceController.loadDecks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newDeckSegue" {
            if let nav = segue.destination as? UINavigationController, let first = nav.viewControllers.first as? AddDeckViewController {
                first.dismissCompletion = reload
            }
        }
    }
    
    func reload() {
        deckTableView.reloadData()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let tableViewEdingMode = deckTableView.isEditing
        deckTableView.setEditing(!tableViewEdingMode, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckController.decks.count
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deckController.decks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            PokemonPersistenceController.saveDecks(decks: DeckController.shared.decks)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedDeck = deckController.decks.remove(at: fromIndexPath.row)
        deckController.decks.insert(movedDeck, at: to.row)
        PokemonPersistenceController.saveDecks(decks: DeckController.shared.decks)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = deckTableView.dequeueReusableCell(withIdentifier: "deckCell", for: indexPath) as! DeckTableViewCell
        
        let aDeck = deckController.decks[indexPath.row]
        
        cell.deck = aDeck
        
        cell.setup(deck: aDeck)
        
        
       return cell
    }
        
}
