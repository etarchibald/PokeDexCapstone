//
//  AddDeckViewController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/18/24.
//
//modal add top right anddd a cancel top left

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
        // Create a new Deck object with the entered data
        let newDeck = Deck(pokemon: [], id: UUID(), typeOfDeck: deckType, deckName: deckName, numberOfCards: 0)
        
        DeckController.shared.addDeck(newDeck)
        //print(DeckController.shared.decks)
        
        DeckController.saveDecks(decks: DeckController.shared.decks)
        
        if let dismissCompletion {
            dismissCompletion()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
