//
//  FormateDate.swift
//  viper-app
//
//  Created by viltsevdanila on 25.09.2024.
//

import Foundation

class FormateDate {
    static func formateDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dateToCheck = calendar.startOfDay(for: date)
        
        if dateToCheck == today {
            return "Today"
        } else if dateToCheck == calendar.date(byAdding: .day, value: 1, to: today) {
            return "Tomorrow"
        } else if dateToCheck == calendar.date(byAdding: .day, value: -1, to: today) {
            return "Yesterday"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    static func currentDayTitle() -> String {
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        
        return dateFormatter.string(from: currentDate)
    }
}
