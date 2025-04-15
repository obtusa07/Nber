//
//  NetworkError.swift
//  Platform
//
//  Created by Taehwan Kim on 4/15/25.
//


import Foundation

public enum NetworkError: Error {
  case invalidURL(url: String?)
}
