//
//  ImageUtil.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/7/18.
//
// 图片处理工具

import Foundation

public class ImageUtil {
    /// 将source叠加到dest上，返回叠加的图片
    /// @param angle 叠加的夹角
    func combine(from source : UIImage, to dest : UIImage, angle: CGFloat) -> UIImage? {
        if __CGSizeEqualToSize(source.size, dest.size) {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(source.size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        dest.draw(at: CGPoint.zero)
        CGContext.translateBy(ctx)(x: source.size.width/2, y: source.size.height/2)
        CGContext.rotate(ctx)(by: angle)
        CGContext.translateBy(ctx)(x: -source.size.width/2, y: -source.size.height/2)
        source.draw(at: CGPoint.zero)
        let res = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return res
    }
}
