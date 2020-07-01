//
//  DeliveryLogView.swift
//  Deliverable
//
//  Created by EisenWolf on 6/28/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import UIKit

class DeliveryLogView: UIView {
    /* =================== Subviews & Sublayer Components =================== */
    /*
     - Delivery Log
     - Delivery Log Refresh Control
     - Delivery Log Loading Widget
     - Empty Log Display
     */
    private lazy var deliveryLog: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = DeliverableUI.Color.backgroundColor
        tableView.separatorColor = DeliverableUI.Color.navigationUI
        tableView.sectionHeaderHeight = 60
        tableView.addSubview(self.deliveryLogRefreshControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    private lazy var deliveryLogRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        
        control.attributedTitle = HelperUILayout.manager.formattedText(rawText: "Checking updates", alignment: HelperUILayout.TextAlignment.center, indentation: 0, textFont: UIFont.boldSystemFont(ofSize: 20), textColor: DeliverableUI.Color.navigationUI)
        
        control.addTarget(self, action: #selector(self.refreshControllerHandler), for: UIControl.Event.valueChanged)
        
        return control
    }()
    
    private let deliveryLogLoadingWidget = DeliveryLogLoadingWidget()
    
    private lazy var emptyLogDisplay: DeliveryLogEmptyDisplay = {
        let view = DeliveryLogEmptyDisplay(controller: self.sourceController)
        
        return view
    }()
    
    /* ====================================================================== */
    
    /* ***************************** View Data ****************************** */
    private let sourceController: DeliveryLogController

    private var deliveryOrdersContainers = [DeliveryOrderEntry]()
    
    private let deliveryLogCellID = "DeliveryLogCellID"
    
    private let logHeaderHeight: CGFloat = 70
    private let logCellHeight: CGFloat = 85
    
    private let animationDuration: TimeInterval = 1.75
    private let animationDelay: TimeInterval = 0
    
    /* ********************************************************************** */
    
    /* --------------------------- Initialization --------------------------- */
    init(controller: DeliveryLogController) {
        self.sourceController = controller
        
        super.init(frame: CGRect.zero)
        
        self.registerReusableView()
        self.initializeSubcomponent()

        self.startFetchingDeliveryLog()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* -------------------------- External Access --------------------------- */
    public func autoLayout(with viewFrame: CGRect) {
        /* delivery log */
        HelperUILayout.manager.fillPredecessor(for: self.deliveryLog)
        
        /* empty log display */
        HelperUILayout.manager.fillPredecessor(for: self.emptyLogDisplay)
        self.emptyLogDisplay.autoLayout(with: self.frame)
        
        /* delivery log loading Widget */
        HelperUILayout.manager.fillPredecessor(for: self.deliveryLogLoadingWidget)
        self.deliveryLogLoadingWidget.autoLayout(with: self.deliveryLogLoadingWidget.frame)
        
    }
    
    /**
     External function to recieve an updated data and refresh the delivery log.
     
     - Note:
     
     - Parameters:
        -   fetchedLog: The updated delivery log data.
     */
    public func updateDeliveryRenderContainer(fetchedLog: [DeliveryOrderEntry]) {
        self.deliveryOrdersContainers.removeAll()
        self.deliveryOrdersContainers.append(contentsOf: fetchedLog)
        
        DispatchQueue.main.async {
            if self.deliveryLogRefreshControl.isRefreshing {
                self.deliveryLogRefreshControl.endRefreshing()
            }
            
            self.deliveryLog.reloadData()

            self.updateDisplayMode()
        }
        
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.deliveryLogLoadingWidget.alpha = 0
        }) { (_) in
            self.deliveryLogLoadingWidget.isHidden = true
            self.deliveryLogLoadingWidget.stop()
        }
    }
    
    /**
     External function to display a refresh overlay to indicate the download session in the background
     
     - Note:
     The overlay also cover the paging button to prevent fetching task queue up.
     
     - Parameters:

     */
    public func showLogLoadingWidget() {
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDelay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.deliveryLogLoadingWidget.alpha = 1
        }) { (_) in
            self.deliveryLogLoadingWidget.isHidden = false
            self.deliveryLogLoadingWidget.start()
        }
    }
    
    /**
     External function to let the delivery log to reload its reusable view.
     
     - Note:
     Mainly used / called by viewDidApear controller life cycle.
     
     - Parameters:

     */
    public func refreshDeliveryLog() {
        self.updateDisplayMode()
        
        DispatchQueue.main.async {
            self.deliveryLog.reloadData()
        }
    }
    /* ---------------------------------------------------------------------- */
}

extension DeliveryLogView {
    /* ----------------- Subcomponents & Reusable Subviews ------------------ */
    private func initializeSubcomponent() {
        self.backgroundColor = UIColor.clear
        
        /* Add Subviews & Sublayers */
        self.addSubview(self.deliveryLog)
        self.addSubview(self.emptyLogDisplay)
        self.addSubview(self.deliveryLogLoadingWidget)
        
    }
    
    private func registerReusableView() {
        self.deliveryLog.register(DeliveryLogCell.self, forCellReuseIdentifier: self.deliveryLogCellID)
    }
    
    /* ------------------------ View Action Handlers ------------------------ */
    @objc private func refreshControllerHandler() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.deliveryLogRefreshControl.endRefreshing()
            self.startFetchingDeliveryLog()
        }
    }
    
    /* ---------------------- View Internal Functions ----------------------- */
    private func startFetchingDeliveryLog() {
        self.sourceController.controllerModel.fetchDeliveryLog()
    }
    
    private func getSelectedOrderData(_ index: Int) -> DeliveryOrderEntry {
        let orderEntry = self.deliveryOrdersContainers[index]
        
        return orderEntry
    }
    
    /**
     Internal function to switch bewteen render mode, where there are no delivery entry exist.
     
     - Note:
     
     - Parameters:

     */
    private func updateDisplayMode() {
        DispatchQueue.main.async {
            if self.deliveryOrdersContainers.isEmpty {
                self.deliveryLog.isHidden = true
                self.emptyLogDisplay.isHidden = false
                
            } else {
                self.deliveryLog.isHidden = false
                self.emptyLogDisplay.isHidden = true
            }
        }
    }
    
    /* ---------------------------------------------------------------------- */
}

extension DeliveryLogView: UITableViewDelegate {
    /* +++++++++++++++++++++++++ Delegate Functions +++++++++++++++++++++++++ */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = DeliveryLogPaginationInterface(controller: self.sourceController)
        view.autoLayout(with: CGRect(origin: CGPoint.zero, size: CGSize(width: self.frame.size.width, height: self.logHeaderHeight)))
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.logHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.logCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seletedOrder = self.getSelectedOrderData(indexPath.row)
        
        self.sourceController.showOrderDetails(orderData: seletedOrder)
    }
    
    /* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
}

extension DeliveryLogView: UITableViewDataSource {
    /* +++++++++++++++++++++++++ Delegate Functions +++++++++++++++++++++++++ */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deliveryOrdersContainers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.deliveryLog.dequeueReusableCell(withIdentifier: self.deliveryLogCellID, for: indexPath) as! DeliveryLogCell
        
        let orderData = self.deliveryOrdersContainers[indexPath.row]
        
        cell.updateReusableData(orderID: orderData.orderID, orderDescription: orderData.orderRemarkMessage, orderImageURL: orderData.orderPictureURL)
        
        return cell
    }
    /* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
}
