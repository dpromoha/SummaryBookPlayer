//
//  SummaryBookPlayerApp.swift
//  SummaryBookPlayer
//
//  Created by Daria on 01.08.2024.
//

import SwiftUI

@main
struct SummaryBookPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            BookPlayerView(
                viewModel: BookPlayerViewModel()
            )
        }
    }
}
