//
//  OrderDetailsCell.swift
//  Deliverable
//
//  Created by EisenWolf on 6/28/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import UIKit

class OrderDetailsCell: UITableViewCell {
    /* =================== Subviews & Sublayer Components =================== */
    /*
     - Name Field
     - Value Field
     */
    private let nameField = UILabel()
    
    private let valueField = UILabel()
    
    /* ====================================================================== */

    /* --------------------------- Initialization --------------------------- */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.initializeSubcomponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* -------------------------- External Access --------------------------- */
    public func updateReusableData(name: String, value: String) {
        DispatchQueue.main.async {
            self.nameField.attributedText = HelperUILayout.manager.formattedText(rawText: "\(name):", alignment: HelperUILayout.TextAlignment.left, indentation: 5, textFont: UIFont.boldSystemFont(ofSize: 16), textColor: UIColor.black)
            self.nameField.adjustsFontForContentSizeCategory = true
            
            self.valueField.attributedText = HelperUILayout.manager.formattedText(rawText: value, alignment: HelperUILayout.TextAlignment.center, indentation: 0, textFont: UIFont.systemFont(ofSize: 16), textColor: UIColor.black)
            self.valueField.numberOfLines = 3
            self.valueField.adjustsFontForContentSizeCategory = true
        }
    }
    
    /* ---------------------------------------------------------------------- */
}

extension OrderDetailsCell {
    /* ----------------- Subcomponents & Reusable Subviews ------------------ */
    private func initializeSubcomponent() {
        self.backgroundColor = DeliverableUI.Color.backgroundColor
        
        /* Add Subviews & Sublayers */
        self.addSubview(self.nameField)
        self.addSubview(self.valueField)
        
        self.reusableViewInitialLayout()
    }
    
    private func reusableViewInitialLayout() {
        /* name field */
        let nameFieldSise = CGSize(width: 120, height: 80)
        HelperUILayout.manager.placeAxises(for: self.nameField, viewSize: nameFieldSise, x: HelperUILayout.LayoutXAxis.left, xAnchor: self.leftAnchor, xOffset: 0, y: HelperUILayout.LayoutYAxis.center, yAnchor: self.centerYAnchor, yOffset: 0)
        
        /* value field */
        HelperUILayout.manager.placeEdges(for: self.valueField, top: self.topAnchor, left: self.nameField.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)
        
    }
    
    /* ---------------------------------------------------------------------- */
}
