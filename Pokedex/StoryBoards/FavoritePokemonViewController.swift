//
//  FavoritePokemonViewController.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/17/24.
//

import UIKit

class FavoritePokemonViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var pokemon = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load favorite Pokemon and put in pokemon
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //Adjust these when needed to make it look nice
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), repeatingSubitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //load favorite pokemon and put in pokemon
        
    }

}

extension FavoritePokemonViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritePokemonCell", for: indexPath) as! FavoritePokemonCollectionViewCell
        
        //delegate if needed
        
        let pokemon = pokemon[indexPath.row]
        
        cell.updateUI(using: pokemon)
        
        //configure cell background color, if more than one type loop trough and make it a gradient if its just one make it the full background.
        
        cell.layer.cornerRadius = 20
        
        return cell
    }
}
