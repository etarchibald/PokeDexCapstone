//
//  TeamTableViewCell.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/18/24.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

    @IBOutlet weak var teamNameLabel: UILabel!
    
    @IBOutlet weak var numberOfPokemonLabel: UILabel!
    
    @IBOutlet weak var typeOfTeamLabel: UILabel!
    
    var team: Team?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(team: Team) {
        teamNameLabel.text = team.teamName
        
        numberOfPokemonLabel.text = String("Number of Pokemon in Team: \(team.numberOfCards)")
        
        typeOfTeamLabel.text = team.typeOfTeam
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
