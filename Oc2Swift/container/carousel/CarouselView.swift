//
//  CarouselView.swift
//  Oc2Swift
//
//  Created by behind47 on 2025/2/20.
//

import UIKit

class CarouselView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = randomColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 随机生成UIColor
    func randomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    override func copy() -> Any {
        guard let from = self as? CarouselView else {
            fatalError("Copy method called on an incompatible type")
        }
        
        let newCarouselView = CarouselView()
        newCarouselView.backgroundColor = from.backgroundColor
        
        return newCarouselView
    }
    
}
