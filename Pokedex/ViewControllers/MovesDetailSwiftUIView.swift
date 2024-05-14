//
//  MovesDetailSwiftUIView.swift
//  Pokedex
//
//  Created by Ethan Archibald on 5/2/24.
//

import SwiftUI

struct MovesDetailSwiftUIView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var move: PokemonMove
    
    var isLightText: Bool {
        if move.type == .dark || move.type == .poison || move.type == .fighting || move.type == .ghost || move.type == .fire {
            return true
        } else {
            return false
        }
    }
    
    var typeColor: Color {
        return Color(uiColor: UIColor(hex: PokemonPrettyController.shared.getBackgroundColorHex(type: move.type ?? .normal)))
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                
                Text(move.name?.capitalized ?? "ERROR")
                    .font(.largeTitle)
                
                HStack(spacing: 30) {
                    
                    HStack {
                        Text("Level:")
                            .foregroundStyle(typeColor)
                        Text("\(move.levelLearnedAt ?? 0)")
                            .font(.title2)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(typeColor)
                        
                        Text(move.type?.rawValue.capitalized ?? "")
                            .foregroundStyle(isLightText ? .white : .black)
                    }
                    .frame(width: 75, height: 35)
                }
                .padding(.bottom, 10)
                
                HStack(spacing: 40) {
                    VStack {
                        Text("\(move.accuarcy ?? 100)")
                            .font(.title2)
                        Text("Accuracy")
                            .foregroundStyle(typeColor)
                    }
                    
                    VStack {
                        Text("\(move.power ?? 0)")
                            .font(.title2)
                        Text("Power")
                            .foregroundStyle(typeColor)
                    }
                    
                    VStack {
                        Text("\(move.pp ?? 25)")
                            .font(.title2)
                        Text("PP")
                            .foregroundStyle(typeColor)
                    }
                    
                    VStack {
                        Text("\(move.priority ?? 0)")
                            .font(.title2)
                        Text("Priority")
                            .foregroundStyle(typeColor)
                    }
                }
                .padding(.bottom, 10)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        if let learnedMethod = move.moveLearnedMethod {
                            HStack {
                                Text("Learned:")
                                    .foregroundStyle(typeColor)
                                Text(learnedMethod.capitalized)
                                    .font(.title2)
                                
                            }
                        }
                        
                        if let damageClass = move.damageClass {
                            HStack {
                                Text("Damage Class:")
                                    .foregroundStyle(typeColor)
                                Text(damageClass.capitalized)
                                    .font(.title2)
                            }
                        }
                        
                        if let effectChance = move.effectChance {
                            HStack {
                                Text("Effect Chance:")
                                    .foregroundStyle(typeColor)
                                Text("\(effectChance)%")
                                    .font(.title2)
                            }
                        }
                        
                        if let effectEntries = move.effectEntries, !effectEntries.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Effect:")
                                    .foregroundStyle(typeColor)
                                Text(effectEntries)
                                    .font(.title3)
                            }
                        }
                        
                    }
                    .padding()
                    
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(.black.opacity(0.1)))
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 40)
        }
    }
}

#Preview {
    MovesDetailSwiftUIView(move: PokemonMove(move: Move(name: "", url: URL(string: "https://pokeapi.co/api/v2/move/thunder-punch/")!), version_group_details: []))
}
