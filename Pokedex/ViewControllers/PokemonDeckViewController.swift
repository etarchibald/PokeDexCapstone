//
//  PokemonDeckViewController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/18/24.
//

import UIKit

class PokemonDeckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var deckTableView: UITableView!
    
    var decks = [Deck]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deckTableView.dataSource = self
        deckTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    func deckMaker() {
        
    }
    
    func deckSearchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else {
            // If the search text is empty, do nothing
            return
        }
        
        // Filter the decks by deckName containing the search text
        let filteredDecks = decks.filter { $0.deckName.localizedCaseInsensitiveContains(searchText) }
        
        // Now you can use the filteredDecks array as needed, such as displaying it in a table view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = deckTableView.dequeueReusableCell(withIdentifier: "deckCell", for: indexPath) as! DeckTableViewCell
        
        
       return cell
    }
    
    
}
