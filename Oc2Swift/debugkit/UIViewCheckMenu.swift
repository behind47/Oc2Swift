//
//  UIViewCheckMenu.swift
//  Oc2Swift
//
//  Created by behind47 on 2023/4/14.
//
/// UI组件边框检查器

import Foundation

class UIViewCheckMenu : UIView {
    var viewModels : [ViewModel]
    var fastCellList : FastCellList
    static let shared = UIViewCheckMenu()
    let closeBtn : UIButton
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private init() {
        viewModels = [ViewModel]()
        fastCellList = FastCellList()
        closeBtn = UIButton()
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    func show() {
        self.isHidden = false
        UIViewCheckConfig.shared.uiCheckStatus = !self.isHidden
    }
    
    func commonInit() {
        guard let topView = UIApplication.shared.windows.first else {return}
        topView.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalTo(topView)
        }
        topView.bringSubviewToFront(self) // 把self放在window上，以便全局展示
        self.addSubview(closeBtn)
        closeBtn.setBackgroundImage(UIImage(named: "close.png"), for: UIControl.State.normal)
        closeBtn.addTarget(self, action: #selector(closeFocusIcon), for: UIControl.Event.touchUpInside)
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(self).offset(Device.safeTopHeight)
            make.right.equalTo(self).offset(-10)
            make.height.width.equalTo(50)
        }
        self.addSubview(fastCellList)
        fastCellList.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(closeBtn.snp.bottom)
        }
        viewModels.append(ViewModel.init(title: "边框检查器开关", subTitle: "", identifier: "SwitchCell", switchBlock: { (isOn: Bool) in
            UIViewCheckConfig.shared.uiCheckStatus = !self.isHidden
            UIViewCheckConfig.shared.uiCheckOn = isOn
            UIApplication.shared.windows.forEach { window in
                window.recurseiveShowUIBorder(isOn)
            }
        }))
        fastCellList.updateWithViewModels(vms: viewModels)
        self.isHidden = true // 默认隐藏
        UIViewCheckConfig.shared.uiCheckStatus = !self.isHidden
    }
    
    // MARK: Event
    @objc func closeFocusIcon() {
        isHidden = true
        UIViewCheckConfig.shared.uiCheckStatus = !self.isHidden
    }
}

/// 保存<边框检查器开关>状态
class UIViewCheckConfig : NSObject {
    @objc static let shared = UIViewCheckConfig()
    @objc var uiCheckOn = false // 是否开启边框检查开关
    @objc var uiCheckStatus = false // 是否处于边框检查状态，在状态下修改uiCheckOn才会生效
    
    private override init() {
        super.init()
    }
}
