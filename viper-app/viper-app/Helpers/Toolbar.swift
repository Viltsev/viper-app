//
//  Toolbar.swift
//  viper-app
//
//  Created by viltsevdanila on 21.09.2024.
//

import SwiftUI

extension View {
    
    func closeToolbar(action: @escaping () -> ()) -> some View {
        self.toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    action()
                } label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
        })
    }
    
}
