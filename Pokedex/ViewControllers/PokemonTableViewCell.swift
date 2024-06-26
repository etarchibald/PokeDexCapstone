//
//  PokemonTableViewCell.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var type2BackgroundView: UIView!
    @IBOutlet weak var type1BackgroundView: UIView!
    @IBOutlet weak var type2Label: UILabel!
    @IBOutlet weak var type1Label: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var generationLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var favoritePokemonView = FavoritePokemonViewController()
    private var pokemonPrettyController = PokemonPrettyController.shared
    private var imageLoaded = false
    
    var pokemon: Pokemon?
    
    var delegate: FavoritePokemon?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
        numberLabel.text = "#\(pokemon.id)"
        
        if pokemon.primaryType == pokemon.secondaryType {
            type1Label = pokemonPrettyController.createLabelForTypeBox(type1Label, pokemon.primaryType ?? .normal)
            
            type1BackgroundView = pokemonPrettyController.createBackgroundForTypeBox(type1BackgroundView, pokemon.primaryType ?? .normal)
            
            type2Label.text = ""
            type2BackgroundView.backgroundColor = .clear
            
        } else {
            type1Label = pokemonPrettyController.createLabelForTypeBox(type1Label, pokemon.primaryType ?? .normal)
            type1BackgroundView = pokemonPrettyController.createBackgroundForTypeBox(type1BackgroundView, pokemon.primaryType ?? .normal)
            
            type2Label = pokemonPrettyController.createLabelForTypeBox(type2Label, pokemon.secondaryType ?? .normal)
            type2BackgroundView = pokemonPrettyController.createBackgroundForTypeBox(type2BackgroundView, pokemon.secondaryType ?? .normal)
        }
        
        if let generation = pokemon.species?.generation {
            generationLabel.text = "Gen: \(pokemonPrettyController.prettyPrintGen(gen: generation.name))"
        } else {
            generationLabel.text = ""
        }

        if let frontDefault = pokemon.sprites.frontDefault {
            pokemonImage.load(url: frontDefault)
        }
        
        let newImage = UIImage(systemName: pokemon.isFavorited ?? false ? "heart.fill" : "heart")
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .autoreverse, animations: {
            self.favoriteButton.imageView?.contentMode = pokemon.isFavorited ?? false ? .scaleAspectFill : .scaleAspectFit
            UIView.transition(with: self.favoriteButton, duration: 0.375, options: .transitionCrossDissolve, animations: {
                self.favoriteButton.setImage(newImage, for: .normal)
            }, completion: nil)
        }, completion: nil)
        
    }

    @IBAction func favoritebuttonTapped(_ sender: UIButton) {
        
        if pokemon?.isFavorited ?? false {
            self.pokemon?.isFavorited = false
            setup(pokemon: pokemon!)
            FavoritePokemonViewController.favoritePokemon = FavoritePokemonViewController.favoritePokemon.filter { eachPokemon in
                pokemon?.name != eachPokemon.name ? true : false
            }
            delegate?.addPokemonToFavorite(pokemon: pokemon!)
            PokemonPersistenceController.savePokemon(favoritePokemons: FavoritePokemonViewController.favoritePokemon)
        } else {
            self.pokemon?.isFavorited = true
            setup(pokemon: pokemon!)
            FavoritePokemonViewController.favoritePokemon.append(pokemon!)
            delegate?.addPokemonToFavorite(pokemon: pokemon!)
            //check if it has everything then save
            if let pokemon = self.pokemon {
                Task {
                    do {
                        self.pokemon = try await PokemonPersistenceController.shared.fetchInformationToSave(pokemon: pokemon)
                        PokemonPersistenceController.savePokemon(favoritePokemons: FavoritePokemonViewController.favoritePokemon)
                    } catch {
                        fatalError("Error Saving Favorite Pokemon")
                    }
                }
            }
        }
        
        TeamController.saveTeams(teams: TeamController.teams)
    }
}
