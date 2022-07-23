//
//  MyPageControllerVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/22.
//
/// 提供预置的切换动画

import Foundation
import UIKit


open class MyPageControllerVC : UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var childVCs : [BaseVC]
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public init() {
        childVCs = [BaseVC]()
        super.init(nibName: nil, bundle: nil)
    }
    
    open override func viewDidLoad() {
        childVCs = [HomePage(), Contacts(), Personal()]
        super.viewDidLoad()
        let myPageController = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll,
                                                    navigationOrientation: UIPageViewController.NavigationOrientation.horizontal,
                                                    options: [UIPageViewController.OptionsKey.spineLocation: UIPageViewController.SpineLocation.min.rawValue])//这里如果不用rawValue就会报错[__SwiftValue integerValue]: unrecognized selector sent to instance
        myPageController.delegate = self
        myPageController.dataSource = self
        myPageController.setViewControllers([childVCs[0]], direction: UIPageViewController.NavigationDirection.forward, animated: true) { whatisthis in
            print("myPageController set viewControllers done \(whatisthis)")
        }
        self.addChild(myPageController)
        self.view.addSubview(myPageController.view)
        myPageController.view.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    
    // MARK: UIPageViewControllerDataSource
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = childVCs.firstIndex(of: viewController as! BaseVC)
        if (index != nil && index! > 0) {
            return childVCs[index!-1]
        }
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = childVCs.firstIndex(of: viewController as! BaseVC)
        if (index != nil && index! < childVCs.count-1) {
            return childVCs[index!+1]
        }
        return nil
    }
}
