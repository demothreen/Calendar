//
//  CalendarHeaderView.swift
//  
//
//  Created by demothreen on 23.04.2022.
//

import UIKit

class CalendarHeaderView: UIView {
  var monthLabel: UILabel = UILabel()
  var leftShevronBtn: UIButton = UIButton()
  var rightShevronBtn: UIButton = UIButton()
  var selectColor: UIColor = .black {
    didSet { setNeedsLayout() }
  }
  private let horizontalPadding: CGFloat = 25
  private var titlePosition: TitlePosition
  private var daysOfWeekStackView = UIStackView()

  init(titlePosition: TitlePosition) {
    self.titlePosition = titlePosition
    super.init(frame: .zero)
    setMonthLabel()
    setShevronBtns()
    setWeekStackView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    leftShevronBtn.tintColor = selectColor
    rightShevronBtn.tintColor = selectColor
    monthLabel.textColor = selectColor
  }

  private func setShevronBtns() {
    addSubview(leftShevronBtn)
    addSubview(rightShevronBtn)
    leftShevronBtn.setImage(UIUtils.getIconByName("calendarShevronLeft")?.withRenderingMode(.alwaysTemplate), for: .normal)
    leftShevronBtn.snp.makeConstraints { make in
      if titlePosition == .center {
        make.left.equalToSuperview().inset(horizontalPadding)
      } else {
        make.right.equalTo(rightShevronBtn.snp.left).offset(-30)
      }
      make.centerY.equalTo(monthLabel)
    }
    rightShevronBtn.setImage(UIUtils.getIconByName("calendarShevronRight")?.withRenderingMode(.alwaysTemplate), for: .normal)
    rightShevronBtn.snp.makeConstraints { make in
      make.right.equalToSuperview().inset(horizontalPadding)
      make.centerY.equalTo(monthLabel)
      make.height.width.equalTo(30)
    }
  }

  private func setMonthLabel() {
    addSubview(monthLabel)
    monthLabel.font = UIUtils.titleFont
    monthLabel.textAlignment = titlePosition == .center ? .center : .left
    monthLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(UIUtils.screenPadding)
      make.left.right.equalToSuperview().inset(horizontalPadding)
      make.height.equalTo(30)
    }
  }

  private func updateStackViewSubviews() {
    if daysOfWeekStackView.arrangedSubviews.count > 0 {
      daysOfWeekStackView.subviews.forEach { $0.removeFromSuperview() }
    }
    let weekTexts = ["mon", "tue", "wed", "thur", "fri", "sat", "sun"]
    weekTexts.forEach { text in
      let label = UILabel()
      label.text = text.localizedFromModule
      label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
      label.textColor = .dayColor.withAlphaComponent(0.6)
      label.textAlignment = .center
      daysOfWeekStackView.addArrangedSubview(label)
    }
  }

  private func setWeekStackView() {
    addSubview(daysOfWeekStackView)
    daysOfWeekStackView.distribution = .fillEqually
    daysOfWeekStackView.snp.makeConstraints { make in
      make.top.equalTo(monthLabel.snp.bottom).inset(-UIUtils.screenPadding)
      make.left.right.equalToSuperview().inset(UIUtils.screenPadding)
      make.height.equalTo(40)
      make.bottom.equalToSuperview()
    }
    updateStackViewSubviews()
  }
}
