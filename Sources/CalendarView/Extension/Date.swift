//
//  Date.swift
//  
//
//  Created by demothreen on 17.03.2022.
//

import Foundation

public extension Date {
  var calendar: Calendar { Calendar.current }
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


  // MARK: - The method checks that the day and month are the same as the given date
  func hasSameDayAndMonth(as date: Date) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MM"
    let date1String = dateFormatter.string(from: self)
    let date2String = dateFormatter.string(from: date)
    return date1String == date2String
  }

  var weekdayStartMon: Int {
    (calendar.component(.weekday, from: self) - calendar.firstWeekday + 7) % 7 + 1
  }

  var weekdayStartSun: Int {
    calendar.component(.weekday, from: self)
  }
}
