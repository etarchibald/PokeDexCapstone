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
    @IBOutlet weak var favoritedButton: UIButton!
    @IBOutlet weak var pokemonTypingLabel: UILabel!
    
    // Evolution chain data labels
//    @IBOutlet weak var previousEvolutionLabel: UILabel!
//    @IBOutlet weak var nextEvolutionLabel: UILabel!
    
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
    
    @IBOutlet weak var pokemonSpritesCollectionView: UICollectionView!
    
    var pokemon: Pokemon
    var pokemonController = PokemonNetworkController.shared
    var storedImages: [UIImage] = []
    var arrayOfTypingView: [UIView] = []
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonSpritesCollectionView.delegate = self
        pokemonSpritesCollectionView.dataSource = self
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tableView.tableHeaderView = UIView(frame: frame)
        
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
    
    // MARK: Functions
    
    func saveImageData() {
        Task {
            do {
                let spriteURLs = pokemon.sprites

                var urls =
                [
                    spriteURLs.frontDefault,
                    spriteURLs.backDefault,
                    spriteURLs.frontShiny,
                    spriteURLs.backShiny,
                    
                ]
                
                let officialSprites = pokemon.sprites.other.officialArtwork
                let homeURLs = pokemon.sprites.other.home
                let dreamWorldURLs = pokemon.sprites.other.dreamWorld
                let showdownURLs = pokemon.sprites.other.showdown
                
                if let officialArtwork = officialSprites.frontDefault, let backArtwork = officialSprites.backDefault {
                    urls.append(officialArtwork)
                    urls.append(backArtwork)
                }
                
                for url in urls {
                    let data = try await pokemonController.fetchImageData(url: url)
                    
                    if let image = UIImage(data: data) {
                        storedImages.append(image)
                    }
                }
            }
            pokemonSpritesCollectionView.reloadData()
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        if pokemon.isFavorited ?? false {
            pokemon.isFavorited = false
            FavoritePokemonViewController.favoritePokemon = FavoritePokemonViewController.favoritePokemon.filter { eachPokemon in
               pokemon.name != eachPokemon.name ? true : false
            }
            PokemonPersistenceController.savePokemon(favoritePokemons: FavoritePokemonViewController.favoritePokemon)
        } else {
            pokemon.isFavorited = true
            FavoritePokemonViewController.favoritePokemon.append(pokemon)
            PokemonPersistenceController.savePokemon(favoritePokemons: FavoritePokemonViewController.favoritePokemon)
        }
        
        favoritedButton.setImage(UIImage(systemName: pokemon.isFavorited ?? false ? "heart.fill" : "heart"), for: .normal)
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
        
        favoritedButton.setImage(UIImage(systemName: pokemon.isFavorited ?? false ? "heart.fill" : "heart"), for: .normal)
        
        if pokemon.species?.isMythical ?? false {
            pokemonTypingLabel.text = "Mythical \(pokemonTyping) Type Pokemon"
        } else if pokemon.species?.isLegendary ?? false {
            pokemonTypingLabel.text = "Legendary \(pokemonTyping) Type Pokemon"
        } else {
            pokemonTypingLabel.text = "\(pokemonTyping) Type Pokemon"
        }
        
        pokemonNameLabel.text = pokemon.name.capitalized
        
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

// MARK: CollectionView

extension PokemonDetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pokemonSpritesCollectionView.dequeueReusableCell(withReuseIdentifier: "detailPokemonCell", for: indexPath) as! DetailCollectionViewCell
        
        if storedImages.isEmpty {
            cell.pokemonSpriteImageView.image = UIImage(named: "photo")
        } else {
            cell.pokemonSpriteImageView.image = storedImages[indexPath.row]
        }
        
        cell.background.layer.cornerRadius = 15
        
        return cell
    }
    
}
