//
//  CustomProgressBar.swift
//  Pokedex
//
//  Created by Jacob Davis on 5/10/24.
//

import UIKit

class CustomProgressBar: UIView {
    private let progressView = UIView()
    var progress: CGFloat = 0.0 {
        didSet {
            updateProgress()
            updateProgressColor()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupProgressBar()
    }
    
    private func setupProgressBar() {
        backgroundColor = .gray.withAlphaComponent(0.35)
        progressView.backgroundColor = .red
        
        addSubview(progressView)
    }
    
    private func updateProgress() {
        let maxWidth = frame.width
        let progressWidth = maxWidth * progress / 255
        
        progressView.frame = CGRect(x: 0, y: 0, width: progressWidth, height: frame.height)
    }
    
    func setProgress(value: CGFloat) {
        progress = min(max(value, 0), 255)
    }
    
    private func updateProgressColor() {
            if progress < 15 {
                progressView.backgroundColor = .red
            } else if progress <= 90 {
                progressView.backgroundColor = .yellow
            } else if progress <= 120 {
                progressView.backgroundColor = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0) // Light green
            } else if progress <= 150 {
                progressView.backgroundColor = .green
            } else {
                progressView.backgroundColor = UIColor(red: 64/255, green: 224/255, blue: 208/255, alpha: 1.0) // Turquoise
            }
        }
    
    
    
    
}
