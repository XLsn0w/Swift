//
//  Swift.swift
//  Swift-4.2
//
//  Created by HL on 2018/7/6.
//  Copyright © 2018年 XL. All rights reserved.
//

import UIKit

class Swift: NSObject {

}

/*
 
 Swift 4.2是Swift 4.0发布以来的第二次小更新, 继上次Xcode 9.3和Swift 4.1发布以来也有俩月有余
 
 上个版本Swift 4.1 的新特性中介绍了条件一致性和哈希索引等相关更新
 
 随着Xcode Bate 10的发布, Swift 4.2也发布了测试版, 相信也带来了很多优化和改进
 
 下面运行环境都是在Xcode Bate 10环境中进行的
 
 CaseInterable协议
 
 SE-0194介绍了在Swift 4.2中新增的一个新的CaseIterable协议
 
 定义的枚举遵循CaseIterable协议后, 编译时Swift 会自动合成一个allCases属性，是包含枚举的所有case项的数组
 
 
 enum NetState: CaseIterable {
 case wifi
 case hotWifi
 case mobile
 case none
 }
 之后我们在其他地方调用改枚举时就可以获取到allCase属性, 如下
 
 1
 2
 3
 4
 5
 6
 7
 8
 9
 10
 11
 12
 print(NetState.allCases)
 print("case个数: " + "\(NetState.allCases.count)")
 for item in NetState.allCases {
 print(item)
 }
 // 输出结果:
 [__lldb_expr_9.NetState.wifi, __lldb_expr_9.NetState.hotWifi, __lldb_expr_9.NetState.mobile, __lldb_expr_9.NetState.none]
 case个数: 4
 wifi
 hotWifi
 mobile
 none
 这个allCases的自动合成仅替换没有参数的case值, 但是如果需要你需要所有case值, 可以重写allCases属性自己添加
 
 1
 2
 3
 4
 5
 6
 7
 8
 9
 10
 11
 12
 13
 14
 15
 16
 17
 18
 19
 enum FoodKind: CaseIterable {
 //此处, 必须重写allCases属性, 否则报错
 static var allCases: [FoodKind] {
 return [.apple, .pear, .orange(look: false)]
 }
 
 case apple
 case pear
 case orange(look: Bool)
 }
 for item in FoodKind.allCases {
 print(item)
 }
 /*
 * 输出结果:
 apple
 pear
 orange(look: false)
 */
 如果有枚举项标记为unavailable，则默认无法合成allCases，只能依靠自己来手动合成
 
 1
 2
 3
 4
 5
 6
 7
 8
 9
 10
 11
 12
 13
 14
 15
 16
 17
 18
 19
 20
 enum CarKind: CaseIterable {
 //当有unavailable修饰的case值, 也必须重写allCase属性
 static var allCases: [CarKind] {
 return [.bwm, .ford]
 }
 
 case bwm
 case ford
 
 @available(*, unavailable)
 case toyota
 }
 for item in CarKind.allCases {
 print(item)
 }
 /*
 输出结果:
 bwm
 ford
 */
 #warning和#error编译指令
 
 SE-0196介绍新的编译指令来强制Xcode在build时生成警告或错误信息
 
 这两个指令是#warning和#error，前者会强制Xcode在生成你的代码时发出一个警告，后者会发出一个编译错误这样你的代码就完全不能编译
 
 #warning主要用于提醒你或者别人一些工作还没有完成，Xcode模板常使用#warning标记一些你需要替换成自己代码的方法存根(method stubs)。
 
 #error主要用于如果你发送一个库，需要其他开发者提供一些数据。比如，一个网络 API的认证密码，你需要用户输入它们自己的密码，就使用#error在继续之前强制他们更改这行代码
 
 9.png
 
 image
 
 #warning和#error可以和已存的#if编译指令共同使用，并且只有在条件为true时才会激活。例如：
 
 1
 2
 3
 #if os(macOS)
 #error("MyLibrary is not supported on macOS.")
 #endif
 动态成员查找
 
 SE-0195介绍了一个方法，让Swift更接近类似Python的脚本语言, 让Swift可以以属性访问的方式调用下标操作
 
 这让我们可以像Python一样来访问字典值，不过是以类型安全的方式, 其核心在于:
 
 @dynamicMemberLookup: 可以让Swift以一种下标方法去进行属性访问
 
 subscript(dynamicMember:)：可以通过所请求属性的字符串名得到，并且可以返回你想要的任何值
 
 我们可以创建一个Titan结构，并且从一个字典读取它的值
 
 1
 2
 3
 4
 5
 6
 struct Titan {
 subscript(dynamicMember member: String) -> String {
 let properties = ["name": "Titanjun", "city": "Hang"]
 return properties[member, default: "0"] //默认值
 }
 }
 可以看到上述代码按字符串接收成员名字，并返回一个字符串。
 
 从内部看它只是在一个字典中查找这个成员名字并返回它的值
 
 即使取不到对应的值, 也会以默认值的形式返回, 上述结构的代码可以这么写
 
 1
 2
 3
 4
 5
 6
 7
 8
 let titan = Titan()
 print(titan.name)
 print(titan.city)
 print(titan.age)
 // 输出:
 Titanjun
 Hang
 0
 处理多种不同的类型
 
 上述subscript(dynamicMember:) 方法必须返回一串字符，这体现了Swift的类型安全性
 
 如果你想要多种不同的类型, 就执行不同的subscript(dynamicMember:)方法
 
 1
 2
 3
 4
 5
 6
 7
 8
 9
 10
 11
 12
 @dynamicMemberLookup
 struct Titan {
 subscript(dynamicMember member: String) -> String {
 let properties = ["name": "Titanjun", "city": "Hang"]
 return properties[member, default: "0"] //默认值
 }
 
 subscript(dynamicMember member: String) -> Int {
 let properties = ["age": 20, "source": 99]
 return properties[member, default: 0] //默认值
 }
 }
 需要注意的是: 这里取值的时候, 必须注明所取得值的类型
 
 1
 2
 3
 4
 5
 6
 7
 8
 9
 10
 let titan = Titan()
 let name: String = titan.name
 let city: String = titan.city
 let age: Int = titan.age
 let jun: String = titan.jun
 print(jun)
 print("name = \(name), city = \(city), age = \(age)")
 //输出:
 0
 name = Titanjuun, city = Hang, age = 20
 增强的条件一致性
 
 条件一致性在Swift 4.1中引入，一个类型的所有元素如果符合Hashable协议，则类型自动符合Hashable协议
 
 1
 2
 3
 4
 5
 6
 7
 8
 9
 10
 11
 12
 13
 14
 15
 16
 17
 18
 //定义Purchaseable协议
 protocol Purchaseable {
 func buy()
 }
 //定义一个符合该协议的结构体
 struct Book: Purchaseable {
 func buy() {
 print("You bought a book")
 }
 }
 //数组遵循该协议, 并且每一个元素也遵循该协议
 extension Array: Purchaseable where Element: Purchaseable {
 func buy() {
 for item in self {
 item.buy()
 }
 }
 }
 下面我们在Swift 4.1中运行如下代码, 会发现崩溃
 
 1
 2
 3
 4
 5
 let items: Any = [Book(), Book(), Book()]
 
 if let books = items as? Purchaseable {
 books.buy()
 }
 如果你收到一种类型的数据，想要检查它是否可以被转化为一个条件一致性协议, 这种在Swift 4.1中是不支持的, 但是在Swift 4.2中却可以很好的解决
 
 另外, 对Hashable一致性自动合并的支持在Swift 4.2被大幅提高，来自Swift 标准库的几个内置类型，包括optionals, arrays, dictionaries和 ranges, 现在当他们的元素符合Hashable时会自动符合Hashable 协议
 
 本地集合元素移除
 
 SE-0197介绍一个新的removeAll(where:)方法, 高效地执行根据条件删除操作
 
 1
 2
 3
 4
 var pythons = ["John", "Michael", "Graham", "Terry", "Eric", "Terry"]
 pythons.removeAll { $0.hasPrefix("Terry") }
 print(pythons)
 //输出: ["John", "Michael", "Graham", "Eric"]
 对比filter过滤方法
 
 1
 2
 3
 var python2 = ["John", "Michael", "Graham", "Terry", "Eric", "Terry"]
 python2 = python2.filter { !$0.hasPrefix("Terry") }
 print(python2)
 这并不是非常有效地使用内存，它指定了你不想要的东西，而不是你想要的东西
 
 随机数字的生成和洗牌
 
 SE-0202中Swift引入了新的随机数API
 
 可以通过调用random()随机数方法来生成一个随机数, 只需提供一个随机数范围即可
 
 1
 2
 3
 4
 5
 let ranInt = Int.random(in: 0..<5)
 let ranFloat = Float.random(in: 0..<5)
 let ranDouble = Double.random(in: 0..<5)
 let ranCGFloat = CGFloat.random(in: 0..<5)
 let ranBOOL = Bool.random()
 对数组进行重新洗牌
 
 SE-0202还支持使用新方法shuffle()和shuffled()方法对数组元素进行重新随机排序
 
 1
 2
 3
 4
 5
 var albums = ["Red", "1989", "Reputation"]
 // 没有返回值
 albums.shuffle()
 // 有返回值, 重新返回一个数组
 let shuffled = albums.shuffled()
 获取数组中的一个随机元素
 
 randomElement(): 数组的一个新方法, 如果数组部位空, 则返回数组中的一个随机元素, 否则返回nil
 
 1
 2
 3
 if let random = albums.randomElement() {
 print("The random album is \(random).")
 }
 更简单，更安全的哈希
 
 SE-0206介绍了在Swift 4.1中简化了我们使自定义类型符合Hashable协议的方式
 
 Swift 4.2引入了一个新的Hasher结构，它提供了一个随机播种的通用散列函数
 
 1
 2
 3
 4
 5
 6
 7
 struct iPad: Hashable {
 var serialNumber: String
 var capacity: Int
 func hash(into hasher: inout Hasher) {
 hasher.combine(serialNumber)
 }
 }
 可以通过combine()重复调用将更多属性添加到散列，并且添加属性的顺序会影响完成的散列值。
 
 还可以将其Hasher用作独立散列发生器：只要提供您想散列的任何值，然后调用finalize()以生成最终值
 
 1
 2
 3
 4
 5
 6
 let first = iPad(serialNumber: "12345", capacity: 256)
 let second = iPad(serialNumber: "54321", capacity: 512)
 var hasher = Hasher()
 hasher.combine(first)
 hasher.combine(second)
 let hash = hasher.finalize()
 Hasher每次散列对象时都会使用随机种子，这意味着任何对象的散列值在您的应用运行之间有效地保证是不同的
 
 这又意味着您添加到集合或字典中的元素很可能在您每次运行应用程序时都有不同的顺序
 
 检查序列元素是否符合条件
 
 SE-0207提供了allSatisfy()一种检查序列中的所有元素是否满足条件的新方法
 
 1
 2
 3
 4
 5
 6
 //判断数组的所有元素是否全部大于85
 let scores = [86, 88, 95, 92]
 //返回一个BOOL
 let passed = scores.allSatisfy({ $0 > 85 })
 print(passed)
 //输出: true
 布尔切换
 
 SE-0199引入了一种新的toggle()方法, 可以将布尔值取反, 实现代码如下:
 
 1
 2
 3
 4
 5
 extension Bool {
 mutating func toggle() {
 self = !self
 }
 }
 测试代码
 
 1
 2
 3
 4
 var isSwift = true
 //toggle函数没有返回值
 isSwift.toggle()
 print(isSwift)
 SE-0204介绍了数组中的获取满足条件的数组中的最后一个元素或者索引值
 
 在Swift 4.1中我们只能取得first值, 却无法获取数组中的最后一个值(或者要用大量代码实现)
 
 在Swift 4.2中提供了last(where:)和lastIndex(where:)方法来获取数组中满足条件的最后的元素和索引值
 
 //获取满足条件的数组中的第一个值
 
 1
 2
 3
 4
 5
 6
 7
 8
 let a = [20, 30, 10, 40, 20, 30, 10, 40, 20]
 print(a.first(where: { $0 > 25 }))
 print(a.index(where: { $0 > 25 }))
 print(a.index(of: 10))
 //输出:
 30
 1
 2
 Swift 4.2中新增的last函数
 
 1
 2
 3
 4
 5
 6
 7
 8
 //在Swift4.1中
 print((a.reversed().index(where: { $0 > 25 })?.base).map({ a.index(before: $0) }))
 //输出: 7
 //Swift 4.2
 //获取满足条件的元素
 print(a.last(where: { $0 > 25 }))   //40
 //获取满足条件的元素的索引
 print(a.lastIndex(where: { $0 > 25 }))   //7
 */
