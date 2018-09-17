//
//  OYNetSpeedTool.swift
//  OYNetSpeedTool
//
//  Created by 欧阳铨 on 2018/9/17.
//  Copyright © 2018年 欧阳铨. All rights reserved.
//

import UIKit
//import ifaddrs.h


enum OYNetSpeedToolType {
    case en
    case lo
    case ap
    case pdp_ip
    case awdl
    case utun
}

class OYNetSpeedTool: NSObject {
    
    
    func getCurrentBytes() -> Dictionary<OYNetSpeedToolType, Any>? {
        var addrs:ifaddrs
        let cursor:ifaddrs
        
        var currentBytes:Int64 = 0;
        
        if(getifaddrs(UnsafeMutablePointer<UnsafeMutablePointer<addrs>>) == 0){
            
        }
        
        return nil
    }
}
