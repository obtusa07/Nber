//
//  AppDelegate.swift
//  Nber
//
//  Created by Taehwan Kim on 4/15/25.
//

import Foundation
import ModernRIBs

final class AppComponent: Component<EmptyDependency>, AppRootDependency {
  init() {
    super.init(dependency: EmptyComponent())
  }
}
