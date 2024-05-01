//
//  PokemonCardsViewController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/30/24.
//

import UIKit

class PokemonCardsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    static var deckPokemon = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2)), repeatingSubitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        collectionView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PokemonCardsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        PokemonCardsViewController.deckPokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritePokemonCell", for: indexPath) as! FavoritePokemonCollectionViewCell
        
        let pokemon = PokemonCardsViewController.deckPokemon[indexPath.item]
        
        cell.updateUI(using: pokemon)
        
        return cell
    }
}
