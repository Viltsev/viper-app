//
//  TodoCell.swift
//  viper-app
//
//  Created by viltsevdanila on 19.09.2024.
//

import SwiftUI

struct TodoCell: View {
    @State var checked: Bool
    let task: LocalTodo
    
    let closeTask: (LocalTodo) -> ()
    let openTask: (LocalTodo) -> ()
    
    var body: some View {
        content
    }
}

// MARK: - UI
extension TodoCell {
    var content: some View {
        VStack {
            topCell
                .padding(.horizontal, 5)
                .padding(.top, 16)
                .padding(.bottom, 5)
            Divider()
                .padding(.horizontal, 25)
            bottomCell
                .padding(.top, 10)
                .padding(.horizontal, 5)
                .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal, 20)
    }
    
    var topCell: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.todo)
                    .foregroundStyle(.black)
                    .font(.headline)
                    .bold()
                    .strikethrough(checked)
                Text(task.subTodo)
                    .font(.subheadline)
                    .foregroundStyle(.grayText)
            }
            Spacer()
            Checkbox(checked: $checked,
                     task: task,
                     closeTask: closeTask,
                     openTask: openTask)
        }
        .padding(.horizontal, 20)
    }
    
    var bottomCell: some View {
        HStack(spacing: 10) {
            Text(FormateDate.formateDate(task.date))
                .font(.footnote)
                .foregroundStyle(.gray)
                .bold()
            Text("\(task.startTime) - \(task.endTime)")
                .font(.footnote)
                .foregroundStyle(.grayLightText)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
