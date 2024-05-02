//
//  MovesDetailViewController.swift
//  Pokedex
//
//  Created by Ethan Archibald on 5/1/24.
//

import UIKit

class MovesDetailViewController: UIViewController {
    
    @IBOutlet var otherLabels: [UILabel]!
    @IBOutlet weak var backgroundSquareView: UIView!
    @IBOutlet weak var effectChanceDetailLabel: UILabel!
    @IBOutlet weak var effectDetailLabel: UILabel!
    @IBOutlet weak var targetDetailLabel: UILabel!
    @IBOutlet weak var damageClassDetailLabel: UILabel!
    @IBOutlet weak var learnedDetailLabel: UILabel!
    @IBOutlet weak var priorityNumberLabel: UILabel!
    @IBOutlet weak var PPNumberLabel: UILabel!
    @IBOutlet weak var powerNumberLabel: UILabel!
    @IBOutlet weak var accuracyNumberLabel: UILabel!
    @IBOutlet weak var levelNumberLabel: UILabel!
    @IBOutlet weak var typeBackgroundLabel: UIView!
    @IBOutlet weak var typeNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var move: PokemonMove
    
    required init?(move: PokemonMove, coder: NSCoder) {
        self.move = move
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    private func updateUI() {
        if let type = move.type {
            for eachLabel in otherLabels {
                eachLabel.textColor = UIColor(hex: type.rawValue)
            }
            nameLabel.text = move.name
            typeNameLabel.text = type.rawValue
            typeBackgroundLabel = PokemonPrettyController.shared.createBackgroundForTypeBox(typeBackgroundLabel, type)
            levelNumberLabel.text = "\(move.levelLearnedAt ?? 0)"
            accuracyNumberLabel.text = "\(move.accuarcy ?? 0)"
            powerNumberLabel.text = "\(move.power ?? 0)"
            PPNumberLabel.text = "\(move.pp ?? 0)"
            priorityNumberLabel.text = "\(move.priority ?? 0)"
            learnedDetailLabel.text = move.moveLearnedMethod
            damageClassDetailLabel.text = move.damageClass
            targetDetailLabel.text = move.target
            effectDetailLabel.text = move.effectEntries
            effectChanceDetailLabel.text = "\(move.effectChance ?? 0)"
            backgroundSquareView.backgroundColor = UIColor(hex: PokemonPrettyController.shared.getBackgroundColorHex(type: type)).withAlphaComponent(0.4)
            
            backgroundSquareView.layer.cornerRadius = 10
        }
    }

}
