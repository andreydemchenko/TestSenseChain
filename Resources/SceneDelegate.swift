//
//  SceneDelegate.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 22.11.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead)
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.value(forKey: "accessToken") == nil {
            userDefaults.set("", forKey: "accessToken")
            userDefaults.set("", forKey: "refreshToken")
        }
        
        let accessToken = userDefaults.string(forKey: "accessToken") ?? ""
        let refreshToken = userDefaults.string(forKey: "refreshToken") ?? ""
        
        checkAccess(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    func checkAccess(accessToken: String, refreshToken: String) {
        appContext.authentication.testQuery(accessToken: accessToken) { [weak self] res in
            switch res {
            case let .success(model):
                if model.data != nil {
                    DispatchQueue.main.async {
                        let result = ResponseAuthModel(data: DataResponseAuthModel(access_token: accessToken, refresh_token: refreshToken))
                        self?.openTheDesiredController(isAuthorized: true, result: result)
                    }
                } else {
                    self?.refreshToken(refreshToken: refreshToken)
                }
            case let .failure(error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.openTheDesiredController(isAuthorized: false, result: nil)
                }
            }
        }
    }
    
    func refreshToken(refreshToken: String) {
        appContext.authentication.refreshToken(refreshToken: refreshToken) { [weak self] res in
            switch res {
            case let .success(model):
                if model.data != nil {
                    self?.saveData(model: model)
                    DispatchQueue.main.async {
                        self?.openTheDesiredController(isAuthorized: true, result: model)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.openTheDesiredController(isAuthorized: false, result: nil)
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.openTheDesiredController(isAuthorized: false, result: nil)
                }
            }
        }
    }
    
    func openTheDesiredController(isAuthorized: Bool, result: ResponseAuthModel?) {
        if isAuthorized {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as?
            MainTabBarController
            guard let vc else { return }
            //vc.presenter = ContractsPresenter(view: vc, result: result)
            let navController = UINavigationController(rootViewController: vc)
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        } else {
            let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInViewController
            let navController = UINavigationController(rootViewController: vc ?? SignInViewController())
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        }
    }
    
    func saveData(model: ResponseAuthModel?) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "isUserLoggedIn")
        userDefaults.set(model?.data?.access_token, forKey: "accessToken")
        userDefaults.set(model?.data?.refresh_token, forKey: "refreshToken")
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
    }


}

