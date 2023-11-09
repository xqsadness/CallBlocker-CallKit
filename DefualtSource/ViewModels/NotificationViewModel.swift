//
//  NotificationViewModel.swift
//  DefualtSource
//
//  Created by daktech on 31/10/2023.
//

import Foundation

class NotificationModel: ObservableObject{
    static var shared = NotificationModel()
    
    func parseNoti(from NotiData: [String: Any]) -> NotificationModelUser? {
        guard let notiId = NotiData["notiId"] as? String,
              let title = NotiData["title"] as? String,
              let content = NotiData["content"] as? String,
              let idProduct = NotiData["idProduct"] as? String,
              let date = NotiData["date"] as? String,
              let idOder = NotiData["idOder"] as? String,
              let isWatched = NotiData["isWatched"] as? Bool else {
            return nil
        }
        return NotificationModelUser(notiId: notiId, title: title, content: content, idProduct: idProduct, idOder: idOder, date: date, isWatched: isWatched)
    }

}
