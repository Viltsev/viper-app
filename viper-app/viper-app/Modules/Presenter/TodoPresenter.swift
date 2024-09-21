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
    @Published var todoList: [ToDoModel] = []
    
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
    
    func closeTask(_ task: ToDoModel) {
        interactor.input.closeTaskSubject.send(task)
    }
    
    func openTask(_ task: ToDoModel) {
        interactor.input.openTaskSubject.send(task)
    }
    
    func editTask(_ task: ToDoModel) {
        interactor.input.editTaskSubject.send(task)
        router.popView()
    }
    
    func deleteTask(_ task: ToDoModel) {
        interactor.input.deleteTaskSubject.send(task)
        router.popView()
    }
    
    func createTask(_ title: String, _ subtitle: String) {
        interactor.input.createTaskSubject.send((title, subtitle))
        router.popView()
    }
    
    func pushDetailView(_ model: ToDoModel?) {
        router.pushView(AppNavigation.pushDetailView(model))
    }
    
    func closeDetailView() {
        router.popView()
    }
    
    var openList: [ToDoModel] {
        self.todoList.filter { $0.complited == false }
    }
    
    var closedList: [ToDoModel] {
        self.todoList.filter { $0.complited }
    }
}
