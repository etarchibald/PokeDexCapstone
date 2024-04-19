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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func textFromFields(deck: Deck ) {
        deckNameTextField.text = deck.deckName
        deckTypeTextField.text = deck.typeOfDeck
    }
    
    
    @IBAction func addDeckButtonTapped(_ sender: Any) {
        
    }
    
}
