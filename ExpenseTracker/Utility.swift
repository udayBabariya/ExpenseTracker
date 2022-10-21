//
//  Utility.swift
//  ExpenseTracker
//
//  Created by Uday on 21/10/22.
//

import UIKit

class Utility {
    
    struct UserDefaultsKey {
        static let isUserLoggedIn = "isUserLoggedIn"
    }
    
    class func setRootViewController() {
        isUserLoggedIn() ? setHomeScreenAsRootVC() : setLoginScreenAsRootVC()
    }
    
    class func setUserLoginStatus(_ status: Bool) {
        UserDefaults.standard.set(status, forKey: UserDefaultsKey.isUserLoggedIn)
        UserDefaults.standard.synchronize()
    }
    
    class func isUserLoggedIn() -> Bool {
        if let userLoginStatus = UserDefaults.standard.value(forKey: UserDefaultsKey.isUserLoggedIn) as? Bool {
            return userLoginStatus
        }
        return false
    }
    
    class func setLoginScreenAsRootVC() {
        guard let loginVC = UIStoryboard(name: "Login", bundle: .main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}
        let rootNavController = UINavigationController(rootViewController: loginVC)
        if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            delegate.window?.rootViewController = rootNavController
            delegate.window?.makeKeyAndVisible()
        }
    }
    
    class func setHomeScreenAsRootVC() {
        guard let homeVC = UIStoryboard(name: "Home", bundle: .main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {return}
        let rootNavController = UINavigationController(rootViewController: homeVC)
        if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            delegate.window?.rootViewController = rootNavController
            delegate.window?.makeKeyAndVisible()
        }
    }
}
