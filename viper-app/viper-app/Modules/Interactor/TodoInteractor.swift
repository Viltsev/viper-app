//
//  TodoInteractor.swift
//  viper-app
//
//  Created by viltsevdanila on 20.09.2024.
//

import Foundation
import Combine

class TodoInteractor: ObservableObject {
    let input: Input = Input()

    @Published var selection: Selection = .all
    @Published var todoList: [ToDoModel] =  [
        .init(id: 1, todo: "title 1", subtitle: "subtitle 1", complited: false),
        .init(id: 2, todo: "title 2", subtitle: "subtitle 2", complited: false),
        .init(id: 3, todo: "title 3", subtitle: "subtitle 3", complited: false)
    ]
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

extension TodoInteractor {
    func bind() {
        closeTask()
        openTask()
        editTask()
        deleteTask()
        createTask()
    }
    
    func closeTask() {
        input.closeTaskSubject
            .sink { [weak self] task in
                guard let self = self else { return }
                
                if let index = self.todoList.firstIndex(where: { $0.id == task.id }) {
                    self.todoList[index].complited = true
                }
            }
            .store(in: &cancellable)
    }
    
    func openTask() {
        input.openTaskSubject
            .sink { [weak self] task in
                guard let self = self else { return }
                
                if let index = self.todoList.firstIndex(where: { $0.id == task.id }) {
                    self.todoList[index].complited = false
                }
            }
            .store(in: &cancellable)
    }
    
    func editTask() {
        input.editTaskSubject
            .sink { [weak self] editedTask in
                guard let self = self else { return }
                
                if let index = self.todoList.firstIndex(where: { $0.id == editedTask.id }) {
                    self.todoList[index] = editedTask
                }
            }
            .store(in: &cancellable)
    }
    
    func deleteTask() {
        input.deleteTaskSubject
            .sink { [weak self] deletedTask in
                guard let self = self else { return }
                
                if let index = self.todoList.firstIndex(where: { $0.id == deletedTask.id }) {
                    self.todoList.remove(at: index)
                }
            }
            .store(in: &cancellable)
    }
    
    func createTask() {
        input.createTaskSubject
            .sink { [weak self] title, subtitle in
                guard let self = self else { return }
                
                let newId = generateId(self.todoList)
                let newTask = ToDoModel(id: newId,
                                        todo: title,
                                        subtitle: subtitle,
                                        complited: false)
                self.todoList.append(newTask)
            }
            .store(in: &cancellable)
    }
    
    func generateId(_ todos: [ToDoModel]) -> Int {
        return (todos.max(by: { $0.id < $1.id })?.id ?? 0) + 1
    }
}

extension TodoInteractor {
    struct Input {
        let closeTaskSubject = PassthroughSubject<ToDoModel, Never>()
        let openTaskSubject = PassthroughSubject<ToDoModel, Never>()
        let editTaskSubject = PassthroughSubject<ToDoModel, Never>()
        let deleteTaskSubject = PassthroughSubject<ToDoModel, Never>()
        let createTaskSubject = PassthroughSubject<(String, String), Never>()
    }
}
