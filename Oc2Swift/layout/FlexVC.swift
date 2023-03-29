//
//  FlexVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/11/16.
//

import Foundation
import SnapKit

class FlexCell : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bgView = UIButton()
        bgView.backgroundColor = .systemPink
        self.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.right.equalTo(self)
            make.height.equalTo(22)
        }
        bgView.setTitle("just test", for: UIControl.State.normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FlexVC : BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgView = UIView()
        bgView.backgroundColor = .yellow
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(12)
            make.right.equalTo(view).offset(-12)
            make.top.equalTo(view).offset(88)
            make.height.equalTo(50)
        }
        
        let horizontal = UIStackView(arrangedSubviews: [
            FlexCell(frame: CGRect.zero),
            FlexCell(frame: CGRect.zero),
            FlexCell(frame: CGRect.zero),
            FlexCell(frame: CGRect.zero),
        ])
        horizontal.distribution = UIStackView.Distribution.equalSpacing
        bgView.addSubview(horizontal)
        horizontal.snp.makeConstraints { make in
            make.edges.equalTo(bgView)
        }
        horizontal.backgroundColor = .green
    }
}
