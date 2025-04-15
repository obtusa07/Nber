//
//  NberPayDashboardInteractor.swift
//  Finance
//
//  Created by Taehwan Kim on 3/30/25.
//

import ModernRIBs
import Combine
import Foundation
import CombineUtil

protocol NberPayDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol NberPayDashboardPresentable: Presentable {
    var listener: NberPayDashboardPresentableListener? { get set }
    
  func updateBalance(_ balance: String)
}

protocol NberPayDashboardListener: AnyObject {
    func nberPayDashboardDidTapTopup()
}

protocol NberPayDashboardInteractorDependency {
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }
  var balanceFormatter: NumberFormatter { get }
}

final class NberPayDashboardInteractor: PresentableInteractor<NberPayDashboardPresentable>, NberPayDashboardInteractable, NberPayDashboardPresentableListener {

    weak var router: NberPayDashboardRouting?
    weak var listener: NberPayDashboardListener?
    private let dependency: NberPayDashboardInteractorDependency
    private var cancellables: Set<AnyCancellable>
  
    init(
      presenter: NberPayDashboardPresentable,
      dependency: NberPayDashboardInteractorDependency
    ) {
      self.dependency = dependency
      self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

  override func didBecomeActive() {
    super.didBecomeActive()
    self.dependency.balance
      .receive(on: DispatchQueue.main)
      .sink { [weak self] balance in
        self?.dependency.balanceFormatter.string(from: NSNumber(value: balance)).map({
          self?.presenter.updateBalance($0)
        })
      }.store(in: &cancellables)
  }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
  func topupButtonDidTap() {
    listener?.nberPayDashboardDidTapTopup()
  }
}
