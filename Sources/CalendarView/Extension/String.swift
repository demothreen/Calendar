//
//  String.swift
//
//
//  Created by demothreen on 21.03.2022.
//

import UIKit

public extension String {
  var localizedFromModule: String {
    return NSLocalizedString(self, bundle: Bundle.module, comment: "")
  }

  func capitalizingFirstLetter() -> String {
    return prefix(1).capitalized + dropFirst()
  }
  
  mutating func capitalizeFirstLetter() {
    self = capitalizingFirstLetter()
  }
}
