//
//  TypingSwiftUIView.swift
//  Pokedex
//
//  Created by Jacob Davis on 4/29/24.
//

import SwiftUI

struct TypingSwiftUIView: View {
    var typingText: PokemonType
    
    var body: some View {
        let backgroundHex = PokemonPrettyController.shared.getBackgroundColorHex(type: typingText).dropFirst()
        let color = Color(hex: String(backgroundHex))
                          
        Text(typingText.rawValue.capitalized)
            .frame(width: 100)
            .padding(10)
            .background(color, in: RoundedRectangle(cornerRadius: 10))
            
            
            
    }
}

#Preview {
    TypingSwiftUIView(typingText: .bug)
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

