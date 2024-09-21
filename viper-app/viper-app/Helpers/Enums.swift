//
//  Enums.swift
//  viper-app
//
//  Created by viltsevdanila on 20.09.2024.
//

import Foundation

enum Selection {
    case all
    case open
    case closed
    
    var title: String {
        switch self {
        case .all:
            "All"
        case .open:
            "Open"
        case .closed:
            "Closed"
        }
    }
}

enum DetailState {
    case edit
    case add
}
