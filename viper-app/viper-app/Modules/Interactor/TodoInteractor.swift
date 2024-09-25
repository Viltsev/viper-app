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
    private let persistenceController: PersistenceController
    
    var cancellable = Set<AnyCancellable>()
    
    
    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
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
                        self.saveTaskListToCoreData()
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
                    var newTask = task
                    newTask.completed = true
                    self.updateTaskInCoreData(task: newTask)
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
                    var newTask = task
                    newTask.completed = false
                    self.updateTaskInCoreData(task: newTask)
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
                    self.updateTaskInCoreData(task: editedTask)
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
                    self.deleteTaskFromCoreData(deletedTask.id)
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
                    self.todoList.insert(newTask, at: 0)
                    self.saveTaskListToCoreData()
                }
            }
            .store(in: &cancellable)
    }
    
    func generateId(_ todos: [LocalTodo]) -> Int {
        return (todos.max(by: { $0.id < $1.id })?.id ?? 0) + 1
    }
}

extension TodoInteractor {
    func fetchTasksFromCoreData() {
        self.todoList = persistenceController.fetchTasks()
    }
    
    private func saveTaskToCoreData(task: LocalTodo) {
        persistenceController.saveTask(task: task)
    }
    
    private func saveTaskListToCoreData() {
        persistenceController.saveTaskList(list: self.todoList)
    }
    
    private func deleteTaskFromCoreData(_ id: Int) {
        persistenceController.deleteTask(taskId: id)
    }
    
    private func updateTaskInCoreData(task: LocalTodo) {
        persistenceController.updateTask(task: task)
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
