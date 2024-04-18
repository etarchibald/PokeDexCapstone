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
    
    var deck = [Deck]()
    var dummyDeck = [Deck(pokemon: [Pokemon(id: 1, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56)], id: UUID(), typeOfDeck: "Water", deckName: "Water Boi's", numberOfCards: 60),
    
        Deck(pokemon: [Pokemon(id: 2, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56)], id: UUID(), typeOfDeck: "fire", deckName: "fire", numberOfCards: 20),
        Deck(pokemon: [Pokemon(id: 3, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56)], id: UUID(), typeOfDeck: "ground", deckName: "ground", numberOfCards: 20),
                     
        Deck(pokemon: [Pokemon(id: 3, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56)], id: UUID(), typeOfDeck: "flying", deckName: "flying", numberOfCards: 20),
                     
        Deck(pokemon: [Pokemon(id: 4, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56)], id: UUID(), typeOfDeck: "electric", deckName: "really long name for some reason because maybe someone wants to explain it as they type", numberOfCards: 20)
                     
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deckTableView.dataSource = self
        deckTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    func deckMaker() {
        
    }
    
    func deckSearchBarSearchButtonClicked() {
        guard let searchText = deckSearchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else {
            // If the search text is empty, do nothing
            return
        }
        
        // Filter the decks by deckName containing the search text
        var filteredDecks = dummyDeck.filter { $0.deckName.localizedCaseInsensitiveContains(searchText) }
        
        // If the searched deck is found, move it to the top
        if let searchedDeckIndex = filteredDecks.firstIndex(where: { $0.deckName.localizedCaseInsensitiveContains(searchText) }) {
            let searchedDeck = filteredDecks.remove(at: searchedDeckIndex)
            filteredDecks.insert(searchedDeck, at: 0)
        }
        
        deckTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyDeck.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = deckTableView.dequeueReusableCell(withIdentifier: "deckCell", for: indexPath) as! DeckTableViewCell
        
        cell.setup(deck: dummyDeck[indexPath.row])
        
       return cell
    }
    
    
}
