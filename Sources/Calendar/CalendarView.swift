//
//  CalendarView.swift
//  RedDays
//
//  Created by demothreen on 08.03.2022.
//

import UIKit

public class CalendarView: UIView {
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
      days = CalendarHelper().generateDaysInMonth(for: baseDate, selectedDays: selectedDates)
    }
  }
  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.locale = Locale.autoupdatingCurrent
    dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
    return dateFormatter
  }()
  public var selectedDateChanged: ((Date) -> Void)?
  public var baseDate: Date = Date() {
    didSet {
      days = CalendarHelper().generateDaysInMonth(for: baseDate, selectedDays: selectedDates)
      collectionView.reloadData()
      monthLabel.text = CalendarHelper().monthLabelText(from: baseDate)
    }
  }
  private lazy var days: [CalendarDay] = CalendarHelper().generateDaysInMonth(for: baseDate, selectedDays: selectedDates)
  private var selectColor: UIColor

  init(baseDate: Date, selectColor: UIColor) {
    self.selectColor = selectColor
    self.baseDate = baseDate
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
    leftShevronBtn.setImage(UIImage(named: "calendarShevronLeft")?.withRenderingMode(.alwaysTemplate), for: .normal)
    leftShevronBtn.addTarget(self, action: #selector(pressLeftBtn), for: .touchUpInside)
    leftShevronBtn.tintColor = selectColor
    leftShevronBtn.snp.makeConstraints { make in
      make.left.equalToSuperview().inset(UIUtils.screenPadding)
      make.centerY.equalTo(monthLabel)
    }
    rightShevronBtn.setImage(UIImage(named: "calendarShevronRight")?.withRenderingMode(.alwaysTemplate), for: .normal)
    rightShevronBtn.addTarget(self, action: #selector(pressRightBtn), for: .touchUpInside)
    rightShevronBtn.tintColor = selectColor
    rightShevronBtn.snp.makeConstraints { make in
      make.right.equalToSuperview().inset(UIUtils.screenPadding)
      make.centerY.equalTo(monthLabel)
      make.height.width.equalTo(30)
    }
  }

  @objc private func pressLeftBtn() {
    baseDate = CalendarHelper().minusMonth(date: baseDate)
  }

  @objc private func pressRightBtn() {
    baseDate = CalendarHelper().plusMonth(date: baseDate)
  }

  private func setMonthLabel() {
    addSubview(monthLabel)
    monthLabel.font = UIUtils.titleFont
    monthLabel.textColor = selectColor
    monthLabel.text = CalendarHelper().monthLabelText(from: baseDate)
    monthLabel.snp.makeConstraints { make in
      make.top.equalTo(snp.top).inset(UIUtils.screenPadding)
      make.centerX.equalToSuperview()
      make.height.equalTo(30)
    }
  }

  private func setWeekStackView() {
    addSubview(daysOfWeekStackView)
    let weekTexts = ["sun", "mon", "tue", "wed", "thur", "fri", "sat"]
    weekTexts.forEach { text in
      let label = UILabel()
      label.text = text.localized
      label.font = UIUtils.subtitleFont
      label.textColor = .gray
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
    addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(daysOfWeekStackView.snp.bottom)
      make.left.right.equalTo(daysOfWeekStackView)
      make.bottom.equalToSuperview()
    }
  }
}

extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return days.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CalendarCell
    cell.day = days[indexPath.row]
    cell.selectColor = selectColor
    return cell
  }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let day = days[indexPath.row]
    print("### delected day", day)
    selectedDateChanged?(day.date)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = (frame.size.width - 30) / 8
    return CGSize(width: size, height: size)
  }
}
