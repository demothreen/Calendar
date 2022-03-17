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
  public var color: UIColor = .clear
  public let isSelected: Bool
  public let isWithinDisplayedMonth: Bool
}

