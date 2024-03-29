//
//  FocusIcon.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/4/3.
/// 组件检查工具，用来定位组件的⭕️。
/// 包含一个⭕️——focusView，一个显示组件信息的panel——focusPanel
///
/// 需要解决的问题：
/// 1. 从根视图开始做BFS，可以找到最接近focusView的级。但是同一级上有多层重叠的view，如何判断哪一个view在上面呢？——经过测试，发现subViews是一个有序数组，同一级的view在subViews里，排在后面的是上层view。
/// 2. focusView所在的window上的坐标，和view所在的vc.view里的坐标似乎不是一个坐标轴的。用view的frame判断focusView是否在其中，存在误差。在scrollView里的view也会有误差。有系统API可以直接获取view在window坐标系里的坐标吗？还是只能从根视图开始计算view的坐标呢？
///
/// 可以改进的点：
/// 1. 取色器模式可以换个准心，增加长按显示方法镜的效果。

import Foundation
import SwiftUI
import SnapKit

enum FocusIconType {
    case color // 取色器
    case component // 组件检查器
    case rod // 对齐标尺
}

/// 找到FocusIcon定位坐标上，最上层的UIView，最上层包含层与级两个概念
class FocusIcon : UIView {
    static let shared = FocusIcon()
    var debugMenu : FocusIcon!
    var focusView : UIView // 准心
    var focusPanel : UIView // 显示信息的panel
    var focusLabel : UILabel
    let closeBtn : UIButton
    var targetView : UIView? // 准心选中的最上层view
    var type : FocusIconType = FocusIconType.color
    var image : UIImage? // 截屏的图片
    let horizontalRod : UIView // 水平标尺
    let verticalRod : UIView // 竖直标尺
    
    func show(type: FocusIconType) {
        self.type = type
        if type == FocusIconType.color {
            guard let screen = UIApplication.shared.windows.first else {return}
            UIGraphicsBeginImageContext(screen.frame.size)
            guard let context = UIGraphicsGetCurrentContext() else {return}
            screen.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageView = UIImageView(image: image)
            screen.insertSubview(imageView, belowSubview: self)
            imageView.snp.makeConstraints { make in
                make.edges.equalTo(screen)
            }
        } else if type == FocusIconType.rod {
            horizontalRod.isHidden = false
            verticalRod.isHidden = false
            updateDetail()
        }
        isHidden = false
    }
    
    private init() {
        focusView = UIView()
        focusPanel = UIView()
        focusLabel = UILabel()
        closeBtn = UIButton()
        horizontalRod = UIView()
        verticalRod = UIView()
        super.init(frame: CGRect.zero)
        guard let topView = UIApplication.shared.windows.first else {return}
        topView.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalTo(topView)
        }
        topView.bringSubviewToFront(self) // 把self放在window上，以便全局展示
        topView.backgroundColor = .gray
        
