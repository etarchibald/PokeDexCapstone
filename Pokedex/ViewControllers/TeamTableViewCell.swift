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
    let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

