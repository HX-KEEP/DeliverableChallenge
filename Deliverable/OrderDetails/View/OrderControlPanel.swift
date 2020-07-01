//
//  OrderControlPanel.swift
//  Deliverable
//
//  Created by EisenWolf on 6/28/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import UIKit

class OrderControlPanel: UIView {
    /* =================== Subviews & Sublayer Components =================== */
    /*
     - Favorite Message
     - Favorite Switch
     */
    lazy var favoriteMessage: UILabel = {
        let label = UILabel()
        
        label.attributedText = HelperUILayout.manager.formattedText(rawText: "Favorite", alignment: HelperUILayout.TextAlignment.center, indentation: 0, textFont: UIFont.boldSystemFont(ofSize: 16), textColor: UIColor.black)
        
        return label
    }()
    
    lazy var favoriteSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        
        if let orderData = self.sourceController.orderDetailsData {
            uiSwitch.isOn = DeliveryOrder.manager.checkFavorite(orderID: orderData.orderID)
        } else {
            uiSwitch.isOn = false
        }
        uiSwitch.tintColor = UIColor.lightGray
        uiSwitch.onTintColor = DeliverableUI.Color.navigationUI
        uiSwitch.addTarget(self, action: #selector(self.favoriteSwitchHandler(sender:)), for: UIControl.Event.valueChanged)
        
        return uiSwitch
    }()
    /* ====================================================================== */
    
    /* ***************************** View Data ****************************** */
    private let sourceController: OrderDetailsController
    
    /* ********************************************************************** */
    
    /* --------------------------- Initialization --------------------------- */
    init(controller: OrderDetailsController) {
        self.sourceController = controller
        
        super.init(frame: CGRect.zero)
        
        self.initializeSubcomponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* -------------------------- External Access --------------------------- */
    public func autoLayout(with viewFrame: CGRect) {
        let xSpacing: CGFloat = 30
        /* favorite message */
        let messageSize = CGSize(width: 120, height: viewFrame.height * 0.8)
        HelperUILayout.manager.placeAxises(for: self.favoriteMessage, viewSize: messageSize, x: HelperUILayout.LayoutXAxis.left, xAnchor: self.leftAnchor, xOffset: xSpacing, y: HelperUILayout.LayoutYAxis.center, yAnchor: self.centerYAnchor, yOffset: 0)
        
        /* favorite switch */
        let switchSize = CGSize(width: 60, height: viewFrame.size.height * 0.5)
        HelperUILayout.manager.placeAxises(for: self.favoriteSwitch, viewSize: switchSize, x: HelperUILayout.LayoutXAxis.right, xAnchor: self.rightAnchor, xOffset: -xSpacing, y: HelperUILayout.LayoutYAxis.center, yAnchor: centerYAnchor, yOffset: 0)
    }
    
    /* ---------------------------------------------------------------------- */
}

extension OrderControlPanel {
    /* ----------------- Subcomponents & Reusable Subviews ------------------ */
    private func initializeSubcomponent() {
        self.backgroundColor = DeliverableUI.Color.backgroundColor
        
        /* Add Subviews & Sublayers */
        self.addSubview(self.favoriteMessage)
        self.addSubview(self.favoriteSwitch)
    }
    
    /* ------------------------ View Action Handlers ------------------------ */
    @objc private func favoriteSwitchHandler(sender: UISwitch) {
        guard let orderData = self.sourceController.orderDetailsData else {
            return
        }

        if self.favoriteSwitch.isOn {
            DeliveryOrder.manager.setFavorite(orderID: orderData.orderID)
        } else {
            DeliveryOrder.manager.removeFavorite(orderID: orderData.orderID)
        }
    }
    
    /* ---------------------- View Internal Functions ----------------------- */
    
    /* ---------------------------------------------------------------------- */
}

extension OrderControlPanel {
    /* +++++++++++++++++++++++++ Delegate Functions +++++++++++++++++++++++++ */
    
    /* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
}
