//
//  ProfileHomeBuilder.swift
//  Profile
//
//  Created by Taehwan Kim on 3/30/25.
//

import ModernRIBs

public protocol ProfileHomeDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class ProfileHomeComponent: Component<ProfileHomeDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol ProfileHomeBuildable: Buildable {
  func build(withListener listener: ProfileHomeListener) -> ViewableRouting
}

public final class ProfileHomeBuilder: Builder<ProfileHomeDependency>, ProfileHomeBuildable {
  
  public override init(dependency: ProfileHomeDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: ProfileHomeListener) -> ViewableRouting {
    let _ = ProfileHomeComponent(dependency: dependency)
    let viewController = ProfileHomeViewController()
    let interactor = ProfileHomeInteractor(presenter: viewController)
    interactor.listener = listener
    return ProfileHomeRouter(interactor: interactor, viewController: viewController)
  }
}
