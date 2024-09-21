//
//  AppRouter.swift
//  viper-app
//
//  Created by viltsevdanila on 19.09.2024.
//

import Foundation
import SwiftUI

final class AppRouter: ObservableObject {
    @Published var path = NavigationPath() {
        didSet {
            print(path.count)
        }
    }
    
    func pushView<T: Hashable>(_ destination: T) {
        self.path.append(destination)
    }
    
    func popToRoot() {
        self.path = NavigationPath()
    }
    
    func popView() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
