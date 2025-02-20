//
//  CarouselViewController.swift
//  Oc2Swift
//
//  Created by behind47 on 2025/2/19.
//
/// 轮播图的实现方法：
/// 1、基于UICollectionView实现，搞一个超大的数组，伪装无限滚动。每次切换cell时绘制cell。UICollectionView会管理cell缓存。
/// 2、基于UIScrollView实现，每次只能划动一页。在划动停止时计算所在的页，如果是第一页，就切换到最后一页，如果是最后一页，就切换到第一页。

import Foundation
import UIKit

class CarouselViewController: UIViewController, UIScrollViewDelegate {
    
    // 绘制一个轮播图，每一页是一个CarouselView对象，一共包含5页。
    var carouselViews: [CarouselView] = []
    var scrollView: UIScrollView!
    var currentPage: Int = 0
    var pageCount: Int = 5
    var pageWidth: CGFloat = 375
    var pageHeight: CGFloat = 193
    var fingerDidUp: Bool = true // 手指是否离开屏幕

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // 创建CarouselView
        for _ in 0..<pageCount {
            let carouselView = CarouselView(frame: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
            carouselViews.append(carouselView)
        }
        // 数组的第一页放最后一页，数组的最后一页放第一页，实现无限滚动。
        carouselViews.insert(carouselViews[pageCount-1].copy() as! CarouselView, at: 0)
        carouselViews.append(carouselViews[1].copy() as! CarouselView)
        pageCount += 2

        // 创建scrollView
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 80, width: pageWidth, height: pageHeight))
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(pageCount), height: pageHeight)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        self.view.addSubview(scrollView)
        
        // 在scrollView中添加CarouselView
        for i in 0..<pageCount {
            let carouselView = carouselViews[i]
            carouselView.frame = CGRect(x: pageWidth * CGFloat(i), y: 0, width: pageWidth, height: pageHeight)
            scrollView.addSubview(carouselView)
        }

        // scrollView划到第2页
        scrollView.setContentOffset(CGPoint(x: pageWidth, y: 0), animated: false)
        currentPage = 1
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        fingerDidUp = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        fingerDidUp = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard fingerDidUp == false else {
            currentPage = Int(round(scrollView.contentOffset.x / pageWidth))
            if currentPage == 0 {
                currentPage = pageCount-2
            } else if currentPage == pageCount-1 {
                currentPage = 1
            }
            scrollView.setContentOffset(CGPoint(x: pageWidth * CGFloat(currentPage), y: 0), animated: false)
            return
        }
    }
}
