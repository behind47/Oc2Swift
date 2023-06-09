//
//  CustomDrawUIViewVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/6/9.
//
/// 重写UIView的draw(_ rect: CGRect)，可以在UIView的矩形rect里绘制图像。
///

import Foundation
import SnapKit

class CustomDrawUIViewVC : BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CustomUIView()
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(50)
            make.top.equalTo(self.view).offset(100)
            make.width.height.equalTo(100)
        }
    }
}

class CustomUIView : UIView {
    /// 传入一个当前UIView对象的bound，以便绘制时能获取画布的相对位置
    override func draw(_ rect: CGRect) {
        /// 画个上半部红色，下半部绿色的矩形
        /// UIGraphicsGetCurrentContext用来获取一个CGContext对象，这是一个画布，可以指定画笔的颜色、宽度，然后填充画布上指定的范围。
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1)
        context?.setFillColor(UIColor.red.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: rect.width, height: rect.height/2))
        
        context?.setFillColor(UIColor.green.cgColor)
        context?.fill(CGRect(x: 0, y: rect.height/2, width: rect.width, height: rect.height/2))
    }
}
