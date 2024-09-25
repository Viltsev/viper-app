//
//  AddButton.swift
//  viper-app
//
//  Created by viltsevdanila on 19.09.2024.
//

import SwiftUI

struct AddButton: View {
    let action: (LocalTodo?) -> ()
    
    var body: some View {
        Button {
            action(nil)
        } label: {
            HStack {
                Text("+ New Task")
                    .fontWeight(.regular)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 13)
                    .font(.headline)
                    .foregroundColor(.darkBlue)
            }
            .background(Color.lightBlue)
            .cornerRadius(13)
        }
    }
}
