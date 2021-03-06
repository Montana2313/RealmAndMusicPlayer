//
//  SceneDelegate.swift
//  MusicPlayerWork
//
//  Created by Mac on 25.07.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "path URL error")
        window = UIWindow(frame: UIScreen.main.bounds)
        var viewController = UIViewController()
        if UserDefaults.standard.string(forKey: "username") !=  nil{
            viewController = MusicPlayerViewController()
        }else {
            viewController = LoginVC()
        }
        let navigationController = UINavigationController()
        navigationController.viewControllers = [viewController]
        navigationController.navigationBar.isHidden = true
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        // Menu path yapılacak
        window?.makeKeyAndVisible()

        
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }


}

