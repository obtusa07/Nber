//
//  SetupURLProtocol.swift
//  Nber
//
//  Created by Taehwan Kim on 4/14/25.
//

import Foundation

func setupURLProtocol() {
  let topupResponse: [String: Any] = [
    "status": "success"
  ]
  
  let topupResponseData = try! JSONSerialization.data(withJSONObject: topupResponse, options: [])
  let addCardResponse: [String: Any] = [
    "card": [
      "id": "999",
      "name": "ニューカード",
      "digits": "**** 0101",
      "color": "",
      "isPrimary": false
    ]
  ]
  let addCardResponseData = try! JSONSerialization.data(withJSONObject: addCardResponse, options: [])
  let cardOnFileResponse: [String: Any] = [
    "cards": [
      ["id": "0",
       "name": "A銀行",
       "digits": "1233",
       "color": "#f19a38ff",
       "isPrimary": false
      ],
      [
        "id": "1",
        "name": "Bバンク",
        "digits": "0987",
        "color": "#65c466ff",
        "isPrimary": false
      ],
      [
        "id": "2",
        "name": "C銀行",
        "digits": "3328",
        "color": "#3478f6ff",
        "isPrimary": false
      ]
    ]
  ]
  let cardOnFileResponseData = try! JSONSerialization.data(withJSONObject: cardOnFileResponse, options: [])
  SuperAppURLProtocol.successMock = [
    "/api/v1/topup": (200, topupResponseData),
    "/api/v1/addCard": (200, addCardResponseData),
    "/api/v1/cards": (200, cardOnFileResponseData)
  ]
}
