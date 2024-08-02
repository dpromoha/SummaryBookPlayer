//
//  AudioPlayerState.swift
//  SummaryBookPlayer
//
//  Created by Daria on 02.08.2024.
//

import Foundation

enum AudioPlayerState {
    
    case play(AudioState)
    case pause(AudioState)
    case slideToPlace(AudioState)
    case rewind(AudioState)
    case fastForward(AudioState)
    case next(AudioState)
    case previous(AudioState)
    
}

public struct AudioState {
    
    let book: Book
    let indexOfBook: Int
    let isPreviousAudioButtonDisabled: Bool
    let isNextAudioButtonDisabled: Bool
    let isPlay: Bool
    
}
