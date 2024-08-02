//
//  Book.swift
//  SummaryBookPlayer
//
//  Created by Daria on 01.08.2024.
//

import Foundation

struct Book {
    
    let title: String
    let audioName: String
 
    public static func empty() -> Self {
        .init(title: "", audioName: "")
    }
    
}
