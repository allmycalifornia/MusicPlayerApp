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
                HStack {
                    Color.white
                        .frame(width: 60, height: 60)
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading) {
                        Text("Unstoppable")
                            .songNameFont()
                        Text("SIA")
                            .artistFont()
                    }
                    
                    Spacer()
                    
                    Text("03:48")
                        .artistFont()
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    PlayerView()
}
