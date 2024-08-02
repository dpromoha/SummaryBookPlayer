//
//  Logger.swift
//  SummaryBookPlayer
//
//  Created by Daria on 02.08.2024.
//

import Foundation

public enum Logger {
    
    public static func error(_ string: @autoclosure () -> String, file: String = #file, line: Int = #line) {
        log(string, file: file, line: line)
    }
    
    private static func log(_ string: () -> String, file: String = #file, line: Int = #line) {
        #if DEBUG
        let startIndex = file.range(of: "/", options: .backwards)?.upperBound
        let fileName = file[startIndex!...]
        print("[\(NSDate())] \(fileName)(\(line)) | \(string())")
        #endif
    }
    
}
