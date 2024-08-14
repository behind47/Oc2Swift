//
//  URLSessionMemoryVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2024/6/12.
//
/// receive data directly into memory by creating a data task from a URL session.
/// 1. simple situation, use URLSession.shared
/// 2. custom situation, create a session which implements URLSessionDelegate, config with a URLSessionConfiguration

import UIKit
import WebKit
import SnapKit

class URLSessionMemoryVC: BaseVC, URLSessionDataDelegate {
    
    var webView: WKWebView
    var loadButton: UIButton
    var loadButton2: UIButton
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init!(frame: CGRect) {
        loadButton = UIButton(type: UIButton.ButtonType.system)
        webView = WKWebView(frame: CGRectZero)
        loadButton2 = UIButton(type: UIButton.ButtonType.system)
        super.init(frame: frame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadButton.setTitle("用completion处理task的res", for: UIControl.State.normal)
        loadButton.addTarget(self, action: #selector(startLoad), for: UIControl.Event.touchUpInside)
        self.view?.addSubview(loadButton)
        loadButton.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(self.view).offset(80);
            make.right.equalTo(self.view).offset(-20);
            make.height.equalTo(24)
        }
        
        loadButton2.setTitle("用delegate处理task的res", for: UIControl.State.normal)
        loadButton2.addTarget(self, action: #selector(startLoad2), for: UIControl.Event.touchUpInside)
        self.view?.addSubview(loadButton2)
        loadButton2.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(loadButton.snp.bottom).offset(10);
            make.right.equalTo(self.view).offset(-20);
            make.height.equalTo(24)
        }
        
        self.view?.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(loadButton2.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    //MARK: create a task which uses a completion handler
    @objc func startLoad() {
        let url = URL(string: "https://www.jianshu.com/p/a8305f4cb686")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error { //
                self.handleClientError(error: error)
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                self.handleServerError(response: response)
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "text/html", let data = data, let string = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.webView.loadHTMLString(string, baseURL: url)
                }
            }
        }
        task.resume()
    }
    
    func handleClientError(error: Error?) {
        
    }
    
    func handleServerError(response: URLResponse?) {
        
    }
    
    var receiveData: Data?
    
    //MARK: receive transfer details and results with a delegate
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    @objc func startLoad2() {
        let url = URL(string: "https://www.jianshu.com/p/a8305f4cb686")!
        receiveData = Data()
        let task = session.dataTask(with: url)
        task.resume()
    }
    
    //MARK: URLSessionDataDelegate
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode),
              let mimeType = response.mimeType,
              mimeType == "text/html" else {
            completionHandler(.cancel)
            return
        }
        completionHandler(.allow)
    }
    
    private func urlSession(_ session: URLSession, task: URLSessionTask, didReceive data: Data) {
        self.receiveData?.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async { [self] in
            if let error = error {
                handleClientError(error: error)
            } else if let receiveData = self.receiveData,
                      let string = String(data: receiveData, encoding: .utf8) {
                self.webView.loadHTMLString(string, baseURL: task.currentRequest?.url)
            }
        }
    }
}


