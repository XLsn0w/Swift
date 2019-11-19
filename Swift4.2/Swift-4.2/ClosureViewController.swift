
import UIKit

class ClosureViewController: UIViewController {
    
    var httpTool : HttpTool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        httpTool = HttpTool()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        httpTool?.loadData(finished: { (jsonData) in
            print("在控制器中拿到数据:\(jsonData)")
        })
    }

}


class HttpTool: NSObject {
    func loadData(finished: @escaping (_ jsonData : [String]) -> ()) ->() {
        DispatchQueue.global().async {
            
            () -> Void in
            print("发送异步网络请求,耗时操作:\(Thread.current)")
            
            //获取到的json结果数据
            let json = ["姓名", "年龄", "身高"];
            
            DispatchQueue.main.async {
                () -> Void in
                print("回到主线程, 将数据回调出去")
                finished(json)
            }
        }
    }
}


func getIncFunc(inc: Int) -> (Int) -> Int {
    var max = 10
    func incFunc(x: Int) ->Int{
        print("incFunc函数结束")
        max += 1
        return max + x
    }
    // 当执行到这一句时inc参数就应该被释放了, 但是由于在内部函数中使用到了它, 所以它被捕获了;
    // 同理, 当执行完这一句时max变量就被释放了, 但是由于在内部函数中使用到了它, 所以它被捕获了.
    print("getIncFunc函数结束")
    return incFunc
}

//当捕获的值回合与之对应的方法绑定在一起, 同意个方法中的变量会被绑定到不同的方法中
let value =  getIncFunc(inc: 5)
