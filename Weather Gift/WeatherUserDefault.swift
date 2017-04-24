//
//  WeatherUserDefault.swift
//  WeatherGift
//
//  Created by Angela Zhang on 7/28/2013.
//  Copyright © 2017 Angela Zhang. All rights reserved.
//

import Foundation

class WeatherUserDefault: NSObject, NSCoding {
    
    var name = ""
    var coordinates = ""
    
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        coordinates = aDecoder.decodeObject(forKey: "coordinates") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(coordinates, forKey: "coordinates")
    }
}
