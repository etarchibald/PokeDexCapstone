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
    
    let segments = 4
    var pokemon: Pokemon
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        abilitiesTableView.dataSource = self
        abilitiesTableView.delegate = self
        
        setUpPokemonInfo()
    }
    
    init?(pokemon: Pokemon, coder: NSCoder) {
        self.pokemon = pokemon
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpPokemonInfo() {
        
        // Needs to be corrected to load properly showing nil
        let strengths = pokemon.damageRelations?.damageRelations.doubleDamageTo
        let weaknesses = pokemon.damageRelations?.damageRelations.doubleDamageFrom
        
//        print(strengths)
//        print(weaknesses)
        
        pokemonNameLabel.text = pokemon.name.capitalized
        pokemonImageView.load(url: pokemon.sprites.front_default)
        pokemonTypingLabel.text = pokemon.types.reduce("") { "\($0) \($1.type.name)" }.capitalized
        
        
        for stat in pokemon.stats {
            let statDataToAppend = String(stat.base_stat)
            switch stat.stat.name {
            case "hp":
                hpStatLabel.text! += " \(statDataToAppend)"
            case "attack":
                attackLabel.text! += " \(statDataToAppend)"
            case "defense":
                defenseLabel.text! += " \(statDataToAppend)"
            case "special-attack":
                specialAttackLabel.text! += " \(statDataToAppend)"
            case "special-defense":
                specialDefenseLabel.text! += " \(statDataToAppend)"
            case "speed":
                speedLabel.text! += " \(statDataToAppend)"
            default:
                break
            }
        }
        
        // Reliant on image fetching call from API
        for segment in 0..<segments {
            
        }
        
        
        
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

