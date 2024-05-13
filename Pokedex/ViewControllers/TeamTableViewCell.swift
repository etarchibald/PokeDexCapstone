//
//  TeamTableViewCell.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/18/24.
//

import UIKit
//uiimage, programticllay to set for each pokemon
//Visualizations and grouping
//icon, info, space around content and same space,
//add boxes of types that are in teams
//maybe a ui circle or box that has the first letter of the team
//litte arrows at end of cell to show it goes somewhere
//separators or spacing?
//cards?
class TeamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var numberOfPokemonLabel: UILabel!
    @IBOutlet weak var typeOfTeamLabel: UILabel!
    @IBOutlet weak var typeBackgroundView: UIView!
    
    let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let prettyControllerShared = PokemonPrettyController.shared
    private let teamControllerShared = TeamController.shared
    
    var team: Team? {
        didSet {
            if let team = team {
                setup(team: team)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20), // Adjust as needed
            chevronImageView.heightAnchor.constraint(equalToConstant: 20) // Adjust as needed
        ])
    }
    
    func setup(team: Team) {
        teamNameLabel.text = team.teamName
        numberOfPokemonLabel.text = String("Number of Pokemon in Team: \(team.numberOfCards)")
        typeOfTeamLabel.text = team.typeOfTeam
        
        
        // Clear previous sublayers
        typeBackgroundView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        // Loop through each Pokemon and add a gradient layer for its background
        for (index, pokemon) in team.pokemon.enumerated() {
            let gradient = CAGradientLayer()
            gradient.colors = [
                UIColor(hex: prettyControllerShared.getBackgroundColorHex(type: pokemon.primaryType ?? .normal)).cgColor,
                UIColor(hex: prettyControllerShared.getBackgroundColorHex(type: pokemon.secondaryType ?? .normal)).cgColor
            ]
            let gradientWidth: CGFloat = 30
            let gradientSpacing: CGFloat = 2
            let xOffset = CGFloat(index) * (gradientWidth + gradientSpacing) // Adjust the width and spacing as needed
            gradient.frame = CGRect(x: xOffset, y: 0, width: gradientWidth, height: typeBackgroundView.bounds.height)
            
            gradient.cornerRadius = 5
            
            typeBackgroundView.clipsToBounds = false
            typeBackgroundView.layer.cornerRadius = 10
            typeBackgroundView.layer.addSublayer(gradient)
        }
        
        // Add shadow and corner radius to the cell
        self.addShadowAndCornerRadiusForTables()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

