//
//  TransportHomeBuilder.swift
//  Transport
//
//  Created by Taehwan Kim on 4/15/25.
//

import ModernRIBs
import TransportHome
import FinanceRepository
import CombineUtil
import Topup

public protocol TransportHomeDependency: Dependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var nberPayRepository: NberPayRepository { get }
  var topupBuildable: TopupBuildable { get }
}

final class TransportHomeComponent: Component<TransportHomeDependency>, TransportHomeInteractorDependency {
  var topupBaseViewController: ViewControllable
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  var nberPayRepository: NberPayRepository { dependency.nberPayRepository }
  var nberPayBalance: ReadOnlyCurrentValuePublisher<Double> { nberPayRepository.balance }
  var topupBuildable: TopupBuildable { dependency.topupBuildable }
  
  init(
    dependency: TransportHomeDependency,
    topupBaseViewController: ViewControllable
  ) {
    self.topupBaseViewController = topupBaseViewController
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

//public protocol TransportHomeBuildable: Buildable {
//  func build(withListener listener: TransportHomeListener) -> ViewableRouting
//}

public final class TransportHomeBuilder: Builder<TransportHomeDependency>, TransportHomeBuildable {
  
  public override init(dependency: TransportHomeDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: TransportHomeListener) -> ViewableRouting {
    let viewController = TransportHomeViewController()
    let component = TransportHomeComponent(
      dependency: dependency,
      topupBaseViewController: viewController
    )
    
    let interactor = TransportHomeInteractor(
      presenter: viewController,
      dependency: component
    )
    interactor.listener = listener
        
    return TransportHomeRouter(
      interactor: interactor,
      viewController: viewController,
      topupBuildable: component.topupBuildable
    )
  }
}
