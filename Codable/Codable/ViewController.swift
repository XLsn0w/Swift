//
//  ViewController.swift
//  Codable
//
//  Created by mac on 2019/11/19.
//  Copyright © 2019 XLsn0w. All rights reserved.
/*
 如果你是一名有一定开发经验的开发者，那么你就一定会遇到过数据解析的问题。 最常见的就是 JSON 数据的解析，你的 APP 总会要请求一些服务器数据，比如各种信息列表，配置数据等。

 如果你之前用过 Objective-C 的话， 那么你一定对 NSJSONSerialization 并不陌生。 它的总体步骤大致是这样，先从 Data对象中解析出 NSDictionary 或 NSArray, 然后在从这里面按照属性名称取出需要的值，最后再用这些值给实体对象赋值。

 总体来说这个操作并不轻松，而且比较容易出差错，比如你在写解析代码的时候把属性名写错了，或者某个 nil 判断没有处理正确，导致了程序意外崩溃,就需要花不少时间进行调试。

 Codable
 我们的主题自然不是 NSJSONSerialization， 而是 Swift 中提供的 Codable 协议。 它和前者有着相似的作用，但应用范围更广，并且易用性更好。 先来看一下 Codable 协议的定义：

 typealias Codable = Decodable & Encodable
 它其实另外两个 Protocol 的集合，也就是 Decodable 和 Encodable。 一个用作数据解析，另一个用作数据编码。 其他不多说，咱们先来看一个实例，我们先声明一个实体类 Person 它声明实现了 Codable：

 struct Person : Codable {

 var name: String
 var gender: String
 var age: Int

 }
 除了声明 Codable 之外，这个实体类并没有其他代码，只有几个属性声明。 如果我们需要把他的实例编码成 JSON 字符串，可以这样：

 let person = Person(name: "swift", gender: "male", age: 24)

 let encoder = JSONEncoder()
 let data = try! encoder.encode(person)
 let encodedString = String(data: data, encoding: .utf8)!
 print(encodedString) // 输出 {"name":"swift","age":24,"gender":"male"}
 如上所示，首先初始化了一个 Person 实例。 然后初始化了一个 JSONEncoder。 再调用它的 encode 方法，把 person 实例进行编码。 让后整个 JSON 编码操作就完成了。

 再来看看如何解析：

 let jsonString = "{\"name\":\"swift\",\"age\":22,\"gender\":\"female\"}"
 let jsonData = jsonString.data(using: .utf8)!
 let decoder = JSONDecoder()

 let result = try! decoder.decode(Person.self, from: jsonData)
 print(result) // 输出： Person(name: "swift", gender: "female", age: 22)
 解析的时候用的是 JSONDecoder 对象，给他的 decode 方法传入要解析的实例类型 - Person.self, ，再加上要解析的数据对象 jsonData 就完成了 JSON 数据的解析。

 使用 Codable 协议就是这么简单， 你不需要些任何具体的解析代码，只需要你的实体类属性名和 JSON 数据能够对应上，就完成了内容的解析。 这样相比 NSJSONSerialization 来看，精简了很多，并且不容易出错。

 这里只有一点需要注意，对于我们刚才例子中的 Person 类，除了它自己实现 Codable 协议之外，它的所有属性也必须是遵循 Codable 的。 Swift 系统库中的 String,Int,Double,Date,URL,Data 这些类都是实现了 Codable 的。 如果你的自定义属性是其他类型，则需要注意一下它是否也实现了 Codable。

 另外， 除了 JSONEncoder 和 JSONDecoder 之外， Swift 还为其他类型的数据提供了编解码能力， 比如 PropertyListEncoder可以编码 plist 数据格式。

 对指定属性编码
 默认情况下，如果声明继承了 Codable 协议，这个实例中的所有属性都会被算作编码范围内。 如果你只想对一部分属性进行编解码，也是有办法的，可以在你的自定义类中声明一个 CodingKeys 枚举属性：

 struct Person : Codable {

 var name: String
 var gender: String = ""
 var age: Int

 enum CodingKeys: String, CodingKey {

 case name
 case age

 }

 }
 还是之前的 Person 类，这次我们加入了 CodingKeys 属性，并且定义了两个枚举值 name 和 age，只有在 CodingKeys 中指定的属性名才会进行编码，如果我们再次对 Person 进行编码，得到的将会是这样的结果：

 {"name":"swift","age":24}
 可以看到， gender 属性由于没有在 CodingKeys 中声明，所以不会被编码。 另外如果使用了 CodingKeys，那些没有在 CodingKeys 中声明的属性就必须要要有一个默认值，我们上面的代码中其实给 gender 属性也声明了默认值。

 我们还可以使用 CodingKeys 改变编码属性的名称：

 struct Person : Codable {

 var name: String
 var gender: String = ""
 var age: Int

 enum CodingKeys: String, CodingKey {

 case name = "title"
 case age

 }

 }
 还是以 Person 为例，这次我们在 CodingKeys 枚举中讲 name 属性重新定义为 title。 这个意思就是说，虽然在 Person 类中，这个属性名还是 name， 但在编码后的 JSON 中，它的属性名就应该是 title。

 对上面这个类运行编码后，得到的结果是这样:

 {"title":"swift","age":24}
 JSON 中的第一个属性名变成了 title， 它对应 Person 类中的 name 属性。

 自定义编码过程
 你还可以自定义整个编码和解码过程。 对于稍复杂一些的数据结构，这个能力还是会经常用到的。 比如我们想给 Person 再加上身高和体重两个属性：

 struct Person : Codable {

 var name: String
 var gender: String = ""
 var age: Int

 var height: Int
 var weight: Int

 enum CodingKeys: String, CodingKey {

 case name = "title"
 case age
 case body

 }

 enum BodyKeys: String, CodingKey {

 case height
 case weight

 }

 }
 这里面新增的 height 和 width 属性，分别对应体重和身高。 并且还增加了另外一个属性 BodyKeys。 为什么要添加这个属性呢？ 是因为我们这次准备把 height 和 width 放到一个单独的对象中。 下面这样解释可能会更直观一些，如果我们不添加 BodyKeys 属性，而是把他们直接定义到 CodingKeys 里面，那么生成的 JSON 结构大致是这样：

 {
 "name" : xxx
 "age": xxx
 "height" : xxx
 "weight": xxx
 }
 但我们单独为 height 和 weight 定义了 BodyKeys 枚举属性。 并且把它有声明到了 CodingKeys 中。 这次 CodingKeys 多了一个 body 属性，它对应的就是 BodyKeys 这个枚举。 至于这个对应关系怎么确立的，稍后会讲到学什么技术好。

 {
 "name" : xxx
 "age": xxx
 "body": {
 "height" : xxx
 "weight": xxx
 }
 }
 这样我想应该就说明了 BodyKeys 的作用了。 这样声明完还不行，我们还需要手动的确立他们之间的对应关系，这就要重载 Codable 的两个方法：

 extension Person {

 init(from decoder: Decoder) throws {

 let vals = try decoder.container(keyedBy: CodingKeys.self)
 name = try vals.decode(String.self, forKey: CodingKeys.name)
 age = try vals.decode(Int.self, forKey: CodingKeys.age)

 let body = try vals.nestedContainer(keyedBy: BodyKeys.self, forKey: .body)
 height = try body.decode(Int.self, forKey: .height)
 weight = try body.decode(Int.self, forKey: .weight)

 }

 func encode(to encoder: Encoder) throws {

 var container = encoder.container(keyedBy: CodingKeys.self)
 try container.encode(name, forKey: .name)
 try container.encode(age, forKey: .age)

 var body = container.nestedContainer(keyedBy: BodyKeys.self, forKey: .body)
 try body.encode(height, forKey: .height)
 try body.encode(weight, forKey: .weight)

 }

 }
 init(from decoder: Decoder) 用于解析数据， encode(to encoder: Encoder) 方法用于编码数据。 上面的代码我想不用过多解释，很容易理解。

 decoder.container() 方法首先获取 CodingKey 的对应关系，这里我们首先传入 CodingKeys.self 表示我们先前声明的类型。 然后调用 vals.decode() 方法，用于解析某个单独的属性。 接下来调用 vals.nestedContainer() 方法获取内嵌的层级，也就是我们先前声明的 BodyKeys。然后继续解析。

 编码的相关处理也大同小异，把上面解码方法中的逻辑反向处理了一遍。

 这样，如果我们对新的 Person 实例再进行编码，得到的将会是这样的结果：

 {"title":"swift","age":24,"body":{"weight":80,"height":180}}
 可以看到，生成了带层级的 JSON 数据。

 总结
 Codable 协议的设计，可以帮助我们产出更好的代码结构。对于简单的数据模型，不需要任何处理即可使用。 而稍复杂的数据结构，也只需要将解析规则封装到实体类中，可以有效避免代码结构的散乱。

 总之，像是数据解析这类的操作，在平时的开发工作中还是比较多的。 如果你正在开发 Swift 项目，它是一个你值得了解的特性。

 
 */

