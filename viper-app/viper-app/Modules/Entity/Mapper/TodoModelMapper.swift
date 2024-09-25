//
//  TodoModelMapper.swift
//  viper-app
//
//  Created by viltsevdanila on 25.09.2024.
//

import Foundation

final class TodoModelMapper: BaseModelMapper<ServerTodos, LocalTodos> {
    override func toLocal(serverEntity: ServerTodos) -> LocalTodos {
        return LocalTodos(todos: TodosModelMapper().toLocal(list: serverEntity.todos))
    }
}

final class TodosModelMapper: BaseModelMapper<ServerTodo, LocalTodo> {
    override func toLocal(serverEntity: ServerTodo) -> LocalTodo {
        return LocalTodo(id: serverEntity.id ?? 0,
                          todo: serverEntity.todo ?? "",
                          subTodo: "",
                          completed: serverEntity.completed ?? false,
                          userId: serverEntity.userId)
    }
}
