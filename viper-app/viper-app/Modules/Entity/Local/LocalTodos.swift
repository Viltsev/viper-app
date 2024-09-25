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
    let date: Date
    let startTime: String
    let endTime: String
    
    var startTimeComponents: DateComponents? {
        return timeComponents(from: startTime)
    }
    
    var endTimeComponents: DateComponents? {
        return timeComponents(from: endTime)
    }
}

extension LocalTodo {
    static var mock: Self = .init(id: 0,
                                  todo: "title",
                                  subTodo: "subtitle",
                                  completed: false,
                                  userId: 0,
                                  date: Date(),
                                  startTime: "09:00",
                                  endTime: "17:00")
    
    private func timeComponents(from timeString: String) -> DateComponents? {
        let components = timeString.split(separator: ":").map { String($0) }
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else { return nil }
        return DateComponents(hour: hour, minute: minute)
    }
}
