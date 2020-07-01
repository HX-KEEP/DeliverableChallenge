//
//  DeliverableUI.swift
//  Deliverable
//
//  Created by EisenWolf on 6/28/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import UIKit

/**
 DeliverableUI
 
 - Note:
 App's global UI attributes
 
 - Requires:
 
 - Author:
 EisenWolf Studio
 
 - Copyright: Copyright ©
 <Class Name>
 by EisenWolf Studio
 */
final class DeliverableUI {
    public enum Color {
        static let backgroundColor = UIColor(displayP3Red: (255 / 255), green: (255 / 255), blue: (255 / 255), alpha: 1)
        
        static let navigationUI = UIColor(displayP3Red: (212 / 255), green: (111 / 255), blue: (44 / 255), alpha: 1)
        
        static let favorateActive = UIColor(displayP3Red: (255 / 255), green: (0 / 255), blue: (0 / 255), alpha: 1)
        
        static let favorateInactive = UIColor(displayP3Red: (235 / 255), green: (235 / 255), blue: (235 / 255), alpha: 1)
    }
}
