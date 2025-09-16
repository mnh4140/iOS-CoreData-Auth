//
//  SceneDelegate.swift
//  CoreDataAuth
//
//  Created by NH on 8/20/25.
//

enum views {
    case login
    case main
    case signUp
    
    var vc: UIViewController {
        switch self {
        case .login:
            return LoginViewController()
        case .main:
            return MainViewController()
        case .signUp:
            return SignUpViewController()
        }
    }
}

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let session = DefaultSessionStore()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .white
        self.window = window
        
        // 1) 세션에 저장된 유저 ID 확인
        if let userId = self.session.currentUserId,
           CoreDataManager.shared.fetchUserID(id: userId) != nil {
            // 2) 유효한 유저면 메인으로
            setRoot(MainViewController())
        } else {
            // 세션은 있지만 CoreData에 유저가 없다면 -> 안전하게 정리
            self.session.clear()
            setRoot(LoginViewController())
        }
    }
    
    private func setRoot(_ vc: UIViewController, animated: Bool = false) {
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        guard animated, let window = window else { return }
        UIView.transition(with: window,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

