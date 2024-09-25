//
//  ServerTodo.swift
//  viper-app
//
//  Created by viltsevdanila on 25.09.2024.
//

import Foundation

struct ServerTodos: Codable {
    let todos: [ServerTodo]?
}

struct ServerTodo: Codable {
    let id: Int?
    let todo: String?
    let completed: Bool?
    let userId: Int?
}
