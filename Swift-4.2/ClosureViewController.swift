
import UIKit

class ClosureViewController: UIViewController {
    
    var httpTool : HttpTool?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        httpTool = HttpTool()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        httpTool?.loadData(finished: { (jsonData) in
            print("在控制器中拿到数据:\(jsonData)")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

