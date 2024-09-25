//
//  TodoListView.swift
//  viper-app
//
//  Created by viltsevdanila on 19.09.2024.
//

import SwiftUI
import CoreData

struct TodoListView: View {
    @ObservedObject var presenter: TodoPresenter
    //@FetchRequest(entity: Todo.entity(), sortDescriptors: []) var todoList: FetchedResults<Todo>
    
    init(presenter: TodoPresenter) {
        self.presenter = presenter
    }
    
    var body: some View {
        NavigationStack(path: $presenter.router.path) {
            content
                .background(Color.grayBackground)
                .navigationDestination(for: AppNavigation.self) { navigation in
                    switch navigation {
                    case let .pushDetailView(model):
                        TodoDetailView(model: model,
                                       title: model?.todo ?? "",
                                       subtitle: model?.subTodo ?? "",
                                       closeAction: presenter.closeDetailView,
                                       editAction: presenter.editTask,
                                       deleteAction: presenter.deleteTask,
                                       createAction: presenter.createTask)
                    }
                }
                .onAppear(perform: presenter.getTasks)
        }
    }
}

// MARK: - UI
extension TodoListView {
    var content: some View {
        VStack {
            header
            selector
            list
            Spacer()
        }
    }
    
    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Today's Task")
                    .font(.title2)
                    .bold()
                Text("Wednesday, 11 May")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            Spacer()
            AddButton(action: presenter.pushDetailView)
        }
        .padding(.top, 20)
        .padding(.bottom, 35)
        .padding(.horizontal, 20)
    }
    
    var selector: some View {
        HStack {
            MenuSelector(selectedItem: $presenter.selection,
                         allList: $presenter.todoList)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    var list: some View {
        VStack {
            ScrollView {
                switch presenter.selection {
                case .all:
                    allList
                case .open:
                    openedList
                case .closed:
                    closedList
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.vertical, 20)
    }
    
    var allList: some View {
        VStack(spacing: 15) {
            ForEach(presenter.todoList) { item in
                Button {
                    presenter.pushDetailView(item)
                } label: {
                    TodoCell(checked: item.completed,
                             task: item,
                             closeTask: presenter.closeTask,
                             openTask: presenter.openTask)
                }
            }
        }
    }
    
    var closedList: some View {
        VStack(spacing: 15) {
            ForEach(presenter.closedList) { item in
                Button {
                    presenter.pushDetailView(item)
                } label: {
                    TodoCell(checked: item.completed,
                             task: item,
                             closeTask: presenter.closeTask,
                             openTask: presenter.openTask)
                }
            }
        }
    }
    
    var openedList: some View {
        VStack(spacing: 15) {
            ForEach(presenter.openList) { item in
                Button {
                    presenter.pushDetailView(item)
                } label: {
                    TodoCell(checked: item.completed,
                             task: item,
                             closeTask: presenter.closeTask,
                             openTask: presenter.openTask)
                }
            }
        }
    }
}

#Preview {
    TodoListView(presenter: .init(interactor: .init(), router: .init()))
}
