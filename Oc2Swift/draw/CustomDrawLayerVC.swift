//
//  CustomDrawLayerVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/6/9.
//

import Foundation
import UIKit

class CustomDrawLayerVC : BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        let layer = CustomCALayer()
        layer.frame = CGRect(x: 50, y: 100, width: 100, height: 100)
        self.view.layer.addSublayer(layer)
        layer.setNeedsDisplay() // 与UIView不同，需要手动触发绘制
    }
}


class CustomCALayer : CALayer {
    /// 当CALayer的contents属性更新后，调用display方法触发draw
    /// 没有default实现。ctx被裁减，以便保护无效的layer内容。
    /// 调用CGContextGetClipBoundingBox()来获取实际的绘画区域
    override func draw(in ctx: CGContext) {
        let rect = ctx.boundingBoxOfClipPath // 就是layer的bounds
        ctx.setFillColor(UIColor.red.cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: rect.width, height: rect.height/2))
        
        ctx.setFillColor(UIColor.green.cgColor)
        ctx.fill(CGRect(x: 0, y: rect.height/2, width: rect.width, height: rect.height/2))
    }
}
