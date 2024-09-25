//
//  Persistence.swift
//  viper-app
//
//  Created by viltsevdanila on 25.09.2024.
//

import Foundation
import CoreData

class PersistenceController: ObservableObject {
    let container = NSPersistentContainer(name: "Todo")
    
    static let shared = PersistenceController()
    
    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("core data failed to load : \(error.localizedDescription)")
            }
        }
    }
    
    func fetchTasks() -> [LocalTodo] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        var todoList: [LocalTodo] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        do {
            let tasks = try context.fetch(fetchRequest)
            todoList = tasks.map { task in
                let dateString = task.date ?? ""
                let date = dateFormatter.date(from: dateString)
                
                let startTime = task.startTime ?? "00:00"
                let endTime = task.endTime ?? "00:00"
                
                return LocalTodo(id: Int(task.id),
                                 todo: task.todo ?? "",
                                 subTodo: task.subTodo ?? "",
                                 completed: task.completed,
                                 userId: Int(task.userId),
                                 date: date ?? Date(),
                                 startTime: startTime,
                                 endTime: endTime)
            }
            
        } catch {
            print("failed to fetch tasks: \(error)")
        }
        
        return todoList
    }
    
    func saveTask(task: LocalTodo) {
        let context = container.viewContext
        let newTask = Todo(context: context)
        newTask.id = Int64(task.id)
        newTask.todo = task.todo
        newTask.subTodo = task.subTodo
        newTask.completed = task.completed
        if let userId = task.userId {
            newTask.userId = Int64(userId)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: task.date)
        newTask.date = dateString
        
        newTask.startTime = task.startTime
        newTask.endTime = task.endTime
        
        do {
            try context.save()
        } catch {
            print("failed to save tasks: \(error)")
        }
    }
    
    func saveTaskList(list: [LocalTodo]) {
        clearCoreData()
        list.forEach { saveTask(task: $0) }
    }
    
    func deleteTask(taskId: Int) {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", taskId)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            if let taskToDelete = tasks.first {
                context.delete(taskToDelete)
                try context.save()
                print("task has been deleted")
            }
        } catch {
            print("failed to delete task: \(error)")
        }
    }
    
    func updateTask(task: LocalTodo) {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            if let existingTask = tasks.first {
                existingTask.todo = task.todo
                existingTask.subTodo = task.subTodo
                existingTask.completed = task.completed
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: task.date)
                existingTask.date = dateString
                
                existingTask.startTime = task.startTime
                existingTask.endTime = task.endTime
                
                try context.save()
                
                print("task has been updated")
            }
        } catch {
            print("failed to update task: \(error)")
        }
    }
    
    func clearCoreData() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Todo.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("data has been deleted from core data")
        } catch {
            print("failed to delete data : \(error)")
        }
    }
    
    
}
