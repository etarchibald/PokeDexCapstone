//
//  PokemonCardsViewController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/30/24.
//

import UIKit
//gotta get the pokemon from the team cell to show here 
class PokemonTeamViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var teamPokemon = [Pokemon]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        configureCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2)), repeatingSubitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    @IBSegueAction func toDetailSegueAction(_ coder: NSCoder) -> UIViewController? {
        
        let indexPath = collectionView.indexPathsForSelectedItems!.first
        
        let selectedPokemon = teamPokemon[indexPath!.row]
        
        return PokemonDetailTableViewController(pokemon: selectedPokemon, coder: coder)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedItemIndex = self.collectionView.indexPathsForSelectedItems
        else {return}
        print()
         if let teamVC = segue.destination as? PokemonDetailTableViewController {
             
             teamVC.pokemon = teamPokemon[selectedItemIndex[0].row]
        }
    }
    
    
}
extension PokemonTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        teamPokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemon = teamPokemon[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritePokemonCell", for: indexPath) as! FavoritePokemonCollectionViewCell
        
        let pokemon = teamPokemon[indexPath.item]
        cell.updateUI(using: pokemon)
        return cell
    }
}
