//
//  FinanceHomeRouter.swift
//  Finance
//
//  Created by Taehwan Kim on 3/30/25.
//

import ModernRIBs
import NberUI
import AddPaymentMethod
import Topup
import RIBsUtil

protocol FinanceHomeInteractable: Interactable, NberPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener, TopupListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
  var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
  func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
  private let nberPayDashboardBuildable: NberPayDashboardBuildable
  private var nberPayRouting: Routing?
  
  private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
  private var cardOnFileRouting: Routing?
  
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?
  
  private let topupBuildable: TopupBuildable
  private var topupRouting: Routing?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: FinanceHomeInteractable,
    viewController: FinanceHomeViewControllable,
    nberPayDashboardBuildable: NberPayDashboardBuildable,
    cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable,
    topupBuildable: TopupBuildable
  ) {
    self.nberPayDashboardBuildable = nberPayDashboardBuildable
    self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    self.topupBuildable = topupBuildable
    super.init(interactor: interactor, viewController: viewController)
    
    interactor.router = self
  }
  func attachNberPayDashboard() {
    if nberPayRouting != nil {
      return
    }
    let router = nberPayDashboardBuildable.build(withListener: interactor)
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    self.nberPayRouting = router
    attachChild(router)
    // 똑같은 자식 두개 이상 안 붙이게 방어 로직
  }
  
  func attachCardOnFileDashboard() {
    if cardOnFileRouting != nil {
      return
    }
    let router = cardOnFileDashboardBuildable.build(withListener: interactor)
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    self.cardOnFileRouting = router
    attachChild(router)
  }
  
  func attachAddPaymentMethod() {
    if addPaymentMethodRouting != nil {
      return
    }
    let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: .close)
    let navigation = NavigationControllerable(root: router.viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    viewControllable.present(navigation, animated: true, completion: nil)
    addPaymentMethodRouting = router
    attachChild(router)
  }
  func detachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else {
      return
    }
    viewControllable.dismiss(completion: nil)
    detachChild(router)
    addPaymentMethodRouting = nil
  }
  
  func attachTopup() {
    if topupRouting != nil {
      return
    }
    let router = topupBuildable.build(withListener: interactor)
    topupRouting = router
    // 뷰가 없는 리블렛은 attach만
    attachChild(router)
    
  }
  
  func detachTopup() {
    guard let router = topupRouting else {
      return
    }
    detachChild(router)
    self.topupRouting = nil
  }
}
