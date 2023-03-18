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

  var numberOfMonth: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M"
    return dateFormatter.string(from: self)
  }

  func addDay(_ value: Int) -> Date? {
    return Calendar.current.date(byAdding: .day, value: value, to: self)
  }

  func hasSame(as date: Date) -> Bool {
    let calendar = Calendar(identifier: .gregorian)
    return calendar.isDate(date, inSameDayAs: self)
  }

  // MARK: - The method checks that the day and month are the same as the given date
  func hasSameDayAndMonth(as date: Date) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MM"
    let date1String = dateFormatter.string(from: self)
    let date2String = dateFormatter.string(from: date)
    return date1String == date2String
  }

  func monthLabelText() -> String {
    var calendar = Calendar(identifier: .gregorian)
    calendar.firstWeekday = 2
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = calendar
    dateFormatter.locale = Locale.autoupdatingCurrent
    dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
    return dateFormatter.string(from: self)
  }
}
