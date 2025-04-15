//
//  Formatter.swift
//  Finance
//
//  Created by Taehwan Kim on 3/30/25.
//

import Foundation

struct Formatter {
  static let balanceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
}
