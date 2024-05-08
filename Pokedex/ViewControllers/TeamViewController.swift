//
//  PokemonTeamViewController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/18/24.
//

import UIKit

class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var teamSearchBar: UISearchBar!
    
    var filteredTeams = [Team]()
    var isSearching = false
    var delegate: UpdateCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamTableView.dataSource = self
        teamTableView.delegate = self
        teamSearchBar.delegate = self
        
        
        TeamController.teams = TeamController.loadTeams()
        filteredTeams = TeamController.teams
    }
    
    @IBSegueAction func pokemonTeam(_ coder: NSCoder) -> PokemonTeamViewController? {
        
        guard let selectedIndexPath = teamTableView.indexPathForSelectedRow else { return nil }
        let selectedTeam = filteredTeams[selectedIndexPath.row]
       
        //pass the team touched into the coder
        return PokemonTeamViewController(coder: coder, team: selectedTeam)
    }
    /Users/jacobdavis/Mobile Development Projects/Projects/PokeDexCapstone/Pokedex/ViewControllers/AddTeamViewController.swift
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTeamSegue" {
            if let nav = segue.destination as? UINavigationController, let first = nav.viewControllers.first as? AddTeamViewController {
                first.dismissCompletion = reload
            }
        } 
        
        //ib asction segue init the pokemontemview with ns coder and team write init of
//        else if let teamVC = segue.destination as? PokemonTeamViewController {
//            if let indexPath = teamTableView.indexPathForSelectedRow {
//                let selectedTeam = filteredTeams[indexPath.row]
//                teamVC.team = selectedTeam.pokemon
//            }
        }
    
    func reload() {
        filteredTeams = TeamController.teams
        teamTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredTeams = TeamController.teams
        } else {
            isSearching = true
            filteredTeams = TeamController.teams.filter { $0.teamName.lowercased().contains(searchText.lowercased()) }
        }
        teamTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        teamTableView.reloadData()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let tableViewEdingMode = teamTableView.isEditing
        teamTableView.setEditing(!tableViewEdingMode, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredTeams.count
        } else {
            return TeamController.teams.count
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presentAlertForDeleting(indexPath: indexPath)
        }
    }
    
    func presentAlertForDeleting(indexPath: IndexPath) {
        let teamToDelete: Team
        
        if isSearching {
            teamToDelete = filteredTeams[indexPath.row]
        } else {
            teamToDelete = TeamController.teams[indexPath.row]
        }
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete \(teamToDelete.teamName)?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            if self.isSearching {
                self.filteredTeams.remove(at: indexPath.row)
            } else {
                TeamController.teams.remove(at: indexPath.row)
            }
            TeamController.saveTeams(teams: TeamController.teams)
            
            self.teamTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedTeam = TeamController.teams.remove(at: fromIndexPath.row)
        TeamController.teams.insert(movedTeam, at: to.row)
        TeamController.saveTeams(teams: TeamController.teams)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = teamTableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! TeamTableViewCell
        
        let aTeam = filteredTeams[indexPath.row]
        cell.team = aTeam
        cell.setup(team: aTeam)
        cell.selectionStyle = .none
        delegate?.updateCell()
        return cell
    }
    
}

extension TeamViewController: UpdateCell {
    func updateCell() {
        self.teamTableView.reloadData()
    }
    
    
}
