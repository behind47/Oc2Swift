//
//  RunLoopVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/7.
//
/// 测试一个fake run loop的功能
/// Run Loop是iOS的消息机制、
/// Run Loop会监听多个输入，如果没有注册任何监听对象，则loop不会开启。
/// 否则，调用RunLoop.run()会开启一个while循环，每次循环都执行一次runMode:before，响应注册的监听对象的输入消息。
/// CFRunLoopStop可以停止正在执行的runMode:before
/// 主线程里启动了runloop，因此不会自动退出

import Foundation
import SnapKit

open class RunLoopVC : UIViewController {
    var commonThread : Thread
    var stopBtn : UIButton
    var commonRunLoop : RunLoop
    var shouldKeeping : Bool
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        commonThread = CommonThread()
        stopBtn = UIButton()
        commonRunLoop = RunLoop.current
        shouldKeeping = true
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        testRunLoop()
    }
    
    func testRunLoop() {
        print("🔞 START: \(Thread.current)")
        commonThread = CommonThread.init { [self] in
            print("🏃‍♀️🏃‍♀️ \(Thread.current)")
            
            commonRunLoop = RunLoop.current
            commonRunLoop.add(Port(), forMode: RunLoop.Mode.default) // 添加一个port到runloop监听的source1
//            commonRunLoop.run() // 如果没有监听输入事件，只是在这里run，loop也会退出
            while(shouldKeeping) { // commonRunLoop.run()相当于这个，while循环执行
                commonRunLoop.run(mode: RunLoop.Mode.default, before: Date.distantFuture)
            }
            
            print("♻️♻️  \(commonRunLoop) \(commonRunLoop)")
        }
        commonThread.start()
        view.addSubview(stopBtn)
        stopBtn.snp.makeConstraints { make in
            make.top.equalTo(view).offset(150)
            make.left.equalTo(view).offset(50)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        stopBtn.backgroundColor = .green
        stopBtn.addTarget(self, action: #selector(stopRunLoop(sender:)), for: UIControl.Event.touchUpInside)
        print("🔞 END: \(Thread.current)")
    }
    
    @objc
    func rocket(param: NSObject) {
        print("🚀🚀 \(Thread.current) param: \(param)")
    }
    
    @objc
    func stopRunLoop(sender: UIButton?) {
        print("🎏 stop loop START...")
        guard commonThread.isCancelled || commonThread.isFinished else {
            return perform(#selector(stopRunLoopEvent(param:)), on: commonThread, with: nil, waitUntilDone: true)
        }
        print("🎏 stop loop END...")
    }
    
    @objc
    func stopRunLoopEvent(param: NSObject) {
        print("🎏 stop loop START(EVENT)...")
        shouldKeeping = false
        /// RunLoop.run()会开启一个while循环，每次循环都执行一次runMode:before
        /// CFRunLoopStop可以停止正在执行的runMode:before
        CFRunLoopStop(CFRunLoopGetCurrent())
        print("🎏 stop loop END(EVENT)...")
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("📺📺 START...")
        perform(#selector(rocket(param:)), on: commonThread, with: nil, waitUntilDone: true)
        print("📺📺 END...")
    }
    
    deinit {
        stopRunLoop(sender: nil)
    }
}

open class CommonThread : Thread {
    open override class func exit() {
        print("🍀🍀🍀 \(#file) CommonThread \(#function)")
        super.exit()
    }
}
