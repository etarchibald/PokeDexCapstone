//
//  MovesDetailViewController.swift
//  Pokedex
//
//  Created by Ethan Archibald on 5/1/24.
//

import UIKit
import SwiftUI

class MovesDetailViewController: UIViewController {
    
    @IBOutlet weak var detailView: UIView!
    
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
        
//        updateUI()
        setupDetailView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        updateUI()
    }
    
    private func setupDetailView() {
        let detailView = UIHostingController(rootView: MovesDetailSwiftUIView(move: move))
        
        let detailSwiftUIView = detailView.view!
        
        addChild(detailView)
        self.detailView.addSubview(detailSwiftUIView)
        
        NSLayoutConstraint.activate([detailSwiftUIView.leadingAnchor.constraint(equalTo: self.detailView.leadingAnchor), detailSwiftUIView.topAnchor.constraint(equalTo: self.detailView.topAnchor), detailSwiftUIView.trailingAnchor.constraint(equalTo: self.detailView.trailingAnchor), detailSwiftUIView.bottomAnchor.constraint(equalTo: self.detailView.bottomAnchor)])
        
        detailView.didMove(toParent: self) 
    }
    
//    private func updateUI() {
//        if let type = move.type {
////            for eachLabel in otherLabels {
////                eachLabel.textColor = UIColor(hex: type.rawValue)
////            }
//            nameLabel.text = move.name
//            typeNameLabel.text = type.rawValue
//            typeBackgroundLabel = PokemonPrettyController.shared.createBackgroundForTypeBox(typeBackgroundLabel, type)
//            levelNumberLabel.text = "\(move.levelLearnedAt ?? 0)"
//            accuracyNumberLabel.text = "\(move.accuarcy ?? 0)"
//            powerNumberLabel.text = "\(move.power ?? 0)"
//            PPNumberLabel.text = "\(move.pp ?? 0)"
//            priorityNumberLabel.text = "\(move.priority ?? 0)"
//            learnedDetailLabel.text = move.moveLearnedMethod
//            damageClassDetailLabel.text = move.damageClass
//            targetDetailLabel.text = move.target
//            effectDetailLabel.text = move.effectEntries
//            effectChanceDetailLabel.text = "\(move.effectChance ?? 0)"
//            backgroundSquareView = PokemonPrettyController.shared.createBackgroundForTypeBox(backgroundSquareView, type)
//        }
//    }

}
