//
//  PokemonPrettyController.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/19/24.
//

import Foundation
import UIKit

class PokemonPrettyController {
    
    static var shared = PokemonPrettyController()
    
    func prettyPrintGen(gen: String) -> String {
        var finalString = ""
        
        switch gen {
        case "generation-i":
            finalString = "I"
        case "generation-ii":
            finalString = "II"
        case "generation-iii":
            finalString = "III"
        case "generation-iv":
            finalString = "IV"
        case "generation-v":
            finalString = "V"
        case "generation-vi":
            finalString = "VI"
        case "generation-vii":
            finalString = "VII"
        case "generation-viii":
            finalString = "VIII"
        default:
            break
        }
        
        return finalString
    }
    
    func getBackgroundColorHex(type: PokemonType) -> String {
        switch type {
        case .normal:
            return "#A8A77A"
        case .fire:
            return "#EE8130"
        case .water:
            return "#6390F0"
        case .electric:
            return "#F7D02C"
        case .grass:
            return "#7AC74C"
        case .ice:
            return "#96D9D6"
        case .fighting:
            return "#C22E28"
        case .poison:
            return "#A33EA1"
        case .ground:
            return "#CC9F4F"
        case .flying:
            return "#7DA6DE"
        case .psychic:
            return "#F95587"
        case .bug:
            return "#A6B91A"
        case .rock:
            return "#B2A061"
        case .ghost:
            return "#735797"
        case .dragon:
            return "#6A7BAF"
        case .dark:
            return "#3F4250"
        case .steel:
            return "#89A1B0"
        case .fairy:
            return "#E397D1"
        }
    }
    
    
    
    func createLabelForTypeBox(_ label: UILabel, _ type: PokemonType) -> UILabel {
        label.text = type.rawValue.capitalized
        
        if type == .dark || type == .fighting || type == .poison || type == .ghost || type == .fire {
            label.textColor = .white
        } else {
            label.textColor = .black
        }
        
        return label
    }
    
    func createBackgroundForTypeBox(_ view: UIView, _ type: PokemonType) -> UIView {
        view.backgroundColor = UIColor(hex: PokemonPrettyController.shared.getBackgroundColorHex(type: type))
        
        view.layer.cornerRadius = 10
        
        return view
    }
}

extension UIColor {
    convenience init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 1)
    }
}

extension Array {
    func splitIntoEqualParts(numberOfParts: Int) -> [[Element]] {
        // Calculate the size of each part
        let chunkSize = count / numberOfParts
        // Create an empty array to store the parts
        var result = [[Element]]()
        var startIndex = startIndex
        
        // Iterate over the array and split it into parts
        for _ in 0..<numberOfParts {
            // Get the endIndex for the current part
            let endIndex = index(startIndex, offsetBy: chunkSize, limitedBy: endIndex) ?? endIndex
            // Slice the array to create the current part
            let part = Array(self[startIndex..<endIndex])
            // Append the part to the result array
            result.append(part)
            // Move the startIndex to the next position for the next part
            startIndex = endIndex
        }
        
        return result
    }
}

extension UICollectionViewCell {
    func addShadowAndCornerRadius(corner: CGFloat = 15, color: UIColor = .black, radius: CGFloat = 3, offset: CGSize = CGSize(width: 0, height: 0), opacity: Float = 0.5) {
        let cell = self
        cell.contentView.layer.cornerRadius = corner
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = color.cgColor
        cell.layer.shadowOffset = offset
        cell.layer.shadowRadius = radius
        cell.layer.shadowOpacity = opacity
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    }
}
