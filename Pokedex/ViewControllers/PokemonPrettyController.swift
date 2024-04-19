//
//  PokemonPrettyController.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/19/24.
//

import Foundation
import UIKit

enum TypeColor: String {
    case normal = "#A8A77A"
    case fire = "#EE8130"
    case water = "#6390F0"
    case electric = "#F7D02C"
    case grass = "#7AC74C"
    case ice = "#96D9D6"
    case fighting = "#C22E28"
    case poison = "#A33EA1"
    case ground = "#E2BF65"
    case flying = "#A98FF3"
    case psychic = "#F95587"
    case bug = "#A6B91A"
    case rock = "#B6A136"
    case ghost = "#735797"
    case dragon = "#6F35FC"
    case dark = "#705746"
    case steel = "#B7B7CE"
    case fairy = "#D685AD"
}

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
    
    func getbackgroundColor(type: String) -> UIColor {
        switch type.lowercased() {
        case "normal":
            return getColorFrom(hex: TypeColor.normal.rawValue)
        case "fire":
            return getColorFrom(hex: TypeColor.fire.rawValue)
        case "water":
            return getColorFrom(hex: TypeColor.water.rawValue)
        case "electric":
            return getColorFrom(hex: TypeColor.electric.rawValue)
        case "grass":
            return getColorFrom(hex: TypeColor.grass.rawValue)
        case "ice":
            return getColorFrom(hex: TypeColor.ice.rawValue)
        case "fighting":
            return getColorFrom(hex: TypeColor.fighting.rawValue)
        case "poison":
            return getColorFrom(hex: TypeColor.poison.rawValue)
        case "ground":
            return getColorFrom(hex: TypeColor.ground.rawValue)
        case "flying":
            return getColorFrom(hex: TypeColor.flying.rawValue)
        case "psychic":
            return getColorFrom(hex: TypeColor.psychic.rawValue)
        case "bug":
            return getColorFrom(hex: TypeColor.bug.rawValue)
        case "rock":
            return getColorFrom(hex: TypeColor.rock.rawValue)
        case "ghost":
            return getColorFrom(hex: TypeColor.ghost.rawValue)
        case "dragon":
            return getColorFrom(hex: TypeColor.dragon.rawValue)
        case "dark":
            return getColorFrom(hex: TypeColor.dark.rawValue)
        case "steel":
            return getColorFrom(hex: TypeColor.steel.rawValue)
        case "fairy":
            return getColorFrom(hex: TypeColor.fairy.rawValue)
        default:
            return .clear
        }
    }
    
    func getColorFrom(hex: String) -> UIColor {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 0)
    }
    
}
