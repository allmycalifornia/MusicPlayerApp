//
//  ContentView.swift
//  Music Player App
//
//  Created by Борис Кравченко on 23.12.2024.
//

import SwiftUI
import RealmSwift

struct PlayerView: View {
    @ObservedResults(SongModel.self) var songs
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
                
                // MARK: - Songs List
                VStack {
                    List {
                        ForEach(songs) { song in
                            SongCell(song: song, durationFormateed: viewModel.durationFormatted)
                                .onTapGesture {
                                    viewModel.playAudio(song: song)
                                }
                        }
                        .onDelete(perform: $songs.remove)
                    }
                    .listStyle(.plain)
                    
                    Spacer()
                    
                    // MARK: - Player
                    if viewModel.currentSong != nil {
                        Player()
                            .frame(height: showFullPlayer ? SizeConstants.fullPlayer : SizeConstants.miniPlayer)
                            .onTapGesture {
                                withAnimation(.spring) {
                                    self.showFullPlayer.toggle()
                                }
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
                ImportFileManager()
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
    
    //@ViewBuilder
    private func Player() -> some View {
        VStack {
            // MARK: - Mini Player
            HStack {
                
                // Cover
                SongImageView(imageData: viewModel.currentSong?.coverImage, size: frameImage)
                
                if !showFullPlayer {
                    
                    // Description
                    VStack(alignment: .leading) {
                        if let currentSong = viewModel.currentSong {
                            Text(currentSong.name)
                                .songNameFont()
                            Text(currentSong.artist ?? "Unknown Artist")
                                .artistFont()
                        }
                    }
                    .matchedGeometryEffect(id: "Description", in: playerAnimation)
                    
                    Spacer()
                    
                    CustomButton(image: viewModel.isPlaying ? "pause.fill" : "play.fill", size: .title) {
                        viewModel.playPause()
                    }
                }
            }
            .padding()
            .background(showFullPlayer ? .clear : .black.opacity(0.3))
            .cornerRadius(10)
            .padding()
            
            // Full Player
            if showFullPlayer {
                HStack(spacing: 60) {
                    
                    Button {
                        if viewModel.isShuffle {
                            viewModel.toggleRepeat()  // Переключаем на режим повторения
                        } else {
                            viewModel.toggleShuffle()  // Переключаем на режим перемешивания
                        }
                    } label: {
                        Image(systemName: viewModel.isShuffle ? "shuffle" : "repeat")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                    
                    VStack {
                        if let currentSong = viewModel.currentSong {
                            Text(currentSong.name)
                                .songNameFont()
                            Text(currentSong.artist ?? "Unknown Artist")
                                .artistFont()
                        }
                    }
                    .matchedGeometryEffect(id: "Description", in: playerAnimation)
                    .padding(.top)
                    
                    // MARK: - Bluetooth Output Picker
                    AudioOutputPicker()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.white) // Цвет кнопки
                }
                
                VStack {
                    // Duration
                    HStack {
                        Text("\(viewModel.durationFormatted(viewModel.currentTime))")
                        Spacer()
                        Text("\(viewModel.durationFormatted(viewModel.totalTime))")
                    }
                    .durationFont()
                    .padding()
                    
                    // Slider
                    Slider(value: $viewModel.currentTime, in: 0...viewModel.totalTime) { editing in
                        
                        if !editing {
                            viewModel.seekAudio(time: viewModel.currentTime)
                        }
                    }
                    .offset(y: -16)
                    .accentColor(.white)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            viewModel.updateProgress()
                        }
                    }
                    
                    HStack(spacing: 50) {
                        
                        CustomButton(image: "15.arrow.trianglehead.counterclockwise", size: .title2) {
                            viewModel.rewindAudio()
                        }
                        
                        CustomButton(image: "backward.end.fill", size: .title2) {
                            viewModel.backward()
                        }
                        
                        CustomButton(image: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill", size: .largeTitle) {
                            viewModel.playPause()
                        }
                        
                        CustomButton(image: "forward.end.fill", size: .title2) {
                            viewModel.forward()
                        }
                        
                        CustomButton(image: "15.arrow.trianglehead.clockwise", size: .title2) {
                            viewModel.fastForwardAudio()
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

#Preview {
    PlayerView()
}
