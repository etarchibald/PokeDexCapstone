//
//  PokemonCardsViewController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/30/24.
//

import UIKit
//use teamController
class PokemonTeamViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var team: Team
    var isEditingMode = false
    
    init?(coder: NSCoder, team: Team) {
        self.team = team
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        configureCollectionView()
        self.collectionView.register(UINib(nibName: "PokemonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "favoritePokemonCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        
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
    
    @IBSegueAction func showDetailSegue(_ coder: NSCoder) -> UIViewController? {
        
        let indexPath = collectionView.indexPathsForSelectedItems!.first
        
        let selectedPokemon = team.pokemon[indexPath!.row]
        
        return PokemonDetailTableViewController(pokemon: selectedPokemon, coder: coder)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedItemIndex = self.collectionView.indexPathsForSelectedItems
        else {return}
        print()
         if let teamVC = segue.destination as? PokemonDetailTableViewController {
             
             teamVC.pokemon = team.pokemon[selectedItemIndex[0].row]
        }
    }
    
    //add x button to cell
    //hit edit shows x
    //hit x deletes
    @objc func editButtonTapped() {
        isEditingMode = !isEditingMode
        
        // Toggle editing mode of the collection view
        collectionView.isEditing = isEditingMode
        
        // Update the UI based on the editing mode
        let buttonTitle = isEditingMode ? "Done" : "Edit"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: buttonTitle, style: .plain, target: self, action: #selector(editButtonTapped))
        
        // Enable or disable collection view interaction based on editing mode
        collectionView.allowsSelection = !isEditingMode
    }

//    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//        if action == #selector(UIResponderStandardEditActions.delete(_:)) {
//            // Delete the item from your data source array
//            //remove from file system
//            team.pokemon.remove(at: indexPath.item)
//            
//            // Update the collection view to reflect the deletion
//            collectionView.deleteItems(at: [indexPath])
//        }
//        
//        TeamController.saveTeams(teams: [team])
//    }
    
    func deletePokemon(_ pokemon: Pokemon) {
        // delete from team
//        team.pokemon.remove(at: indexPath.item)
//        
//        collectionView.deleteItems(at: [indexPath])
        print("Deleteing you!")
    }
    
}
extension PokemonTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        team.pokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemon = team.pokemon[indexPath.item]
        
        performSegue(withIdentifier: "showDetailSegue", sender: nil)
        
//        if isEditingMode {
//            team.remove(at: indexPath.item)
//
//            collectionView.deleteItems(at: [indexPath])
//        } else {
//            let selectedPokemon = team[indexPath.item]
//        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritePokemonCell", for: indexPath) as! PokemonCollectionViewCell
        
        cell.isEditing = isEditingMode
        let pokemon = team.pokemon[indexPath.item]
        cell.onDelete = {
            self.deletePokemon(pokemon)
        }
        cell.updateUI(using: pokemon)
        return cell
    }
    
}

