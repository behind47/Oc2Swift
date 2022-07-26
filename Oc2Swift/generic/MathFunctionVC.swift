//
//  MathFunctionVC.swift
//  Oc2Swift
//
//  Created by behind47 on 2022/7/26.
//
/// Self是一个占位符，适用于两种情形：
/// 1. 在protocol中，Self指向实现了protocol的类型。e.g. 它被用来要求两个被比较的值是相同类型的。它就像一个泛型符号，只是不用放在<>里。它的值由上下文推定。
/// 2. 在一个类方法里，Self能被用作返回值类型，表明返回值类型是发送方法的类的类型，而不是声明方法的类的类型。与OC里的instancetype相似。

import Foundation

protocol SumProtocol {
    // Self是一个占位符，类似一个T
    func addTwo(obj:Self, next:Self) -> Self
}

extension NSString {
    public func addTwo(a:NSString, b:NSString) -> Int {
        return a.length + b.length
    }
}

//extension NSString : SumProtocol {
    /// 这里这样使用会报错，解开注释可见，Cannot convert return expression of type 'NSString' to return type 'Self'
    /// 错误原因可见
    /// https://stackoverflow.com/questions/25645090/protocol-func-returning-self
    /// 因为Self表示返回当前类的类型，只能使用type(of: self).init()这样的方式动态获取当前类的类型然后初始化
    /// 否则，如果返回了NSString类型，但是这个类的子类没有重写这个方法，那么对于子类，本该返回Self，即子类的类型，却返回了NSString，即父类的类型
    /// 消除这个编译错误，除了上述说明用type(of: self).init()这样的方式动态获取当前类的类型然后初始化之外，还可以将当前类设置为final，禁止继承。
    /// 当然，这里extension是不能final的，但是对于普通的class可以final处理。
//    func addTwo(obj: NSString, next: NSString) -> Self {
//        return obj   错误的方式❌
//        return type(of: self).init() 正确的方式☑️
//    }
//}
/// 接上，struct由于不可继承，相当于final的class，因此可以修改返回值为具体的类型
extension String : SumProtocol {
    func addTwo(obj: String, next: String) -> String {
        return obj + next
    }
}

protocol Container {
    /// 与class不同，protocol不能直接使用泛型符号，只能用associatedtype
    /// associatedtype只是一个占位符，可以任意命名，在class实现协议时，要使用typealias将associatedtype重命名为泛型符号
    associatedtype anyName
    var arr:Array<anyName> { get }
    func push(obj:anyName)
    func pop() -> anyName?
}

class Group<Ele> : Container {
    /// 将protocol中的associatedtype占位符重命名为泛型符号
    typealias anyName = Ele
    var arr = Array<Ele>()
    
    func push(obj: Ele) {
        arr.append(obj)
    }
    
    func pop() -> Ele? {
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
        //
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


