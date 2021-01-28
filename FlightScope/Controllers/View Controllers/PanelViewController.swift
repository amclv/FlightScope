//
//  PanelViewController.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/27/21.
//
// SCROLL VIEW NOTES:
// scrollView's .contentSize.width is now
// scrollView's width (defined by subviews' leading and trailing anchors
//
// and scrollView's .contentSize.height is now
// redView-Height + 20-pts-spacing +
// greenView-Height + 20-pts-spacing +
// blueView-Height +
// 8-pts top-padding + 8-pts bottom-padding
// or 956

import UIKit

class PanelViewController: UIViewController {
    
    // MARK: - Properties -
    let scrollViewSpacing: CGFloat = 8
    let panelTitleHeight: CGFloat = 70
    
    // MARK: - Computer Properties -
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = .customColor(.green)
        return v
    }()
    
    let panelTitle: UILabel = {
        let label = UILabel()
        label.textColor = .customColor(.black)
        label.textAlignment = .center
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        constraints()
    }

}

extension PanelViewController {
    private func constraints() {
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor,
                          bottom: view.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        
        scrollView.addSubview(panelTitle)
        panelTitle.anchor(leading: scrollView.leadingAnchor,
                          trailing: scrollView.trailingAnchor)
        
        panelTitle.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        panelTitle.heightAnchor.constraint(equalToConstant: panelTitleHeight).isActive = true

    }
}

