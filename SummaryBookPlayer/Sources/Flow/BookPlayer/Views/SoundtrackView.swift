//
//  SoundtrackView.swift
//  SummaryBookPlayer
//
//  Created by Daria on 02.08.2024.
//

import SwiftUI

struct SoundtrackView: View {
    
    @ObservedObject var viewModel: BookPlayerViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.currentTime)
                .foregroundStyle(.grayFont)
                .font(.system(size: 14.0, weight: .light))
                .padding(.horizontal, 2.0)
            
            Slider(
                value: $viewModel.audioPercent,
                in: 0...1,
                onEditingChanged: { isEditing in
                    if !isEditing {
                        viewModel.slideAudio()
                    }
                }
            )
            .frame(maxWidth: 280.0)
            .onAppear {
                UISlider.appearance().setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
            }
            Text(viewModel.duration)
                .foregroundStyle(.grayFont)
                .font(.system(size: 14.0, weight: .light))
                .padding(.horizontal, 2.0)
        }
        .padding(.horizontal, 16.0)
        
        VStack {
            Button {
                viewModel.speedButtonWasTapped()
            } label: {
                Text("Speed x\(Formatters.floatFormatter(viewModel.playRate))")
                    .font(.system(size: 14.0, weight: .semibold))
                    .foregroundStyle(.blackFont)
                    .padding(.all, 10.0)
                    .background(Color("gray_element_color"))
                    .cornerRadius(8.0)
            }
        }
    }
    
}
