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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        configureCollectionView()
        // Do any additional setup after loading the view.
    }
    
    private func configureCollectionView() {
        
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
