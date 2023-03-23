//
//  DebugIcon.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/3/23.
// floating在屏幕上的icon。点击打开debug菜单页面

import Foundation

class DebugIcon : UIView {
    static let shared = DebugIcon()
    
    private init() {
        super.init(frame: CGRect.zero)
        guard let topView = UIApplication.shared.windows.first else {return}
        frame = CGRect(x: topView.center.x, y: topView.center.y, width: 50, height: 50)
        topView.addSubview(self)
        topView.bringSubviewToFront(self) // 把self放在window上，以便全局展示
        backgroundColor = .gray
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
