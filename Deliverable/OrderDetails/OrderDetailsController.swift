//
//  OrderDetailsController.swift
//  Deliverable
//
//  Created by EisenWolf on 6/28/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import UIKit

class OrderDetailsController: UIViewController {
    /* =========================== Navigation Bar =========================== */
    private func initializeNavigationBar() {
        self.title = "Order Detail"
        
        self.navigationController?.isNavigationBarHidden = false
        
        let backButton = UIBarButtonItem(image: UIImage(named: "Back"), style: UIBarButtonItem.Style.done, target: self, action: #selector(self.backButtonHandler))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    /* ====================================================================== */
    
    /* *********************** Controller Model & View ********************** */
    public lazy var controllerModel: OrderDetailsModel = {
        let model = OrderDetailsModel(controller: self)
        
        return model
    }()
    
    public lazy var controllerView: OrderDetailsView = {
        let view = OrderDetailsView(controller: self)
        
        return view
    }()
    
    /* ************************** Controller Data *************************** */
    public var orderDetailsData: DeliveryOrderEntry?
    
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
    
    /* ---------------------- External Data Injection ----------------------- */
    public func injectData(data: DeliveryOrderEntry) {
        self.orderDetailsData = data
    }

    /* ---------------------------------------------------------------------- */
}

extension OrderDetailsController {
    /* --------------------- Controller Action Handlers --------------------- */
    @objc private func backButtonHandler() {        
        self.navigationController?.popToRootViewController(animated: true)
    }
    /* ---------------------------------------------------------------------- */
}
