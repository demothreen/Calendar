//
//  UIUtils.swift
//  
//
//  Created by demothreen on 17.03.2022.
//

import UIKit

class UIUtils {
  public static let screenPadding: CGFloat = 15
  public static var titleFont: UIFont? = {
    return UIFont.systemFont(ofSize: 20)
  }()

  public static var subtitleFont: UIFont? = {
    return UIFont.systemFont(ofSize: 14)
  }()

  public static func getIconByName(_ name: String) -> UIImage? {
    UIImage(named: name, in: Bundle.module, compatibleWith: nil)
  }
}
