//
//  FavoritePokemonViewControllerTests.swift
//  PokedexUnitTests
//
//  Created by Ethan Archibald on 5/9/24.
//

import XCTest
@testable import Pokedex

class FavoritePokemonViewControllerTests: XCTestCase {
    
    func getPokemon() async throws -> [Pokemon] {
        do {
            return try await PokemonNetworkController.shared.getGenericPokemon()
        } catch {
            throw error
        }
    }
    
    var sut: FavoritePokemonViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "FavoritePokemonView", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "FavoritePokemon") as? FavoritePokemonViewController
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testCollectionViewDataSource() {
        XCTAssertNotNil(sut.collectionView.dataSource)
        XCTAssertTrue(sut.collectionView.dataSource is FavoritePokemonViewController)
    }
    
    func testCollectionViewDelegate() {
        XCTAssertNotNil(sut.collectionView.delegate)
        XCTAssertTrue(sut.collectionView.delegate is FavoritePokemonViewController)
    }
    
    func testCollectionViewRegistersCell() {
        let cell = sut.collectionView.dequeueReusableCell(withReuseIdentifier: "favoritePokemonCell", for: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is PokemonCollectionViewCell)
    }
}
