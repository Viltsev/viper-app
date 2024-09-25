//
//  LocalTodo.swift
//  viper-app
//
//  Created by viltsevdanila on 25.09.2024.
//

import Foundation

struct LocalTodos: Equatable {
    let todos: [LocalTodo]?
}

struct LocalTodo: Identifiable, Equatable, Hashable {
    let id: Int
    var todo: String
    var subTodo: String
    var completed: Bool
    let userId: Int?
}

extension LocalTodo {
    static var mock: Self = .init(id: 0,
                                  todo: "title",
                                  subTodo: "subtitle",
                                  completed: false,
                                  userId: 0)
}
