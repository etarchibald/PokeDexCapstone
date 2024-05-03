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
    
    
    func setup(move: PokemonMove) {
        nameLabel.text = move.name?.capitalized
        levelLabel.text = "\(move.levelLearnedAt ?? 0)"
        typeLabel = PokemonPrettyController.shared.createLabelForTypeBox(typeLabel, move.moveDetail!.type.name)
        typeBackgroundView = PokemonPrettyController.shared.createBackgroundForTypeBox(typeBackgroundView, move.moveDetail!.type.name)
        powerLabel.text = "\(move.moveDetail?.power ?? 0)"
        PPLabel.text = "\(move.pp ?? 0)"
    }
}
