//
//  ImageVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/8/2.
//
/// 图像加载，用SDWebImage

import Foundation

class ImageVC : BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        let imageView = UIImageView(frame: CGRect.zero)
        self.view.addSubview(imageView)
        imageView.sd_setImage(with:
                                URL(string: "https://bkimg.cdn.bcebos.com/pic/f9dcd100baa1cd11397333cabf12c8fcc2ce2d16?x-bce-process=image/watermark,image_d2F0ZXIvYmFpa2U4MA==,g_7,xp_5,yp_5/format,f_auto"),
                              placeholderImage: UIImage(named: "cat.webp"),
                              options: SDWebImageOptions.refreshCached,
                              completed: nil)
        imageView.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(50)
            make.top.equalTo(self.view).offset(200)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
    }
    
    func initNavigation() {
        navigationItem.title = "图片加载"
        navigationItem.backButtonTitle = "back"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.bookmarks, target: self, action: nil)
    }
}
