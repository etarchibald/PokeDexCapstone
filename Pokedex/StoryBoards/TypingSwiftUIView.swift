//
//  TypingSwiftUIView.swift
//  Pokedex
//
//  Created by Jacob Davis on 4/29/24.
//

import SwiftUI

struct TypingSwiftUIView: View {
    var arrayOfTypes: [PokemonType]
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    let whiteRequired: [PokemonType] = [.dark, .fighting, .ghost, .poison]
    
    var body: some View {
        
        HStack {
            
        }
        
        LazyVGrid(columns: columns, content: {
            ForEach(arrayOfTypes, id: \.self) { type in
                let backgroundHex = PokemonPrettyController.shared.getBackgroundColorHex(type: type).dropFirst()
                        let color = Color(hex: String(backgroundHex))
                
                Text(type.rawValue.capitalized)
                    .foregroundStyle(whiteRequired.contains(type) ? .white : .black)
                    .frame(width: 75)
                    .padding(10)
                    .background(color, in: RoundedRectangle(cornerRadius: 10))
                    
            }
        })
        .padding()
        .background(.gray.opacity(0.7))
        .shadow(radius: 5)
//
            
            
            
    }
}

#Preview {
    TypingSwiftUIView(arrayOfTypes: [.ice, .dark, .bug, .dragon, .electric, .fairy, .fighting, .fire, .ground, .flying, .ghost, .grass, .poison, .psychic, .rock, .steel, .normal])
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0

        scanner.scanHexInt64(&rgb)

        self.init(
            .sRGB,
            red: Double((rgb >> 16) & 0xFF) / 255.0,
            green: Double((rgb >> 8) & 0xFF) / 255.0,
            blue: Double(rgb & 0xFF) / 255.0
        )
    }
}

