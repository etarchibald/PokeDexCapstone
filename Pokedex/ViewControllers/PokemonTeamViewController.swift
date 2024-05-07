//
//  PokemonCardsViewController.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/30/24.
//

import UIKit

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
    
    @objc func editButtonTapped() {
        isEditingMode = !isEditingMode
        
        // Toggle editing mode of the collection view
        collectionView.isEditing = isEditingMode
        
        // Update the UI based on the editing mode
        let buttonTitle = isEditingMode ? "Done" : "Edit"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: buttonTitle, style: .plain, target: self, action: #selector(editButtonTapped))
        
        // Enable or disable collection view interaction based on editing mode
        collectionView.allowsSelection = !isEditingMode
        
        collectionView.reloadData()
    }
    
    func deletePokemon(_ pokemon: Pokemon) {
        guard let index = team.pokemon.firstIndex(of: pokemon) else {
            return
        }
        
        // Update the collection view to reflect the deletion
        collectionView.performBatchUpdates({
            team.pokemon.remove(at: index)
            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }, completion: nil)
        
        //print("Array count: \(team.pokemon.count)")
        //print("Index: \(index)")
        
        TeamController.saveTeams(teams: TeamController.teams)
    }
    
}
extension PokemonTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        team.pokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemon = team.pokemon[indexPath.item]
        
        performSegue(withIdentifier: "showDetailSegue", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritePokemonCell", for: indexPath) as! PokemonCollectionViewCell
        
        cell.isEditing = isEditingMode
        let pokemon = team.pokemon[indexPath.item]
        cell.onDelete = { [weak self] in
            guard let self = self else { return }
            guard let index = self.collectionView.indexPath(for: cell)?.item else { return }
            self.deletePokemon(self.team.pokemon[index])
        }
        cell.updateUI(using: pokemon)
        return cell
    }
    
}

