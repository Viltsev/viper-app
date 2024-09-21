//
//  ToDo.swift
//  viper-app
//
//  Created by viltsevdanila on 20.09.2024.
//

import Foundation

struct ToDoModel: Equatable, Identifiable, Hashable {
    let id: Int
    let todo: String
    let subtitle: String
    var complited: Bool
    let userId: Int = 1
}

extension ToDoModel {
    static var mock: Self = .init(id: 1,
                                  todo: "title",
                                  subtitle: "subtitle",
                                  complited: false)
}
