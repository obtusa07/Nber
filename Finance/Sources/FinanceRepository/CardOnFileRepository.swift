//
//  CardOnFileRepository.swift
//  Finance
//
//  Created by Taehwan Kim on 3/30/25.
//

import Foundation
import Combine
import FinanceEntity
import CombineUtil
import Network

public protocol CardOnFileRepository {
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
  func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error>
  func fetch()
}

public final class CardOnFileRepositoryImp: CardOnFileRepository {
  
  public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodsSubject }
  
  private let paymentMethodsSubject = CurrentValuePublisher<[PaymentMethod]>([
//    PaymentMethod(id: "0", name: "a-bank", digits: "1233", color: "#f19a38ff", isPrimary: false),
//    PaymentMethod(id: "1", name: "b-bank", digits: "0987", color: "#f14738ff", isPrimary: false),
//    PaymentMethod(id: "2", name: "c-bank", digits: "3328", color: "#789a38ff", isPrimary: false),
//    PaymentMethod(id: "3", name: "d-bank", digits: "5823", color: "#f19a38ff", isPrimary: false)
  ])
  
  public func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, any Error> {
    let request = AddCardRequest(baseURL: baseURL, info: info)
    return network.send(request)
      .map(\.output.card)
      .handleEvents(
        receiveSubscription: nil,
        receiveOutput: { [weak self] method in
          guard let this = self else {
            return
          }
          this.paymentMethodsSubject.send(this.paymentMethodsSubject.value + [method])
        },
        receiveCompletion: nil,
        receiveCancel: nil,
        receiveRequest: nil
      )
      .eraseToAnyPublisher()
    
//    let paymentMethod = PaymentMethod(id: "0", name: "new card", digits: "\(info.number.suffix(4))", color: "", isPrimary: false)
//    var new = paymentMethodsSubject.value
//    new.append(paymentMethod)
//    paymentMethodsSubject.send(new)
//    return Just(paymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
  }
  
  
  public func fetch() {
    let request = CardOnFileRequest(baseURL: baseURL)
    network.send(request).map(\.output.cards)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { [weak self] cards in
          self?.paymentMethodsSubject.send(cards)
        }
      )
      .store(in: &cancellables)
  }
  
  private let network: Network
  private let baseURL: URL
  private var cancellables: Set<AnyCancellable>
  public init(network: Network, baseURL: URL) {
    self.network = network
    self.baseURL = baseURL
    self.cancellables = .init()
  }
}
