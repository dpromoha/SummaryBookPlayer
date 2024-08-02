//
//  SharedLinks.swift
//  SummaryBookPlayer
//
//  Created by Daria on 02.08.2024.
//

import Foundation

public struct SharedLinks {
    
    public enum Cover {
        case musicIndustryBook
        
        public var url: String {
            switch self {
            case .musicIndustryBook:
                return "https://m.media-amazon.com/images/I/71m88Y8C2nL._AC_UF894,1000_QL80_.jpg"
            }
        }
    }
    
}
