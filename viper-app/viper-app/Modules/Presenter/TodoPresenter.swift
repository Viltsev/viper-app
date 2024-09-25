//
//  TodoPresenter.swift
//  viper-app
//
//  Created by viltsevdanila on 20.09.2024.
//

import Foundation
import Combine

class TodoPresenter: ObservableObject {
    private var interactor: TodoInteractor
    var router: AppRouter
    private var cancellable = Set<AnyCancellable>()
    
    @Published var selection: Selection = .all
    @Published var todoList: [LocalTodo] = []
    
    init(interactor: TodoInteractor, router: AppRouter) {
        self.interactor = interactor
        self.router = router
        
        interactor.$selection
            .assign(to: \.selection, on: self)
            .store(in: &cancellable)
        
        interactor.$todoList
            .assign(to: \.todoList, on: self)
            .store(in: &cancellable)
    }
    
    func getTasks() {
        interactor.input.getTasksSubject.send()
//        if !TodoStorage.shared.appStatus {
//            interactor.input.getTasksSubject.send()
//        }
    }
    
    func closeTask(_ task: LocalTodo) {
        interactor.input.closeTaskSubject.send(task)
    }
    
    func openTask(_ task: LocalTodo) {
        interactor.input.openTaskSubject.send(task)
    }
    
    func editTask(_ task: LocalTodo) {
        interactor.input.editTaskSubject.send(task)
        router.popView()
    }
    
    func deleteTask(_ task: LocalTodo) {
        interactor.input.deleteTaskSubject.send(task)
        router.popView()
    }
    
    func createTask(_ title: String, _ subtitle: String) {
        interactor.input.createTaskSubject.send((title, subtitle))
        router.popView()
    }
    
    func pushDetailView(_ model: LocalTodo?) {
        router.pushView(AppNavigation.pushDetailView(model))
    }
    
    func closeDetailView() {
        router.popView()
    }
    
    var openList: [LocalTodo] {
        self.todoList.filter { $0.completed == false }
    }
    
    var closedList: [LocalTodo] {
        self.todoList.filter { $0.completed }
    }
}
