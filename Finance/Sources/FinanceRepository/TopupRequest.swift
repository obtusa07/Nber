//
//  TopupRequest.swift
//  Finance
//
//  Created by Taehwan Kim on 4/14/25.
//

import Foundation
import Network

struct TopupRequest: Request {
  typealias Output = TopupResponse
  
  let endpoint: URL
  let method: HTTPMethod
  let query: QueryItems
  let header: HTTPHeader
  
  init(baseURL: URL, amount: Double, paymentMethodID: String) {
    self.endpoint = baseURL.appendingPathComponent("/topup")
    self.method = .post
    self.query = [
      "amount": amount,
      "paymentMethodID": paymentMethodID
    ]
    self.header = [:]
  }
  
}

struct TopupResponse: Decodable {
  let status: String
}
