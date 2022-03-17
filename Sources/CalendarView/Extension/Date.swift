//
//  Date.swift
//  
//
//  Created by demothreen on 17.03.2022.
//

import Foundation

public extension Date {
  var numberOfDate: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    return dateFormatter.string(from: self)
  }

  func addDay(_ value: Int) -> Date? {
    return Calendar.current.date(byAdding: .day, value: value, to: self)
  }

  func hasSame(as date: Date) -> Bool {
    let calendar = Calendar(identifier: .gregorian)
    return calendar.isDate(date, inSameDayAs: self)
  }
}
