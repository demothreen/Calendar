//
//  CalendarCell.swift
//
//  Created by demothreen on 08.03.2022.
//

import UIKit
import SnapKit

class CalendarCell: UICollectionViewCell {
  private lazy var selectionBackgroundView: UIView = {
    let view = UIView()
    view.clipsToBounds = true
    return view
  }()
  private lazy var dayOfMonthLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  private lazy var accessibilityDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
    return dateFormatter
  }()
  var selectColor: UIColor = .black {
    didSet {
      guard let day = day else { return }
      selectionBackgroundView.layer.borderColor = day.isSelected ? selectColor.cgColor : UIColor.clear.cgColor
    }
  }
  override var isSelected: Bool {
    didSet{
      UIView.animate(withDuration: 0.3) { [self] in
        selectionBackgroundView.backgroundColor = isSelected ? selectColor : day?.color
        let defaultColor: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
        dayOfMonthLabel.textColor = isSelected ? .white : defaultColor.withAlphaComponent(day?.isWithinDisplayedMonth ?? false ? 1 : 0.2)
      }
    }
  }

  var day: CalendarDay? {
    didSet {
      guard let day = day else { return }
      self.selectionBackgroundView.backgroundColor = day.color
      //      self.selectionBackgroundView.layer.borderColor = day.isSelected ? UIColor.sectionColor.cgColor : UIColor.clear.cgColor
      dayOfMonthLabel.text = day.number
      let defaultColor: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
      dayOfMonthLabel.textColor = defaultColor.withAlphaComponent(day.isWithinDisplayedMonth ? 1 : 0.2)
      accessibilityLabel = accessibilityDateFormatter.string(from: day.date)
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    isAccessibilityElement = true
    accessibilityTraits = .button
    contentView.addSubview(selectionBackgroundView)
    contentView.addSubview(dayOfMonthLabel)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    NSLayoutConstraint.deactivate(selectionBackgroundView.constraints)
    dayOfMonthLabel.snp.makeConstraints({ make in
      make.centerY.centerX.equalTo(contentView)
    })
    let size = contentView.frame.size.height - 5
    selectionBackgroundView.snp.makeConstraints({ make in
      make.centerY.centerX.equalTo(contentView)
      make.width.height.equalTo(size)
    })
    selectionBackgroundView.layer.cornerRadius = size / 2
    selectionBackgroundView.layer.borderWidth = 1
    selectionBackgroundView.layer.masksToBounds = true
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    layoutSubviews()
  }
}
