//
//  BookPlayerViewModel.swift
//  SummaryBookPlayer
//
//  Created by Daria on 01.08.2024.
//

import Foundation
import Combine

final class BookPlayerViewModel: ObservableObject {

    @Published var isPlay: Bool = false
    @Published var duration = "00:00"
    @Published var currentTime = "00:00"
    @Published var audioPercent = Double()
    @Published var currentBook = Book.empty()
    @Published var isPreviousButtonDisabled = false
    @Published var isNextAudioButtonDisabled = false
    @Published var numberOfChapter = String()
    @Published var numberOfChapters = String()
    @Published var playRate: Float = 1.0
    @Published var isShowErrorAlert = false
    
    private var subscriptions = Set<AnyCancellable>()
    private let model = BookPlayerModel(bookPlayerService: AudioPlayerFactory.createAudioPlayerManager())
    
    init() {
        numberOfChapters = String(model.books.count)
        
        initDefaultState()
        setupBindings()
        setupStateBindings()
    }
    
    func previousButtonTapped() {
        model.turnOnPreviousAudio()
    }
    
    func slideAudio() {
        model.slideAudio(at: audioPercent, isPlay: isPlay)
    }
    
    func rewindButtonWasTapped() {
        model.rewindBook()
    }
    
    func fastForwardButtonWasTapped() {
        model.fastForwardBook()
    }
    
    func nextButtonTapped() {
        model.turnOnNextAudio()
    }
    
    func speedButtonWasTapped() {
        model.speedButtonWasTapped()
    }
    
    func playButtonWasTapped() {
        model.configureBookState()
    }
    
    private func initDefaultState() {
        switch model.state.value {
        case .pause(let pauseAudioState):
            currentBook = model.books[pauseAudioState.indexOfBook]
            duration = Formatters.audioDurationTimeFormatter(model.setupAudio(audioName: model.books[pauseAudioState.indexOfBook].audioName, rate: playRate))
            numberOfChapters = String(model.books.count)
            isPlay = false
            
        case .play, .slideToPlace, .rewind, .fastForward, .next, .previous:
            break
        }
    }

    private func setupBindings() {
        model.currentTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] time in
            guard let self = self else { return }
            
            self.currentTime = Formatters.audioDurationTimeFormatter(time)
        }.store(in: &subscriptions)
        
        model.duration
            .removeDuplicates()
            .sink { [weak self] duration in
                self?.duration = Formatters.audioDurationTimeFormatter(duration)
            }.store(in: &subscriptions)
        
        model.rate
            .sink { [weak self] rate in
                self?.playRate = rate
            }.store(in: &subscriptions)
        
        model.chapterPercent
            .sink { [weak self] percent in
                self?.audioPercent = percent
            }.store(in: &subscriptions)
        
        model.errorSubject
            .sink { [weak self] _ in
                self?.isShowErrorAlert = true
            }.store(in: &subscriptions)
    }
    
    private func setupStateBindings() {
        model.state
            .sink { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .play(let playAudioState):
                currentBook = playAudioState.book
                numberOfChapter = String(playAudioState.indexOfBook + 1)
                isPreviousButtonDisabled = playAudioState.isPreviousAudioButtonDisabled
                isNextAudioButtonDisabled = playAudioState.isNextAudioButtonDisabled
                isPlay = playAudioState.isPlay
                
            case .pause(let pauseAudioState):
                currentBook = pauseAudioState.book
                numberOfChapter = String(pauseAudioState.indexOfBook + 1)
                isPreviousButtonDisabled = pauseAudioState.isPreviousAudioButtonDisabled
                isNextAudioButtonDisabled = pauseAudioState.isNextAudioButtonDisabled
                isPlay = pauseAudioState.isPlay

            case .slideToPlace(let sliderState):
                currentBook = sliderState.book
                numberOfChapter = String(sliderState.indexOfBook + 1)
                isPreviousButtonDisabled = sliderState.isPreviousAudioButtonDisabled
                isNextAudioButtonDisabled = sliderState.isNextAudioButtonDisabled
                isPlay = sliderState.isPlay
                
            case .rewind(let rewindAudioState):
                currentBook = rewindAudioState.book
                numberOfChapter = String(rewindAudioState.indexOfBook + 1)
                isPreviousButtonDisabled = rewindAudioState.isPreviousAudioButtonDisabled
                isNextAudioButtonDisabled = rewindAudioState.isNextAudioButtonDisabled
                isPlay = rewindAudioState.isPlay

            case .fastForward(let fastForwardAudioState):
                currentBook = fastForwardAudioState.book
                numberOfChapter = String(fastForwardAudioState.indexOfBook + 1)
                isPreviousButtonDisabled = fastForwardAudioState.isPreviousAudioButtonDisabled
                isNextAudioButtonDisabled = fastForwardAudioState.isNextAudioButtonDisabled
                isPlay = fastForwardAudioState.isPlay

            case .next(let nextAudioState):
                currentBook = nextAudioState.book
                numberOfChapter = String(nextAudioState.indexOfBook + 1)
                isPreviousButtonDisabled = nextAudioState.isPreviousAudioButtonDisabled
                isNextAudioButtonDisabled = nextAudioState.isNextAudioButtonDisabled
                isPlay = nextAudioState.isPlay

            case .previous(let previousAudioState):
                currentBook = previousAudioState.book
                numberOfChapter = String(previousAudioState.indexOfBook + 1)
                isPreviousButtonDisabled = previousAudioState.isPreviousAudioButtonDisabled
                isNextAudioButtonDisabled = previousAudioState.isNextAudioButtonDisabled
                isPlay = previousAudioState.isPlay
            }
        }.store(in: &subscriptions)
    }
    
}
