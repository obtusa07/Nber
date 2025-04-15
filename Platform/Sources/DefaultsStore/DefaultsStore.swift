//
//  DefaultsStore1.swift
//  Platform
//
//  Created by Taehwan Kim on 4/15/25.
//

import Foundation

public protocol DefaultsStore {
  var isInitialLaunch: Bool { get set }
  var lastNoticeDate: Double { get set }
}

public struct DefaultsStoreImp: DefaultsStore {
  
  public var isInitialLaunch: Bool {
    get {
      userDefaults.bool(forKey: kIsInitialLaunch)
    }
    set {
      userDefaults.set(newValue, forKey: kIsInitialLaunch)
    }
  }
  
  public var lastNoticeDate: Double {
    get {
      userDefaults.double(forKey: kLastNoticeDate)
    }
    set {
      userDefaults.set(newValue, forKey: kLastNoticeDate)
    }
  }
  
  private let userDefaults: UserDefaults
  
  private let kIsInitialLaunch = "kIsInitialLaunch"
  private let kLastNoticeDate = "kLastNoticeDate"
  
  public init(defaults: UserDefaults) {
    self.userDefaults = defaults
  }
}
