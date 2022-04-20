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

class CalendarHelper {
  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    return dateFormatter
  }()
  private var firstDayIsMonday: Bool = false
  let calendar = Calendar(identifier: .gregorian)

  init(_ firstDayIsMonday: Bool) {
    self.firstDayIsMonday = firstDayIsMonday
  }

  func monthLabelText(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = calendar
    dateFormatter.locale = Locale.autoupdatingCurrent
    dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
    return dateFormatter.string(from: date)
  }

  func plusMonth(date: Date) -> Date {
    return calendar.date(byAdding: .month, value: 1, to: date)!
  }

  func minusMonth(date: Date) -> Date {
    return calendar.date(byAdding: .month, value: -1, to: date)!
  }

  private func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
    guard let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate.addDay(1)!)?.count,
          let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate.addDay(1)!))
    else {
      throw CalendarDataError.metadataGeneration
    }
    let firstDayWeekday = firstDayIsMonday ? firstDayOfMonth.weekdayStartMon : firstDayOfMonth.weekdayStartSun
    return MonthMetadata(
      numberOfDays: numberOfDaysInMonth,
      firstDay: firstDayOfMonth,
      firstDayWeekday: firstDayWeekday)
  }

  func generateDaysInMonth(for baseDate: Date, selectedDays: [CalendarDay]) -> [CalendarDay] {
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
    let additionalDays = 7 - (firstDayIsMonday ? lastDayInMonth.weekdayStartMon : lastDayInMonth.weekdayStartSun)
    guard additionalDays > 0 else {
      return []
    }
    let days: [CalendarDay] = (1...additionalDays)
      .map { generateDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false) }
    return days
  }

  enum CalendarDataError: Error {
    case metadataGeneration
  }
}
