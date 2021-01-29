//
//  FloatPanelController.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/28/21.
//

//import Foundation
//import UIKit
//import FloatingPanel
//
//class FloatPanelController: UIViewController {
//    var panel: FloatingPanelController!
//    
//    func setData(dataSource: Destination) {
//        guard isViewLoaded, let contentView = panel.contentViewController as? ContentViewController else { return }
//        contentView.destination = dataSource
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Initialize a 'FloatingPanelController'
//        panel = FloatingPanelController()
//        // Assign self as the delegate of the controller
//        panel.delegate = self
//        // Setup PanelViewController
//        let panelVC = ContentViewController()
//        panel.set(contentViewController: panelVC)
//        // Track a scroll view in the PanelViewController
//        panel.track(scrollView: panelVC.scrollView)
//        // Adds the views managed by the FloatingPanelController object to self
////        panel.addPanel(toParent: self)
//    }
//}
//
//// MARK: - DestinationViewController FloatingPanelController Delegate -
//extension FloatPanelController: FloatingPanelControllerDelegate {
//    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
//        return FloatingPanelStocksLayout()
//    }
//    
//    class FloatingPanelStocksLayout: FloatingPanelLayout {
//        let position: FloatingPanelPosition = .bottom
//        let initialState: FloatingPanelState = .tip
//        
//        let full: CGFloat = 0
//        let half: CGFloat = 422
//        let tip: CGFloat = 45.0
//        
//        var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
//            return [
//                .full: FloatingPanelLayoutAnchor(absoluteInset: full, edge: .top, referenceGuide: .safeArea),
//                .half: FloatingPanelLayoutAnchor(absoluteInset: half, edge: .bottom, referenceGuide: .superview),
//                .tip: FloatingPanelLayoutAnchor(absoluteInset: tip, edge: .bottom, referenceGuide: .safeArea),
//            ]
//        }
//        
//        func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
//            return 0.0
//        }
//    }
//}
