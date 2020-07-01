//
//  DeliveryLogPaginationInterface.swift
//  Deliverable
//
//  Created by EisenWolf on 6/28/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import UIKit

class DeliveryLogPaginationInterface: UIView {
    /* =================== Subviews & Sublayer Components =================== */
    /*
     - Page Display
     - Next Page Button
     - Previous Page Buttpn
     */
    private let pageDisplay = UILabel()
    
    private lazy var nextPageButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        
        button.setAttributedTitle(HelperUILayout.manager.formattedText(rawText: "Next", alignment: HelperUILayout.TextAlignment.center, indentation: 0, textFont: UIFont.boldSystemFont(ofSize: 16), textColor: DeliverableUI.Color.navigationUI), for: UIControl.State.normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = DeliverableUI.Color.navigationUI.cgColor
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(self.nextPageButtonHandler), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    private lazy var previousPageButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        
        button.setAttributedTitle(HelperUILayout.manager.formattedText(rawText: "Previous", alignment: HelperUILayout.TextAlignment.center, indentation: 0, textFont: UIFont.boldSystemFont(ofSize: 16), textColor: DeliverableUI.Color.navigationUI), for: UIControl.State.normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = DeliverableUI.Color.navigationUI.cgColor
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(self.previousPageButtonHandler), for: UIControl.Event.touchUpInside)
        
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
        self.updatePageDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* -------------------------- External Access --------------------------- */
    public func autoLayout(with viewFrame: CGRect) {
        /* page display */
        let pageDisplaySize = CGSize(width: 50, height: viewFrame.size.height * 0.8)
        HelperUILayout.manager.placeAxises(for: self.pageDisplay, viewSize: pageDisplaySize, x: HelperUILayout.LayoutXAxis.center, xAnchor: self.centerXAnchor, xOffset: 0, y: HelperUILayout.LayoutYAxis.center, yAnchor: self.centerYAnchor, yOffset: 0)
        
        /* previous page button */
        let buttonSize = CGSize(width: 90, height: viewFrame.size.height * 0.8)
        HelperUILayout.manager.placeAxises(for: self.previousPageButton, viewSize: buttonSize, x: HelperUILayout.LayoutXAxis.right, xAnchor: self.pageDisplay.leftAnchor, xOffset: -20, y: HelperUILayout.LayoutYAxis.center, yAnchor: self.centerYAnchor, yOffset: 0)
        
        /* next page button */
        HelperUILayout.manager.placeAxises(for: self.nextPageButton, viewSize: buttonSize, x: HelperUILayout.LayoutXAxis.left, xAnchor: self.pageDisplay.rightAnchor, xOffset: 20, y: HelperUILayout.LayoutYAxis.center, yAnchor: self.centerYAnchor, yOffset: 0)
        
    }
    
    /* ---------------------------------------------------------------------- */
}

extension DeliveryLogPaginationInterface {
    /* ----------------- Subcomponents & Reusable Subviews ------------------ */
    private func initializeSubcomponent() {
        self.backgroundColor = DeliverableUI.Color.backgroundColor

        
        /* Add Subviews & Sublayers */
        self.addSubview(self.pageDisplay)
        self.addSubview(self.nextPageButton)
        self.addSubview(self.previousPageButton)
        
    }
    
    /* ------------------------ View Action Handlers ------------------------ */
    @objc private func nextPageButtonHandler() {
        self.sourceController.pageIndex += 1
        self.updatePageDisplay()
    }
    
    @objc private func previousPageButtonHandler() {
        if self.sourceController.pageIndex > 1 {
            self.sourceController.pageIndex -= 1
            self.updatePageDisplay()
        }
    }
    
    /* ---------------------- View Internal Functions ----------------------- */
    private func updatePageDisplay() {
        self.pageDisplay.attributedText = HelperUILayout.manager.formattedText(rawText: "\(self.sourceController.pageIndex)", alignment: HelperUILayout.TextAlignment.center, indentation: 0, textFont: UIFont.boldSystemFont(ofSize: 16), textColor: UIColor.black)
    }
    
    /* ---------------------------------------------------------------------- */
}
