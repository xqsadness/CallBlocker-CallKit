//
//  CustomSheet.swift
//  RingtoneMVVM2023
//
//  Created by CycTrung on 01/06/2023.
//

import Foundation
import SwiftUI

extension View{
    func customSheet<SheetView: View>(height: CGFloat, detents: [UISheetPresentationController.Detent]? = nil, showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping ()->SheetView)->some View{
        return self.background(
            SheetHepler(sheetView: sheetView(), height: height, detents: detents, showSheet: showSheet)
        )
    }
    
    var deviceCornerRadius: CGFloat{
        let key = "_displayCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen{
            if let cornerRadius = screen.value(forKey: key) as? CGFloat{
                return cornerRadius
            }
            return 0
        }
        return 0
    }
}

struct RemoveBackground: UIViewRepresentable{
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}
struct SheetHepler<SheetView: View>: UIViewControllerRepresentable{
    var sheetView: SheetView
    var height: CGFloat
    var detents: [UISheetPresentationController.Detent]? = nil
    @Binding var showSheet: Bool
    let controller = UIViewController()
    
    func makeUIViewController(context: Context) ->  UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if showSheet{
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.height = height
            uiViewController.present(sheetController, animated: true)
        }else{
            uiViewController.dismiss(animated: true)
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content>{
    var height: CGFloat = 0.0
    var detents: [UISheetPresentationController.Detent]? = nil
    override func  viewDidLoad() {
        if let presentationController = presentationController as? UISheetPresentationController{
            //preferredContentSize.height = height
            if let dentent = detents{
                if #available(iOS 16.0, *) {
                    presentationController.detents = dentent +  [.custom(resolver: { context in
                        return self.height
                    })]
                } else {
                    presentationController.detents = dentent
                }
            }else{
                if #available(iOS 16.0, *) {
                    presentationController.detents = [.custom(resolver: { context in
                        return self.height
                    })]
                } else {
                    if height <= UIScreen.main.bounds.height / 2 - 60 {
                        presentationController.detents = [.medium()]
                    }
                    else{
                        presentationController.detents = [.large()]
                    }
                }
            }
        }
    }
}
