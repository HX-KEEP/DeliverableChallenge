//
//  DeliveryLogModel.swift
//  Deliverable
//
//  Created by EisenWolf on 6/28/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import UIKit

class DeliveryLogModel {
    /* ***************************** Model Data ***************************** */
    private let sourceController: DeliveryLogController
    
    /* ********************************************************************** */
    
    /* --------------------------- Initialization --------------------------- */
    init(controller: DeliveryLogController) {
        self.sourceController = controller
        
    }
    
    /* -------------------------- External Access --------------------------- */
    /**
     External function to fetch delivery data from the RESTful API
     
     - Note:
     
     - Parameters:
     
     */
    public func fetchDeliveryLog() {
        let request = self.buildDeliveryFetchRequest(startingIndex: self.sourceController.orderStartIndex, numberOfItems: self.sourceController.orderEntryPerPage)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        HelperNetwork.manager.fetchRESTful(with: request, over: session, decodeInto: [DeliveryOrderEntry].self) { (data, error) in
            guard let data = data, error == nil else {
                return
            }
            
            self.sourceController.controllerView.updateDeliveryRenderContainer(fetchedLog: data)
        }
        
    }
    
    /* ---------------------------------------------------------------------- */
}

extension DeliveryLogModel {
    /* ---------------------- Model Internal Functions ---------------------- */
    /**
     Internal function to construct delivery data fetch request.
     
     - Note:
     In this demo, use static value to construct the request URL, and set the timeout to 30 seconds. Assuming the request URL will always be valid.
     In production however, components (host, endpoint parameters, etc.) are expected from API response / redirect instead.

     Check if  parameters exist append '?' to the end of the URL then append parameters separate by '&'.
     
     - Parameters:
        -   startingIndex: Optional query parameter for starting index.
        -   numberOfItems: Optional query parameter for number of items requested.
     */
    private func buildDeliveryFetchRequest(startingIndex: Int, numberOfItems: Int) -> URLRequest {
        let host = "mock-api-mobile.dev.lalamove.com"
        let endpoint = "/v2/deliveries"
        
        guard let requestURL = URL(string: "https://\(host)\(endpoint)?offset=\(startingIndex)&limit=\(numberOfItems)") else {
            assert(false, "<DeliveryLogModel> Invalid URL")
        }
        
        let request = HelperNetwork.manager.buildHTTPRequest(with: requestURL, httpMethod: HelperNetwork.HTTPMethod.get, timeout: 30, cachePolicy: nil, httpHeaders: nil, httpBody: nil)
        
        return request
    }
    /* ---------------------------------------------------------------------- */
}


public let orderImageCache = NSCache<AnyObject, AnyObject>()
