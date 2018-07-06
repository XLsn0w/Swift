//
//  ViewController.swift
//  Swift-4.2
//
//  Created by HL on 2018/7/6.
//  Copyright © 2018年 XL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var array = [String]();
    var array2 = Array<String>()
    
    enum XLType : Int {
        case XLType_default
        case XLType_custom
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var array = [Int]()
        array.append(1)
        print(array)
        array.append(88)
        print("\(array)")//\()
        
        
        let i = 10
        if i > 9 {
            //
        } else {
            //
        }
        
        //Swift
        for _ in 0 ..< 100 {
            print("This will be printed 100 times.")
        }
        
        for num in array {
            print(num)
            
            print(type(of: num))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

