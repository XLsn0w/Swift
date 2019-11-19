//
//  ThrowViewController.swift
//  Swift-4.2
//
//  Created by HL on 2018/8/17.
//  Copyright © 2018年 XL. All rights reserved.
//

import UIKit

class ThrowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let manager = FileReadManager()
        do {
            let str = try manager.readFileContent("hello.txt")
            print(str as Any)
        } catch {
            let errorType = error as! FileReadError
            
            switch errorType {
            case FileReadError.fileNameNotNull:
                print("fileNameNotNull")
            case FileReadError.filePathNotFind:
                print("filePathNotFind")
            case FileReadError.fileDataError:
                print("fileDataError")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
