//
//  DeliveryLogController.swift
//  Deliverable
//
//  Created by EisenWolf on 6/28/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import UIKit

class DeliveryLogController: UIViewController {
    /* =========================== Navigation Bar =========================== */
    private func initializeNavigationBar() {
        self.title = "My Delivery"
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    /* ====================================================================== */
    
    /* *********************** Controller Model & View ********************** */
    public lazy var controllerModel: DeliveryLogModel = {
        let model = DeliveryLogModel(controller: self)
        
        return model
    }()
    
    public lazy var controllerView: DeliveryLogView = {
        let view = DeliveryLogView(controller: self)
        
        return view
    }()
    
    /* ************************** Controller Data *************************** */
    public let orderEntryPerPage = 20
    
    public var orderStartIndex = 0
    
    public var pageIndex = 1 {
        didSet {
            self.controllerView.showLogLoadingWidget()
            
            if pageIndex == 1 {
                self.orderStartIndex = 0
            } else {
                self.orderStartIndex = self.orderEntryPerPage * pageIndex + 1
            }
            
            self.controllerModel.fetchDeliveryLog()
        }
    }
    
    /* ********************************************************************** */
    
    /* ------------------------ Controller Life Cycle ----------------------- */
    override func loadView() {
        self.view = self.controllerView
        
        DispatchQueue.main.async {
            self.controllerView.autoLayout(with: self.view.frame)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initializeNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.controllerView.refreshDeliveryLog()
    }
    
    /* ----------------------- Controller Navigations ----------------------- */
    public func showOrderDetails(orderData: DeliveryOrderEntry) {
        let controller = OrderDetailsController()
        
        controller.injectData(data: orderData)
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /* ---------------------------------------------------------------------- */
}
