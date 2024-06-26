//
//  PokemonMovesViewController.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/30/24.
//

import UIKit

class PokemonMovesViewController: UIViewController {

    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var pokemonTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pokemonMoves = [PokemonMove]() ////Source of truth
    var pokemonFilteredMoves = [PokemonMove]() ////edits based on filter
    var pokemon: Pokemon?
    
    var dataSource: UICollectionViewDiffableDataSource<String, PokemonMove>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        setUpCollectionViewDataSource()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if pokemon?.moves.first?.moveDetail == nil {
            Task {
                do {
                    let newPokemon = try await PokemonNetworkController.shared.fetchPokemonMoves(pokemon: pokemon!)
                    pokemonMoves = newPokemon.moves
                    
                    pokemonTitleLabel.text = "\(pokemon?.name.capitalized ?? "") moves"
                    
                    pokemonFilteredMoves = filterPokemonMoves(sender: filterSegmentedControl)
                    applySnapshot(from: pokemonFilteredMoves)
                    
                } catch {
                    throw error
                }
            }
        } else {
            
            if let moves = pokemon?.moves {
                pokemonMoves = moves
            }
            
            pokemonTitleLabel.text = "\(pokemon?.name.capitalized ?? "Error loading") moves"
            
            pokemonFilteredMoves = filterPokemonMoves(sender: filterSegmentedControl)
            applySnapshot(from: pokemonFilteredMoves)
        }
    }
    
    private func configureCollectionView() {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.15)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    func filterPokemonMoves(sender: UISegmentedControl) -> [PokemonMove] {
        
        switch sender.selectedSegmentIndex {
        case 0:
            return pokemonMoves.sorted { (move1, move2) in
                if move1.levelLearnedAt == move2.levelLearnedAt {
                    return move1.name! < move2.name!
                } else {
                    return move1.levelLearnedAt! > move2.levelLearnedAt!
                }
            }
        case 1:
            return pokemonMoves.sorted { $0.moveDetail!.name < $1.moveDetail!.name }
        case 2:
            return pokemonMoves.sorted {(move1, move2) in
                if move1.moveDetail?.type.name == move2.moveDetail?.type.name {
                    return move1.name! < move2.name!
                } else {
                    return move1.moveDetail!.type.name.rawValue < move2.moveDetail!.type.name.rawValue
                }
            }
        case 3:
            return pokemonMoves.sorted { $0.moveDetail!.power ?? 0 > $1.moveDetail!.power ?? 0 }
        default:
            return pokemonMoves
        }
    }
    
    @IBSegueAction func toMoveDetail(_ coder: NSCoder) -> MovesDetailViewController? {
        
        let indexPath = collectionView.indexPathsForSelectedItems!.first
            
        let selectedMoves = pokemonFilteredMoves[indexPath!.row]
        
        return MovesDetailViewController(move: selectedMoves, coder: coder)
    }
    
    @IBAction func filterBySegmentedControlChanged(_ sender: UISegmentedControl) {
        
        pokemonFilteredMoves = filterPokemonMoves(sender: sender)
        applySnapshot(from: pokemonFilteredMoves)
    }
}

extension PokemonMovesViewController {
    
    func setUpCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<String, PokemonMove>(collectionView: collectionView) { collectionView, indexPath, pokemonMove in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokemonMoves", for: indexPath) as! PokemonMovesCollectionViewCell
            
            cell.setup(move: pokemonMove)
            
            return cell
        }
    }
    
    func applySnapshot(from pokemon: [PokemonMove]) {
        var snapshot = NSDiffableDataSourceSnapshot<String, PokemonMove>()
        snapshot.appendSections(["MainSection"])
        snapshot.appendItems(pokemon)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
