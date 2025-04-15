//
//  Formatter.swift
//  Transport
//
//  Created by Taehwan Kim on 4/13/25.
//

import Foundation

struct Formatter {
  static let balanceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
}
