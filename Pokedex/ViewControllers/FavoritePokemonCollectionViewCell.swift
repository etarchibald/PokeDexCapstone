//
//  FavoritePokemonCollectionViewCell.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/17/24.
//

import UIKit

class FavoritePokemonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func updateUI(using pokemon: Pokemon) {
        nameLabel.text =  pokemon.name
        imageView.load(url: pokemon.sprites.front_default)
    }
}
