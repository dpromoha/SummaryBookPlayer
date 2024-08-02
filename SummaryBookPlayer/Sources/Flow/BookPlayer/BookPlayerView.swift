//
//  BookPlayerView.swift
//  SummaryBookPlayer
//
//  Created by Daria on 01.08.2024.
//

import SwiftUI
import AVFoundation

struct BookPlayerView: View {
    
    @ObservedObject var viewModel: BookPlayerViewModel
    
    var body: some View {
        ZStack {
            Color("background_color")
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                BookDetailsView(viewModel: viewModel)
                SoundtrackView(viewModel: viewModel)
                MediaControlsView(viewModel: viewModel)
                Spacer()
                ToggleButtonView()
            }
            .alert(isPresented: $viewModel.isShowErrorAlert) {
                Alert(
                    title: Text("Oh, something went wrong."),
                    primaryButton: .default(Text("OK")),
                    secondaryButton: .cancel()
                )
            }
        }
        .zIndex(-1.0)
    }
    
}
