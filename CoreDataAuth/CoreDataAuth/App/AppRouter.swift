//
//  AppRouter.swift
//  CoreDataAuth
//
//  Created by NH on 9/23/25.
//

import UIKit

enum AppRouter {

    /// 로그인 화면으로
    static func toLogin(in window: UIWindow? = activeWindow, animated: Bool = true) {
        let root = UINavigationController(rootViewController: LoginViewController())
        setRoot(root, in: window, animated: animated)
    }

    /// 메인 화면으로
    static func toMain(in window: UIWindow? = activeWindow, animated: Bool = true) {
        let root = UINavigationController(rootViewController: MainViewController())
        setRoot(root, in: window, animated: animated)
    }

    /// 실제 루트 교체
    static func setRoot(_ vc: UIViewController,
                        in window: UIWindow? = activeWindow,
                        animated: Bool = true) {
        guard let window = window else { return }
        if animated {
            UIView.transition(with: window,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { window.rootViewController = vc },
                              completion: nil)
        } else {
            window.rootViewController = vc
        }
        window.makeKeyAndVisible()
    }

    /// 포어그라운드의 키 윈도우를 안전하게 찾기 (iOS 13+ 멀티 씬 대응)
    private static var activeWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })?
            .windows.first(where: { $0.isKeyWindow })
    }
}
