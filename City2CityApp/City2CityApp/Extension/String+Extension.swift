//
//  String+Extension.swift
//  City2CityApp
//
//  Created by muhammad on 10/14/19
//  Copyright © 2019 muhammad. All rights reserved.
//

import Foundation

extension String {
    
    
    var addCommas: String? {
        
        guard let number = Int(self) else { return nil }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: number as NSNumber)
    }
    
    
    
}
