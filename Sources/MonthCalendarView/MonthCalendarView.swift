//
//  CalendarView.swift
//
//  Created by demothreen on 08.03.2022.
//

import UIKit
import SnapKit

public class MonthCalendarView: UIView {
  private var monthLabel: UILabel = UILabel()
  private var leftShevronBtn: UIButton = UIButton()
  private var rightShevronBtn: UIButton = UIButton()
  private var daysOfWeekStackView = UIStackView()
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
      days = CalendarHelper(firstDayIsMonday).generateDaysInMonth(for: baseDate, selectedDays: selectedDates)
    }
  }
  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.locale = Locale.autoupdatingCurrent
    dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
    return dateFormatter
  }()
  public var selectedDateChanged: ((CalendarDay) -> Void)?
  public var baseDate: Date = Date() {
    didSet {
      days = CalendarHelper(firstDayIsMonday).generateDaysInMonth(for: baseDate, selectedDays: selectedDates)
      collectionView.reloadData()
      monthLabel.text = CalendarHelper(firstDayIsMonday).monthLabelText(from: baseDate)
    }
  }
  private lazy var days: [CalendarDay] = CalendarHelper(firstDayIsMonday).generateDaysInMonth(for: baseDate, selectedDays: selectedDates)
  private var selectColor: UIColor
  private var firstDayIsMonday: Bool = false

  public init(baseDate: Date, selectColor: UIColor, firstDayIsMonday: Bool = false) {
    self.selectColor = selectColor
    self.baseDate = baseDate
    self.firstDayIsMonday = firstDayIsMonday
    super.init(frame: .zero)
    prepare()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func prepare() {
    setMonthLabel()
    setShevronBtns()
    setWeekStackView()
    setCollectionView()
  }

  private func setShevronBtns() {
    addSubview(leftShevronBtn)
    addSubview(rightShevronBtn)
    leftShevronBtn.setImage(UIUtils.getIconByName("calendarShevronLeft")?.withRenderingMode(.alwaysTemplate), for: .normal)
    leftShevronBtn.addTarget(self, action: #selector(pressLeftBtn), for: .touchUpInside)
    leftShevronBtn.tintColor = selectColor
    leftShevronBtn.snp.makeConstraints { make in
      make.left.equalToSuperview().inset(UIUtils.screenPadding)
      make.centerY.equalTo(monthLabel)
    }
    rightShevronBtn.setImage(UIUtils.getIconByName("calendarShevronRight")?.withRenderingMode(.alwaysTemplate), for: .normal)
    rightShevronBtn.addTarget(self, action: #selector(pressRightBtn), for: .touchUpInside)
    rightShevronBtn.tintColor = selectColor
    rightShevronBtn.snp.makeConstraints { make in
      make.right.equalToSuperview().inset(UIUtils.screenPadding)
      make.centerY.equalTo(monthLabel)
      make.height.width.equalTo(30)
    }
  }

  @objc private func pressLeftBtn() {
    baseDate = CalendarHelper(firstDayIsMonday).minusMonth(date: baseDate)
  }

  @objc private func pressRightBtn() {
    baseDate = CalendarHelper(firstDayIsMonday).plusMonth(date: baseDate)
  }

  private func setMonthLabel() {
    addSubview(monthLabel)
    monthLabel.font = UIUtils.titleFont
    monthLabel.textColor = selectColor
    monthLabel.text = CalendarHelper(firstDayIsMonday).monthLabelText(from: baseDate)
    monthLabel.snp.makeConstraints { make in
      make.top.equalTo(snp.top).inset(UIUtils.screenPadding)
      make.centerX.equalToSuperview()
      make.height.equalTo(30)
    }
  }

  private func setWeekStackView() {
    addSubview(daysOfWeekStackView)
    var weekTexts = ["mon", "tue", "wed", "thur", "fri", "sat"]
    weekTexts.insert("sun", at: firstDayIsMonday ? 6 : 0)
    weekTexts.forEach { text in
      let label = UILabel()
      label.text = text.localizedFromModule
      label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
      label.textColor = traitCollection.userInterfaceStyle == .dark ? .white.withAlphaComponent(0.6) : .black.withAlphaComponent(0.6)
      label.textAlignment = .center
      daysOfWeekStackView.addArrangedSubview(label)
    }
    daysOfWeekStackView.distribution = .fillEqually
    daysOfWeekStackView.snp.makeConstraints { make in
      make.top.equalTo(monthLabel.snp.bottom).inset(-UIUtils.screenPadding)
      make.left.right.equalToSuperview().inset(UIUtils.screenPadding)
      make.height.equalTo(40)
    }
  }

  private func setCollectionView() {
    collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "cellId")
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .clear
    addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(daysOfWeekStackView.snp.bottom)
      make.left.right.equalTo(daysOfWeekStackView)
      make.bottom.equalToSuperview()
    }
  }
}

extension MonthCalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return days.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CalendarCell
    cell.day = days[indexPath.row]
    cell.selectColor = selectColor
    return cell
  }
}

extension MonthCalendarView: UICollectionViewDelegateFlowLayout {
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
