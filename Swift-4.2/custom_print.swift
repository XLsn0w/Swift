//
//  custom_print.swift
//  Swift-4.2
//
//  Created by HL on 2018/8/17.
//  Copyright © 2018年 XL. All rights reserved.
//

import UIKit

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
func printout<T>(message: T, file : String = #file, funcName:String = #function, lineNum : Int = #line){
    
    #if DEBUG
    
    // Build Settings --> swift flags --> 在debug后点击 + --> -D 自己起的名字
    let fileName = (file as NSString).lastPathComponent
    
    // 打印函数名
    print("\(fileName):(第\(lineNum)行) - \(message)")
    
    #endif
}
