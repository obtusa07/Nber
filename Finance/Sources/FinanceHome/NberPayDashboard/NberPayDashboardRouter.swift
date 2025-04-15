//
//  NberPayDashboardRouter.swift
//  Finance
//
//  Created by Taehwan Kim on 3/30/25.
//

import ModernRIBs

protocol NberPayDashboardInteractable: Interactable {
    var router: NberPayDashboardRouting? { get set }
    var listener: NberPayDashboardListener? { get set }
}

protocol NberPayDashboardViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class NberPayDashboardRouter: ViewableRouter<NberPayDashboardInteractable, NberPayDashboardViewControllable>, NberPayDashboardRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: NberPayDashboardInteractable, viewController: NberPayDashboardViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
