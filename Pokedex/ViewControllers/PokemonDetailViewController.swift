//
//  ViewController.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    // Outlets relating to Pokemon images
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonTypingLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var imageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var generationIntroducedLabel: UILabel!
    
    //Evolution chain data labels
    @IBOutlet weak var previousEvolutionLabel: UILabel!
    @IBOutlet weak var nextEvolutionLabel: UILabel!
    
    // Base stats labels
    @IBOutlet weak var hpStatLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var specialAttackLabel: UILabel!
    @IBOutlet weak var specialDefenseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    // Damage relations labels
    @IBOutlet weak var typeStrengthsLabel: UILabel!
    @IBOutlet weak var typeWeaknessLabel: UILabel!
    
    // Abilites tableview
    @IBOutlet weak var abilitiesTableView: UITableView!
    
    var pokemon: Pokemon

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        abilitiesTableView.dataSource = self
        abilitiesTableView.delegate = self
        
        
        pokemonNameLabel.text = pokemon.name
        pokemonImageView.load(url: pokemon.sprites.front_default)
        pokemonTypingLabel.text = pokemon.types.reduce("") { "\($0 ?? "") \($1.type.name)" }
    }
    
    init?(pokemon: Pokemon, coder: NSCoder) {
        self.pokemon = pokemon
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension PokemonDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemon.abilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let ability = pokemon.abilities[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = ability.ability.name
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}

