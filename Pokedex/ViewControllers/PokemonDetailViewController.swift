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
    
    // Evolution chain data labels
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
        let strengths = pokemon.damageRelations?.damageRelations.doubleDamageTo ?? []
        let weaknesses = pokemon.damageRelations?.damageRelations.doubleDamageFrom ?? []
        let pokemonTyping = pokemon.types.reduce("") { "\($0) \($1.type.name)" }.capitalized
        
        if pokemon.species?.isMythical ?? false {
            pokemonTypingLabel.text = "Mythical \(pokemonTyping) Pokemon"
        } else if pokemon.species?.isLegendary ?? false {
            pokemonTypingLabel.text = "Legendary \(pokemonTyping) Pokemon"
        } else {
            pokemonTypingLabel.text = "\(pokemonTyping) Pokemon"
        }
        
        pokemonNameLabel.text = pokemon.name.capitalized
        pokemonImageView.load(url: pokemon.sprites.front_default)
        generationIntroducedLabel.text! += pokemon.species?.generation?.name ?? ""
        previousEvolutionLabel.text! += "\n\(pokemon.evolutionChain?.chain.evolvesTo.first?.species.name.capitalized ?? "None")"
        nextEvolutionLabel.text! += "\n\(pokemon.evolutionChain?.chain.evolvesTo.first?.evolvesTo?.first?.species.name.capitalized ?? "None")"
        typeStrengthsLabel.text! = strengths.reduce("") { "\($0) \($1.name)"}.capitalized
        typeWeaknessLabel.text! = weaknesses.reduce("") { "\($0) \($1.name)"}.capitalized

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
        content.text = ability.ability.name.capitalized
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}

