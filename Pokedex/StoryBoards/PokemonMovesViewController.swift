//
//  PokemonMovesViewController.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/30/24.
//

import UIKit

class PokemonMovesViewController: UIViewController {

    @IBOutlet weak var pokemonTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pokemonMoves = [PokemonMove]()
    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        configureCollectionView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pokemonTitleLabel.text = "\(pokemon?.name ?? "") moves"
    }
    
    private func configureCollectionView() {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
}

extension PokemonMovesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonMoves.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokemonMoves", for: indexPath) as! PokemonMovesCollectionViewCell
        
        let moves = pokemonMoves[indexPath.item]
        
        cell.setup(moves: moves)
        
        return cell
    }
    
}