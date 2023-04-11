//
//  CordinateVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/4/7.
//
/// 需要探究的问题：
/// 1. window里添加view，坐标的原点在何处。
/// 2. viewController.view里添加view，坐标的原点在何处。
/// 3. UIScrollView里添加view，坐标的原点在何处。
///
/// 结论：
/// 1. window里添加view，坐标的原点在屏幕左上角。
/// 2. viewController.view里添加view，坐标的原点也在屏幕左上角。view和1里的view重合。
/// 3. UIScrollView里添加view，坐标的原点在contentView的左上角。contentOffset是scrollView的左上角在contentView中的坐标。所以，以UIScrollView的左上角作为原点，view的坐标是view.frame-contentOffset。

import Foundation

class CordinateVC : BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewInVC = UIView()
        viewInVC.backgroundColor = .green
        self.view.addSubview(viewInVC)
        viewInVC.frame = CGRect(x: 50, y: 50, width: 100, height: 80)
        
        let viewInWindow = UIView()
        viewInWindow.backgroundColor = .systemPink
        guard let topView = UIApplication.shared.windows.first else {return}
        topView.addSubview(viewInWindow)
        viewInWindow.frame = CGRect(x: 50, y: 50, width: 100, height: 80)
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.frame = CGRect(x: 50, y: 200, width: 400, height: 400)
        scrollView.contentSize = CGSize(width: 800, height: 800)
        scrollView.backgroundColor = .yellow
        scrollView.contentOffset = CGPoint(x: 50, y: 50)
        
        let viewInScrollView = UIView()
        viewInScrollView.backgroundColor = .blue
        scrollView.addSubview(viewInScrollView)
        viewInScrollView.frame = CGRect(x: 20, y: 20, width: 100, height: 80)
    }
}
