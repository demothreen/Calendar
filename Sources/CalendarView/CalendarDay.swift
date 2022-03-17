//
//  CalendarDay.swift
//  RedDays
//
//  Created by demothreen on 10.03.2022.
//

import UIKit

public struct CalendarDay {
  public let date: Date
  public let number: String
  public var color: UIColor
  public let isSelected: Bool
  public let isWithinDisplayedMonth: Bool

  public init(date: Date, number: String, color: UIColor = .clear, isSelected: Bool, isWithinDisplayedMonth: Bool) {
    self.date = date
    self.number = number
    self.color = color
    self.isSelected = isSelected
    self.isWithinDisplayedMonth = isWithinDisplayedMonth
  }
}
