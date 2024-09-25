//
//  AppContainer.swift
//  viper-app
//
//  Created by viltsevdanila on 21.09.2024.
//

import SwiftUI

struct AppContainer: View {
    @StateObject var router: AppRouter = AppRouter()
    @StateObject var interactor: TodoInteractor = TodoInteractor(persistenceController: PersistenceController.shared)
    
    var body: some View {
        TodoListView(presenter: .init(interactor: interactor, router: router))
    }
}
