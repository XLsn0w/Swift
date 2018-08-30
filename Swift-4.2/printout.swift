
/*
 // 1.获取打印所在的文件
 // LastPathComponent: 获取最后一个路径
 let file = (#file as NSString).lastPathComponent
 
 // 2.获取打印所在的方法
 let funcName = #function
 
 // 3.获取打印所在的行数
 let lineNum = #line
 
 //        print("\(file):[\(funcName)](\(#line)) - 123")
 */
// T是动态类型
func printout<T>(message: T, file : String = #file, funcName:String = #function, lineNum : Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent  /// Build Settings --> swift flags --> 在debug后点击 + --> -D 自己起的名字
    print("\(fileName):(第\(lineNum)行) - \(message)")    /// 打印函数名
    #endif
}
