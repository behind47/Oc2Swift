//
//  CustomDrawMenuVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/6/9.
//
/// 自定义绘制有两种：
/// 1. 自定义CALayer，重写- (void)drawInContext:(CGContextRef)ctx;
/// 2. 自定义UIView，重写- (void)drawRect:(CGRect)rect;

import Foundation

class CustomDrawMenuVC : BaseMenuVC {
    override func commonInit() {
        viewModels.append(ViewModel.init(title: "自定义UIView", subTitle: "UIView绘制", callback: {
            self.navigationController?.pushViewController(CustomDrawUIViewVC(), animated: true)
        }))
        viewModels.append(ViewModel.init(title: "自定义CALayer", subTitle: "Layer绘制", callback: {
            self.navigationController?.pushViewController(CustomDrawLayerVC(), animated: true)
        }))
        super.commonInit()
    }
}

