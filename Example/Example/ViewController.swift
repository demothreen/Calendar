//
//  ViewController.swift
//  Example
//
//  Created by demothreen on 17.03.2022.
//

import UIKit
import CalendarView

class ViewController: UIViewController {
  var calendarView = CalendarView(baseDate: Date(), selectColor: .black)
  var selectedDays: [CalendarDay] = [
    CalendarDay(date: Date().addDay(-5)!, number: Date().addDay(-5)!.numberOfDate, color: .red, isSelected: false, isWithinDisplayedMonth: true),
    CalendarDay(date: Date().addDay(-4)!, number: Date().addDay(-4)!.numberOfDate, color: .red.withAlphaComponent(0.2), isSelected: false, isWithinDisplayedMonth: true)
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = "Calendar"

    setCalendar()
  }

  private func setCalendar() {
    calendarView.selectedDateChanged = { [weak self] selectedDate in
      guard self != nil else { return }
    }
    view.addSubview(calendarView)
    setCalendarHeight(UIScreen.main.bounds.width)
    calendarView.selectedDates = selectedDays
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let height = calendarView.collectionView.collectionViewLayout.collectionViewContentSize.height
    let viewHeight: CGFloat = height > 0 ? height + 100 : UIScreen.main.bounds.width
    setCalendarHeight(viewHeight)
    calendarView.layoutSubviews()
  }

  private func setCalendarHeight(_ height: CGFloat) {
    calendarView.snp.remakeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.left.right.equalToSuperview()
      make.height.equalTo(height)
    }
  }

}
