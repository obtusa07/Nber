//
//  NberPayDashboardBuilder.swift
//  Finance
//
//  Created by Taehwan Kim on 3/30/25.
//

import ModernRIBs
import Foundation
import CombineUtil

protocol NberPayDashboardDependency: Dependency {
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }
}

final class NberPayDashboardComponent: Component<NberPayDashboardDependency>, NberPayDashboardInteractorDependency {
  var balanceFormatter: NumberFormatter { Formatter.balanceFormatter }
  
  var balance: ReadOnlyCurrentValuePublisher<Double> { dependency.balance }
}

// MARK: - Builder

protocol NberPayDashboardBuildable: Buildable {
    func build(withListener listener: NberPayDashboardListener) -> NberPayDashboardRouting
}

final class NberPayDashboardBuilder: Builder<NberPayDashboardDependency>, NberPayDashboardBuildable {

    override init(dependency: NberPayDashboardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: NberPayDashboardListener) -> NberPayDashboardRouting {
        let component = NberPayDashboardComponent(dependency: dependency)
        let viewController = NberPayDashboardViewController()
      let interactor = NberPayDashboardInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return NberPayDashboardRouter(interactor: interactor, viewController: viewController)
    }
}
