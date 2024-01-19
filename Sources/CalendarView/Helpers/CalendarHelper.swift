//
//  CalendarHelper.swift
//
//  Created by demothreen on 08.03.2022.
//

import UIKit

struct MonthMetadata {
  let numberOfDays: Int
  let firstDay: Date
  let firstDayWeekday: Int
}

enum CalendarDataError: Error {
  case metadataGeneration
}

public enum CalendarType: Int {
  case month
  case week
}

final class CalendarHelper {
  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DateFormat.d.rawValue
    return dateFormatter
  }()
  lazy var calendar: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.firstWeekday = 2 // always monday
    return calendar
  }()
  var selectedDays: [CalendarDay] = []
  
  func addMonth(date: Date, month: Int) -> Date {
    return calendar.date(byAdding: .month, value: month, to: date)!
  }

  func addDays(date: Date, days: Int) -> Date {
    return calendar.date(byAdding: .day, value: days, to: date)!
  }

  private func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
    guard let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate.addDay(1)!)?.count,
          let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate.addDay(1)!))
    else {
      throw CalendarDataError.metadataGeneration
    }
    let firstDayWeekday = getCurrentWeekDay(from: firstDayOfMonth)
    return MonthMetadata(
      numberOfDays: numberOfDaysInMonth,
      firstDay: firstDayOfMonth,
      firstDayWeekday: firstDayWeekday)
  }

  func generateDaysInMonth(for baseDate: Date) -> [CalendarDay] {
    guard let metadata = try? monthMetadata(for: baseDate) else {
      preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
    }
    let numberOfDaysInMonth = metadata.numberOfDays
    let offsetInInitialRow = metadata.firstDayWeekday
    let firstDayOfMonth = metadata.firstDay
    var days: [CalendarDay] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
      .map { day in
        let isWithinDisplayedMonth = day >= offsetInInitialRow
        let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)
        return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
      }
    days += generateStartOfNextMonth(using: firstDayOfMonth)
    return coloredDays(for: days)
  }

  func generateDaysInWeek(for baseDate: Date) -> [CalendarDay] {
    var days: [CalendarDay] = []
    var current = sundayForDate(date: baseDate)
    let nextSunday = addDays(date: current, days: 7)

    while (current < nextSunday) {
      days.append(
        CalendarDay(
          date: current,
          number: current.numberOfDate,
          isSelected: calendar.isDate(current, inSameDayAs: Date()),
          isWithinDisplayedMonth: current.numberOfMonth == baseDate.numberOfMonth
        )
      )
      current = addDays(date: current, days: 1)
    }
    return coloredDays(for: days)
  }

  private func coloredDays(for days: [CalendarDay]) -> [CalendarDay] {
    let coloredDays: [CalendarDay] = days.map { generatedDay in
      var coloredDay = generatedDay
      selectedDays.forEach({ selectedDay in
        if selectedDay.isEquallyEveryYear {
          if selectedDay.date.hasSameDayAndMonth(as: coloredDay.date) {
            coloredDay.color = selectedDay.color
          }
        } else {
          if selectedDay.date.hasSame(as: coloredDay.date) {
            coloredDay.color = selectedDay.color
          }
        }
      })
      return coloredDay
    }
    return coloredDays
  }

  func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> CalendarDay {
    let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
    return CalendarDay(date: date, number: dateFormatter.string(from: date), isSelected: calendar.isDate(date, inSameDayAs: Date()), isWithinDisplayedMonth: isWithinDisplayedMonth)
  }

  func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [CalendarDay] {
    guard let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfDisplayedMonth) else { return [] }

    let additionalDays = 7 - getCurrentWeekDay(from: lastDayInMonth)
    guard additionalDays > 0 else {
      return []
    }
    let days: [CalendarDay] = (1...additionalDays)
      .map { generateDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false) }
    return days
  }

  private func getCurrentWeekDay(from date: Date) -> Int {
    return (calendar.component(.weekday, from: date) - calendar.firstWeekday + 7) % 7 + 1
  }

  func sundayForDate(date: Date) -> Date {
    var current = date
    let oneWeekAgo = addDays(date: current, days: -7)

    while(current > oneWeekAgo) {
      let currentWeekDay = getCurrentWeekDay(from: current)
      if currentWeekDay == 1 {
        return current
      }
      current = addDays(date: current, days: -1)
    }
    return current
  }
}
