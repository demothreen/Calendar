//
//  UICollectionView.swift
//  
//
//  Created by demothreen on 22.04.2022.
//

import UIKit

extension UICollectionView {
  func registerCell<Cell: UICollectionViewCell>(_ cell: Cell.Type) {
    register(Cell.self, forCellWithReuseIdentifier: reuseIdentifier(for: cell))
  }

  private func reuseIdentifier<Cell: UICollectionViewCell>(for cell: Cell.Type) -> String {
    String(describing: cell)
  }

  func dequeueCell<Cell: UICollectionViewCell>(_ cell: Cell.Type, for indexPath: IndexPath) -> Cell {
    if let cell = dequeueReusableCell(withReuseIdentifier: String(describing: cell), for: indexPath) as? Cell {
      return cell
    }
    return Cell()
  }
}
