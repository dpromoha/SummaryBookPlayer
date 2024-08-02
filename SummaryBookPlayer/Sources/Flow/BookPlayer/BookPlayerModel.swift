//
//  BookPlayerModel.swift
//  SummaryBookPlayer
//
//  Created by Daria on 02.08.2024.
//

import Foundation
import Combine

final class BookPlayerModel {
        
    private(set) var state = CurrentValueSubject<AudioPlayerState, Never>(
        .pause(
            .init(
                book: Book(
                    title: "Design is not how a thing looks, but how it works",
                    audioName: "TTPD"
                ),
                indexOfBook: 0,
                isPreviousAudioButtonDisabled: true,
                isNextAudioButtonDisabled: false,
                isPlay: false
            )
        )
    )
    
    private(set) var currentTime = PassthroughSubject<TimeInterval, Never>()
    private(set) var duration = PassthroughSubject<TimeInterval, Never>()
    private(set) var rate = PassthroughSubject<Float, Never>()
    private(set) var chapterPercent = PassthroughSubject<Double, Never>()
    private(set) var errorSubject = PassthroughSubject<AudioPlayerError, Never>()
    private(set) var books: [Book]
    private(set) var isPlay: Bool = false
    
    private var currentBook = Book(
        title: "Design is not how a thing looks, but how it works",
        audioName: "TTPD"
    )
    
    private var playRate: Float = 1.0
    private var timerTask: Task<Void, Never>?
    private var subscriptions = Set<AnyCancellable>()
    
    private let bookPlayerService: AudioPlayerService
        
    init(
        books: [Book] = BookLibrary.books, // for testing issues
        bookPlayerService: AudioPlayerService
    ) {
        self.books = books
        self.bookPlayerService = bookPlayerService
        
        initBindings()
    }
    
    func setupAudio(audioName: String, rate: Float) -> TimeInterval {
        bookPlayerService.setupAudioPlayer(audioName: audioName, rate: rate)
        
        return bookPlayerService.duration
    }
    
    func rewindBook() {
        if let currentIndex = books.indexOf(book: currentBook) {
            bookPlayerService.rewind()

            duration.send(bookPlayerService.duration)

            state.send(.rewind(.init(
                book: currentBook,
                indexOfBook: currentIndex,
                isPreviousAudioButtonDisabled: currentIndex == 0,
                isNextAudioButtonDisabled: currentIndex == books.count - 1,
                isPlay: isPlay
            )))
        }
        
        if isPlay {
            playBook()
        } else {
            currentTime.send(bookPlayerService.currentTime)
            chapterPercent.send(bookPlayerService.currentTime / bookPlayerService.duration)
        }
    }
    
    func configureBookState() {
        isPlay.toggle()
        
        if isPlay {
            if let currentIndex = books.indexOf(book: currentBook) {
                state.send(.play(.init(
                    book: currentBook,
                    indexOfBook: currentIndex,
                    isPreviousAudioButtonDisabled: currentIndex == 0,
                    isNextAudioButtonDisabled: currentIndex == books.count - 1,
                    isPlay: true
                )))
                
                playBook()
            }
        } else {
            if let currentIndex = books.indexOf(book: currentBook) {
                state.send(.pause(.init(
                    book: currentBook,
                    indexOfBook: currentIndex,
                    isPreviousAudioButtonDisabled: currentIndex == 0,
                    isNextAudioButtonDisabled: currentIndex == books.count - 1,
                    isPlay: false
                )))
            }
            
            pauseBook()
        }
        duration.send(bookPlayerService.duration)
    }
    
    func turnOnNextAudio() {
        guard let currentIndex = books.indexOf(book: currentBook) else { return }
        
        if currentIndex < books.count - 1 {
            if let nextBook = books.nextBook(after: currentBook) {
                currentBook = nextBook
                
                bookPlayerService.setupAudioPlayer(audioName: currentBook.audioName, rate: playRate)
                
                if let currentIndex = books.indexOf(book: currentBook) {
                    duration.send(bookPlayerService.duration)
                    
                    state.send(.next(.init(
                        book: currentBook,
                        indexOfBook: currentIndex,
                        isPreviousAudioButtonDisabled: currentIndex == 0,
                        isNextAudioButtonDisabled: currentIndex == books.count - 1,
                        isPlay: isPlay
                    )))
                }
            }
            
            if isPlay {
                playBook()
            } else {
                currentTime.send(bookPlayerService.currentTime)
                chapterPercent.send(bookPlayerService.currentTime / bookPlayerService.duration)
            }
        } else {
            state.send(.pause(.init(
                book: currentBook,
                indexOfBook: currentIndex,
                isPreviousAudioButtonDisabled: currentIndex == 0,
                isNextAudioButtonDisabled: currentIndex == books.count - 1,
                isPlay: false
            )))
        }
    }
    
