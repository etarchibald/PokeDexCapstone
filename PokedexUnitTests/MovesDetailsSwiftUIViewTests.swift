//
//  MovesDetailsSwiftUIViewTests.swift
//  PokedexUnitTests
//
//  Created by Ethan Archibald on 5/9/24.
//

import XCTest
@testable import Pokedex
import SwiftUI

class MovesDetailSwiftUIViewTests: XCTestCase {
    
    func testMove() async {
        // Given
        do {
            var pokemon = try await PokemonNetworkController.shared.getGenericPokemon().first!
            pokemon = try await PokemonNetworkController.shared.fetchPokemonMoves(pokemon: pokemon)
            
            let moves = pokemon.moves.sorted { $0.moveDetail!.name > $1.moveDetail!.name }
            
            // When
            let view = MovesDetailSwiftUIView(move: moves.first!)
            
            // Then
            XCTAssertNotNil(view.move.name)
            XCTAssertEqual(view.move.name, "worry-seed")
        } catch {
            XCTFail("Error loading pokemon")
        }
    }
    
    func testTypeColor() async {
        
        do {
            var pokemon = try await PokemonNetworkController.shared.getGenericPokemon().first!
            pokemon = try await PokemonNetworkController.shared.fetchPokemonMoves(pokemon: pokemon)
            
            let moves = pokemon.moves.sorted { $0.moveDetail!.name > $1.moveDetail!.name }
            
            // When
            let view = MovesDetailSwiftUIView(move: moves.first!)
            
            // Then
            XCTAssertEqual(view.isLightText, false)
            XCTAssertNotNil(view.typeColor)
        } catch {
            XCTFail("Error loading pokemon")
        }
        
    }
    
    func testNotNil() async {
        
        do {
            var pokemon = try await PokemonNetworkController.shared.getGenericPokemon().first!
            pokemon = try await PokemonNetworkController.shared.fetchPokemonMoves(pokemon: pokemon)
            
            let moves = pokemon.moves.sorted { $0.moveDetail!.name > $1.moveDetail!.name }
            
            // When
            let view = MovesDetailSwiftUIView(move: moves.first!)
            
            // Then
            DispatchQueue.main.async {
                XCTAssertNotNil(view.body)
            }
            
        } catch {
            XCTFail("Error loading pokemon")
        }
    }
}
