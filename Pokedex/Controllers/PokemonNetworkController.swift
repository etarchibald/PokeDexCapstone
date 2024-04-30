//
//  PokemonController.swift
//  Pokedex
//
//  Created by Brayden Lemke on 1/10/24.
//

import Foundation

class PokemonNetworkController {
    
    static var shared = PokemonNetworkController()
    
    /// An API call to get a list of 20 pokemon. No searching involved.
    /// - Parameter page: An optional parameter to get 20 more pokemon after the initial 20.
    /// - Returns: An array of usable pokemon objects
    func getGenericPokemon(page: Int = 0) async throws -> [Pokemon] {
        
        //create Request
        let fetchGenericPokemonRequest = FetchGenericPokemonRequest(page: page)
        
        //get Pokemon using Reqest
        let pokemonGenericSearch = try await API.shared.sendRequest(fetchGenericPokemonRequest)
        
        // Now loop through the results and make another API call to get extra data about each pokemon
        var pokemon = [Pokemon]()
        for pokemonResult in pokemonGenericSearch.results {
            do {
                await pokemon.append(try fetchAllPokemonInformationUsing(URL: pokemonResult.url))
            } catch {
                continue
            }
        }
        
        return pokemon
    }
    
    func fetchGenerationPokemonResults(gen: Int) async throws -> [PokemonGenericSearchResults] {
        
        let fetchGenerationPokemonRequest = FetchGenerationPokemonRequest(genNumber: gen)
        
        let pokemonGenerationSearch = try await API.shared.sendRequest(fetchGenerationPokemonRequest)
        
        return pokemonGenerationSearch.results
    }
    
    func fetchGenerationBatch(genBatch: [PokemonGenericSearchResults]) async -> [Pokemon] {
        var pokemon = [Pokemon]()
        
        for batchPokemon in genBatch {
            do {
                await pokemon.append(try fetchAllPokemonInformationUsing(URL: URL(string: "\(API.url)/pokemon/\(batchPokemon.name)")!))
            } catch {
                print("Pokemon: \(batchPokemon.name) failed to load")
                continue
            }
        }
        
        return pokemon
    }
    
    /// An API call to get a singular pokemon
    /// - Parameter name: The pokemons name to search for
    /// - Returns: An optional pokemon.
    func getSpecificPokemon(pokemonName name: String) async throws -> Pokemon? {
        do {
            return try await fetchAllPokemonInformationUsing(URL: URL(string: "\(API.url)/pokemon/\(name.lowercased())")!)
        } catch {
            return nil
        }
    }
    
    func fetchAllPokemonInformationUsing(URL: URL) async throws -> Pokemon {
        
        let fetchAllRequest = FetchAllPokemonInfoRequest(url: URL)
        
        var singlePokemon = try await API.shared.sendRequest(fetchAllRequest)
        
        //API call to get damage relations
        do {
            singlePokemon.damageRelations = try await fetchPokemonDamageRelations(type: singlePokemon.primaryType ?? .normal)
            singlePokemon.damageRelations = try await fetchPokemonDamageRelations(type: singlePokemon.secondaryType ?? .normal)
        } catch {
            throw error
        }
        
        
        //API call to get species info
        do {
            singlePokemon.species = try await fetchPokemonSpecies(id: singlePokemon.id)
            if let url = singlePokemon.species?.evolutionChain?.url {
                singlePokemon.evolutionChain = try await fetchEvolutionChain(url: url)
            }
        } catch {
            throw error
        }
        
        do {
            let abilitiesDetails = try await withThrowingTaskGroup(of: AbilityDetails.self) { group in
                for eachAbility in singlePokemon.abilities {
                    group.addTask {
                        // Fetch details for each ability
                        do {
                            return try await self.fetchPokemonAbilitiesDetails(url: eachAbility.ability.url)
                        } catch {
                            throw error
                        }
                    }
                }
                // Collect the fetched ability details
                var results = [AbilityDetails]()
                do {
                    for try await details in group {
                        results.append(details)
                    }
                } catch {
                    throw error
                }
                return results
            }
            
            // Update abilityDetails property for each ability
            for (index, details) in abilitiesDetails.enumerated() {
                singlePokemon.abilities[index].abilityDetails = details
            }
        } catch {
            throw error
        }
        
        
        do {
            let movesDetails = try await withThrowingTaskGroup(of: MoveDetail.self) { moves in
                for eachMove in singlePokemon.moves {
                    moves.addTask {
                        do {
                            return try await self.fetchPokemonMoveDetails(url: eachMove.url!)
                        } catch {
                            throw error
                        }
                    }
                }
                
                var resutls = [MoveDetail]()
                
                do {
                    for try await details in moves {
                        resutls.append(details)
                    }
                } catch {
                    throw error
                }
                
                return resutls
            }
            
            for (index, details) in movesDetails.enumerated() {
                singlePokemon.moves[index].moveDetail = details
            }
            
        } catch {
            print(error)
            throw error
        }
        
        
        for eachFavoritedPokemon in await FavoritePokemonViewController.favoritePokemon {
            if eachFavoritedPokemon.name == singlePokemon.name {
                singlePokemon.isFavorited = true
            }
        }
        
        return singlePokemon
    }
    
    func fetchPokemonDamageRelations(type: PokemonType) async throws -> PokemonDamageRelations {
        let damageRelationsRequest = FetchDamageRelationsRequest(type: type)
        
        return try await API.shared.sendRequest(damageRelationsRequest)
    }
    
    func fetchPokemonSpecies(id: Int) async throws -> PokemonSpecies {
        
        let pokemonSpeciesRequest = FetchPokemonSpeciesRequest(id: id)
        
        return try await API.shared.sendRequest(pokemonSpeciesRequest)
    }
    
    func fetchEvolutionChain(url: URL) async throws -> PokemonEvolution {
        
        let evolutionChainRequest = FetchEvolutionChainRequest(url: url)
        
        return try await API.shared.sendRequest(evolutionChainRequest)
    }
    
    func fetchPokemonAbilitiesDetails(url: URL) async throws -> AbilityDetails {
        
        let ablitliesDetailRequest = FetchPokemonAbilities(url: url)
        
        return try await API.shared.sendRequest(ablitliesDetailRequest)
        
    }
    
    func fetchPokemonMoveDetails(url: URL) async throws -> MoveDetail {
        
        let movesDetailRequest = FetchPokemonMoves(url: url)
        
        return try await API.shared.sendRequest(movesDetailRequest)
        
    }
    
    func fetchImageData(url: URL) async throws -> Data {
        let session = URLSession.shared
        let request = URLRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw API.APIError.ImageFetchFailed
        }
        
        return data
    }
}
