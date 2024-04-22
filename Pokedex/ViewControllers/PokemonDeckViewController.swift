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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckController.decks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = deckTableView.dequeueReusableCell(withIdentifier: "deckCell", for: indexPath) as! DeckTableViewCell
        
        let aDeck = deckController.decks[indexPath.row]
        
        cell.deck = aDeck
        
        cell.setup(deck: aDeck)
        
        
       return cell
    }
    
    
}
