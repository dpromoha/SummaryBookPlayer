//
//  MediaControlsView.swift
//  SummaryBookPlayer
//
//  Created by Daria on 01.08.2024.
//

import SwiftUI

struct MediaControlsView: View {
      
    @ObservedObject var viewModel: BookPlayerViewModel
    
    var body: some View {
        HStack(spacing: 24.0) {
            Button {
                viewModel.previousButtonTapped()
            } label: {
                Image(systemName: "backward.end.fill")
                    .font(.system(size: 30.0, weight: .light))
                    .foregroundColor(viewModel.isPreviousButtonDisabled ? .gray : .black)
            }
            .disabled(viewModel.isPreviousButtonDisabled)
            
            Button {
                viewModel.rewindButtonWasTapped()
            } label: {
                Image(systemName: "gobackward.5")
                    .font(.system(size: 30.0))
            }
            
            Button {
                viewModel.playButtonWasTapped()
            } label: {
                Image(systemName: viewModel.isPlay ? "pause.fill" : "play.fill")
                    .font(.system(size: 46.0))
                    .frame(width: 50.0, height: 50.0)
            }
            
            Button {
                viewModel.fastForwardButtonWasTapped()
            } label: {
                Image(systemName: "goforward.10")
                    .font(.system(size: 30.0))
            }
            
            Button {
                viewModel.nextButtonTapped()
            } label: {
                Image(systemName: "forward.end.fill")
                    .font(.system(size: 28.0, weight: .light))
                    .foregroundColor(viewModel.isNextAudioButtonDisabled ? .gray : .black)
            }
            .disabled(viewModel.isNextAudioButtonDisabled)
        }
        .padding(.horizontal, 60.0)
        .padding(.vertical, 24.0)
        .foregroundColor(Color("black_font_color"))
    }
    
}
