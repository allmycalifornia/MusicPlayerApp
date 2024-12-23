//
//  BackgroundView.swift
//  Music Player App
//
//  Created by Борис Кравченко on 23.12.2024.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [.topBackground, .bottomBackground],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
