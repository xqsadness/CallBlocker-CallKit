
import Foundation
import StoreKit
import SwiftUI

enum IAP_MESSAGE: String{
    case RESTORE_COMPLETION = "RESTORE_COMPLETION"
    case RESTORE_FAILED = "RESTORE_FAILED"
    case PURCHASED_COMPLETION = "PURCHASED_COMPLETION"
    case PURCHASED_FAILED = "PURCHASED_FAILED"
    case REQUEST_PRODUCT_START = "REQUEST_PRODUCT_START"
    case REQUEST_PRODUCT_END = "REQUEST_PRODUCT_END"
}

enum TypeIAP{
    case disabled
    case restored
    case purchased
}

class IAPHandler: NSObject {
    static let shared = IAPHandler()
    
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    var purchaseStatusBlock: ((TypeIAP) -> Void)?
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    
    func getProduct() -> [SKProduct] {
        return iapProducts
    }
    
    func getPackage(productID: String) -> SKProduct? {
        for child in iapProducts {
            if child.productIdentifier == productID {
                return child
            }
        }
        return nil
    }
    
    func purchaseMyProduct(index: Int){
        if iapProducts.count == 0 {
            return
        }
        if self.canMakePurchases() {
            let product = iapProducts[index]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            productID = product.productIdentifier
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    func purchaseProduct(productID: String) {
        if let acivedProduct = getPackage(productID: productID) {
            let payment = SKPayment(product: acivedProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(){
        
        let iapPackages = CONSTANT.SHARED.IAP
        var productIdentifiers = Set<String>()
        
        for package in iapPackages {
            productIdentifiers.insert(package.PRODUCT_ID)
        }
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func fetchAvailableProducts(currproductID: String){
        let productIdentifiers = NSSet(array: [currproductID])
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    /**
     Check user package purchase to know user problem
     */
    func checkUserPurchasedPackage(completion: ((Data?) -> ())? = nil) {
        let verifyReceiptURL = CONSTANT.SHARED.INFO_APP.VERIFY_RECEIPT
        guard let receiptFileURL = Bundle.main.appStoreReceiptURL else{
            completion?(nil)
            return
        }
        var receiptData : NSData?
        do{
            receiptData = try NSData(contentsOf: receiptFileURL, options: NSData.ReadingOptions.alwaysMapped)
        }
        catch{
            print("ERROR: Could not get data from receipt" + error.localizedDescription)
        }
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) ?? ""
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString as AnyObject, "password" : CONSTANT.SHARED.INFO_APP.SECRET_PASS as AnyObject]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            storeRequest.httpBody = requestData
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: { (data, response, error) in
                guard let newData = data else {
                    completion?(nil)
                    return
                }
                completion?(newData)
            })
            task.resume()
        } catch let parseError {
            print(parseError)
            completion?(nil)
        }
    }
    /**
     
     */
    func checkReceiptValidate(completion: ((Bool?) -> ())? = nil) {
        debugPrint("Called to validate...")
        let verifyReceiptURL = CONSTANT.SHARED.INFO_APP.VERIFY_RECEIPT
        guard let receiptFileURL = Bundle.main.appStoreReceiptURL
        else {
            completion?(false)
            return
        }
        var receiptData : NSData?
        do{
            receiptData = try NSData(contentsOf: receiptFileURL, options: NSData.ReadingOptions.alwaysMapped)
        }
        catch{
            print("ERROR: " + error.localizedDescription)
            completion?(false)
            return
        }
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) ?? ""
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString as AnyObject, "password" : CONSTANT.SHARED.INFO_APP.SECRET_PASS as AnyObject]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            storeRequest.httpBody = requestData
            storeRequest.timeoutInterval = 5
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            let task = session.dataTask(with: storeRequest, completionHandler: { (data, response, error) in
                guard let newData = data else {
                    completion?(false)
                    return
                }
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: newData, options: JSONSerialization.ReadingOptions.mutableContainers)
                    debugPrint("JSON:",jsonResponse)
                    if let jsonDict = jsonResponse as? NSDictionary {
                        if let receiptInfo: NSArray = jsonDict["latest_receipt_info"] as? NSArray {
                            let arrSorted = receiptInfo.sorted { (dict1, dict2) -> Bool in
                                if let temp1 = dict1 as? NSDictionary {
                                    if let temp2 = dict2 as? NSDictionary {
                                        let date1 =  (temp1["expires_date"] as? String)?.toDate(format: "yyyy-MM-dd HH:mm:ss VV")
                                        let date2 =  (temp2["expires_date"] as? String)?.toDate(format: "yyyy-MM-dd HH:mm:ss VV")
                                        guard let d1 = date1, let d2 = date2 else {
                                           return false
                                        }
                                        return d1.compare(d2) == ComparisonResult.orderedAscending
                                    }
                                    return false
                                }
                                return false
                            }
                            
                            if arrSorted.count > 0 {
                                for child in arrSorted {
                                    if let appleDict = child as? NSDictionary {
                                        if let appleIAPID = appleDict["product_id"] as? String {
                                            if CONSTANT.SHARED.IAP.contains(where: { iap in
                                                return iap.PRODUCT_ID == appleIAPID
                                            }){
                                                guard let date = (appleDict["expires_date"] as? String)?.toDate(format: "yyyy-MM-dd HH:mm:ss VV") else{
                                                    return
                                                }
                                                if Int(date.timeIntervalSince1970) > User.shared.timeExpired{
                                                    UserDefaults.standard.set(Int(date.timeIntervalSince1970), forKey:  CONSTANT.EXPIRED_PREMIUM)
                                                    UserDefaults.standard.set(true, forKey: CONSTANT.IS_AUTO_RENEWS)
                                                }
                                                else{
                                                    UserDefaults.standard.set(false, forKey:  CONSTANT.IS_AUTO_RENEWS)
                                                }
                                                completion?(true)
                                                return

                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            debugPrint("JSon response is not Dictionary")
                            completion?(false)
                        }
                    }
                    else {
                        debugPrint("JSon response is not Dictionary")
                        completion?(false)
                    }
                    
                }catch let parseError {
                    print(parseError)
                    completion?(false)
                }
            })
            task.resume()
        } catch let parseError {
            print(parseError)
            completion?(false)
        }
    }
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request: SKProductsRequest, didReceive response:SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("Products Request End"), object: nil)
            }
        }else {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("Products Request End"), object: nil)
            }
        }
    }
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var isCheckedReceipt = false
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    debugPrint("purchased ID:",trans.transactionIdentifier as Any)
                    if CONSTANT.SHARED.IAP.count > 0{
                        for i in 0..<CONSTANT.SHARED.IAP.count{
                            if CONSTANT.SHARED.IAP[i].PRODUCT_ID == trans.payment.productIdentifier{
                                if CONSTANT.SHARED.IAP[i].KEY == "week"{
                                    UserDefaults.standard.set(Int(Date().addingTimeInterval(7*86400).timeIntervalSince1970), forKey: CONSTANT.EXPIRED_PREMIUM)
                                }
                                else if CONSTANT.SHARED.IAP[i].KEY == "month"{
                                    UserDefaults.standard.set(Int(Date().addingTimeInterval(30*86400).timeIntervalSince1970), forKey: CONSTANT.EXPIRED_PREMIUM)
                                }
                                else if CONSTANT.SHARED.IAP[i].KEY == "year" {
                                    UserDefaults.standard.set(Int(Date().addingTimeInterval(365*86400).timeIntervalSince1970), forKey: CONSTANT.EXPIRED_PREMIUM)
                                }
                            }
                        }
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("Purchased Successful"), object: nil)
                    self.purchaseStatusBlock?(.purchased)
                    break
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    NotificationCenter.default.post(name: NSNotification.Name("Fail Purchased"), object: nil)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if isCheckedReceipt == false {
                        checkReceiptValidate { [weak self](result) in
                            DispatchQueue.main.async {
                                self?.purchaseStatusBlock?(.restored)
                            }
                        }
                    }
                    isCheckedReceipt = true
                    break
                default: break
                }}}
    }
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        finishRestore(queue: queue)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        finishRestore(queue: queue)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("Restore Error"), object: nil)
    }
    
    func finishRestore(queue: SKPaymentQueue) {
        for transaction:SKPaymentTransaction  in queue.transactions {
            if transaction.transactionState == SKPaymentTransactionState.restored {
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            }
        }
        checkReceiptValidate { (result) in
            DispatchQueue.main.async {
                self.purchaseStatusBlock?(.restored)
                NotificationCenter.default.post(name: NSNotification.Name("Restore Successful"), object: nil)
            }
        }
    }
}


