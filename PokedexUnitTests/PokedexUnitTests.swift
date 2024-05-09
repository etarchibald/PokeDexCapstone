//
//  PokedexUnitTests.swift
//  PokedexUnitTests
//
//  Created by Austin Dobberfuhl on 4/30/24.
//

import XCTest
@testable import Pokedex

final class PokedexUnitTests: XCTestCase {
    
    let pokemonNetworkController = PokemonNetworkController.shared
    
    var sut: FavoritePokemonViewController!
    var collectionView: UICollectionView!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDecodePokemon() throws {
        // Given
        let bundle = Bundle(for: type(of: self))
        let json = bundle.url(forResource: "PokemonTest", withExtension: "json")!
        // When
        let jsonData = try Data(contentsOf: json)
        let decoder = JSONDecoder()
        let pokemon = try decoder.decode(Pokemon.self, from: jsonData)
        
        // Then
        XCTAssertEqual(pokemon.id, 1)
        XCTAssertEqual(pokemon.name, "bulbasaur")
        XCTAssertFalse(pokemon.isFavorited ?? false)
        XCTAssertEqual(pokemon.types.count, 2)
        XCTAssertEqual(pokemon.primaryType?.rawValue, "grass")
        XCTAssertEqual(pokemon.secondaryType?.rawValue, "poison")
        XCTAssertEqual(pokemon.sprites.frontDefault, URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"))
        XCTAssertEqual(pokemon.abilities.count, 2)
        XCTAssertEqual(pokemon.stats.count, 6)
        XCTAssertEqual(pokemon.height, 7)
        XCTAssertEqual(pokemon.weight, 69)
        XCTAssertNil(pokemon.damageRelations)
        XCTAssertNil(pokemon.evolutionChain)
        XCTAssertEqual(pokemon.moves.count, 86)
        XCTAssertNil(pokemon.moves[0].name)
    }
    
    func testGetGenericPokemon() async throws {
        var receivedPokemon: [Pokemon]?
        
        do {
            receivedPokemon = try await pokemonNetworkController.getGenericPokemon()
        } catch {
            XCTFail("Error fetching generic pokemon: \(error)")
        }
        
        XCTAssertNotNil(receivedPokemon)
        XCTAssertFalse(receivedPokemon!.isEmpty)
    }
    
    func testFetchImageData() async throws {
        let imageURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!
        
        var image: UIImage?
        
        do {
            image = try await pokemonNetworkController.fetchImageData(url: imageURL)
        } catch {
            XCTFail("Error fetching Image")
        }
        
        XCTAssertNotNil(image)
    }
    
    func testMoveComputedProperties() throws {
        // Given
        let move = Move(name: "Tackle", url: URL(string: "https://example.com/move/tackle")!)
        let moveDetail = MoveDetail(name: "Tackle", accuracy: 100, effectChance: 10, effectEntries: [EffectEntries(effect: "An attack", language: Language(name: "en")), EffectEntries(effect: "A powerful move", language: Language(name: "en"))], damageClass: DamageClass(name: "Physical"), power: 50, pp: 10, priority: 0, target: Target(name: "One Enemy"), type: APIPokemonType(name: PokemonType.normal))
        let versionGroupDetails = VersionGroupDetails(level_learned_at: 5, move_learn_method: MoveLearnMethod(name: "Level Up"))
        let pokemonMove = PokemonMove(move: move, version_group_details: [versionGroupDetails], moveDetail: moveDetail)
        
        // When & Then
        XCTAssertEqual(pokemonMove.name, "Tackle")
        XCTAssertEqual(pokemonMove.url?.absoluteString, "https://example.com/move/tackle")
        XCTAssertEqual(pokemonMove.accuarcy, 100)
        XCTAssertEqual(pokemonMove.effectChance, 10)
        XCTAssertEqual(pokemonMove.effectEntries, "An attack")
        XCTAssertEqual(pokemonMove.damageClass, "Physical")
        XCTAssertEqual(pokemonMove.power, 50)
        XCTAssertEqual(pokemonMove.pp, 10)
        XCTAssertEqual(pokemonMove.priority, 0)
        XCTAssertEqual(pokemonMove.target, "One Enemy")
        XCTAssertEqual(pokemonMove.type, .normal)
        XCTAssertEqual(pokemonMove.levelLearnedAt, 5)
        XCTAssertEqual(pokemonMove.moveLearnedMethod, "Level Up")
    }
    
    func testEffect() {
        // Given
        let abilityDetails = AbilityDetails(effectEntries: [EffectEntries(effect: "This is the effect", language: Language(name: "en"))], flavorTextEntries: [])
        let ability = Ability(name: "abilityName", url: URL(string: "https://example.com/ability")!)
        let pokemonAbility = PokemonAbilities(ability: ability, slot: 1, abilityDetails: abilityDetails)
        
        // When & Then
        XCTAssertEqual(pokemonAbility.effect, "This is the effect", "Effect should match the effect entry in the ability details")
    }
    
    func testFlavorText() {
        // Given
        let flavorTextEntries = [FlavorTextEntries(flavor_text: "This is the flavor text")]
        let abilityDetails = AbilityDetails(effectEntries: [], flavorTextEntries: flavorTextEntries)
        let ability = Ability(name: "abilityName", url: URL(string: "https://example.com/ability")!)
        let pokemonAbility = PokemonAbilities(ability: ability, slot: 1, abilityDetails: abilityDetails)
        
        // When & Then
        XCTAssertEqual(pokemonAbility.flavorText, "This is the flavor text", "Flavor text should match the flavor text entry in the ability details")
    }
    
}
