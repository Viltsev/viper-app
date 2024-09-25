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
    @Published var todoList: [LocalTodo] = []
    
    private var apiClient: GeneralAPI = GeneralAPI()
    
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
        getTasks()
    }
    
    func getTasks() {
        input.getTasksSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] in
                guard let self = self else { return }
                apiClient.getTodoList { result in
                    switch result {
                    case .success(let success):
                        self.todoList = success.todos ?? []
                        TodoStorage.shared.appStatus = true
                    case .failure(let failure):
                        print("Failure: \(failure)")
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    func closeTask() {
        input.closeTaskSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] task in
                guard let self = self else { return }
                
                if let index = self.todoList.firstIndex(where: { $0.id == task.id }) {
                    DispatchQueue.main.async {
                        self.todoList[index].completed = true
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    func openTask() {
        input.openTaskSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] task in
                guard let self = self else { return }
                
                if let index = self.todoList.firstIndex(where: { $0.id == task.id }) {
                    DispatchQueue.main.async {
                        self.todoList[index].completed = false
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    func editTask() {
        input.editTaskSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] editedTask in
                guard let self = self else { return }
                
                if let index = self.todoList.firstIndex(where: { $0.id == editedTask.id }) {
                    DispatchQueue.main.async {
                        self.todoList[index] = editedTask
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    func deleteTask() {
        input.deleteTaskSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] deletedTask in
                guard let self = self else { return }
                
                if let index = self.todoList.firstIndex(where: { $0.id == deletedTask.id }) {
                    DispatchQueue.main.async {
                        self.todoList.remove(at: index)
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    func createTask() {
        input.createTaskSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] title, subtitle in
                guard let self = self else { return }
                
                let newId = generateId(self.todoList)
                let newTask = LocalTodo(id: newId,
                                        todo: title,
                                        subTodo: subtitle,
                                        completed: false, 
                                        userId: nil)
                
                DispatchQueue.main.async {
                    self.todoList.append(newTask)
                }
            }
            .store(in: &cancellable)
    }
    
    func generateId(_ todos: [LocalTodo]) -> Int {
        return (todos.max(by: { $0.id < $1.id })?.id ?? 0) + 1
    }
}

extension TodoInteractor {
    struct Input {
        let closeTaskSubject = PassthroughSubject<LocalTodo, Never>()
        let openTaskSubject = PassthroughSubject<LocalTodo, Never>()
        let editTaskSubject = PassthroughSubject<LocalTodo, Never>()
        let deleteTaskSubject = PassthroughSubject<LocalTodo, Never>()
        let createTaskSubject = PassthroughSubject<(String, String), Never>()
        let getTasksSubject = PassthroughSubject<Void, Never>()
    }
}
