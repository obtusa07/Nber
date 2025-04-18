//
//  TransportHomeViewController.swift
//  Transport
//
//  Created by Taehwan Kim on 4/15/25.
//

import ModernRIBs
import UIKit
import NberUI

protocol TransportHomePresentableListener: AnyObject {
  func didTapBack()
  func didTapRideConfirmButton()
}

final class TransportHomeViewController: UIViewController, TransportHomePresentable, TransportHomeViewControllable {
  
  weak var listener: TransportHomePresentableListener?
  
  private let mapView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
//    imageView.image = UIImage(named: "map_seoul", in: .module, with: nil)
    imageView.image = UIImage(named: "map_tokyo", in: .module, with: nil)
    return imageView
  }()
  
  private let searchView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addShadowWithRoundedCorners(8)
    view.backgroundColor = .white
    return view
  }()
  
  private let departureLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    label.text = "自宅"
    return label
  }()
  
  private let destinationLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    label.text = "会社"
    return label
  }()
  
  private let arrowImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.tintColor = .black
    imageView.image = UIImage(
      systemName: "arrow.right",
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
    )
    return imageView
  }()
  
  private let rideTypeView: RideTypeView = {
    let view = RideTypeView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let nberPayView: NberPayView = {
    let view = NberPayView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .white
    button.roundCorners(25)
    button.tintColor = .black
    button.setImage(
      UIImage(
        systemName: "chevron.backward",
        withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
      ),
      for: .normal
    )
    button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  private let rideTypeStackView: UIStackView = {
    let stack = UIStackView()
    
    return stack
  }()
  
  private let paymentStackView: UIStackView = {
    let stack = UIStackView()
    
    return stack
  }()
  
  private let rideInfoPane: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    view.addShadowWithRoundedCorners()
    return view
  }()
  
  private lazy var rideConfirmButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("タクシーを呼ぶ", for: .normal)
    button.backgroundColor = .primaryRed
    button.tintColor = .white
    button.addTarget(self, action: #selector(didTapRideConfirmButton), for: .touchUpInside)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    return button
  }()
  
  private let separatorView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemGray6
    return view
  }()
  
  func setNberPayBalance(_ balanceText: String) {
    nberPayView.setBalanceText("現在の残高: \(balanceText)円")
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupViews()
  }
  
  private func setupViews() {
    view.addSubview(mapView)
    view.addSubview(searchView)
    searchView.addSubview(arrowImageView)
    searchView.addSubview(departureLabel)
    searchView.addSubview(destinationLabel)
    view.addSubview(backButton)
    view.addSubview(rideInfoPane)
    rideInfoPane.addSubview(rideTypeView)
    rideInfoPane.addSubview(nberPayView)
    rideInfoPane.addSubview(separatorView)
    rideInfoPane.addSubview(rideConfirmButton)
    
    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
      
      searchView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 10),
      searchView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
      searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      searchView.heightAnchor.constraint(equalToConstant: 50),
      
      departureLabel.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 60),
      departureLabel.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
      
      destinationLabel.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -60),
      destinationLabel.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
      
      rideInfoPane.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      rideInfoPane.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      rideInfoPane.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      rideInfoPane.topAnchor.constraint(equalTo: mapView.bottomAnchor),
      
      backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      backButton.widthAnchor.constraint(equalToConstant: 50),
      backButton.heightAnchor.constraint(equalToConstant: 50),
      
      arrowImageView.centerXAnchor.constraint(equalTo: searchView.centerXAnchor),
      arrowImageView.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
      
      rideTypeView.leadingAnchor.constraint(equalTo: rideInfoPane.leadingAnchor, constant: 30),
      rideTypeView.trailingAnchor.constraint(equalTo: rideInfoPane.trailingAnchor, constant: -30),
      rideTypeView.topAnchor.constraint(equalTo: rideInfoPane.topAnchor, constant: 10),
      rideTypeView.heightAnchor.constraint(equalToConstant: 70),
      
      separatorView.topAnchor.constraint(equalTo: rideTypeView.bottomAnchor),
      separatorView.leadingAnchor.constraint(equalTo: rideInfoPane.leadingAnchor),
      separatorView.trailingAnchor.constraint(equalTo: rideInfoPane.trailingAnchor),
      separatorView.heightAnchor.constraint(equalToConstant: 1),
      
      nberPayView.leadingAnchor.constraint(equalTo: rideInfoPane.leadingAnchor, constant: 30),
      nberPayView.trailingAnchor.constraint(equalTo: rideInfoPane.trailingAnchor, constant: -30),
      nberPayView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0),
      nberPayView.bottomAnchor.constraint(equalTo: rideConfirmButton.topAnchor),
      
      rideConfirmButton.leadingAnchor.constraint(equalTo: rideInfoPane.leadingAnchor, constant: 30),
      rideConfirmButton.trailingAnchor.constraint(equalTo: rideInfoPane.trailingAnchor, constant: -30),
      rideConfirmButton.bottomAnchor.constraint(equalTo: rideInfoPane.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      rideConfirmButton.heightAnchor.constraint(equalToConstant: 60)
    ])
  }
  
  @objc
  private func backButtonDidTap() {
    listener?.didTapBack()
  }
  
  @objc
  private func didTapRideConfirmButton() {
    listener?.didTapRideConfirmButton()
  }
}
