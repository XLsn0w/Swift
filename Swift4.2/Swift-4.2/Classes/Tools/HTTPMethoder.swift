
import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class HTTPMethoder {
    ///+
    class func requestData(_ type     : MethodType,
                           URLString  : String,
                           parameters : [String : Any]? = nil,
                           finishedCallback : @escaping (_ result : Any) -> ()) {
        
        // 1.获取类型
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            // 4.将结果回调出去
            finishedCallback(result)
        }   
    }
}
