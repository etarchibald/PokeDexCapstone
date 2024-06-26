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
    @IBOutlet weak var pokemonIdLabel: UILabel!
    @IBOutlet weak var favoritedButton: UIButton!
    
    @IBOutlet weak var primaryTypeBackground: UIView!
    @IBOutlet weak var primaryTypeLabel: UILabel!
    @IBOutlet weak var secondaryTypeBackground: UIView!
    @IBOutlet weak var secondaryTypeLabel: UILabel!
    @IBOutlet weak var ampersandLabel: UILabel!
    
    // Base Stat Labels and Views
    @IBOutlet weak var hpProgressBar: CustomProgressBar!
    @IBOutlet weak var attackProgressBar: CustomProgressBar!
    @IBOutlet weak var defenseProgressBar: CustomProgressBar!
    @IBOutlet weak var spAttackProgressBar: CustomProgressBar!
    @IBOutlet weak var spDefenseProgressBar: CustomProgressBar!
    @IBOutlet weak var speedProgressBar: CustomProgressBar!
    
    @IBOutlet weak var hpStatLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var specialAttackLabel: UILabel!
    @IBOutlet weak var specialDefenseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    // Damage relations labels
    @IBOutlet weak var strengthSwiftUIView: UIView!
    @IBOutlet weak var pokemonSpritesCollectionView: UICollectionView!
    @IBOutlet weak var weaknessSwiftUIView: UIView!
    
    // Abilites and Moves Labels
    @IBOutlet weak var abilityLabel: UILabel!
    @IBOutlet weak var firstMoveLabel: UILabel!
    @IBOutlet weak var secondMoveLabel: UILabel!
    @IBOutlet weak var thirdMoveLabel: UILabel!
    @IBOutlet weak var showAllAbilitiesButton: UIButton!
    @IBOutlet weak var showAllMovesButton: UIButton!
    
    var pokemon: Pokemon
    var pokemonController = PokemonNetworkController.shared
    var teamController = TeamController.shared
    var storedImages: [UIImage] = []
    var delegate: FavoritePokemon?
    var isComingFromATeam = false
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonSpritesCollectionView.delegate = self
        pokemonSpritesCollectionView.dataSource = self
        
        staticTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMoves()
        setupMenu()
        
        favoritedButton.isHidden = isComingFromATeam
        
        Task {
            do {
                pokemon = try await PokemonNetworkController.shared.fetchDetailInformation(pokemon: pokemon)
            } catch {
                //present alert
                let alertController = UIAlertController(title: "Loading Failed", message: "Unable to Fetch Pokemon details at this time. Please try again later.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel)
                
                alertController.addAction(okayAction)
                showAllMovesButton.isEnabled = false
                showAllAbilitiesButton.isEnabled = false
                present(alertController, animated: true)
            }
            
            setUpPokemonInfo()
            saveImageData()
            setupStrengthsAndWeaknessesSwiftUIView()
            
            staticTableView.reloadData()
        }
    }
    
    init?(pokemon: Pokemon, coder: NSCoder) {
        self.pokemon = pokemon
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: TableView Overrides
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 1 {
                return 180
            }
        case 1:
            if indexPath.row == 0 {
                return 220
            }
        case 5:
            if indexPath.row == 0 {
                return 50
            }
            if pokemon.moves.isEmpty {
                return 0
            }
            
        default:
            return UITableView.automaticDimension
        }
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    // MARK: Fetching Moves
    
    func fetchMoves() {
        Task {
            do {
                pokemon = try await pokemonController.fetchPokemonMoves(pokemon: pokemon)
                
            }
            if pokemon.moves.isEmpty {
                showAllMovesButton.isEnabled = false
            } else if !pokemon.moves.isEmpty {
                reloadMoves()
            }
        }
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
                
                if let frontofficialArtwork = officialSprites.frontDefault, let backArtwork = officialSprites.backDefault {
                    urls.append(frontofficialArtwork)
                    urls.append(backArtwork)
                }
                
                for url in urls {
                    if let url {
                        let newImage = try await pokemonController.fetchImageData(url: url)
                        if storedImages.count == 4 {
                            pokemonSpritesCollectionView.reloadData()
                            return
                        } else if storedImages.count < 5 {
                            storedImages.append(newImage)
                        }
                    }
                }
            } catch {
                let alertController = UIAlertController(title: "Loading Failed", message: "Unable to Fetch Pokemon images at this time. Please try again later.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel)
                
                alertController.addAction(okayAction)
                present(alertController, animated: true)
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
            delegate?.addPokemonToFavorite(pokemon: pokemon)
            PokemonPersistenceController.savePokemon(favoritePokemons: FavoritePokemonViewController.favoritePokemon)
        } else {
            pokemon.isFavorited = true
            FavoritePokemonViewController.favoritePokemon.append(pokemon)
            delegate?.addPokemonToFavorite(pokemon: pokemon)
            
            Task {
                do {
                    self.pokemon = try await PokemonPersistenceController.shared.fetchInformationToSave(pokemon: pokemon)
                    PokemonPersistenceController.savePokemon(favoritePokemons: FavoritePokemonViewController.favoritePokemon)
                } catch {
                    //handle errors
                    let alertController = UIAlertController(title: "Saving Failed", message: "Unable to Save Pokemon at this time. Please try again later.", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel)
                    
                    alertController.addAction(okayAction)
                    present(alertController, animated: true)
                }
            }
        }
        
        TeamController.saveTeams(teams: TeamController.teams)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .autoreverse, animations: {
            self.favoritedButton.imageView?.contentMode = self.pokemon.isFavorited ?? false ? .scaleAspectFill : .scaleAspectFit
            UIView.transition(with: self.favoritedButton, duration: 0.375, options: .transitionCrossDissolve, animations: {
                self.favoritedButton.setImage(UIImage(systemName: self.pokemon.isFavorited ?? false ? "heart.fill" : "heart"), for: .normal)
            }, completion: nil)
        }, completion: nil)
    }
    
    // MARK: Setting up Labels, etc.
    
    func reloadMoves() {
        firstMoveLabel.text = pokemon.moves[0].name?.capitalized
        secondMoveLabel.text = pokemon.moves[1].name?.capitalized
        thirdMoveLabel.text = pokemon.moves[2].name?.capitalized
    }
    
    func setUpPokemonInfo() {
        
        primaryTypeLabel = PokemonPrettyController.shared.createLabelForTypeBox(primaryTypeLabel, pokemon.primaryType!)
        primaryTypeBackground = PokemonPrettyController.shared.createBackgroundForTypeBox(primaryTypeBackground, pokemon.primaryType!)
        
        if pokemon.secondaryType != pokemon.primaryType {
            secondaryTypeLabel = PokemonPrettyController.shared.createLabelForTypeBox(secondaryTypeLabel, pokemon.secondaryType!)
            secondaryTypeBackground = PokemonPrettyController.shared.createBackgroundForTypeBox(secondaryTypeBackground, pokemon.secondaryType!)
        } else if pokemon.primaryType == pokemon.secondaryType {
            ampersandLabel.isHidden = true
            secondaryTypeLabel.isHidden = true
            secondaryTypeBackground.isHidden = true
        }
        
        favoritedButton.setImage(UIImage(systemName: pokemon.isFavorited ?? false ? "heart.fill" : "heart"), for: .normal)
        
        abilityLabel.text = "\(pokemon.abilities[0].name?.capitalized ?? "N/A")"
        
        if !pokemon.moves.isEmpty {
            firstMoveLabel.text = pokemon.moves[0].name?.capitalized
            secondMoveLabel.text = pokemon.moves[1].name?.capitalized
            thirdMoveLabel.text = pokemon.moves[2].name?.capitalized
        } else if pokemon.moves.isEmpty {
            firstMoveLabel.text = "No Moves to List"
            showAllMovesButton.isEnabled = false
        }
        
        pokemonNameLabel.text = pokemon.name.capitalized
        pokemonIdLabel.text = "#\(pokemon.id)"
        
        for stat in pokemon.stats {
            let statDataToAppend = String(stat.base_stat)
            switch stat.stat.name {
            case "hp":
                hpStatLabel.text! = " \(statDataToAppend)"
                hpProgressBar.progress = CGFloat(Int(statDataToAppend) ?? 0)
            case "attack":
                attackLabel.text! = " \(statDataToAppend)"
                attackProgressBar.progress = CGFloat(Int(statDataToAppend) ?? 0)
            case "defense":
                defenseLabel.text! = " \(statDataToAppend)"
                defenseProgressBar.progress = CGFloat(Int(statDataToAppend) ?? 0)
            case "special-attack":
                specialAttackLabel.text! = " \(statDataToAppend)"
                spAttackProgressBar.progress = CGFloat(Int(statDataToAppend) ?? 0)
            case "special-defense":
                specialDefenseLabel.text! = " \(statDataToAppend)"
                spDefenseProgressBar.progress = CGFloat(Int(statDataToAppend) ?? 0)
            case "speed":
                speedLabel.text! = " \(statDataToAppend)"
                speedProgressBar.progress = CGFloat(Int(statDataToAppend) ?? 0)
            default:
                break
            }
        }
        
    }
    
    // MARK: SwiftUIView & Related Func
    
    func setupStrengthsAndWeaknesses() -> [[PokemonType]] {
        let strengthAPITyping = pokemon.firstTypeDamageRelations?.damageRelations.doubleDamageTo ?? []
        let secondaryTypeStrength = pokemon.secondTypeDamageRelations?.damageRelations.doubleDamageTo ?? []
        var strengths: [PokemonType] = []
        
        if pokemon.primaryType != pokemon.secondaryType {
            for strength in secondaryTypeStrength {
                strengths.append(strength.name)
            }
        }
        
        for strength in strengthAPITyping {
            if !strengths.contains(strength.name) {
                strengths.append(strength.name)
            }
            
        }
        
        let weaknessesAPITyping = pokemon.firstTypeDamageRelations?.damageRelations.doubleDamageFrom ?? []
        let secondaryTypeWeaknesses = pokemon.secondTypeDamageRelations?.damageRelations.doubleDamageFrom ?? []
        var weaknesses: [PokemonType] = []
        
        if pokemon.primaryType != pokemon.secondaryType {
            for weakness in secondaryTypeWeaknesses {
                weaknesses.append(weakness.name)
            }
        }
        
        for weakness in weaknessesAPITyping {
            if !weaknesses.contains(weakness.name) {
                weaknesses.append(weakness.name)
            }
        }
        
        var modifiedWeaknesses = weaknesses
        var modifiedStrengths = strengths
        
        for weakness in weaknesses {
            if strengths.contains(weakness) || weakness == pokemon.primaryType || weakness == pokemon.secondaryType {
                modifiedStrengths.removeAll(where: {$0 == weakness})
                modifiedWeaknesses.removeAll(where: {$0 == weakness})
            }
        }
        
        for strength in strengths {
            if weaknesses.contains(strength) || strength == pokemon.primaryType || strength == pokemon.secondaryType {
                modifiedStrengths.removeAll(where: {$0 == strength})
                modifiedWeaknesses.removeAll(where: {$0 == strength})
            }
        }
        
        return [modifiedStrengths, modifiedWeaknesses]
    }
    
    
    func setupStrengthsAndWeaknessesSwiftUIView() {
        
        let arrayOfArrayOfTypes = setupStrengthsAndWeaknesses()
        
        let weaknessViewHC = UIHostingController(rootView: TypingSwiftUIView(types: arrayOfArrayOfTypes[1], isStrengths: false))
        let strengthsViewHC = UIHostingController(rootView: TypingSwiftUIView(types: arrayOfArrayOfTypes[0], isStrengths: true))
        let weaknessInnerView = weaknessViewHC.view!
        let strengthsInnerView = strengthsViewHC.view!
        
        strengthsInnerView.translatesAutoresizingMaskIntoConstraints = false
        weaknessInnerView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(weaknessViewHC)
        addChild(strengthsViewHC)
        strengthSwiftUIView.addSubview(strengthsInnerView)
        weaknessSwiftUIView.addSubview(weaknessInnerView)
        
        NSLayoutConstraint.activate([
            strengthsInnerView.leadingAnchor.constraint(equalTo: strengthSwiftUIView.leadingAnchor),
            strengthsInnerView.topAnchor.constraint(equalTo: strengthSwiftUIView.topAnchor),
            strengthsInnerView.trailingAnchor.constraint(equalTo: strengthSwiftUIView.trailingAnchor),
            strengthsInnerView.bottomAnchor.constraint(equalTo: strengthSwiftUIView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weaknessInnerView.leadingAnchor.constraint(equalTo: weaknessSwiftUIView.leadingAnchor),
            weaknessInnerView.topAnchor.constraint(equalTo: weaknessSwiftUIView.topAnchor),
            weaknessInnerView.trailingAnchor.constraint(equalTo: weaknessSwiftUIView.trailingAnchor),
            weaknessInnerView.bottomAnchor.constraint(equalTo: weaknessSwiftUIView.bottomAnchor)
        ])
        
        strengthsViewHC.sizingOptions = [.intrinsicContentSize]
        weaknessViewHC.sizingOptions = [.intrinsicContentSize]
        
        strengthsViewHC.didMove(toParent: self)
        weaknessViewHC.didMove(toParent: self)
        
    }
    
    // MARK: Menu Setup
    
    func setupMenu() {
        var actions: [UIAction] = []
        let teams = TeamController.loadTeams()
        
        if !teams.isEmpty {
            if teams.count > 3 {
                for index in 0..<3 {
                    actions.append(UIAction(title: teams[index].teamName) { _ in
                        self.teamController.addPokemonToTeam(pokemon: self.pokemon, toTeam: TeamController.teams[index].id)
                    })
                }
                actions.append(UIAction(title: "Show All Teams") { (_) in
                    self.performSegue(withIdentifier: "presentModalTeams", sender: self)
                })
            } else {
                for team in teams {
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
            
            let rightBarButton = UIBarButtonItem(title: "Add To Team", menu: menu)
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        
        
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? PokemonAbilitiesTableViewController {
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.startAnimating()
            tableView.tableHeaderView = spinner
            
            if pokemon.abilities.first?.abilityDetails == nil {
                Task {
                    do{
                        let pokemon = try await PokemonNetworkController.shared.fetchPokemonAbilites(pokemon: pokemon)
                        detailVC.pokemon = pokemon
                        spinner.stopAnimating()
                        tableView.tableHeaderView = nil
                    } catch {
                        print("Error fetching data: \(error)")
                        spinner.stopAnimating()
                        tableView.tableHeaderView = nil
                    }
                }
            } else {
                detailVC.pokemon = pokemon
                spinner.stopAnimating()
                tableView.tableHeaderView = nil
            }
        }
        
        if let detailVC = segue.destination as? PokemonMovesViewController {
            detailVC.pokemon = pokemon
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
        cell.background.alpha = 0.5
        
        return cell
    }
    
}
