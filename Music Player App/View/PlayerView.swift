//
//  ContentView.swift
//  Music Player App
//
//  Created by Борис Кравченко on 23.12.2024.
//

import SwiftUI

struct PlayerView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                List {
                    ForEach(viewModel.songs) { song in
                        SongCell(song: song)
                    }
                }
                .listStyle(.plain)
            }
            
            // MARK: - Navigation Bar
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // action
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    PlayerView()
}
