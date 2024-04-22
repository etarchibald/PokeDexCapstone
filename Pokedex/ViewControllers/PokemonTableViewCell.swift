//
//  PokemonTableViewCell.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var generationLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var favoritePokemonView = FavoritePokemonViewController()
    var pokemon: Pokemon?
    
    var delegate: FavoritePokemon?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
        
        let typeNames = "\(pokemon.primaryType?.rawValue.capitalized ?? ""), \(pokemon.secondaryType?.rawValue.capitalized ?? "")"
        typeLabel.text = typeNames
        
        generationLabel.text = PokemonPrettyController.shared.prettyPrintGen(gen: pokemon.species?.generation?.name ?? "")
        
        pokemonImage.load(url: pokemon.sprites.front_default)
        favoriteButton.setImage(UIImage(systemName: pokemon.isFavorited ?? false ? "heart.fill" : "heart"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func favoritebuttonTapped(_ sender: UIButton) {
        
        if pokemon?.isFavorited ?? false {
            pokemon?.isFavorited = false
            setup(pokemon: pokemon!)
            FavoritePokemonController().favoritePokemon = FavoritePokemonController().favoritePokemon.filter { eachPokemon in
               pokemon?.name != eachPokemon.name ? true : false
            }
            delegate?.addPokemonToFavorite(pokemon: pokemon!)
        } else {
            pokemon?.isFavorited = true
            setup(pokemon: pokemon!)
            FavoritePokemonController().favoritePokemon.append(pokemon!)
            delegate?.addPokemonToFavorite(pokemon: pokemon!)
        }
        
    }
}
