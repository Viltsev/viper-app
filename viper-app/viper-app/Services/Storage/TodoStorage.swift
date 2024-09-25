//
//  TodoStorage.swift
//  viper-app
//
//  Created by viltsevdanila on 25.09.2024.
//

import Foundation

enum TodoStorageKey: String {
    case appStatus
}

struct TodoStorage {
    private let userDefaults = UserDefaults.standard
    static var shared = TodoStorage()
    
    private init() {}
    
    var appStatus: Bool {
        get {
            userDefaults.bool(forKey: TodoStorageKey.appStatus.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: TodoStorageKey.appStatus.rawValue)
        }
    }
}
