//
//  KeyBoardVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/30.
//

import Foundation
import UIKit

class KeyBoardVC : BaseVC, UITextViewDelegate {
    
    var sendButton : UIButton!
    var outputView : UILabel!
    var myInputView: UITextView!
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton = UIButton(frame: CGRect.zero)
        sendButton.setTitle("Send", for: UIControl.State.normal)
        sendButton.backgroundColor = .blue
        sendButton.addTarget(self, action: #selector(sendMsg), for: UIControl.Event.touchUpInside)
        self.view.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(200)
            make.right.equalTo(self.view).offset(-10)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        
        myInputView = UITextView(frame: CGRect.zero)
        myInputView.delegate = self
        self.view.addSubview(myInputView)
        myInputView.backgroundColor = .gray
        myInputView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(200)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(sendButton.snp.left).offset(-10)
            make.height.equalTo(20)
        }
        
        outputView = UILabel(frame: CGRect.zero)
        self.view.addSubview(outputView)
        outputView.backgroundColor = .yellow
        outputView.numberOfLines = 0
        outputView.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        outputView.snp.makeConstraints { make in
            make.top.equalTo(myInputView.snp.top).offset(50)
            make.left.right.equalTo(self.view)
        }
    }
    
    @objc func sendMsg() {
        outputView.text = myInputView.text
        myInputView.text = ""
        myInputView.resignFirstResponder()
    }
    
    
    // MARK: UITextViewDelegate
    // Responding to Editing Notifications
//    @available(iOS 2.0, *)
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//
//    }
//
//    @available(iOS 2.0, *)
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//
//    }
//
//
//    @available(iOS 2.0, *)
//    func textViewDidBeginEditing(_ textView: UITextView) {
//
//    }
//
//    @available(iOS 2.0, *)
//    func textViewDidEndEditing(_ textView: UITextView) {
//
//    }

    // Responding to Text Changes
//    @available(iOS 2.0, *)
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//    }

    @available(iOS 2.0, *)
    func textViewDidChange(_ textView: UITextView) {
        
    }

    // Responding to Selection Changes
    @available(iOS 2.0, *)
    func textViewDidChangeSelection(_ textView: UITextView) {
        
    }

    // Interacting with Text Data
//    @available(iOS 10.0, *)
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        
//    }
//
//    @available(iOS 10.0, *)
//    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        
//    }
}
