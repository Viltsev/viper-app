//
//  MenuSelector.swift
//  viper-app
//
//  Created by viltsevdanila on 19.09.2024.
//

import SwiftUI

struct MenuSelector: View {
    @Binding var selectedItem: Selection
    @Binding var allList: [LocalTodo]
    
    var body: some View {
        HStack(spacing: 15) {
            selection(.all, allList.count)
            Text("|")
                .foregroundStyle(.gray)
            selection(.open, openList.count)
            selection(.closed, closedList.count)
        }
    }
}

// MARK: - UI
extension MenuSelector {
    @ViewBuilder
    func selection(_ selected: Selection, _ amount: Int) -> some View {
        HStack(spacing: 5) {
            Text(selected.title)
                .foregroundStyle(selectedItem == selected ? .darkBlue : .gray)
                .font(.subheadline)
                .bold()
            amountView(amount, selected)
        }
        .onTapGesture {
            selectedItem = selected
        }
    }
    
    @ViewBuilder
    func amountView(_ amount: Int, _ selected: Selection) -> some View {
        HStack {
            Text("\(amount)")
                .foregroundStyle(.white)
                .font(.caption)
                .padding(.vertical, 5)
                .padding(.horizontal, 7)
        }
        .background(selectedItem == selected ? .darkBlue : .gray)
        .cornerRadius(15)
    }
}

extension MenuSelector {
    var openList: [LocalTodo] {
        self.allList.filter { $0.completed == false }
    }
    
    var closedList: [LocalTodo] {
        self.allList.filter { $0.completed }
    }
}

//#Preview {
//    MenuSelector(selectedItem: .all, amount: 3)
//}
