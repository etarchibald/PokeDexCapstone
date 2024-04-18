//
//  PokemonTableViewCell.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var generationLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
        
        let typeNames = pokemon.types.map { $0.type.name.capitalized }
        let typesString = typeNames.joined(separator: ", ")
        typeLabel.text = typesString.isEmpty ? "Unknown Type" : typesString
        
        generationLabel.text = pokemon.species?.generation?.name
        
        pokemonImage.load(url: pokemon.sprites.front_default)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
