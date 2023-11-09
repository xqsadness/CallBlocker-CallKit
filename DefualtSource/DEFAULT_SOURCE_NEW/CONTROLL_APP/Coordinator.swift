//
//  Coordinator.swift
//  Default_Project
//
//  Created by CycTrung on 25/05/2023.
//

import Foundation
import SwiftUI

enum Page: String, Identifiable{
    case NONE
    var id: String{
        return self.rawValue
    }
}

enum Sheet: String, Identifiable{
    case NONE
    var id: String{
        return self.rawValue
    }
}

enum FullScreenCover: String, Identifiable{
    case PREMIUM, premiumDefaultView
    
    var id: String{
        return self.rawValue
    }
}

class Coordinator: ObservableObject{
    static var shared = Coordinator()
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    func push(_ page: Page){
        path.append(page)
    }
    
    func present(_ sheet: Sheet){
        self.fullScreenCover = nil
        self.sheet = sheet
    }
    
    func presentFullScreen(_ fullScreenCover: FullScreenCover){
        self.sheet = nil
        self.fullScreenCover = fullScreenCover
    }
    
    func pop(){
        path.removeLast()
    }
    
    func popToRoot(){
        path.removeLast(path.count)
    }
    
    func dismissSheet(){
        self.sheet = nil
    }
    
    func dissmissFullscreenCover(){
        self.fullScreenCover = nil
    }
    
    @ViewBuilder
    func build(page: Page) -> some View{
        switch page{
            
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func build(sheet: Sheet, isRemoveBackground: Bool = false ,dentents: Set<PresentationDetent> = [.large]) -> some View{
        switch sheet{
        default:
            EmptyView()
                .background(isRemoveBackground ? RemoveBackground() : .init())
                .presentationDetents(dentents)
        }
    }
    
    @ViewBuilder
    func build(fullScreenCover: FullScreenCover) -> some View{
        switch fullScreenCover{
        case .premiumDefaultView:
            PremiumDefaultView()
                .environmentObject(Coordinator.shared)
        default:
            EmptyView()
        }
    }
    
    @discardableResult
    static func share(
        items: [Any],
        excludedActivityTypes: [UIActivity.ActivityType]? = nil
    ) -> Bool {
        guard let source = topViewController() else {
            return false
        }
        let vc = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        vc.excludedActivityTypes = excludedActivityTypes
        vc.popoverPresentationController?.sourceView = source.view
        source.present(vc, animated: true)
        return true
    }
    
    static func topViewController(_ viewController: UIViewController? = nil) -> UIViewController? {
        let vc = viewController ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
        if let navigationController = vc as? UINavigationController {
            return topViewController(navigationController.topViewController)
        } else if let tabBarController = vc as? UITabBarController {
            return tabBarController.presentedViewController != nil ? topViewController(tabBarController.presentedViewController) : topViewController(tabBarController.selectedViewController)
            
        } else if let presentedViewController = vc?.presentedViewController {
            return topViewController(presentedViewController)
        }
        return vc
    }
}

