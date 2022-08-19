//
//  TableViewOptimizationVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/8/18.
//
/// 优化的理念：1. 将与UI刷新无关的耗时操作放在子线程中处理。2. 尽量避免频繁的上下文切换影响性能。
/// 1. 图片的读取、解码放在子线程
/// 2. 用缓存减少图片的下载
/// 3. 在滑动结束后才开始图片加载（用runLoopMode.）
/// 4. 复用同类的Cell（可以用离屏渲染复用复杂的图形）

import Foundation

// 搞一些可以复用的cell来提升效率
class InfoCell : UITableViewCell {
    
    var avatar : UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        avatar = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.left.top.equalTo(contentView).offset(20)
            make.bottom.equalTo(contentView).offset(-20)
            make.height.equalTo(100)
        }
        avatar.backgroundColor = .green
    }
    
    func update(with model: InfoModel) -> Void {
        avatar.sd_setImage(with: URL(string: model.url)) { [self] image, error, cacheType, url in
            // TODO:在子线程中调整图片大小，节省在这里让图片适应约束大小的开销。
            let destImage = image?.sd_resizedImage(with: CGSize(width: 100, height: 100), scaleMode: SDImageScaleMode.aspectFit)
            print("isMainThread : \(Thread.isMainThread)")
            avatar.image = destImage
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct InfoModel {
    var url : String
}

class TableViewOptimizationVC : BaseVC, UITableViewDelegate, UITableViewDataSource {
    var tableView : UITableView!
    var infoModels : [InfoModel]!
    
    override func viewDidLoad() {
        tableView = UITableView()
        infoModels = [
            InfoModel(url: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg9.51tietu.net%2Fpic%2F2019-091302%2Fxgena3d4xz2xgena3d4xz2.jpg&refer=http%3A%2F%2Fimg9.51tietu.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663433979&t=c96b2b75bc32f8ef7caea7cb01870824"),
            InfoModel(url: "https://bkimg.cdn.bcebos.com/pic/f9dcd100baa1cd11397333cabf12c8fcc2ce2d16?x-bce-process=image/watermark,image_d2F0ZXIvYmFpa2U4MA==,g_7,xp_5,yp_5/format,f_auto"),
            InfoModel(url: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2F1114%2F0Q620141250%2F200Q6141250-5-1200.jpg&refer=http%3A%2F%2Fimg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663434012&t=fd4b22574268c591b08d50c4c8d76ed1"),
            InfoModel(url: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2F1114%2F0Q620141250%2F200Q6141250-5-1200.jpg&refer=http%3A%2F%2Fimg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663433979&t=ba95f52827d6730aedb1dbdf20f9e293"),
            InfoModel(url: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2F711%2F101913115423%2F131019115423-4-1200.jpg&refer=http%3A%2F%2Fimg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663433979&t=828bef1ff820102e387c38750f844978"),
            InfoModel(url: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F015ab755f00ed032f875a132a4d80b.JPG%401280w_1l_2o_100sh.jpg&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663433979&t=cd0fa5c016dc4a0b1970e50cedf18a24"),
            InfoModel(url: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01d0105779c6ac0000012e7e5f6e2d.JPG%401280w_1l_2o_100sh.jpg&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663433979&t=54e3f33dccc2aec1610b9eae699df04b"),
            InfoModel(url: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2F1114%2F0Q620141250%2F200Q6141250-12-1200.jpg&refer=http%3A%2F%2Fimg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663433979&t=f74589770164a8fe8453feed8a892e35"),
            InfoModel(url: "http://t15.baidu.com/it/u=1992447891,2595872700&fm=224&app=112&f=JPEG?w=500&h=500"),
            InfoModel(url: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2019-08-12%2F5d50fc1092338.jpg&refer=http%3A%2F%2Fpic1.win4000.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663433979&t=c4b519bd38a63b7dac84b518a6b50b3a"),
            InfoModel(url: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F015e4f55f00e0a6ac7251df8e6dffc.JPG%401280w_1l_2o_100sh.jpg&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663433979&t=d3bacd7cddb4a648ae7bcf40ab665067"),
            InfoModel(url: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2F1113%2F0F220091H1%2F200F2091H1-13-1200.jpg&refer=http%3A%2F%2Fimg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663433979&t=6c59b6737e9dd6e3593e481f9f64a8ca"),
            InfoModel(url: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farticle%2F4a30bcefbe1f216e719245583e221deb0c7a8437.jpg&refer=http%3A%2F%2Fi0.hdslb.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1663433979&t=949ac8ab97b09b2cff27af132f61ead8"),
        ]
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
        cell.update(with: infoModels[indexPath.row % infoModels.count])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
