//
//  ContentView.swift
//  Music Player App
//
//  Created by Борис Кравченко on 23.12.2024.
//

import SwiftUI

struct PlayerView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
            List {
                SongCell()
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    PlayerView()
}
