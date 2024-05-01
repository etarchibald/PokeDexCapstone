//
//  AddDeckViewController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/18/24.
//

import UIKit

class AddDeckViewController: UIViewController {
    
    @IBOutlet weak var deckNameTextField: UITextField!
    @IBOutlet weak var deckTypeTextField: UITextField!
    
    var deck: Deck?
    var dismissCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addDeckButtonTapped(_ sender: Any) {
        guard let deckName = deckNameTextField.text,
              let deckType = deckTypeTextField.text else {
            return
        }
        
       // let selectedPokemon: [Pokemon] =  fetch the pokemon where they are stored?
    //newDeck.pokemon.append(contentsOf: selectedPokemon)
        
        // Create a new Deck object with the entered data
        var newDeck = Deck(pokemon: [] , id: UUID(), typeOfDeck: deckType, deckName: deckName, numberOfCards: 0) //selectedPokemon.count
        
        //newDeck.pokemon.append(selectedPokemon)
        
        DeckController.shared.addDeck(newDeck)
        //print(DeckController.shared.decks)
        
        DeckController.saveDecks(decks: DeckController.decks)
        
        if let dismissCompletion {
            dismissCompletion()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
