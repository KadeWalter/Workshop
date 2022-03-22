//
//  SceneDelegate.swift
//  CollectionViewDemo
//
//  Created by Kade Walter on 3/22/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        
        let navCont = UINavigationController(rootViewController: ViewController())
        navCont.navigationBar.prefersLargeTitles = false
        
        window.rootViewController = navCont
        window.makeKeyAndVisible()
        self.window = window
    }
}
