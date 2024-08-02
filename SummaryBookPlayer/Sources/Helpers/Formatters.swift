//
//  Formatters.swift
//  SummaryBookPlayer
//
//  Created by Daria on 01.08.2024.
//

import Foundation

public struct Formatters {
    
    static let audioDurationTimeFormatter: (TimeInterval) -> String = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        
        return { timeInterval in
            formatter.string(from: timeInterval) ?? "00:00"
        }
    }()
    
    static let floatFormatter: (Float) -> String = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.decimalSeparator = "."

        return { floatValue in
            formatter.string(from: NSNumber(value: floatValue)) ?? "\(floatValue)"
        }
    }()
    
}
