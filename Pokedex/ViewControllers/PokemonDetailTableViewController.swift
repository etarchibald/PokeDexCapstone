//
//  DetailTableViewController.swift
//  Pokedex
//
//  Created by Jacob Davis on 4/23/24.
//

import SwiftUI
import UIKit

class PokemonDetailTableViewController: UITableViewController {
    
    @IBOutlet var staticTableView: UITableView!
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
    @IBOutlet weak var strengthsAndWeaknessesView: UIView!
    
    @IBOutlet weak var pokemonSpritesCollectionView: UICollectionView!
    
    var pokemon: Pokemon
    var pokemonController = PokemonNetworkController.shared
    var teamController = TeamController.shared
    var storedImages: [UIImage] = []
//    var arrayOfTypingView: [UIHostingController<TypingSwiftUIView>] = []
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonSpritesCollectionView.delegate = self
        pokemonSpritesCollectionView.dataSource = self
        
        
        setupMenu()
        setupSwiftUIView()
        
        saveImageData()
        setUpPokemonInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupMenu()
    }
    
    init?(pokemon: Pokemon, coder: NSCoder) {
        self.pokemon = pokemon
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Displaying Images
    
    func saveImageData() {
        Task {
            do {
                let spriteURLs = pokemon.sprites

                var urls =
                [
                    spriteURLs.frontDefault,
                    spriteURLs.backDefault,
                    spriteURLs.frontShiny,
                    spriteURLs.backShiny
                ]
                
                let officialSprites = pokemon.sprites.other.officialArtwork
                let homeURLs = pokemon.sprites.other.home
                let dreamWorldURLs = pokemon.sprites.other.dreamWorld
                let showdownURLs = pokemon.sprites.other.showdown
                
                if let frontofficialArtwork = officialSprites.frontDefault, let backArtwork = officialSprites.backDefault {
                    urls.append(frontofficialArtwork)
                    urls.append(backArtwork)
                }
                
                if let dreamWorldFront = dreamWorldURLs.frontDefault, let dreamWorldBack = dreamWorldURLs.backDefault {
                    urls.append(dreamWorldFront)
                    urls.append(dreamWorldBack)
                }
                
                
                
                for url in urls {
                    if let url {
                        let newImage = try await pokemonController.fetchImageData(url: url)
                        storedImages.append(newImage)
                        print(url)
                        print(storedImages)
                    }
                }
            }
            pokemonSpritesCollectionView.reloadData()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: Favorite Button
    
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
    
    // MARK: Setting up Labels, etc.
        
    func setUpPokemonInfo() {
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
    
    // MARK: SwiftUIView
    
    func setupSwiftUIView() {
        let strengthAPITyping = pokemon.damageRelations?.damageRelations.doubleDamageTo ?? []
        var strengths: [PokemonType] = []
        for strength in strengthAPITyping {
            strengths.append(strength.name)
        }
        let weaknessesAPITyping = pokemon.damageRelations?.damageRelations.doubleDamageFrom ?? []
        var weaknesses: [PokemonType] = []
        for weakness in weaknessesAPITyping {
            weaknesses.append(weakness.name)
        }
        
        let strengthsView = UIHostingController(rootView: TypingSwiftUIView(strengths: strengths, weaknesses: weaknesses))
        let strengthSwiftUIView = strengthsView.view!
        
        strengthSwiftUIView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(strengthsView)
        strengthsAndWeaknessesView.addSubview(strengthSwiftUIView)
        
        NSLayoutConstraint.activate([
            strengthSwiftUIView.leadingAnchor.constraint(equalTo: strengthsAndWeaknessesView.leadingAnchor),
            strengthSwiftUIView.topAnchor.constraint(equalTo: strengthsAndWeaknessesView.topAnchor),
            strengthSwiftUIView.trailingAnchor.constraint(equalTo: strengthsAndWeaknessesView.trailingAnchor),
            strengthSwiftUIView.bottomAnchor.constraint(equalTo: strengthsAndWeaknessesView.bottomAnchor)
        ])
        
        strengthsView.didMove(toParent: self)
    }

    // MARK: Menu Setup
    
    func setupMenu() {
        var actions: [UIAction] = []
        
        if !TeamController.teams.isEmpty {
            if TeamController.teams.count > 3 {
                for index in 0..<3 {
                    actions.append(UIAction(title: TeamController.teams[index].teamName) { _ in
                        self.teamController.addPokemonToTeam(pokemon: self.pokemon, toTeam: TeamController.teams[index].id)
                    })
                }
                actions.append(UIAction(title: "Show All Teams") { (_) in
                    self.performSegue(withIdentifier: "presentModalTeams", sender: self)
                })
            } else {
                for team in TeamController.teams {
                    actions.append(UIAction(title: team.teamName) { _ in
                        self.teamController.addPokemonToTeam(pokemon: self.pokemon, toTeam: team.id)
                    })
                }
            }
            
            let menu = UIMenu(title: "Add To Team", children: actions)
            let rightBarButton = UIBarButtonItem(title: "", image: UIImage(systemName: "plus"), menu: menu)
            self.navigationItem.rightBarButtonItem = rightBarButton
            
        } else {
            actions.append(UIAction(title: "No Teams") { (_) in })
            let menu = UIMenu(title: "Add To Team", children: actions)
            
            let rightBarButton = UIBarButtonItem(title: "", image: UIImage(systemName: "plus"), menu: menu)
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        
        
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? PokemonAbilitiesTableViewController {
            detailVC.pokemon = pokemon
        }
        
        if let detailVC = segue.destination as? PokemonMovesViewController {
            detailVC.pokemon = pokemon
            detailVC.pokemonMoves = pokemon.moves
        }
        
        if let teamlistVC = segue.destination as? ViewMoreTeamsTableViewController {
            teamlistVC.pokemon = pokemon
        }
        
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
