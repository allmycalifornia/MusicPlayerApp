//
//  FontsView.swift
//  Music Player App
//
//  Created by Борис Кравченко on 23.12.2024.
//

import SwiftUI

struct DurationFontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .font(.system(size: 14, weight: .light, design: .rounded))
    }
}

extension View {
    func durationFont() -> some View {
        self.modifier(DurationFontModifier())
    }
}

extension Text {
    func songNameFont() -> some View {
        self
            .foregroundStyle(.white)
            .font(.system(size: 16, weight: .semibold, design: .rounded))
    }
    
    func artistFont() -> some View {
        self
            .foregroundStyle(.white)
            .font(.system(size: 14, weight: .light, design: .rounded))
    }
}


struct FontsView: View {
    var body: some View {
        VStack {
            Text("Fonts")
                .songNameFont()
            Text("Fonts")
                .artistFont()
        }
    }
}

#Preview {
    FontsView()
}
