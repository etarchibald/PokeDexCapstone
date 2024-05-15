//
//  FetchAPIModels.swift
//  Pokedex
//
//  Created by Ethan Archibald on 4/26/24.
//

import Foundation

struct FetchGenericPokemonRequest: APIRequest {
    var page: Int
    
    var urlRequest: URLRequest {
        var url = URLComponents(string: "\(API.url)/pokemon")!
        url.queryItems = [
            URLQueryItem(name: "offset", value: String(page * 20)),
            URLQueryItem(name: "limit", value: "20")
        ]
        return URLRequest(url: url.url!)
    }
    
    func decodeData(_ data: Data) throws -> PokemonGenericSearch {
        return try JSONDecoder().decode(PokemonGenericSearch.self, from: data)
    }
}

struct FetchSameTypePokmeon: APIRequest {
    var type: String
    
    var urlRequest: URLRequest {
        let url = URL(string: "https://pokeapi.co/api/v2/type/\(type.lowercased())/")!
        
        return URLRequest(url: url)
    }
    
    func decodeData(_ data: Data) throws -> PokemonTypeSearch {
        return try JSONDecoder().decode(PokemonTypeSearch.self, from: data)
    }
}

struct FetchGenerationPokemonRequest: APIRequest {
    var genNumber: Int
    
    var urlRequest: URLRequest {
        let url = URL(string: "\(API.url)/generation/\(genNumber)")!
        
        return URLRequest(url: url)
    }
    
    func decodeData(_ data: Data) throws -> PokemonGenerationSearch {
        return try JSONDecoder().decode(PokemonGenerationSearch.self, from: data)
    }
}

struct FetchAllPokemonInfoRequest: APIRequest {
    var url: URL
    
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
    
    func decodeData(_ data: Data) throws -> Pokemon {
        return try JSONDecoder().decode(Pokemon.self, from: data)
    }
}

struct FetchDamageRelationsRequest: APIRequest {
    var type: PokemonType
    
    var urlRequest: URLRequest {
        let url = URL(string: "\(API.url)/type/\(type.rawValue)")!
        return URLRequest(url: url)
    }
    
    func decodeData(_ data: Data) throws -> PokemonDamageRelations {
        return try JSONDecoder().decode(PokemonDamageRelations.self, from: data)
    }
}

struct FetchPokemonSpeciesRequest: APIRequest {
    var id: Int
    
    var urlRequest: URLRequest {
        let url = URL(string: "\(API.url)/pokemon-species/\(id)")!
        return URLRequest(url: url)
    }
    
    func decodeData(_ data: Data) throws -> PokemonSpecies {
        return try JSONDecoder().decode(PokemonSpecies.self, from: data)
    }
}

struct FetchEvolutionChainRequest: APIRequest {
    var url: URL
    
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
    
    func decodeData(_ data: Data) throws -> PokemonEvolution {
        return try JSONDecoder().decode(PokemonEvolution.self, from: data)
    }
}

struct FetchPokemonAbilities: APIRequest {
    var url: URL
    
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
    
    func decodeData(_ data: Data) throws -> AbilityDetails {
        return try JSONDecoder().decode(AbilityDetails.self, from: data)
    }
}

struct FetchPokemonMoves: APIRequest {
    var url: URL
    
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
    
    func decodeData(_ data: Data) throws -> MoveDetail {
        return try JSONDecoder().decode(MoveDetail.self, from: data)
    }
}
