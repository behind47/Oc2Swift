//
//  RouterManager.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/8/22.
//

import Foundation

let sharedRouterManager = RouterManager()

class RouterManager {
    var routeMap : [String: AnyClass]!
    
    func register(route: String, cls : AnyClass) {
        routeMap[route] = cls
    }
    
    func obtainCls(with route : String) -> AnyClass? {
        return routeMap[route]
    }
}
