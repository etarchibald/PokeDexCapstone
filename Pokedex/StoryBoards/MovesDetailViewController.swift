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
        
        setupDetailView()
    }
    
    private func setupDetailView() {
        let detailView = UIHostingController(rootView: MovesDetailSwiftUIView(move: move))
        
        let detailSwiftUIView = detailView.view!

        detailSwiftUIView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(detailView)
        self.detailView.addSubview(detailSwiftUIView)
        
        NSLayoutConstraint.activate([detailSwiftUIView.leadingAnchor.constraint(equalTo: self.detailView.leadingAnchor), detailSwiftUIView.topAnchor.constraint(equalTo: self.detailView.topAnchor), detailSwiftUIView.trailingAnchor.constraint(equalTo: self.detailView.trailingAnchor), detailSwiftUIView.bottomAnchor.constraint(equalTo: self.detailView.bottomAnchor)])
        
        detailView.didMove(toParent: self) 
    }
}
