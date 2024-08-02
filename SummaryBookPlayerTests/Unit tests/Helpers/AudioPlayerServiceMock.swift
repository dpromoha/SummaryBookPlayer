//
//  AudioPlayerServiceMock.swift
//  SummaryBookPlayerTests
//
//  Created by Daria on 02.08.2024.
//

import XCTest
import Combine
@testable import SummaryBookPlayer

final class AudioPlayerServiceMock: AudioPlayerService {
    
    var duration: TimeInterval
    var currentTime: TimeInterval
    var errorPublisher = PassthroughSubject<SummaryBookPlayer.AudioPlayerError, Never>()
    var isAudioFinished = PassthroughSubject<Bool, Never>()
    
    let playWithMoveExpectation = XCTestExpectation()
    let moveExpectation = XCTestExpectation()
    
    private(set) var isRateChangesCalled = false
    private(set) var isPlayAudioCalled = false
    private(set) var isPauseAudioCalled = false
    private(set) var isAudioSetup = false
    private(set) var isFastForwardCalled = false
    private(set) var isRewindCalled = false
    private(set) var isAudioMoved = false
    private(set) var isAudioPlayedWithMove = false
        
    init(currentTime: TimeInterval = 0, duration: TimeInterval = 0) {
        self.currentTime = currentTime
        self.duration = duration
        
        isAudioFinished.send(true)
    }
    
    func playAudio() {
        isPlayAudioCalled = true
    }
    
    func pauseAudio() {
        isPauseAudioCalled = true
    }
    
    func fastForward() {
        isFastForwardCalled = true
    }
    
    func rewind() {
        isRewindCalled = true
    }
    
    func moveAudio(from percent: Double) {
        moveExpectation.fulfill()
        isAudioMoved = true
    }
    
    func setupAudioPlayer(audioName: String, rate: Float) {
        isAudioSetup = true
    }
    
    func setPlayRate(_ rate: Float) {
        isRateChangesCalled = true
    }
    
    func playAudio(from percent: Double) {
        playWithMoveExpectation.fulfill()
        isAudioPlayedWithMove = true
    }
    
}
