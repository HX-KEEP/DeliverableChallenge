//
//  DeliveryLogLoadingWidget.swift
//  Deliverable
//
//  Created by EisenWolf on 6/28/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import UIKit

class DeliveryLogLoadingWidget: UIView {
    /* =================== Subviews & Sublayer Components =================== */
    /*
     - Loading Indicator
     - Loading Message
     */
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView
        
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        } else {
            indicator = UIActivityIndicatorView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 75, height: 75)))
        }
        
        indicator.color = DeliverableUI.Color.navigationUI
        
        indicator.isHidden = true
        
        return indicator
    }()
    
    private let loadingMessage: UILabel = {
        let label = UILabel()
        
        label.attributedText = HelperUILayout.manager.formattedText(rawText: "Loading...", alignment: HelperUILayout.TextAlignment.center, indentation: 0, textFont: UIFont.boldSystemFont(ofSize: 24), textColor: DeliverableUI.Color.navigationUI)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    /* ====================================================================== */

    /* --------------------------- Initialization --------------------------- */
    init() {
        super.init(frame: CGRect.zero)
        
        self.initializeSubcomponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* -------------------------- External Access --------------------------- */
    public func autoLayout(with viewFrame: CGRect) {
        /*  loading indicator */
        let indicatorSpacing = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        HelperUILayout.manager.placeEdges(for: self.loadingIndicator, padding: indicatorSpacing, top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)
        
        /* loading message */
        let messageSize = CGSize(width: 240, height: 60)
        HelperUILayout.manager.placeAxises(for: self.loadingMessage, viewSize: messageSize, x: HelperUILayout.LayoutXAxis.center, xAnchor: self.centerXAnchor, xOffset: 0, y: HelperUILayout.LayoutYAxis.bottom, yAnchor: self.bottomAnchor, yOffset: -120)
        
    }
    
    public func start() {
        self.loadingIndicator.startAnimating()
    }
    
    public func stop() {
        self.loadingIndicator.stopAnimating()
    }
    
    /* ---------------------------------------------------------------------- */
}

extension DeliveryLogLoadingWidget {
    /* ----------------- Subcomponents & Reusable Subviews ------------------ */
    private func initializeSubcomponent() {
        self.backgroundColor = UIColor(white: 0.7, alpha: 0.6)
        
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        
        /* Add Subviews & Sublayers */
        self.addSubview(self.loadingIndicator)
        self.addSubview(self.loadingMessage)
        
    }

    /* ---------------------------------------------------------------------- */
}
