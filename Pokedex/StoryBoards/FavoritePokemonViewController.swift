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
        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //load favorite pokemon and put in pokemon
        collectionView.reloadData()
    }
    
    
    func setUpCollectionView() {
        self.collectionView.register(UINib(nibName: "PokemonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "favoritePokemonCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2)), repeatingSubitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    @IBSegueAction func showDetailSegue(_ coder: NSCoder) -> UIViewController? {
        
        let indexPath = collectionView.indexPathsForSelectedItems!.first
            
        let selectedPokemon = FavoritePokemonViewController.favoritePokemon[indexPath!.row]
        
        return PokemonDetailTableViewController(pokemon: selectedPokemon, coder: coder)
    }
    
}

extension FavoritePokemonViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailSegue", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        FavoritePokemonViewController.favoritePokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritePokemonCell", for: indexPath) as! PokemonCollectionViewCell
        
        let pokemon = FavoritePokemonViewController.favoritePokemon[indexPath.item]
        
        cell.updateUI(using: pokemon)
        
        return cell
    }
}
