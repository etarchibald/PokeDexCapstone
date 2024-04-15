//
//  API.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import Foundation

struct API {
    static var url = "https://pokeapi.co/api/v2"
    
    enum APIError: Error, LocalizedError {
        case unknownError
        case APIRequestFailed
        case GenericAPIRequestFailed
        case SpecificPokemonRequestFailed
    }
}
