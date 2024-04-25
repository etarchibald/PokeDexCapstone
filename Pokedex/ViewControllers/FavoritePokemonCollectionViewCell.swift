//
//  FavoritePokemonCollectionViewCell.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/17/24.
//

import UIKit
import SwiftUI

class FavoritePokemonCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet var cellBackgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private let prettyControllerShared = PokemonPrettyController.shared
    
    func updateUI(using pokemon: Pokemon) {
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(hex: prettyControllerShared.getBackgroundColorHex(type: pokemon.primaryType ?? .normal)).cgColor, UIColor(hex: prettyControllerShared.getBackgroundColorHex(type: pokemon.secondaryType ?? .normal)).cgColor]
        gradient.frame = bounds
        
        cellBackgroundView.layer.addSublayer(gradient)
        
        self.layer.cornerRadius = 20
        
        nameLabel.text =  pokemon.name.capitalized
        
        if pokemon.primaryType == .dark || pokemon.primaryType == .fighting || pokemon.primaryType == .poison || pokemon.primaryType == .ghost {
            nameLabel.textColor = .white
        } else {
            nameLabel.textColor = .black
        }
        
        imageView.load(url: pokemon.sprites.frontDefault)
    }
}
