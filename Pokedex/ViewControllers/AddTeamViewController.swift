//
//  AddTeamViewController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/18/24.
//

import UIKit

class AddTeamViewController: UIViewController {
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamTypeTextField: UITextField!
    
    var team: Team?
    var dismissCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func addTeamButtonTapped(_ sender: Any) {
        guard let teamName = teamNameTextField.text,
              let teamType = teamTypeTextField.text else {
            return
        }
        // let selectedPokemon: [Pokemon] =  fetch the pokemon where they are stored?
        //newTeam.pokemon.append(contentsOf: selectedPokemon)
        
        // Create a new Team object with the entered data
        let newTeam = Team(pokemon: [] , id: UUID(), typeOfTeam: teamType, teamName: teamName) //selectedPokemon.count
        
        //newTeam.pokemon.append(selectedPokemon)
        TeamController.shared.addTeam(newTeam)
        //print(TeamController.shared.teams)
        
        TeamController.saveTeams(teams: TeamController.teams)
        
        if let dismissCompletion {
            dismissCompletion()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
