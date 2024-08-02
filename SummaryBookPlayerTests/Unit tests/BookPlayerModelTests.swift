//
//  BookPlayerModelTests.swift
//  SummaryBookPlayerTests
//
//  Created by Daria on 02.08.2024.
//

import XCTest
import Combine
@testable import SummaryBookPlayer

final class BookPlayerModelTests: XCTestCase {
    
    func test_audioShouldBeSetup() {
        let testDuration = 122.0
        let serviceMock = AudioPlayerServiceMock(duration: testDuration)
        let sut = BookPlayerModel(
            books: BookLibrary.books,
            bookPlayerService: serviceMock
        )
        
        XCTAssertFalse(serviceMock.isAudioSetup, "Audio shouldn't be setup")
        
        let duration = sut.setupAudio(audioName: "DBM", rate: 1.0)
        
        XCTAssertEqual(duration, testDuration, "Duration values should be equal")
        XCTAssertTrue(serviceMock.isAudioSetup, "Audio should be setup")
    }
    
    func test_bookStateShouldBeConfigured() {
        var isPlayState = false
        let serviceMock = AudioPlayerServiceMock()
        let sut = BookPlayerModel(
            books: BookLibrary.books,
            bookPlayerService: serviceMock
        )
        
        let expectation = XCTestExpectation()
        
        let cancellable = sut.state.sink { state in
            switch state {
            case .play:
                isPlayState = true
                expectation.fulfill()
                
            case .pause, .slideToPlace, .rewind, .fastForward, .next, .previous:
                break
            }
        }
        
        sut.configureBookState()
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
        
        XCTAssertTrue(isPlayState, "Book state should be configured as play state")
        XCTAssertTrue(serviceMock.isPlayAudioCalled, "Audio should start to play")
    }
    
    func test_bookStateShouldBeConfiguredAsPauseState() {
        var isPauseState = false
        let serviceMock = AudioPlayerServiceMock()
        let sut = BookPlayerModel(
            books: BookLibrary.books,
            bookPlayerService: serviceMock
        )
        
        let expectation = XCTestExpectation()
        
        let cancellable = sut.state.sink { state in
            switch state {
            case .pause:
                isPauseState = true
                expectation.fulfill()
                
            case .play, .slideToPlace, .rewind, .fastForward, .next, .previous:
                break
            }
        }
        
        sut.configureBookState()
        sut.configureBookState() // To avoid violating the encapsulation of sut properties, I call this method twice to obtain the pause state.
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
        
        XCTAssertTrue(isPauseState, "Book state should be configured as play state")
        XCTAssertTrue(serviceMock.isPauseAudioCalled, "Audio should stop")
    }

    func test_previousAudioShouldntTurnOn() {
        var isPreviousState = false
        let expectation = XCTestExpectation()
        let serviceMock = AudioPlayerServiceMock()
        let sut = BookPlayerModel(
            books: BookLibrary.books,
            bookPlayerService: serviceMock
        )
                
        let cancellable = sut.state.sink { state in
            switch state {
            case .previous:
                isPreviousState = true
                expectation.fulfill()
                
            case .pause, .slideToPlace, .rewind, .fastForward, .next, .play:
                isPreviousState = false
                expectation.fulfill()
            }
        }
        
        sut.turnOnPreviousAudio()
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
        
        XCTAssertFalse(isPreviousState, "There shouldn't be ability to go to the previous state")
    }
    
    func test_previousAudioShouldTurnOn() {
        var isPreviousState = false
        let books = [
            Book(
                title: "You create your own life experience",
                audioName: "DBM"
            ),
            Book(
                title: "3 steps to manifesting your ideal life",
                audioName: "CP"
            ),
            Book(
                title: "Design is not how a thing looks, but how it works",
                audioName: "TTPD" // it was the first song, now it is the last, so we have previous soungs in array
            )
        ]
        let expectation = XCTestExpectation()
        let serviceMock = AudioPlayerServiceMock()
        let sut = BookPlayerModel(
            books: books,
            bookPlayerService: serviceMock
        )
                
        let cancellable = sut.state.sink { state in
            switch state {
            case .previous:
                isPreviousState = true
                expectation.fulfill()
                
            case .pause, .slideToPlace, .rewind, .fastForward, .next, .play:
                isPreviousState = false
                expectation.fulfill()
            }
        }
        
        sut.turnOnPreviousAudio()
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
        
        XCTAssertTrue(isPreviousState, "Should be ability to go to the previous state")
    }
    
