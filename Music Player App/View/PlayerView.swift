//
//  ContentView.swift
//  Music Player App
//
//  Created by Борис Кравченко on 23.12.2024.
//

import SwiftUI

struct PlayerView: View {
    
    @StateObject var viewModel = ViewModel()
    @State private var showFiles = false
    @State private var showFullPlayer = false
    @Namespace private var playerAnimation
    
    var frameImage: CGFloat {
        showFullPlayer ? 320 : 50
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                VStack {
                    List {
                        ForEach(viewModel.songs) { song in
                            SongCell(song: song, durationFormateed: viewModel.durationdFormatted)
                                .onTapGesture {
                                    viewModel.playAudio(song: song)
                                }
                        }
                    }
                    .listStyle(.plain)
                    
                    Spacer()
                    
                    // MARK: - Player
                    VStack {
                        // MARK: - Mini Player
                        HStack {
                            Color.white
                                .frame(width: frameImage, height: frameImage)
                            
                            if !showFullPlayer {
                                VStack(alignment: .leading) {
                                    Text("Name")
                                        .songNameFont()
                                    Text("Unknown artist")
                                        .artistFont()
                                }
                                .matchedGeometryEffect(id: "Description", in: playerAnimation)
                                
                                Spacer()
                                
                                CustomButton(image: "play.fill", size: .title) {
                                    // action
                                }
                            }
                        }
                        .padding()
                        .background(showFullPlayer ? .clear : .black.opacity(0.3))
                        .cornerRadius(10)
                        .padding()
                        
                        // Full Player
                        if showFullPlayer {
                            VStack {
                                Text("Name")
                                    .songNameFont()
                                Text("Unknown artist")
                                    .artistFont()
                            }
                            .matchedGeometryEffect(id: "Description", in: playerAnimation)
                            .padding(.top)
                            
                            VStack {
                                // Duration
                                HStack {
                                    Text("00:00")
                                    Spacer()
                                    Text("03:27")
                                }
                                .durationFont()
                                .padding()
                                
                               // Slider
                                Divider()
                                
                                HStack(spacing: 50) {
                                    CustomButton(image: "backward.end.fill", size: .title2) {
                                        // action
                                    }
                                    
                                    CustomButton(image: "play.circle.fill", size: .largeTitle) {
                                        // action
                                    }
                                    
                                    CustomButton(image: "forward.end.fill", size: .title2) {
                                        // action
                                    }
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                    .frame(height: showFullPlayer ? SizeConstants.fullPlayer : SizeConstants.miniPlayer)
                    .onTapGesture {
                        withAnimation(.spring) {
                            self.showFullPlayer.toggle()
                        }
                    }
                }
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
    
    // MARK: - Methods
    private func CustomButton(image: String, size: Font, action: @escaping () -> ()) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: image)
                .foregroundStyle(.white)
                .font(size)
        }
    }
}

#Preview {
    PlayerView()
}
