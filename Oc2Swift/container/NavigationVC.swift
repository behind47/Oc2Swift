//
//  NavigationVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/27.
//

import Foundation

public class NavigationVC : UINavigationController, UINavigationControllerDelegate {
    // remove the topmost view controller using the back button or using a left-edge swipe gesture
 
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.barStyle = UIBarStyle.default
        navigationBar.backgroundColor = .white
        isToolbarHidden = true
        isNavigationBarHidden = false
        modalPresentationStyle = UIModalPresentationStyle.fullScreen
    }
}