    func fastForwardBook() {
        let timeToFastForward: TimeInterval = 10
        let currentTimeValue = bookPlayerService.currentTime
        let duration = bookPlayerService.duration
        
        if currentTimeValue + timeToFastForward >= duration {
            if let currentIndex = books.indexOf(book: currentBook) {
                let nextIndex = currentIndex + 1
                
                if nextIndex < books.count {
                    currentBook = books[nextIndex]
                    bookPlayerService.setupAudioPlayer(audioName: currentBook.audioName, rate: playRate)
                    
                    state.send(.next(.init(
                        book: currentBook,
                        indexOfBook: nextIndex,
                        isPreviousAudioButtonDisabled: nextIndex == 0,
                        isNextAudioButtonDisabled: nextIndex == books.count - 1,
                        isPlay: isPlay
                    )))
                }
            }
        } else {
            if let currentIndex = books.indexOf(book: currentBook) {
                bookPlayerService.fastForward()

                state.send(.fastForward(.init(
                    book: currentBook,
                    indexOfBook: currentIndex,
                    isPreviousAudioButtonDisabled: currentIndex == 0,
                    isNextAudioButtonDisabled: currentIndex == books.count - 1,
                    isPlay: isPlay
                )))
            }
        }
        
        if isPlay {
            playBook()
        } else {
            currentTime.send(bookPlayerService.currentTime)
            chapterPercent.send(bookPlayerService.currentTime / bookPlayerService.duration)
        }
    }
    
    func turnOnPreviousAudio() {
        if let previousBook = books.previousBook(after: currentBook) {
            currentBook = previousBook
            
            bookPlayerService.setupAudioPlayer(audioName: currentBook.audioName, rate: playRate)
            
            if let currentIndex = books.indexOf(book: currentBook) {
                duration.send(bookPlayerService.duration)

                state.send(.previous(.init(
                    book: currentBook,
                    indexOfBook: currentIndex,
                    isPreviousAudioButtonDisabled: currentIndex == 0,
                    isNextAudioButtonDisabled: currentIndex == books.count - 1,
                    isPlay: isPlay
                )))
            }
        }
                
        if isPlay {
            playBook()
        } else {
            currentTime.send(bookPlayerService.currentTime)
            chapterPercent.send(bookPlayerService.currentTime / bookPlayerService.duration)
        }
    }
    
    func slideAudio(at percent: Double, isPlay: Bool) {
        DispatchQueue.main.async {
            if isPlay {
                self.startUpdatingCurrentTime()
                self.bookPlayerService.playAudio(from: percent)
            } else {
                self.stopUpdatingCurrentTime()
                self.bookPlayerService.moveAudio(from: percent)
            }
            
            self.currentTime.send(self.bookPlayerService.currentTime)
        }
    }
    
    func speedButtonWasTapped() {
        let playRates: [Float] = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0]
        if let currentIndex = playRates.firstIndex(of: playRate) {
            let nextIndex = (currentIndex + 1) % playRates.count
            playRate = playRates[nextIndex]
            
            rate.send(playRate)
            bookPlayerService.setPlayRate(playRate)
        }
    }
    
    private func initBindings() {
        bookPlayerService.errorPublisher
            .sink { [weak self] error in
                guard let self = self else { return }
                
                self.errorSubject.send(error)
                
                switch error {
                case .fileNotFound:
                    self.bookPlayerService.setupAudioPlayer(audioName: self.currentBook.audioName, rate: 1.0)
                    self.stopUpdatingCurrentTime()
                    
                case .unknown, .playbackFailed, .audioInitializationFailed:
                    self.stopUpdatingCurrentTime()
                }
            }.store(in: &subscriptions)
        
        bookPlayerService.isAudioFinished
            .sink { [weak self] isAudioFinished in
                if isAudioFinished {
                    self?.turnOnNextAudio()
                }
            }.store(in: &subscriptions)
    }
    
}

// MARK: - Timer work handling

private extension BookPlayerModel {
    
    func playBook() {
        bookPlayerService.playAudio()
        startUpdatingCurrentTime()
    }
    
    func pauseBook() {
        bookPlayerService.pauseAudio()
        stopUpdatingCurrentTime()
    }

    func startUpdatingCurrentTime() {
        stopUpdatingCurrentTime()
        
        timerTask = Task {
            await updateCurrentTimePeriodically()
        }
    }

    func stopUpdatingCurrentTime() {
        timerTask?.cancel()
        timerTask = nil
    }

    func updateCurrentTimePeriodically() async {
        let interval: TimeInterval = 0.5
        
        while !Task.isCancelled {
            await updateCurrentTime()
            
            try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
        }
    }

    func updateCurrentTime() async {
        DispatchQueue.main.async {
            self.currentTime.send(self.bookPlayerService.currentTime)
            self.chapterPercent.send(self.bookPlayerService.currentTime / self.bookPlayerService.duration)
        }
    }
    
}
