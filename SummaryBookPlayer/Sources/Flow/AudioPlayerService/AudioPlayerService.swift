//
//  AudioPlayerService.swift
//  SummaryBookPlayer
//
//  Created by Daria on 02.08.2024.
//

import Foundation
import Combine

protocol AudioPlayerService {
    
    var duration: TimeInterval { get }
    var currentTime: TimeInterval { get }
    var errorPublisher: PassthroughSubject<AudioPlayerError, Never> { get }
    var isAudioFinished: PassthroughSubject<Bool, Never> { get }
    
    func playAudio()
    func pauseAudio()
    func fastForward()
    func rewind()
    func moveAudio(from percent: Double)
    func setupAudioPlayer(audioName: String, rate: Float)
    func setPlayRate(_ rate: Float)
    func playAudio(from percent: Double)

}
