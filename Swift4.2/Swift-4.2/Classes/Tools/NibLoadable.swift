
import UIKit

protocol NibLoadable {
    
}

extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibName : String? = nil) -> Self {
        let loadName = nibName == nil ? "\(self)" : nibName!
        
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
