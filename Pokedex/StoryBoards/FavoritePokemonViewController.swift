//
//  FavoritePokemonViewController.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/17/24.
//

import UIKit

class FavoritePokemonViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    //somehow needs to be static for it to work, because of the reasons: Yes
    static var favoritePokemon = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load favorite Pokemon and put in pokemon
        
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
        
        //load favorite pokemon and put in pokemon
        collectionView.reloadData()
    }

}

extension FavoritePokemonViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        FavoritePokemonViewController.favoritePokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritePokemonCell", for: indexPath) as! FavoritePokemonCollectionViewCell
        
        let pokemon = FavoritePokemonViewController.favoritePokemon[indexPath.row]
        
        cell.updateUI(using: pokemon)
        
        //configure cell background color, if more than one type loop trough and make it a gradient if its just one make it the full background.
        cell.backgroundColor = .green
        
        cell.layer.cornerRadius = 20
        
        return cell
    }
}
