//
//  DeckTableViewCell.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/18/24.
//

import UIKit

class DeckTableViewCell: UITableViewCell {

    @IBOutlet weak var deckNameLabel: UILabel!
    
    @IBOutlet weak var numberOfCardsLabel: UILabel!
    
    @IBOutlet weak var typeOfDeckLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(deck: Deck) {
        deckNameLabel.text = deck.deckName
        
        numberOfCardsLabel.text = String(deck.numberOfCards)
        
        typeOfDeckLabel.text = deck.typeOfDeck
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
