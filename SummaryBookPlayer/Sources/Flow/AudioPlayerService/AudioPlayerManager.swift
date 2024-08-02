//
//  AudioPlayerManager.swift
//  SummaryBookPlayer
//
//  Created by Daria on 01.08.2024.
//

import Combine
import AVFoundation

enum AudioPlayerError: Error {
    
    case fileNotFound
    case audioInitializationFailed
    case playbackFailed
    case unknown(Error)
    
}

final class AudioPlayerManager: NSObject, AudioPlayerService {
    
    var duration: TimeInterval {
        audioPlayer?.duration ?? 0
    }
    
    var currentTime: TimeInterval {
        audioPlayer?.currentTime ?? 0
    }
    
    let errorPublisher = PassthroughSubject<AudioPlayerError, Never>()
    let isAudioFinished = PassthroughSubject<Bool, Never>()
    private var audioPlayer: AVAudioPlayer?
    
    override init() {
    }
    
    func playAudio() {
        do {
            guard let player = audioPlayer, player.prepareToPlay() else {
                errorPublisher.send(AudioPlayerError.playbackFailed)

                throw AudioPlayerError.playbackFailed
            }
            
            player.play()
        } catch {
            Logger.error("playbackFailed")
            errorPublisher.send(AudioPlayerError.playbackFailed)
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
    }
    
    func fastForward() {
        guard let player = audioPlayer else { return }

        let currentTime = player.currentTime
        let newTime = max(currentTime + 10, 0)
        
        if newTime < player.duration {
            player.currentTime = newTime
        }
    }
    
    func rewind() {
        guard let player = audioPlayer else { return }
        
        let currentTime = player.currentTime
        let newTime = max(currentTime - 5, 0)
        
        player.currentTime = newTime > 0 ? newTime : TimeInterval(0)
    }
    
    func setPlayRate(_ rate: Float) {
        guard let player = audioPlayer else { return }
        
        player.enableRate = true
        player.rate = rate
    }
    
    func moveAudio(from percent: Double) {
        guard let player = audioPlayer else { return }
        
        let duration = player.duration
        let seconds = duration * percent
        player.currentTime = seconds
    }
    
    func playAudio(from percent: Double) {
        do {
            guard let player = audioPlayer, player.prepareToPlay() else {
                errorPublisher.send(AudioPlayerError.playbackFailed)
                
                throw AudioPlayerError.playbackFailed
            }
            
            let duration = player.duration
            let seconds = duration * percent
            player.currentTime = seconds
            
            player.play()
        } catch {
            Logger.error("playbackFailed")
            errorPublisher.send(AudioPlayerError.playbackFailed)
        }
    }
    
    func setupAudioPlayer(audioName: String, rate: Float = 1.0) {
        do {
            guard let audioPath = Bundle.main.path(forResource: audioName, ofType: "mp3") else {
                errorPublisher.send(AudioPlayerError.playbackFailed)
                
                throw AudioPlayerError.fileNotFound
            }
                        
            let audioUrl = URL(fileURLWithPath: audioPath)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
                audioPlayer?.enableRate = true
                audioPlayer?.rate = rate
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
            } catch {
                throw AudioPlayerError.audioInitializationFailed
            }
        } catch AudioPlayerError.fileNotFound {
            errorPublisher.send(AudioPlayerError.fileNotFound)
            Logger.error("Error: Audio file not found at path: \(audioName).mp3")
        } catch AudioPlayerError.audioInitializationFailed {
            errorPublisher.send(AudioPlayerError.audioInitializationFailed)
            Logger.error("Error: Failed to initialize AVAudioPlayer.")
        } catch {
            errorPublisher.send(.unknown(error))
            Logger.error("Unknown error: \(error.localizedDescription)")
        }
    }
    
}

extension AudioPlayerManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isAudioFinished.send(flag)
    }
    
}
