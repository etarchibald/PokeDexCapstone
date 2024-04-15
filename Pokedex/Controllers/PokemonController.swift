//
//  PokemonController.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import Foundation

struct PokemonController {
    
    /// An API call to get a list of 20 pokemon. No searching involved.
    /// - Parameter page: An optional parameter to get 20 more pokemon after the initial 20.
    /// - Returns: An array of usable pokemon objects
    static func getGenericPokemon(page: Int = 0) async throws -> [Pokemon] {
        // Make the initial API call
        let session = URLSession.shared
        var url = URLComponents(string: "\(API.url)/pokemon")!
        url.queryItems = [
            URLQueryItem(name: "offset", value: String(page * 20)),
            URLQueryItem(name: "limit", value: "20")
        ]
        
        var request = URLRequest(url: url.url!)
        
        var data: Data
        var response: URLResponse
        
        do {
            let (httpData, httpResponse) = try await session.data(for: request)
            data = httpData
            response = httpResponse
        } catch {
            throw error
        }
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw API.APIError.GenericAPIRequestFailed
        }
        
        // Decode the initial data
        let decoder = JSONDecoder()
        let pokemonGenericSearch = try decoder.decode(PokemonGenericSearch.self, from: data)
        
        // Now loop through the results and make another API call to get extra data about each pokemon
        var pokemon: [Pokemon] = []
        for pokemonResult in pokemonGenericSearch.results {
            request = URLRequest(url: pokemonResult.url)
            do {
                let (httpData, httpResponse) = try await session.data(for: request)
                data = httpData
                response = httpResponse
            } catch {
                throw error
            }
            
            // Ensure we had a good response (status 200)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw API.APIError.SpecificPokemonRequestFailed
            }
            
            // Decode the pokemon
            let decoder = JSONDecoder()
            let singlePokemon = try decoder.decode(Pokemon.self, from: data)
            pokemon.append(singlePokemon)
        }
        
        return pokemon
    }
    
    /// An API call to get a singular pokemon
    /// - Parameter name: The pokemons name to search for
    /// - Returns: An optional pokemon.
    static func getSpecificPokemon(pokemonName name: String) async throws -> Pokemon? {
        let session = URLSession.shared
        let url = URLComponents(string: "\(API.url)/pokemon/\(name.lowercased())")!
        
        let request = URLRequest(url: url.url!)
        
        var data: Data
        var response: URLResponse
        
        do {
            let (httpData, httpResponse) = try await session.data(for: request)
            data = httpData
            response = httpResponse
        } catch {
            throw error
        }
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            // TODO: Currently an error is thrown if there is no pokemon by the given name.
            // Would be better if nil is returned when there is no pokemon
            // Then return an error for any other errors.
            // Hint: You will need to figure out what the httpResponse.statusCode is when an unkown name is searched
            throw API.APIError.SpecificPokemonRequestFailed
        }
        
        // Decode the pokemon
        let decoder = JSONDecoder()
        do {
            let singlePokemon = try decoder.decode(Pokemon.self, from: data)
            return singlePokemon
        } catch {
            return nil
        }
    }
}
