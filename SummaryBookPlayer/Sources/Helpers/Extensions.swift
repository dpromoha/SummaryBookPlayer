//
//  Extensions.swift
//  SummaryBookPlayer
//
//  Created by Daria on 02.08.2024.
//

import Foundation

extension Array where Element == Book {
    
    func indexOf(book: Book) -> Int? {
        return firstIndex(where: { $0.audioName == book.audioName })
    }
    
    func previousBook(after book: Book) -> Book? {
        guard let currentIndex = indexOf(book: book), currentIndex > 0 else {
            return nil
        }
        
        return self[(currentIndex - 1 + count) % count]
    }
    
    func nextBook(after book: Book) -> Book? {
        guard let currentIndex = indexOf(book: book) else {
            return nil
        }
        
        return self[(currentIndex + 1) % count]
    }
    
}
