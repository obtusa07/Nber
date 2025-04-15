//
//  TransportHomeInteractor.swift
//  Transport
//
//  Created by Taehwan Kim on 4/15/25.
//

import ModernRIBs
import TransportHome
import Combine
import Foundation
import CombineUtil

protocol TransportHomeRouting: ViewableRouting {
  func attachTopup()
  func detachTopup()
}

protocol TransportHomePresentable: Presentable {
  var listener: TransportHomePresentableListener? { get set }
  func setNberPayBalance(_ balance: String)
}

protocol TransportHomeInteractorDependency {
  var nberPayBalance: ReadOnlyCurrentValuePublisher<Double> { get }
}

final class TransportHomeInteractor: PresentableInteractor<TransportHomePresentable>, TransportHomeInteractable, TransportHomePresentableListener {
  
  weak var router: TransportHomeRouting?
  weak var listener: TransportHomeListener?
  private let dependency: TransportHomeInteractorDependency
  private var cancellables: Set<AnyCancellable>
  private let ridePrice: Double = 18000
  init(
    presenter: TransportHomePresentable,
    dependency: TransportHomeInteractorDependency
  ) {
    self.dependency = dependency
    self.cancellables = .init()
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    dependency.nberPayBalance
      .receive(on: DispatchQueue.main)
      .sink { [weak self] balance in
        if let balanceText = Formatter.balanceFormatter.string(from: NSNumber(value: balance)) {
          self?.presenter.setNberPayBalance(balanceText)
        }
      }
      .store(in: &cancellables)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func didTapBack() {
    listener?.transportHomeDidTapClose()
  }
  func didTapRideConfirmButton() {
    if dependency.nberPayBalance.value < ridePrice {
      router?.attachTopup()
    } else {
      print("success")
    }
  }
  
  func topupDidClose() {
    router?.detachTopup()
  }
  
  func topupDidFinish() {
    router?.detachTopup()
  }
}
