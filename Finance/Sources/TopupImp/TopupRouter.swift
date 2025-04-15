//
//  TopupRouter.swift
//  Finance
//
//  Created by Taehwan Kim on 3/31/25.
//

import ModernRIBs
import AddPaymentMethod
import NberUI
import FinanceEntity
import RIBsUtil
import Topup

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener {
  var router: TopupRouting? { get set }
  var listener: TopupListener? { get set }
  var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
  // this RIB does not own its own view, this protocol is conformed to by one of this
  // RIB's ancestor RIBs' view.
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
  
  // MARK: - Private
  private let viewController: ViewControllable
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?
  private let enterAmountBuildable: EnterAmountBuildable
  private var enterAmountRouting: Routing?
  private let cardOnFileBuildable: CardOnFileBuildable
  private var cardOnFileRouting: Routing?
  
  private var navigationControllerable: NavigationControllerable?
  
  init(
    interactor: TopupInteractable,
    viewController: ViewControllable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable,
    enterAmountBuildable: EnterAmountBuildable,
    cardOnFileBuildable: CardOnFileBuildable
  ) {
    self.viewController = viewController
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    self.enterAmountBuildable = enterAmountBuildable
    self.cardOnFileBuildable = cardOnFileBuildable
    super.init(interactor: interactor)
    interactor.router = self
  }
  
  func cleanupViews() {
    if viewController.uiviewController.presentedViewController != nil, navigationControllerable != nil {
      navigationControllerable?.dismiss(completion: nil)
    }
  }
  
  func attachAddPaymentMethod(closeButtonType: DismissButtonType) {
    if addPaymentMethodRouting != nil {
      return
    }
    let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: closeButtonType)
    if let navigationControllerable = navigationControllerable {
      navigationControllerable.pushViewController(router.viewControllable, animated: true)
    } else {
      presentInsideNavigation(router.viewControllable)
    }
    attachChild(router)
    addPaymentMethodRouting = router
  }
  
  func detachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else {
      return
    }
    //    dismissPresentedNavigation(completion: nil)
    navigationControllerable?.popViewController(animated: true)
    detachChild(router)
    addPaymentMethodRouting = nil
  }
  
  private func presentInsideNavigation(_ viewControllable: ViewControllable) {
    let navigation = NavigationControllerable(root: viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    self.navigationControllerable = navigation
    viewController.present(navigation, animated: true, completion: nil)
  }
  
  private func dismissPresentedNavigation(completion: (() -> Void)?) {
    if self.navigationControllerable == nil {
      return
    }
    viewController.dismiss(completion: nil)
    self.navigationControllerable = nil
  }
  
  func attachEnterAmount() {
    if enterAmountRouting != nil {
      return
    }
    
    let router = enterAmountBuildable.build(withListener: interactor)
    
    if let navigation = navigationControllerable {
      navigation.setViewControllers([router.viewControllable])
      resetChildRouing()
    } else {
      presentInsideNavigation(router.viewControllable)
    }
    
    attachChild(router)
    enterAmountRouting = router
  }
  
  func detachEnterAmount() {
    guard let router = enterAmountRouting else {
      return
    }
    dismissPresentedNavigation(completion: nil)
    detachChild(router)
    enterAmountRouting = nil
  }
  
  func attachCardOnFile(paymentMethods: [PaymentMethod]) {
    if cardOnFileRouting != nil {
      return
    }
    let router = cardOnFileBuildable.build(withListener: interactor, paymentMethods: paymentMethods)
    navigationControllerable?.pushViewController(router.viewControllable, animated: true)
    cardOnFileRouting = router
    attachChild(router)
  }
  
  private func resetChildRouing() {
    if let cardOnFileRouting = cardOnFileRouting {
      detachChild(cardOnFileRouting)
      self.cardOnFileRouting = nil
    }
    
    if let addPaymentMethodRouting = addPaymentMethodRouting {
      detachChild(addPaymentMethodRouting)
      self.addPaymentMethodRouting = nil
    }
  }
  
  func detachCardOnFile() {
    guard let router = cardOnFileRouting else {
      return
    }
    navigationControllerable?.popViewController(animated: true)
    detachChild(router)
    cardOnFileRouting = nil
  }
  
  func popToRoot() {
    navigationControllerable?.popToRoot(animated: true)
    resetChildRouing()
  }
}
