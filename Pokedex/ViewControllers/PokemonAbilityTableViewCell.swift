//
//  PokemonAbilityTableViewCell.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/29/24.
//

import UIKit

class PokemonAbilityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var abilityNameLabel: UILabel!
    @IBOutlet weak var effectDescriptionLabel: UILabel!
    @IBOutlet weak var flavorTextLabel: UILabel!
    
    func setup(ability: PokemonAbilities) {
        abilityNameLabel.text = ability.name
        effectDescriptionLabel.text = ability.effect
        flavorTextLabel.text = ability.flavorText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
