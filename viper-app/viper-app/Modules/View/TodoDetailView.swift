//
//  TodoDetailView.swift
//  viper-app
//
//  Created by viltsevdanila on 21.09.2024.
//

import SwiftUI

struct TodoDetailView: View {
    @State var model: LocalTodo?
    @State var title: String
    @State var subtitle: String
    
    let closeAction: () -> ()
    let editAction: (LocalTodo) -> ()
    let deleteAction: (LocalTodo) -> ()
    let createAction: (String, String) -> ()
    
    var body: some View {
        content
            .navigationTitle(model != nil ? "Редактирование задачи" : "Добавление задачи")
            .navigationBarBackButtonHidden(true)
            .toolbar(.visible)
            .closeToolbar(action: closeAction)
    }
}

// MARK: - UI
extension TodoDetailView {
    var content: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            TextField("Task",
                      text: $title,
                      axis: .vertical)
                .font(.title2)
                .foregroundColor(.black)
            TextField("Description",
                      text: $subtitle,
                      axis: .vertical)
                .font(.title3)
                .foregroundColor(.grayText)
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 20) {
                    if let model = self.model {
                        deleteButton(model)
                    }
                    saveButton
                }
                .padding(.bottom, 40)
            }
        }
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    func deleteButton(_ model: LocalTodo) -> some View {
        Button {
            deleteAction(model)
        } label: {
            Image(systemName: "trash.fill")
                .foregroundColor(.red)
                .font(.largeTitle)
        }
    }
    
    var saveButton: some View {
        Button {
            if let model = self.model {
                let newModel = LocalTodo(id: model.id,
                                         todo: self.title,
                                         subTodo: self.subtitle,
                                         completed: model.completed,
                                         userId: model.userId)
                editAction(newModel)
            } else {
                createAction(self.title, self.subtitle)
            }
        } label: {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.black)
                .font(.largeTitle)
        }
    }
}

#Preview {
    TodoDetailView(model: .mock,
                   title: "",
                   subtitle: "", 
                   closeAction: {},
                   editAction: { _ in },
                   deleteAction: { _ in},
                   createAction: { _, _ in})
}
