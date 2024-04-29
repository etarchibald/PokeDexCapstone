//
//  TypingLabelView.swift
//  Pokedex
//
//  Created by Jacob Davis on 4/26/24.
//

import UIKit

class TypingLabelView: UIView {
    private var label: UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
    
    var text: String = "" { didSet { self.label.text = self.text } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        internalInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        internalInit()
    }
    
    private func internalInit() {
        backgroundColor = .red
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
        self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
        self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
        self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
}
