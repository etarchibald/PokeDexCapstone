//
//  CustomProgressBar.swift
//  Pokedex
//
//  Created by Jacob Davis on 5/10/24.
//

import UIKit

class CustomProgressBar: UIView {
    private let progressView = UIView()
    private var progress: CGFloat = 0.0 {
        didSet {
            updateProgress()
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
        backgroundColor = .lightGray
        progressView.backgroundColor = .blue
        
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
    
    
    
    
    
}
