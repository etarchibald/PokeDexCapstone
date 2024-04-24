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
        case "generation = vii":
            finalString = "VII"
        case "generation = viii":
            finalString = "VIII"
        default:
            break
        }
        
        return finalString
    }
    
    func getBackgroundColorHex(type: PokemonType) -> String {
        switch type {
        case .normal:
            return "#AAB09F"
        case .fire:
            return "#EA7A3C"
        case .water:
            return "#6390F0"
        case .electric:
            return "#E5C531"
        case .grass:
            return "#71C558"
        case .ice:
            return "#70CBD4"
        case .fighting:
            return "#CB5F48"
        case .poison:
            return "#A33EA1"
        case .ground:
            return "#CC9F4F"
        case .flying:
            return "#7DA6DE"
        case .psychic:
            return "#F95587"
        case .bug:
            return "#94BC4A"
        case .rock:
            return "#B2A061"
        case .ghost:
            return "#735797"
        case .dragon:
            return "#6A7BAF"
        case .dark:
            return "#736C75"
        case .steel:
            return "#89A1B0"
        case .fairy:
            return "#E397D1"
        }
    }
    
    
    
    func createLabelForTypeBox(_ label: UILabel, _ type: PokemonType) -> UILabel {
        label.text = type.rawValue.capitalized
        return label
    }
    
    func createBackgroundForTypeBox(_ view: UIView, _ type: PokemonType) -> UIView {
        view.backgroundColor = UIColor(hex: PokemonPrettyController.shared.getBackgroundColorHex(type: type))
        
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
