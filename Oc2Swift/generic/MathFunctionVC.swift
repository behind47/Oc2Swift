//
//  MathFunctionVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/26.
//

import Foundation

extension NSString {
    public func addTwo(a:NSString, b:NSString) -> Int {
        return a.length + b.length
    }
}

protocol SumProtocol {
    // Self是一个方法，相当于OC里的class，返回的是Class对象
    func addTwo(obj:Self, next:Self) -> Self
}

protocol Container {
    /// 与class不同，protocol不能直接使用泛型符号，只能用associatedtype
    /// associatedtype只是一个占位符，可以任意命名，在class实现协议时，要使用typealias将associatedtype重命名为泛型符号
    associatedtype anyName
    var arr:Array<anyName> { get }
    func push(obj:anyName)
    func pop() -> anyName?
}

class Group<E> : Container {
    /// 将protocol中的associatedtype占位符重命名为泛型符号
    typealias anyName = E
    var arr = Array<E>()
    
    func push(obj: E) {
        arr.append(obj)
    }
    
    func pop() -> E? {
        return arr.popLast()
    }
}

func sumArr<G:Container>(group:G, initial:G.anyName) -> G.anyName where G.anyName:SumProtocol {
    return group.arr.reduce(initial) { partialResult, nextValue in
        return partialResult.addTwo(obj:partialResult, next:nextValue)
    }
}

struct MyObject : SumProtocol {
    var count: Int
    
    func addTwo(obj: MyObject, next: MyObject) -> MyObject {
        // struct不用写init方法也可以用属性初始化,class就不行
        return MyObject(count: obj.count + next.count)
    }
}

public class MathFunctionVC : BaseVC {
    public override func viewDidLoad() {
        super.viewDidLoad()
        var a = 0.4
        var b = 0.3
        let sum = addTwo(a: &a, b: &b)
        print("add two \(a) and \(b) results \(sum)")
        // 扩展系统类的方法
        let strA = NSString.init(string: "123456")
        let strB = NSString.init(string: "12345")
        let sumStr = strA.addTwo(a: strA, b: strB)
        print("add two \(strA) and \(strB) results \(sumStr)")
        // 数组迭代求和
        let arr = [1,2,3,4,5]
        let sumArr = arr.reduce(0) { partialResult, nextValue in
            return partialResult + nextValue
        }
        print("sum of arr \(arr) is \(sumArr)")
        
    }
    
    func addTwo<T:AdditiveArithmetic>(a: inout T, b: inout T) -> T {
        return a + b
    }
    
    func sum<T:AdditiveArithmetic>(list: [T], initial: T) -> T {
        return list.reduce(initial) { res, next in
            return res + next
        }
    }
}


