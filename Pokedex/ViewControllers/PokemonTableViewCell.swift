//
//  PokemonTableViewCell.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    
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
    var pokemon: Pokemon?
    
    var delegate: FavoritePokemon?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
        
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
        
        generationLabel.text = "Gen: \(PokemonPrettyController.shared.prettyPrintGen(gen: pokemon.species?.generation?.name ?? ""))"
        
        pokemonImage.load(url: pokemon.sprites.frontDefault)
        favoriteButton.setImage(UIImage(systemName: pokemon.isFavorited ?? false ? "heart.fill" : "heart"), for: .normal)
    }

    @IBAction func favoritebuttonTapped(_ sender: UIButton) {
        
        if pokemon?.isFavorited ?? false {
            pokemon?.isFavorited = false
            setup(pokemon: pokemon!)
            FavoritePokemonViewController.favoritePokemon = FavoritePokemonViewController.favoritePokemon.filter { eachPokemon in
               pokemon?.name != eachPokemon.name ? true : false
            }
            delegate?.addPokemonToFavorite(pokemon: pokemon!)
            PokemonPersistenceController.savePokemon(favoritePokemons: FavoritePokemonViewController.favoritePokemon)
        } else {
            pokemon?.isFavorited = true
            setup(pokemon: pokemon!)
            FavoritePokemonViewController.favoritePokemon.append(pokemon!)
            delegate?.addPokemonToFavorite(pokemon: pokemon!)
            //check if it has everything then save
            PokemonPersistenceController.savePokemon(favoritePokemons: FavoritePokemonViewController.favoritePokemon)
        }
    }
}
