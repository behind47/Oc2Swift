//
//  AnimationVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/26.
//

import Foundation

public class AnimationVC : UIViewController {
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 0, y: 100, width: 20, height:50))
        button.backgroundColor = .green
        button.setTitle("基本动画", for: UIControl.State.normal)
        self.view.addSubview(button)
        UIView.animate(withDuration: 3) {
            button.frame = CGRect(x: 50, y: 200, width: 100, height: 100)
        }
    }
}
