//
//  DetailTableViewController.swift
//  Pokedex
//
//  Created by Jacob Davis on 4/23/24.
//

import UIKit

class PokemonDetailTableViewController: UITableViewController {
    
    // Outlets relating to Pokemon images
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonTypingLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var imageSegmentedControl: UISegmentedControl!
    
    // Evolution chain data labels
    @IBOutlet weak var previousEvolutionLabel: UILabel!
    @IBOutlet weak var nextEvolutionLabel: UILabel!
    
    // Base stats labels
//    @IBOutlet weak var weightAndHeightLabel: UILabel!
    @IBOutlet weak var hpStatLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var specialAttackLabel: UILabel!
    @IBOutlet weak var specialDefenseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    // Damage relations labels
    @IBOutlet weak var typeStrengthsLabel: UILabel!
    @IBOutlet weak var typeWeaknessLabel: UILabel!
    
    
    var pokemon: Pokemon
    var pokemonController = PokemonNetworkController.shared
    var storedImages: [String:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        saveImageData()
        setUpPokemonInfo()
        
    }
    
    init?(pokemon: Pokemon, coder: NSCoder) {
        self.pokemon = pokemon
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func changeImageView(_ sender: Any) {
        switch imageSegmentedControl.selectedSegmentIndex {
        case 1: pokemonImageView.image = storedImages["defaultBack"]
        case 2: pokemonImageView.image = storedImages["shinyFront"]
        case 3: pokemonImageView.image = storedImages["shinyBack"]
        default: pokemonImageView.image = storedImages["defaultFront"]
        }
    }
    
    
    func saveImageData() {
        Task {
            do {
                let shinyFrontData = try await pokemonController.fetchImageData(url: pokemon.sprites.frontShiny)
                let shinyBackData = try await pokemonController.fetchImageData(url: pokemon.sprites.backShiny)
                    
                    if let shinyFrontAsImage = UIImage(data: shinyFrontData), let shinyBackAsImage = UIImage(data: shinyBackData) {
                        storedImages["shinyFront"] = shinyFrontAsImage
                        storedImages["shinyBack"] = shinyBackAsImage
                    }
                
                let spriteBehindImageData = try await pokemonController.fetchImageData(url: pokemon.sprites.backDefault)
                let spriteFrontImageData = try await pokemonController.fetchImageData(url: pokemon.sprites.frontDefault)
                if let defaultFront = UIImage(data: spriteFrontImageData), let defaultBack = UIImage(data: spriteBehindImageData) {
                    storedImages["defaultFront"] = defaultFront
                    storedImages["defaultBack"] = defaultBack
                }
                
            }
        }
    }
    
    func setUpPokemonInfo() {
        let strengths = pokemon.damageRelations?.damageRelations.doubleDamageTo ?? []
        let weaknesses = pokemon.damageRelations?.damageRelations.doubleDamageFrom ?? []
        var pokemonTyping = ""
        
        if pokemon.primaryType?.rawValue == pokemon.secondaryType?.rawValue {
            pokemonTyping = "\(pokemon.primaryType!.rawValue)".capitalized
        } else {
            pokemonTyping = "\(pokemon.primaryType!.rawValue), \(pokemon.secondaryType?.rawValue ?? "")".capitalized
        }
        
        
        if pokemon.species?.isMythical ?? false {
            pokemonTypingLabel.text = "Mythical \(pokemonTyping) Type Pokemon"
        } else if pokemon.species?.isLegendary ?? false {
            pokemonTypingLabel.text = "Legendary \(pokemonTyping) Type Pokemon"
        } else {
            pokemonTypingLabel.text = "\(pokemonTyping) Type Pokemon"
        }
        
        pokemonNameLabel.text = pokemon.name.capitalized
        pokemonImageView.load(url: pokemon.sprites.frontDefault)
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        deselectRow(at: indexPath, animated: true)
    }

}