    func test_nextAudioShouldTurnOn() {
        var isNextState = false
        let expectation = XCTestExpectation()
        let serviceMock = AudioPlayerServiceMock()
        let sut = BookPlayerModel(
            books: BookLibrary.books,
            bookPlayerService: serviceMock
        )
                
        let cancellable = sut.state.sink { state in
            switch state {
            case .next:
                isNextState = true
                expectation.fulfill()
                
            case .pause, .slideToPlace, .rewind, .fastForward, .previous, .play:
                isNextState = false
                expectation.fulfill()
            }
        }
        
        sut.turnOnNextAudio()
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
        
        XCTAssertTrue(isNextState, "There should be ability to go to the next state")
    }
    
    func test_nextAudioShouldntTurnOn() {
        var isNextState = false
        let books = [
            Book(
                title: "You create your own life experience",
                audioName: "DBM"
            ),
            Book(
                title: "3 steps to manifesting your ideal life",
                audioName: "CP"
            )
        ]
        let expectation = XCTestExpectation()
        let serviceMock = AudioPlayerServiceMock()
        let sut = BookPlayerModel(
            books: books,
            bookPlayerService: serviceMock
        )
                
        let cancellable = sut.state.sink { state in
            switch state {
            case .next:
                isNextState = true
                expectation.fulfill()
                
            case .pause, .slideToPlace, .rewind, .fastForward, .previous, .play:
                isNextState = false
                expectation.fulfill()
            }
        }
        
        sut.turnOnNextAudio()
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
        
        XCTAssertFalse(isNextState, "There shouldn't be ability to go to the next state")
    }
    
    func test_bookShouldBeRewinded() {
        let serviceMock = AudioPlayerServiceMock(currentTime: 20, duration: 100)
        let sut = BookPlayerModel(
            books: BookLibrary.books,
            bookPlayerService: serviceMock
        )
        
        sut.rewindBook()
        
        XCTAssertTrue(serviceMock.isRewindCalled, "Rewind should be called")
    }
    
    func test_bookShouldBeFastForwarded() {
        let serviceMock = AudioPlayerServiceMock(currentTime: 20, duration: 100)
        let sut = BookPlayerModel(
            books: BookLibrary.books,
            bookPlayerService: serviceMock
        )
        
        sut.fastForwardBook()
        
        XCTAssertTrue(serviceMock.isFastForwardCalled, "Fast forward should be called")
    }
    
    func test_bookShouldntBeFastForwarded() {
        let serviceMock = AudioPlayerServiceMock(currentTime: 98, duration: 100)
        let sut = BookPlayerModel(
            books: BookLibrary.books,
            bookPlayerService: serviceMock
        )
        
        sut.fastForwardBook()
        
        XCTAssertFalse(serviceMock.isFastForwardCalled, "Fast forward shouldn't be called")
    }
    
    func test_slideShouldBeCalledForPlayingAudio() {
        let serviceMock = AudioPlayerServiceMock()
        let sut = BookPlayerModel(
            books: BookLibrary.books,
            bookPlayerService: serviceMock
        )
        
        sut.slideAudio(at: 1.0, isPlay: true)
        wait(for: [serviceMock.playWithMoveExpectation], timeout: 1.0)
        
        XCTAssertTrue(serviceMock.isAudioPlayedWithMove, "Audio should play with time move")
    }
    
    func test_slideShouldBeCalledForMoving() {
        let serviceMock = AudioPlayerServiceMock()
        let sut = BookPlayerModel(
            books: BookLibrary.books,
            bookPlayerService: serviceMock
        )
        
        sut.slideAudio(at: 1.0, isPlay: false)
        wait(for: [serviceMock.moveExpectation], timeout: 1.0)
        
        XCTAssertTrue(serviceMock.isAudioMoved, "Audio should move")
    }
    
    func test_speedShouldChange() {
        var rateTest: Float = 0.0
        let expectation = XCTestExpectation()
        let serviceMock = AudioPlayerServiceMock()
        let sut = BookPlayerModel(
            books: BookLibrary.books,
            bookPlayerService: serviceMock
        )
        
        let cancellable = sut.rate.sink { rate in
            expectation.fulfill()
            rateTest = rate
        }
        
        sut.speedButtonWasTapped()
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
                
        XCTAssertEqual(rateTest, 1.25, "Speed rates should be equal")
        XCTAssertTrue(serviceMock.isRateChangesCalled, "Rate changes should be called")
    }
    
}
