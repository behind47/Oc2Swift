//
//  TouchEventVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/3/25.
//
/// 首先，约定视图层级：
/// 1. 父视图与子视图。
/// 2. 底层是父视图，最底层是UIApplication。顶层是子视图，离手指最近的是最顶层视图。
/// 3. 同一层级内的视图也会有分层。后addSubView的在上。避免混淆，约定父子视图是不同“级”的视图，同“级”视图内添加顺序不同的视图，是不同“层”的视图。
///
/// 测试一下触摸事件传递的流程。
/// - (void)hitTest:(UIView*)view Point:(CGPoint)point;
/// - (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event;
/// 1. 这两个方法，在父视图和子视图，先后调用的顺序。
/// 2. 如果点击在视图外，会如何？
/// 3. 如果子视图在父视图外，会如何？
/// 4. 如果两个同级不同层视图，一个在另一个上面，会如何？
///
/// 结论：
/// 1. 同一个UIView，先调用hitTest，再在hitTest内调用pointInside，根据pointInside的返回结果决定hitTest的返回结果。hitTest方法，先调用子视图的，再调用父视图的。pointInside方法，先调用父视图的，再调用子视图的。
/// 2. 如果点击在view外，pointInside会返回false，表示点击不在view内。注意，如果父视图返回false，就不调用子视图的方法了。于是hitTest返回nil，表示view不响应点击。
/// 3.如果子视图在父视图外，点击子视图，父视图会pointInside返回false，不传递到子视图，于是父视图hitTest返回nil，不接受触摸事件。
/// 4.如果两个同级不同层视图，一个在另一个上面，那点击上面那个视图，会调用它的pointInside返回true，然后调用hitTest返回自身，接收点击事件；如果点击下面那个视图，上面那个视图会pointInside返回false，hitTest返回nil，不接受点击事件，下面那个视图会pointInside返回true，然后调用hitTest返回自身，接收点击事件。

import Foundation

class TouchEventVC : BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 这两个方法，在父视图superView和子视图subView，先后调用的顺序。
        let grandSuperView = GrandSuperView()
        grandSuperView.backgroundColor = .yellow
        grandSuperView.identifier = "grandSuperView"
        view.addSubview(grandSuperView)
        grandSuperView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(30)
            make.width.equalTo(100)
            make.height.equalTo(80)
            make.top.equalTo(view).offset(Device.statusBarHeight + 50)
        }
        
        let superView = SuperView()
        superView.backgroundColor = .green
        superView.identifier = "superView"
        grandSuperView.addSubview(superView)
        superView.snp.makeConstraints { make in
            make.left.top.equalTo(grandSuperView).offset(10)
            make.right.bottom.equalTo(grandSuperView).offset(-10)
        }
        
        let subView = SubView()
        subView.backgroundColor = .red
        subView.identifier = "subView"
        superView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.left.top.equalTo(superView).offset(10)
            make.right.bottom.equalTo(superView).offset(-10)
        }
        
        /// 如果子视图subView2在父视图superView2外，会如何？
        let superView2 = SuperView()
        superView2.backgroundColor = .yellow
        superView2.identifier = "superView2"
        view.addSubview(superView2)
        superView2.snp.makeConstraints { make in
            make.left.equalTo(view).offset(30)
            make.width.equalTo(100)
            make.height.equalTo(80)
            make.top.equalTo(grandSuperView.snp.bottom).offset(50)
        }
        
        let subView2 = SubView()
        subView2.backgroundColor = .green
        subView2.identifier = "subView2"
        superView2.addSubview(subView2)
        subView2.snp.makeConstraints { make in
            make.left.equalTo(superView2.snp.right).offset(10)
            make.top.equalTo(superView2).offset(10)
            make.bottom.equalTo(superView2).offset(-10)
            make.right.equalTo(view).offset(-10)
        }
        
        /// 如果两个同级视图，一个subView3在另一个superView3上面，会如何？
        /// 1. 点击subView3，只调用subView3的hitTest与pointInside。pointInside返回true，表示触摸事件发生在subView3内，而subView3没有子视图，于是hitTest返回subView3自身。
        /// 2. 点击superView3，首先调用subView3的hitTest与pointInside。pointInside返回false，表示触摸事件发生在subView3外，于是hitTest返回nil；其次，调用superView3的hitTest与pointInside。pointInside返回true，表示触摸事件发生在superView3内，而superView3没有子视图，于是hitTest返回superView3自身。
        /// 3. 点击外部，首先调用subView3的hitTest与pointInside。pointInside返回false，表示触摸事件发生在subView3外，于是hitTest返回nil；其次调用superView3的hitTest与pointInside。pointInside返回false，表示触摸事件发生在superView3外，于是hitTest返回nil；接着调用superView2的hitTest与pointInside。pointInside返回false，表示触摸事件发生在superView2外，于是hitTest返回nil；最后调用grandSuperView的hitTest与pointInside。pointInside返回false，表示触摸事件发生在superView2外，于是hitTest返回nil。
        /// 4. 综上，触摸事件的分发是一个广度优先搜索（WFS）。点击事件发生后，先按照view级，自底向上递归调用hitTest。如果pointInside返回false，则hitTest返回nil，递归终止在这一级，返回上一级。对于同一级的view，自顶向下遍历调用hitTest。如果pointInside返回false，则hitTest返回nil，遍历下一层。
        let superView3 = SuperView()
        superView3.backgroundColor = .yellow
        superView3.identifier = "superView3"
        view.addSubview(superView3)
        superView3.snp.makeConstraints { make in
            make.left.equalTo(view).offset(30)
            make.width.equalTo(100)
            make.height.equalTo(80)
            make.top.equalTo(superView2.snp.bottom).offset(50)
        }
        
        let subView3 = SubView()
        subView3.backgroundColor = .green
        subView3.identifier = "subView3"
        view.addSubview(subView3)
        subView3.snp.makeConstraints { make in
            make.left.top.equalTo(superView3).offset(10)
            make.right.bottom.equalTo(superView3).offset(-10)
        }
    }
}

private class SubView : UIView {
    var identifier : String?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("⚠️⚠️\(Self.self) \(identifier ?? "") \(#function)")
        let res = super.hitTest(point, with: event)
        print("⚠️⚠️\(Self.self) \(identifier ?? "") \(#function) \(res)")
        return res
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        print("⚠️⚠️\(Self.self) \(identifier ?? "") \(#function)")
        let res = super.point(inside: point, with: event)
        print("⚠️⚠️\(Self.self) \(identifier ?? "") \(#function) \(res)")
        return res
    }
}

private class SuperView : UIView {
    var identifier : String?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("⚠️⚠️\(Self.self) \(identifier ?? "") \(#function)")
        let res = super.hitTest(point, with: event)
        print("⚠️⚠️\(Self.self) \(identifier ?? "") \(#function) \(res)")
        return res
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        print("⚠️⚠️\(Self.self) \(identifier ?? "") \(#function)")
        let res = super.point(inside: point, with: event)
        print("⚠️⚠️\(Self.self) \(identifier ?? "") \(#function) \(res)")
        return res
    }
}

private class GrandSuperView : UIView {
    var identifier : String?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("⚠️⚠️\(Self.self) \(identifier ?? "") \(#function)")
        let res = super.hitTest(point, with: event)
        print("⚠️⚠️\(Self.self) \(identifier ?? "") \(#function) \(res)")
        return res
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        print("⚠️⚠️\(Self.self) \(identifier ?? "") \(#function)")
        let res = super.point(inside: point, with: event)
        print("⚠️⚠️\(Self.self) \(identifier ?? "") \(#function) \(res)")
        return res
    }
}

