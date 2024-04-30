//
//  PokemonMovesCollectionViewCell.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/30/24.
//

import UIKit

class PokemonMovesCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var PPLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var typeBackgroundView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    
    func setup(moves: PokemonMove) {
        nameLabel.text = moves.name
        levelLabel.text = "\(moves.levelLearnedAt ?? 0)"
        typeLabel = PokemonPrettyController.shared.createLabelForTypeBox(typeLabel, moves.type ?? .normal)
        typeBackgroundView = PokemonPrettyController.shared.createBackgroundForTypeBox(typeBackgroundView, moves.type ?? .normal)
        powerLabel.text = "\(moves.power ?? 0)"
        PPLabel.text = "\(moves.pp ?? 0)"
    }
}
