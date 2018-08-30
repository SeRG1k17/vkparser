//
//  SceneCoordinatorType.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType: class {

    var window: UIWindow! { get set }
    var currentViewController: UIViewController? { get set }

    init()
    init(for window: UIWindow?)

    /// transition to another scene
    @discardableResult
    func transition(to scene: Sceneable, type: SceneTransitionType) -> Observable<Void>

    /// pop scene from navigation stack or dismiss current modal
    @discardableResult
    func pop(animated: Bool) -> Observable<Void>
}

extension SceneCoordinatorType {

    @discardableResult
    func pop() -> Observable<Void> {
        return pop(animated: true)
    }

    static func actualViewController(for viewController: UIViewController) -> UIViewController {

        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first!

        } else {
            return viewController
        }
    }
}

extension SceneCoordinatorType {

    init(for window: UIWindow?) {
        self.init()

        self.window = window ?? UIWindow(frame: UIScreen.main.bounds)
        currentViewController = window?.rootViewController
    }

    @discardableResult
    func transition(to scene: Sceneable, type: SceneTransitionType) -> Observable<Void> {

        let subject = PublishSubject<Void>()
        let viewController = scene.viewController

        switch type {
        case .root:
            currentViewController = SceneCoordinator.actualViewController(for: viewController)

            //let nav = UINavigationController(rootViewController: viewController)
            //window.rootViewController = nav
            window.rootViewController = viewController

            if !window.isKeyWindow { window?.makeKey() }
            if window.isHidden { window?.isHidden = false }

            subject.onCompleted()

        case .push:

            guard let navigationController = currentViewController?.navigationController else {
                subject.onError(TransitionError.push)
                return subject.asObservable()
            }

            if viewController is UINavigationController {
                //Or any error type
                subject.onError(TransitionError.push)
                return subject.asObservable()
            }

            // one-off subscription to be notified when push complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { parameters in
                    guard let didShowVC = parameters[1] as? UIViewController else { return }
                    self.currentViewController = SceneCoordinator.actualViewController(for: didShowVC)
                }
                .bind(to: subject)

            navigationController.pushViewController(viewController, animated: true)
            currentViewController = SceneCoordinator.actualViewController(for: viewController)

        case .modal:
            currentViewController?.present(viewController, animated: true) {
                subject.onCompleted()
            }
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
        }

        return subject.asObservable()
            .take(1)
        //.ignoreElements()
    }

    @discardableResult
    func pop(animated: Bool) -> Observable<Void> {

        let subject = PublishSubject<Void>()

        if let presenter = currentViewController?.presentingViewController {

            // dismiss a modal controller
            currentViewController?.dismiss(animated: animated) {
                self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
                subject.onCompleted()
            }

        } else if let navigationController = currentViewController?.navigationController {

            // navigate up the stack
            // one-off subscription to be notified when pop complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { parameters in
                    guard let didShowVC = parameters[1] as? UIViewController else { return }
                    self.currentViewController = SceneCoordinator.actualViewController(for: didShowVC)
                }
                .bind(to: subject)

            guard navigationController.popViewController(animated: animated) != nil else {
                subject.onError(TransitionError.pop(currentViewController))
                return subject.asObservable()
            }

            // swiftlint:disable line_length
            currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
            // swiftlint:enable: line_length

        } else {
            subject.onError(TransitionError.modal(currentViewController))
        }

        return subject.asObservable()
            .take(1)
        //.ignoreElements()
    }
}
