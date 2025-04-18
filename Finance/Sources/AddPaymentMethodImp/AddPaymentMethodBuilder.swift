//
//  AddPaymentMethodBuilder.swift
//  Finance
//
//  Created by Taehwan Kim on 3/31/25.
//

import ModernRIBs
import FinanceRepository
import RIBsUtil
import AddPaymentMethod

public protocol AddPaymentMethodDependency: Dependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodComponent: Component<AddPaymentMethodDependency>, AddPaymentMethodInteractorDependency {
  var cardOnFileRepository: any CardOnFileRepository { dependency.cardOnFileRepository }

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public final class AddPaymentMethodBuilder: Builder<AddPaymentMethodDependency>, AddPaymentMethodBuildable {
  
  public override init(dependency: AddPaymentMethodDependency) {
    super.init(dependency: dependency)
  }

  public func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting {
        let component = AddPaymentMethodComponent(dependency: dependency)
        let viewController = AddPaymentMethodViewController(closeButtonType: closeButtonType)
        let interactor = AddPaymentMethodInteractor(
          presenter: viewController,
          dependency: component
        )
        interactor.listener = listener
        return AddPaymentMethodRouter(interactor: interactor, viewController: viewController)
    }
}
