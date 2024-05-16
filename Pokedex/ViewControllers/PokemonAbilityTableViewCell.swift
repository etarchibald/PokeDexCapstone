//
//  PokemonAbilityTableViewCell.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/29/24.
//

import UIKit

class PokemonAbilityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var effectTextLabel: UILabel!
    @IBOutlet weak var abilityTextLabel: UILabel!
    
    @IBOutlet weak var extraTextLabel: UILabel!
    @IBOutlet weak var abilityNameLabel: UILabel!
    @IBOutlet weak var effectDescriptionLabel: UILabel!
    @IBOutlet weak var flavorTextLabel: UILabel!
    @IBOutlet weak var abilityBackgroundView: UIView!
    @IBOutlet weak var effectBackgroundView: UIView!
    @IBOutlet weak var flavorTextBackgroundView: UIView!
    @IBOutlet weak var abilityNameLabelBackgroundView: UIView!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    func setup(ability: PokemonAbilities) {
        abilityNameLabel.text = ability.name?.capitalized
        abilityNameLabel.textColor = .black
        abilityTextLabel.textColor = UIColor(hex: "#CC0000")
        effectDescriptionLabel.text = ability.effect
        effectDescriptionLabel.textColor = .black
        flavorTextLabel.text = ability.flavorText
        flavorTextLabel.textColor = .black
        effectTextLabel.textColor = UIColor(hex: "#1E90FF")
        extraTextLabel.textColor = UIColor(hex: "#006600")
        
        
        abilityBackgroundView.backgroundColor = UIColor(hex: "#ECECEC")
        abilityBackgroundView.layer.cornerRadius = 10
        abilityNameLabelBackgroundView.backgroundColor = UIColor(hex: "#ECECEC")
        //abilityBackgroundView.addLightningEffect()
        
        effectBackgroundView.backgroundColor = UIColor(hex: "#ECECEC")
        effectBackgroundView.layer.cornerRadius = 10
        
        //effectBackgroundView.addLightningEffect()
        
        
        flavorTextBackgroundView.backgroundColor = UIColor(hex: "#ECECEC")
        flavorTextBackgroundView.layer.cornerRadius = 10
        //flavorTextBackgroundView.addLightningEffect()
        
        cellBackgroundView.backgroundColor = UIColor(hex: "#ECECEC")
        cellBackgroundView.layer.cornerRadius = 10
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
