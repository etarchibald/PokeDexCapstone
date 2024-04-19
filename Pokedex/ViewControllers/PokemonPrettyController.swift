//
//  PokemonPrettyController.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/19/24.
//

import Foundation

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
    
}