        addSubview(focusView)
        focusView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drageMove)))
        focusView.backgroundColor = .red
        focusView.snp.makeConstraints { make in
            make.center.equalTo(CGPoint(x: topView.frame.width/2, y: topView.frame.height/2))
            make.width.height.equalTo(50)
        }
        
        addSubview(focusPanel)
        focusPanel.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drageMove)))
        focusPanel.backgroundColor = .green
        focusPanel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20)
            make.right.bottom.equalTo(self).offset(-20)
        }
        
        focusLabel.numberOfLines = 0
        focusPanel.addSubview(focusLabel)
        focusPanel.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
        focusLabel.snp.makeConstraints { make in
            make.left.top.equalTo(focusPanel).offset(10)
            make.right.bottom.equalTo(focusPanel).offset(-10)
            make.height.greaterThanOrEqualTo(focusLabel)
            make.height.greaterThanOrEqualTo(100)
        }
        
        focusPanel.addSubview(closeBtn)
        closeBtn.setBackgroundImage(UIImage(named: "close.png"), for: UIControl.State.normal)
        closeBtn.addTarget(self, action: #selector(closeFocusIcon), for: UIControl.Event.touchUpInside)
        closeBtn.snp.makeConstraints { make in
            make.right.equalTo(focusPanel).offset(-5)
            make.top.equalTo(focusPanel).offset(5)
            make.width.height.equalTo(10)
        }
        
        self.addSubview(horizontalRod)
        horizontalRod.snp.makeConstraints { make in
            make.centerY.equalTo(focusView)
            make.height.equalTo(1)
            make.left.right.equalTo(self)
        }
        horizontalRod.backgroundColor = .gray
        horizontalRod.isHidden = true
        self.addSubview(verticalRod)
        verticalRod.snp.makeConstraints { make in
            make.top.bottom.equalTo(self)
            make.width.equalTo(1)
            make.centerX.equalTo(focusView)
        }
        verticalRod.backgroundColor = .gray
        verticalRod.isHidden = true
        
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Event
    @objc func closeFocusIcon() {
        isHidden = true
    }
    
    @objc func drageMove(_ recognizer : UIPanGestureRecognizer) {
        guard let sender = recognizer.view else { return }
        let translation = recognizer.translation(in: sender) // 点击位置与sender原来位置的偏移值
        
        if recognizer.state == UIPanGestureRecognizer.State.changed {
            sender.snp.updateConstraints { make in
                make.center.equalTo(CGPoint(x: sender.center.x + translation.x, y: sender.center.y + translation.y))
            }
            recognizer.setTranslation(CGPoint.zero, in: sender)
            updateDetail()
        }
    }
    
    var viewArr : [UIView] = []
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if type == FocusIconType.component {
            guard let topView = UIApplication.shared.windows.first else {return}
            var tmpView : UIView = topView
            /// 从根节点开始，遍历每一个层级，找到包含point的层级最高的view
            var array = Array<UIView>()
            array.append(tmpView)
            while array.count > 0 {
                tmpView = array.popLast()!
                tmpView.subviews.forEach { view in
                    if point(point: focusView.center, inside: view) {
                        array.append(view)
                    }
                }
            }
            targetView = tmpView
            updateDetail()
        } else if type == FocusIconType.color {
            updateDetail()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    /// point是否在view里
    func point(point: CGPoint, inside view: UIView) -> Bool {
        /// 先把view的坐标换算到point所在坐标系，即window坐标系
        var x = view.frame.origin.x
        var y = view.frame.origin.y
        /// 递归到Window，计算view左上角相对于window左上角的偏移量
        var tmpView = view.superview
        while !(tmpView?.isKind(of: UIWindow.self) ?? true) {
            x += tmpView!.frame.origin.x
            y += tmpView!.frame.origin.y
            if tmpView!.isKind(of: UIScrollView.self) {
                let tmpScrollView = tmpView as! UIScrollView
                x -= tmpScrollView.contentOffset.x
                y -= tmpScrollView.contentOffset.y
            }
            tmpView = tmpView!.superview
        }
        if x < point.x && x + view.frame.size.width > point.x
            && y < point.y && y + view.frame.size.height > point.y {
            return true
        }
        return false
    }
    
    /// 更新显示的信息
    func updateDetail() {
        if type == FocusIconType.component {
            guard let view = targetView else {return}
            view.backgroundColor = .systemPink // TODO: 用边框代替背景色
            focusLabel.text = "\(view.self)"
        } else if type == FocusIconType.color {
            focusLabel.text = "color: \(colorAt(point: focusView.center, in: image))"
        } else if type == FocusIconType.rod {
            focusLabel.text = "point: \(focusView.center)"
        }
    }
    
    /// 获取图像坐标point像素的色值
    /// @param point 目标像素的坐标
    /// @param inImage 目标图像
    func colorAt(point: CGPoint, in inImage : UIImage?) -> String {
        guard let image = inImage, CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height).contains(point) else { // 因为都是window坐标系的，所以可以这样直接判断
            return "point not in image"
        }
        let pointX = Int(trunc(point.x))
        let pointY = Int(trunc(point.y))
        guard let cgImage = image.cgImage else {
            return "cgImage is null"
        }
        let width = Int(cgImage.width)
        let height = Int(cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerRow = 4 * 1
        let bitmapInfo : UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue|CGBitmapInfo.byteOrder32Big.rawValue
        let pixelData = UnsafeMutablePointer<UInt32>.allocate(capacity: width * height)
        pixelData.initialize(repeating: 0, count: width * height) // 需要始化内存缓冲区https://stackoverflow.com/questions/56801083/swift-version-get-wrong-pixels-data-but-the-object-c-version-get-the-right-pixel
        guard let context = CGContext(data: pixelData,
                                      width: 1,
                                      height: 1,
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo)
        else {
            return "point data is null"
        }
        context.translateBy(x: -CGFloat(pointX), y: CGFloat(pointY-height))
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        let hexColor = String.init(format: "#%02x%02x%02x", pixelData[0], pixelData[1], pixelData[2])
        pixelData.deallocate() // 记得释放内存
        return hexColor
    }
}
