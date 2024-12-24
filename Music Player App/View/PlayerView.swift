//
//  ContentView.swift
//  Music Player App
//
//  Created by Борис Кравченко on 23.12.2024.
//

import SwiftUI

struct PlayerView: View {
    
    @StateObject var viewModel = ViewModel()
    @State var showFiles = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                List {
                    ForEach(viewModel.songs) { song in
                        SongCell(song: song, durationFormateed: viewModel.durationdFormatted)
                    }
                }
                .listStyle(.plain)
            }
            
            // MARK: - Navigation Bar
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFiles.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }
                }
            }
            
            // MARK: - File's sheet
            .sheet(isPresented: $showFiles, content: {
                ImportFileManager(songs: $viewModel.songs)
            })
        }
    }
}

#Preview {
    PlayerView()
}
