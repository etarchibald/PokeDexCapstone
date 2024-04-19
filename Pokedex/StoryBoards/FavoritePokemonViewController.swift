//
//  FavoritePokemonViewController.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/17/24.
//

import UIKit

class FavoritePokemonViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cell = PokemonTableViewCell()
    
    var favoritePokemon = [Pokemon]()
    
//    var dummyPokemon = [
//        Pokemon(id: 0, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56),
//        Pokemon(id: 0, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56),
//        Pokemon(id: 0, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56),
//        Pokemon(id: 0, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56),
//        Pokemon(id: 0, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56),
//        Pokemon(id: 0, name: "Bulbasaur", types: [], sprites: PokemonSprites(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!, back_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!), abilities: [], stats: [], height: 45, weight: 56)
//    ]
    
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
        favoritePokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritePokemonCell", for: indexPath) as! FavoritePokemonCollectionViewCell
        
        let pokemon = favoritePokemon[indexPath.row]
        
        cell.updateUI(using: pokemon)
        
        //configure cell background color, if more than one type loop trough and make it a gradient if its just one make it the full background.
        cell.backgroundColor = .green
        
        cell.layer.cornerRadius = 20
        
        return cell
    }
}

//extension FavoritePokemonViewController: FavoritePokemon {
//    func addPokemonToFavorite(pokemon: Pokemon) {
//        favoritePokemon.append(pokemon)
//    }
//}