/*
 Swift 4中苹果引入了全新的编码与解码支持，开发者可以更加方便地将数据转化为JSON或存入本地磁盘。这个功能的核心是Codable协议，其定义如下：

 typealias Codable = Decodable & Encodable

 public protocol Decodable {
     public init(from decoder: Decoder) throws
 }
 public protocol Encodable {
     public func encode(to encoder: Encoder) throws
 }
 编码及解析
 本文主要介绍JSON的编码和解析，使用JSONEncoder用于编码，使用JSONDecoder用于解析。

 let data = try! JSONEncoder().encode([1: 3])
 let dict = try! JSONDecoder().decode([Int: Int].self, from: data)
 print(dict)
 需要注意传入的数据必须是JSON格式的，所以model本身也必须是遵循JSON的规范的。比如基本类型本身并不是Object/Array，是不可以编码或解析的。经实测，key可以不严格遵循JSON规定的String类型。了解JSON

 基本类型
 Swift的Enum，Struct和Class都支持Codable，先看一个简单的示例。

 // Enum的原始值一定要是Codable，一般使用的String/Int都是可以的
 enum Level: String, Codable {
     case large
     case medium
     case small
 }

 struct Location: Codable {
     let latitude: Double
     let longitude: Double
 }

 // CustomDebugStringConvertible只是为了更好打印
 class City: Codable, CustomDebugStringConvertible {
     
     let name: String
     let pop: UInt
     let level: Level
     let location: Location
     
     var debugDescription: String {
         return """
         {
         "name": \(name),
         "pop": \(pop),
         "level": \(level.rawValue),
         "location": {
         "latitude": \(location.latitude),
         "longitude": \(location.longitude)
         }
         }
         """
     }
 }

 let jsonData = """
         {
         "name": "Shanghai",
         "pop": 21000000,
         "level": "large",
         "location": {
           "latitude": 30.40,
           "longitude": 120.51
         }
         }
         """.data(using: .utf8)!
 do {
     let city = try JSONDecoder().decode(City.self, from: jsonData)
     print("city:", city)
 } catch {
     print(error.localizedDescription)
 }
 上述例子中一次性展示了三种基本类型的基本用法，需要注意的是所有存储属性的类型都需遵循Codable才可以推断，计算属性不受此限制。如有存储属性不遵循Codable，需要自行实现本文开头协议中的方法。另外，class继承的父类也需遵循Codable才可以自动推断，否则也需自行实现。

 自定义Key
 由于Codable的key是直接用属性名匹配的，所以当key不匹配时需要我们自定义并实现协议方法。比如上述的的name字段变成了short_name。我们需要：

 定义一个枚举遵循CodingKey协议且原始值为String（定义的最佳位置为嵌套在相应的model内）
 实现Decodable的协议方法
 代码如下：
 let jsonData = """
         {
         "short_name": "Shanghai",  // 这里的key与model不再吻合
         "pop": 21000000,
         "level": "large",
         "location": {
           "latitude": "30.40",
           "longitude": 120.51
         }
         }
         """.data(using: .utf8)!

 class City: Codable, CustomDebugStringConvertible {
    //...其余代码与上例一致，这里不重复
     
     enum CodingKeys: String, CodingKey {
         case name = "short_name"
         case pop
         case level
         case location
     }
     
     required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         name = try container.decode(String.self, forKey: .name)
         pop = try container.decode(UInt.self, forKey: .pop)
         level = try container.decode(Level.self, forKey: .level)
         location = try container.decode(Location.self, forKey: .location)
     }
 }
 进阶篇
 第一式：善用嵌套
 如果JSON格式比较奇怪，比如一个和时间相关的model分组，其key为日期。JSON格式如下：

 {
   "2016-10-01": [Objects],
   "2017-09-30": [Objects],
   ...
 }
 我们可以使用[String: [Object]]解析，这样就可以避免key不整齐的尴尬。

 第二式：巧用泛型
 如果模型封装得比较好，其实大部分属性是可以复用的，我们可以通过泛型（继承也可以实现，只是层级比较复杂，且不支持struct）来实现模型的部分复用。

 struct Resource<Attributes>: Codable where Attributes: Codable {
     let name: String
     let url: URL
     let attributes: Attributes
 }

 struct ImageAttributes: Codable {
     let size: CGSize
     let format: String
 }

 Resource<ImageAttributes> // 可以添加更多的Attributes，实现了多态
 第三式：剥离麻烦
 上文中提到Codable要求存储属性都遵循Codable才可以自动推断，如果只有极少属性不支持Codable的话，实现协议方法就显得十分麻烦。我们可以将部分属性剥离到子类或父类中（此方法仅限于class）。如下例所示：

 let jsonData = """
 {
   "name": "_name",
   "length": 4,
   "uncodableNumber": 6
 }
 """.data(using: .utf8)!

 class CodablePart: Codable {
     let name: String
     let length: UInt
     
 }

 class WholeModel: CodablePart {
     
     enum CodingKeys: String, CodingKey {
         case uncodableNumber
     }

     let uncodableNumber: NSNumber
     
     required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         let number = try container.decode(Int.self, forKey: .uncodableNumber)
         uncodableNumber = NSNumber(value: number)
         try super.init(from: decoder)
     }

 }

 do {
     let model = try JSONDecoder().decode(WholeModel.self, from: jsonData)
     print(model.name)
     print(model.length)
     print(model.uncodableNumber)
 } catch {
     print(error.localizedDescription)
 }
 第四式：偷天换日
 有时候JSON中的格式并非我们所要，比如String格式的浮点型数字，我们希望直接在转model时转换为Double类型。我们可以使用中间类转化类型。如下：

 struct StringToDoubleConverter: Codable { // 此类将获取的String转化为Double
     
     let value: Double?
     
     init(from decoder: Decoder) throws {
         let container = try decoder.singleValueContainer()
         let string = try container.decode(String.self)
         value = Double(string)
     }
 }
 这样我们就可以将希望转化为Double的String字段类型指定为StringToDoubleConverter。不过访问时层级多了.value一层，且类型为可选型（因String转Double本来就可能失败）。

 后记
 Codable提供了简洁的API，使Swift的编码与解析焕然一新。本来打算在本文阐述JSONEncoder，JSONDecoder，NSKeyedArchiver，NSKeyedUnarchiver与Codable结合的用法。但鉴于长度问题，将另开一篇介绍。本文基本用法参照了Medium上的两篇博文，进阶用法来自于自己探索的心得。
 
 */
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

