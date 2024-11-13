//
//  LayerCornerType.swift
//  IntervalAlarm
//
//  Created by 오지연 on 2023/02/16.
//

import UIKit

enum LayerCornerType: Int {
    
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft
    
    case topAll
    case bottomAll
    
    case all
    
    var mask: CACornerMask {
        switch self {
        case .topRight:
            return .layerMaxXMinYCorner
        case .topLeft:
            return .layerMinXMinYCorner
        case .bottomRight:
            return .layerMaxXMaxYCorner
        case .bottomLeft:
            return .layerMinXMaxYCorner
        case .topAll:
            return [LayerCornerType.topRight.mask, LayerCornerType.topLeft.mask]
        case .bottomAll:
            return [LayerCornerType.bottomRight.mask, LayerCornerType.bottomLeft.mask]
        case .all:
            return [LayerCornerType.topAll.mask, LayerCornerType.bottomAll.mask]
        }
    }
    
}
