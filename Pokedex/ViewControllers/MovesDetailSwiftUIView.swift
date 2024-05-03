//
//  MovesDetailSwiftUIView.swift
//  Pokedex
//
//  Created by Ethan Archibald on 5/2/24.
//

import SwiftUI

struct MovesDetailSwiftUIView: View {
    
    var move: PokemonMove
    
    var isLightText: Bool {
        if move.type == .dark || move.type == .poison || move.type == .fighting || move.type == .ghost {
            return true
        } else {
            return false
        }
    }
    
    var typeColor: Color {
        return Color(uiColor: UIColor(hex: PokemonPrettyController.shared.getBackgroundColorHex(type: move.type ?? .normal)))
    }
    
    var body: some View {
        
        VStack {
            
            VStack {
                VStack {
                    
                    Text(move.name?.capitalized ?? "ERROR")
                        .font(.largeTitle)
                    
                    HStack(spacing: 50) {
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
                }
                .padding(.bottom, 30)
                
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
                        Text("\(move.pp!)")
                            .font(.title2)
                        Text("PP")
                            .foregroundStyle(typeColor)
                    }
                    
                    VStack {
                        Text("\(move.priority!)")
                            .font(.title2)
                        Text("Priority")
                            .foregroundStyle(typeColor)
                    }
                }
                .padding(.bottom, 10)
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(typeColor.opacity(0.1))
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Learned:")
                                .foregroundStyle(typeColor)
                            Text(move.moveLearnedMethod ?? "")
                            
                        }
                        
                        VStack {
                            Text("Damage Class:")
                            Text(move.damageClass ?? "")
                        }
                        
                        VStack {
                            Text("Effect:")
                            Text(move.effectEntries ?? "")
                        }
                        
                        VStack {
                            Text("Effect Chance:")
                            Text("\(move.effectChance ?? 0)")
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
        }
    }
}

#Preview {
    MovesDetailSwiftUIView(move: PokemonMove(move: Move(name: "", url: URL(string: "https://pokeapi.co/api/v2/move/thunder-punch/")!), version_group_details: []))
}
