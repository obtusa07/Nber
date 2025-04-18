//
//  NberPayRepository.swift
//  Finance
//
//  Created by Taehwan Kim on 4/4/25.
//

import Foundation
import Combine
import CombineUtil
import Network

public protocol NberPayRepository {
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }
  func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error>
}

public final class NberPayRepositoryImp: NberPayRepository {
  public var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }
  private let balanceSubject = CurrentValuePublisher<Double>(0)
  
  public func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, any Error> {
    
    let request = TopupRequest(baseURL: baseURL, amount: amount, paymentMethodID: paymentMethodID)
    return network.send(request)
      .handleEvents(
        receiveSubscription: nil,
        receiveOutput: { [weak self] _ in
          let newBalance = (self?.balanceSubject.value).map { $0 + amount }
          newBalance.map { self?.balanceSubject.send($0) }
        },
        receiveCompletion: nil,
        receiveCancel: nil,
        receiveRequest: nil
      )
      .map({ _ in })
      .eraseToAnyPublisher()
  }
  
  private let backgroundQueue = DispatchQueue(label: "topup.repository.queue")
  private let network: Network
  private let baseURL: URL
  
  public init(network: Network, baseURL: URL) {
    self.network = network
    self.baseURL = baseURL
  }
}
