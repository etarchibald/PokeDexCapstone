//
//  MovesDetailSwiftUIView.swift
//  Pokedex
//
//  Created by Ethan Archibald on 5/2/24.
//

import SwiftUI

struct MovesDetailSwiftUIView: View {
    
    var move: PokemonMove
    
    var body: some View {
        HStack {
            HStack {
                Text("Level:")
                Text("\(move.levelLearnedAt ?? 0)")
            }
            Text(move.name ?? "ERROR")
                .font(.title)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(uiColor: UIColor(hex: PokemonPrettyController.shared.getBackgroundColorHex(type: move.type!))))
                
                Text(move.type!.rawValue)
            }
            
            HStack {
                VStack {
                    Text("\(move.accuarcy ?? 0)")
                    Text("Accuracy")
                }
                
                VStack {
                    Text("\(move.power ?? 0)")
                    Text("Power")
                }
                
                VStack {
                    Text("\(move.pp ?? 0)")
                    Text("PP")
                }
                
                VStack {
                    Text("\(move.priority ?? 0)")
                    Text("Priority")
                }
            }
            
            VStack {
                Text("Learned:")
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
    
}

#Preview {
    MovesDetailSwiftUIView(move: PokemonMove(move: Move(name: "", url: URL(string: "https://pokeapi.co/api/v2/move/thunder-punch/")!), version_group_details: []))
}
