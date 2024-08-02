//
//  AudioPlayerFactory.swift
//  SummaryBookPlayer
//
//  Created by Daria on 01.08.2024.
//

import Foundation

// Using the Factory pattern because the app is simple and has only one screen.
// For a real app with multiple screens and dependencies, I would use Assembly + Swinject for better dependency management and scalability.

struct AudioPlayerFactory {
    
    static func createAudioPlayerManager() -> AudioPlayerService {
        AudioPlayerManager()
    }
    
}
