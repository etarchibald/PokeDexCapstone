//
//  PokemonController.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import Foundation

class PokemonController {
    
    static var shared = PokemonController()
    
    /// An API call to get a list of 20 pokemon. No searching involved.
    /// - Parameter page: An optional parameter to get 20 more pokemon after the initial 20.
    /// - Returns: An array of usable pokemon objects
    func getGenericPokemon(page: Int = 0) async throws -> [Pokemon] {
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
            var singlePokemon = try decoder.decode(Pokemon.self, from: data)
            
            //API call to get damage relations
            for type in singlePokemon.types {
                let pokemonType = type.type.name
                
                do {
                    singlePokemon.damageRelations = try await fetchPokemonDamageRelations(type: pokemonType)
                } catch {
                    throw error
                }
            }
            
            //API call to get species info
            do {
//                singlePokemon.evolutionChain = try await fetchPokemonEvolution(id: singlePokemon.id)
                singlePokemon.species = try await fetchPokemonSpecies(id: singlePokemon.id)
                singlePokemon.evolutionChain = try await fetchEvolutionChain(url: (singlePokemon.species?.evolutionChain.url)!)
            } catch {
                throw error
            }
            //API call for generation
            
            pokemon.append(singlePokemon)
        }
        
        return pokemon
    }
    
    /// An API call to get a singular pokemon
    /// - Parameter name: The pokemons name to search for
    /// - Returns: An optional pokemon.
    func getSpecificPokemon(pokemonName name: String) async throws -> Pokemon? {
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
    
    func fetchPokemonDamageRelations(type: String) async throws -> PokemonDamageRelations {
        let session = URLSession.shared
        let url = URL(string: "\(API.url)/type/\(type)")!
        
        let request = URLRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw API.APIError.APIRequestFailed
        }
        
        let damageRelations = try JSONDecoder().decode(PokemonDamageRelations.self, from: data)
        
        return damageRelations
    }
    
    func fetchPokemonSpecies(id: Int) async throws -> PokemonSpecies {
        let session = URLSession.shared
        let url = URL(string: "\(API.url)/pokemon-species/\(id)")!
        
        let request = URLRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw API.APIError.APIRequestFailed
        }
        
        let species = try JSONDecoder().decode(PokemonSpecies.self, from: data)
        
        return species
    }
    
    func fetchEvolutionChain(url: URL) async throws -> PokemonEvolution {
        let session = URLSession.shared
        let request = URLRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw API.APIError.APIRequestFailed
        }
        
        let evolutionChain = try JSONDecoder().decode(PokemonEvolution.self, from: data)
        
        return evolutionChain
    }
}
