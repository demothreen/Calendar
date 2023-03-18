//
//  CalendarView.swift
//
//  Created by demothreen on 08.03.2022.
//

import UIKit
import SnapKit

public class CalendarView: UIView {
  public var collectionView:  UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 5
    layout.minimumInteritemSpacing = 5
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = false
    return collectionView
  }()
  public var selectedDates: [CalendarDay] = [] {
    didSet {
      calendarHelper.selectedDays = selectedDates
      updateCalendarViewByType()
    }
  }
  public var selectedDateChanged: ((CalendarDay) -> Void)?
  private var baseDate: Date = Date() {
    didSet { updateCalendarViewByType() }
  }
  private var selectColor: UIColor
  public var presentationType: CalendarType = .month {
    didSet { updateCalendarViewByType() }
  }
  private var calendarHelper = CalendarHelper()
  private lazy var days = [CalendarDay]()
  private var headerView = CalendarHeaderView()

  public init(baseDate: Date, selectColor: UIColor) {
    self.selectColor = selectColor
    self.baseDate = baseDate
    super.init(frame: .zero)
    self.days = calendarHelper.generateDaysInMonth(for: baseDate)
    prepare()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func prepare() {
    setHeaderView()
    setCollectionView()
  }

  private func setHeaderView() {
    addSubview(headerView)
    headerView.leftShevronBtn.addTarget(self, action: #selector(pressLeftBtn), for: .touchUpInside)
    headerView.rightShevronBtn.addTarget(self, action: #selector(pressRightBtn), for: .touchUpInside)
    headerView.monthLabel.text = baseDate.monthLabelText()
    headerView.selectColor = selectColor
    headerView.snp.makeConstraints { make in
      make.top.equalTo(snp.top)
      make.left.right.equalToSuperview()
    }
  }

  private func updateCalendarViewByType() {
    if presentationType == .month {
      days = calendarHelper.generateDaysInMonth(for: baseDate)
    } else {
      days = calendarHelper.generateDaysInWeek(for: baseDate)
    }
    collectionView.reloadData()
    headerView.monthLabel.text = baseDate.monthLabelText()
    collectionView.reloadData()
    layoutIfNeeded()
  }

  @objc private func pressLeftBtn() {
    if presentationType == .month {
      baseDate = calendarHelper.addMonth(date: baseDate, month: -1)
    } else {
      baseDate = calendarHelper.addDays(date: baseDate, days: -7)
    }
  }

  @objc private func pressRightBtn() {
    if presentationType == .month {
      baseDate = calendarHelper.addMonth(date: baseDate, month: 1)
    } else {
      baseDate = calendarHelper.addDays(date: baseDate, days: 7)
    }
  }

  private func setCollectionView() {
    collectionView.registerCell(CalendarCell.self)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .clear
    addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(headerView.snp.bottom)
      make.left.right.equalToSuperview().inset(UIUtils.screenPadding)
      make.bottom.equalToSuperview().inset(-UIUtils.screenPadding)
    }
  }
}

extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return days.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(CalendarCell.self, for: indexPath)
    cell.day = days[indexPath.row]
    cell.selectColor = selectColor
    return cell
  }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let day = days[indexPath.row]
    selectedDateChanged?(day)
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? UIScreen.main.bounds.width/8 : UIScreen.main.bounds.height/8
    let size = (frame.size.width - 30) / 8
    return CGSize(width: size, height: height - 10)
  }
}
