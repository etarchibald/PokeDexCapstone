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
    @IBOutlet weak var abilityBackgroundView: UIView!
    @IBOutlet weak var effectBackgroundView: UIView!
    @IBOutlet weak var flavorTextBackgroundView: UIView!
    
    func setup(ability: PokemonAbilities) {
        abilityNameLabel.text = ability.name
        
        abilityNameLabel.layer.borderColor = UIColor(hex: "#ff0000").cgColor
        abilityNameLabel.layer.borderWidth = 2
        abilityNameLabel.layer.cornerRadius = 10
        
        effectDescriptionLabel.text = ability.effect
        flavorTextLabel.text = ability.flavorText
        
        abilityBackgroundView.backgroundColor = UIColor(hex: "#C0C0C0")
        abilityBackgroundView.layer.cornerRadius = 10
        abilityBackgroundView.addLightningEffect()
        
        effectBackgroundView.backgroundColor = UIColor(hex: "#0068B8")
        effectBackgroundView.layer.cornerRadius = 10
        
        effectBackgroundView.addLightningEffect()
        
        
        flavorTextBackgroundView.backgroundColor = UIColor(hex: "#009900")
        flavorTextBackgroundView.layer.cornerRadius = 10
        flavorTextBackgroundView.addLightningEffect()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

extension UIView {
    func addLightningEffect() {
        let lightningLayer = CAShapeLayer()
        lightningLayer.frame = bounds
        
        let lightningPath = UIBezierPath()
        // Customize lightning path as per your preference
        lightningPath.move(to: CGPoint(x: 0, y: bounds.height / 2))
        lightningPath.addLine(to: CGPoint(x: bounds.width / 2, y: 0))
        lightningPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height / 2))
        lightningPath.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height))
        lightningPath.close()
        
        lightningLayer.path = lightningPath.cgPath
        lightningLayer.strokeColor = UIColor.white.cgColor
        lightningLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(lightningLayer)
    }
}
