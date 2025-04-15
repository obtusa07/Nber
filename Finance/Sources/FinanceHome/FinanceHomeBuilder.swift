//
//  FinanceHomeBuilder.swift
//  Finance
//
//  Created by Taehwan Kim on 3/30/25.
//

import ModernRIBs
import Topup
import FinanceRepository
import AddPaymentMethod
import CombineUtil

public protocol FinanceHomeDependency: Dependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var nberPayRepository: NberPayRepository { get }
  var topupBuildable: TopupBuildable { get }
  var addPaymentMethodBuildable: AddPaymentMethodBuildable { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, NberPayDashboardDependency, CardOnFileDashboardDependency {
  
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  var nberPayRepository: NberPayRepository { dependency.nberPayRepository }
  var balance: ReadOnlyCurrentValuePublisher<Double> { nberPayRepository.balance }
  var topupBuildable: TopupBuildable { dependency.topupBuildable }
  var addPaymentMethodBuildable: AddPaymentMethodBuildable { dependency.addPaymentMethodBuildable }
}

// MARK: - Builder

public protocol FinanceHomeBuildable: Buildable {
//  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
  func build(withListener listener: FinanceHomeListener) -> ViewableRouting
}

public final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
  
  public override init(dependency: FinanceHomeDependency) {
    super.init(dependency: dependency)
  }
  
//  public func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
  public func build(withListener listener: FinanceHomeListener) -> ViewableRouting {
    let viewController = FinanceHomeViewController()
//    let balancePublisher = CurrentValuePublisher<Double>(0)
    let component = FinanceHomeComponent(
      dependency: dependency
    )
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener
    
    let nberPayDashboardBuilder = NberPayDashboardBuilder(dependency: component)
    let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
    
    return FinanceHomeRouter(
      interactor: interactor,
      viewController: viewController,
      nberPayDashboardBuildable: nberPayDashboardBuilder,
      cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
      addPaymentMethodBuildable: component.addPaymentMethodBuildable,
      topupBuildable: component.topupBuildable
    )
  }
}
