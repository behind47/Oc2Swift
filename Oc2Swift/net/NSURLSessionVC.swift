//
//  NSURLSessionVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/8/4.
//

import Foundation

public class NSURLSessionVC : BaseVC, URLSessionDelegate {
    public override func viewDidLoad() {
        super.viewDidLoad()
//        testGet()
        testDownloadImage()
    }
    
    func testGet() -> Void {
        let url = URL(string: "https://bkimg.cdn.bcebos.com/pic/f9dcd100baa1cd11397333cabf12c8fcc2ce2d16?x-bce-process=image/watermark,image_d2F0ZXIvYmFpa2U4MA==,g_7,xp_5,yp_5/format,f_auto")
        let request = URLRequest.init(url: url!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if (error == nil) {
                if (data != nil) {
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data!)
                        print("\(#file) \(dict)")
                    } catch {
                        print("\(#file) \(String(describing: error))")
                    }
                }
            } else {
                print("\(#file) \(String(describing: error))")
            }
        }
        
        dataTask.resume()
    }
    
    func testDownloadImage() -> Void {
        let url = URL(string: "https://bkimg.cdn.bcebos.com/pic/f9dcd100baa1cd11397333cabf12c8fcc2ce2d16?x-bce-process=image/watermark,image_d2F0ZXIvYmFpa2U4MA==,g_7,xp_5,yp_5/format,f_auto")
        let request = URLRequest.init(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    // MARK: URLSessionDelegate
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
    }
}
