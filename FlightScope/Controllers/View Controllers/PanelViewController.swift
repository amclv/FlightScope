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
    
    let contentView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .lightGray
        return cv
    }()
    
    let panelTitle: UILabel = {
        let label = UILabel()
        label.text = "Test"
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
        
        scrollView.addSubview(contentView)
        contentView.anchor(top: scrollView.topAnchor,
                           bottom: scrollView.bottomAnchor,
                           leading: scrollView.leadingAnchor,
                           trailing: scrollView.trailingAnchor)
        contentView.centerX(inView: scrollView)
        contentView.centerY(inView: scrollView)
        
        contentView.addSubview(panelTitle)
        panelTitle.anchor(leading: contentView.leadingAnchor,
                          trailing: contentView.trailingAnchor)
        panelTitle.centerX(inView: contentView)
        
        panelTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        panelTitle.heightAnchor.constraint(equalToConstant: panelTitleHeight).isActive = true

    }
}

