//
//  OrderDetailsView.swift
//  Deliverable
//
//  Created by EisenWolf on 6/28/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import UIKit

class OrderDetailsView: UIView {
    /* =================== Subviews & Sublayer Components =================== */
    /*
     - Order Control Panel
     - Divider Line
     - Order Details
     */
    private lazy var orderControlPanel: OrderControlPanel = {
        let view = OrderControlPanel(controller: self.sourceController)
        
        return view
    }()
    
    private let dividerLine: UIView = {
        let view = UIView()
        
        view.backgroundColor = DeliverableUI.Color.navigationUI
        
        return view
    }()
    
    private lazy var orderDetails: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = DeliverableUI.Color.backgroundColor
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    /* ====================================================================== */
    
    /* ***************************** View Data ****************************** */
    private let sourceController: OrderDetailsController
    
    private struct OrderDetailField {
        let name: String
        let value: String
    }
    
    private var orderDetailFieldsContainer = [OrderDetailField]()
    
    private let orderDetailsCellID = "OrderDetailsCellID"
    
    private let detailsCellHeight: CGFloat = 80
    /* ********************************************************************** */
    
    /* --------------------------- Initialization --------------------------- */
    init(controller: OrderDetailsController) {
        self.sourceController = controller
        
        super.init(frame: CGRect.zero)
        
        self.registerReusableView()
        self.initializeSubcomponent()
        
        self.parseOrderDetail()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* -------------------------- External Access --------------------------- */
    public func autoLayout(with viewFrame: CGRect) {
        /* order control panel */
        let panelSize = CGSize(width: viewFrame.size.width, height: 60)
        HelperUILayout.manager.placeAxises(for: self.orderControlPanel, viewSize: panelSize, x: HelperUILayout.LayoutXAxis.center, xAnchor: self.centerXAnchor, xOffset: 0, y: HelperUILayout.LayoutYAxis.top, yAnchor: self.safeAreaLayoutGuide.topAnchor, yOffset: 0)
        self.orderControlPanel.autoLayout(with: CGRect(origin: CGPoint.zero, size: panelSize))
        
        /* divider line */
        let dividerSize = CGSize(width: viewFrame.size.width, height: 2)
        HelperUILayout.manager.placeAxises(for: self.dividerLine, viewSize: dividerSize, x: HelperUILayout.LayoutXAxis.center, xAnchor: self.centerXAnchor, xOffset: 0, y: HelperUILayout.LayoutYAxis.top, yAnchor: self.orderControlPanel.bottomAnchor, yOffset: 0)
        
        /* order details */
        HelperUILayout.manager.placeEdges(for: self.orderDetails, top: self.dividerLine.bottomAnchor, left: self.leftAnchor, bottom: self.safeAreaLayoutGuide.bottomAnchor, right: self.rightAnchor)
    }
    
    /* ---------------------------------------------------------------------- */
}

extension OrderDetailsView {
    /* ----------------- Subcomponents & Reusable Subviews ------------------ */
    private func initializeSubcomponent() {
        self.backgroundColor = DeliverableUI.Color.backgroundColor
        
        /* Add Subviews & Sublayers */
        self.addSubview(self.orderControlPanel)
        self.addSubview(self.dividerLine)
        self.addSubview(self.orderDetails)
        
    }
    
    private func registerReusableView() {
        self.orderDetails.register(OrderDetailsCell.self, forCellReuseIdentifier: self.orderDetailsCellID)
    }
    
    /* ---------------------- View Internal Functions ----------------------- */
    private func parseOrderDetail() {
        guard let data = self.sourceController.orderDetailsData else {
            return
        }
        
        self.orderDetailFieldsContainer.append(OrderDetailField(name: "Order ID", value: data.orderID))
        
        self.orderDetailFieldsContainer.append(OrderDetailField(name: "Pickup Time", value: self.reformateTimestamp(rawTimestamp: data.orderTimestamp)))
        
        self.orderDetailFieldsContainer.append(OrderDetailField(name: "Delivery Fee", value: data.orderDeliveryFee))
        
        self.orderDetailFieldsContainer.append(OrderDetailField(name: "Surcharge", value: data.orderSurcharge))
        
        self.orderDetailFieldsContainer.append(OrderDetailField(name: "Total", value: self.calculateTotalPrice(deliveryFee: data.orderDeliveryFee, surcharge: data.orderSurcharge)))
        
        self.orderDetailFieldsContainer.append(OrderDetailField(name: "Route Start", value: data.orderRoute.routeStart))
        
        self.orderDetailFieldsContainer.append(OrderDetailField(name: "Route End", value: data.orderRoute.routeEnd))
        
        self.orderDetailFieldsContainer.append(OrderDetailField(name: "Sender Name", value: data.orderSender.senderName))
        
        self.orderDetailFieldsContainer.append(OrderDetailField(name: "Sender Phone", value: data.orderSender.senderPhone))
        
        self.orderDetailFieldsContainer.append(OrderDetailField(name: "Sender Email", value: data.orderSender.senderEmail))
        
        DispatchQueue.main.async {
            self.orderDetails.reloadData()
        }
    }
    
    /**
     Internal function to convert the raw string form of  timestampe into a pretty format.
     
     - Note:
     
     - Parameters:
        -   rawTimestamp: The unformmated string of timestamp.
     */
    private func reformateTimestamp(rawTimestamp: String) -> String {
        /* To Do */
        
        return rawTimestamp
    }
    
    /**
     Internal function to calculate the total by adding fee and surcharge
     
     - Note:
     
     - Parameters:
        -   deliveryFee: Delivery fee in string.
        -   surcharge: Surcharge in string.
     */
    private func calculateTotalPrice(deliveryFee: String, surcharge: String) -> String {
        let feeAmount = Float(deliveryFee.dropFirst()) ?? 0
        let surchargeAmount = Float(surcharge.dropFirst()) ?? 0
        
        return "$\(feeAmount + surchargeAmount)"
    }
    /* ---------------------------------------------------------------------- */
}

extension OrderDetailsView: UITableViewDelegate {
    /* +++++++++++++++++++++++++ Delegate Functions +++++++++++++++++++++++++ */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.detailsCellHeight
    }
    
    /* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
}

extension OrderDetailsView: UITableViewDataSource {
    /* +++++++++++++++++++++++++ Delegate Functions +++++++++++++++++++++++++ */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderDetailFieldsContainer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.orderDetails.dequeueReusableCell(withIdentifier: self.orderDetailsCellID, for: indexPath) as! OrderDetailsCell
        
        let detailsEntry = self.orderDetailFieldsContainer[indexPath.row]
        
        cell.updateReusableData(name: detailsEntry.name, value: detailsEntry.value)
        
        return cell
    }
    /* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
}
