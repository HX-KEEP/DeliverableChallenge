//
//  DeliveryLogEmptyDisplay.swift
//  Deliverable
//
//  Created by EisenWolf on 6/28/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import UIKit

class DeliveryLogEmptyDisplay: UIView {
    /* =================== Subviews & Sublayer Components =================== */
    /*
     - Empty Log Message
     - Refresh Button
     */
    private lazy var emptyLogMessage: UILabel = {
        let label = UILabel()
        
        label.attributedText = HelperUILayout.manager.formattedText(rawText: "No Record", alignment: HelperUILayout.TextAlignment.center, indentation: 0, textFont: UIFont.boldSystemFont(ofSize: 24), textColor: DeliverableUI.Color.navigationUI)
        
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        
        button.setAttributedTitle(HelperUILayout.manager.formattedText(rawText: "Refresh", alignment: HelperUILayout.TextAlignment.center, indentation: 0, textFont: UIFont.boldSystemFont(ofSize: 16), textColor: DeliverableUI.Color.navigationUI), for: UIControl.State.normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = DeliverableUI.Color.navigationUI.cgColor
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(self.refreshButtonHandler), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    /* ====================================================================== */
    
    /* ***************************** View Data ****************************** */
    private let sourceController: DeliveryLogController
    
    /* ********************************************************************** */
    
    /* --------------------------- Initialization --------------------------- */
    init(controller: DeliveryLogController) {
        self.sourceController = controller
        
        super.init(frame: CGRect.zero)
        
        self.initializeSubcomponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* -------------------------- External Access --------------------------- */
    public func autoLayout(with viewFrame: CGRect) {
        /* empty log message */
        let messageSize = CGSize(width: viewFrame.size.width, height: 120)
        HelperUILayout.manager.placeAxises(for: self.emptyLogMessage, viewSize: messageSize, x: HelperUILayout.LayoutXAxis.center, xAnchor: self.centerXAnchor, xOffset: 0, y: HelperUILayout.LayoutYAxis.bottom, yAnchor: self.refreshButton.topAnchor, yOffset: 0)
        
        /* refresh button */
        let buttonSize = CGSize(width: 120, height: 60)
        HelperUILayout.manager.placeAxises(for: self.refreshButton, viewSize: buttonSize, x: HelperUILayout.LayoutXAxis.center, xAnchor: self.centerXAnchor, xOffset: 0, y: HelperUILayout.LayoutYAxis.center, yAnchor: self.centerYAnchor, yOffset: 0)
        
    }
    
    /* ---------------------------------------------------------------------- */
}

extension DeliveryLogEmptyDisplay {
    /* ----------------- Subcomponents & Reusable Subviews ------------------ */
    private func initializeSubcomponent() {
        self.backgroundColor = DeliverableUI.Color.backgroundColor
        
        /* Add Subviews & Sublayers */
        self.addSubview(self.emptyLogMessage)
        self.addSubview(self.refreshButton)
        
    }
    
    /* ------------------------ View Action Handlers ------------------------ */
    @objc private func refreshButtonHandler() {
        self.sourceController.controllerModel.fetchDeliveryLog()
    }
    
    /* ---------------------------------------------------------------------- */
}
