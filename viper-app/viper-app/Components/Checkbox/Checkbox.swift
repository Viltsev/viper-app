//
//  Checkbox.swift
//  viper-app
//
//  Created by viltsevdanila on 20.09.2024.
//

import SwiftUI

struct Checkbox: View {
    @Binding var checked: Bool
    let task: LocalTodo
    let closeTask: (LocalTodo) -> ()
    let openTask: (LocalTodo) -> ()
    
    var body: some View {
        Button {
            withAnimation(.bouncy) {
                if checked {
                    openTask(task)
                } else {
                    closeTask(task)
                }
                checked.toggle()
            }
        } label: {
            if checked {
                Circle()
                    .foregroundColor(.darkBlue)
                    .frame(width: 25)
                    .overlay {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                    }
            } else {
                Circle()
                    .stroke(.gray, lineWidth: 1.0)
                    .foregroundColor(.gray)
                    .frame(width: 25)
            }
        }
    }
}
