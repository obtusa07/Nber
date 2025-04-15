//
//  Array+Utils.swift
//  Finance
//
//  Created by Taehwan Kim on 3/31/25.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
