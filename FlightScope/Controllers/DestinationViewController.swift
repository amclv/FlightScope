//
//  FlightDestinationViewController.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/26/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FloatingPanel

class DestinationViewController: UIViewController {
    
    let firestoreController = FirestoreController()
    
    // MARK: - Properties -
    let standardPadding: CGFloat = 20
    let cellCornerRadius: CGFloat = 20
    let standardSpacing: CGFloat = 8
    
    var panel: FloatingPanelController!
    
    // MARK: - Computer Properties -
    // Explore Section
    let travelCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DefaultCollectionViewCell.self, forCellWithReuseIdentifier: DefaultCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configUI()
        
        navigationItem.title = "Explore"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        firestoreController.fetchData {
            self.travelCollectionView.reloadData()
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        // Remove the views managed by the `FloatingPanelController` object from self.view.
//        panel.removeFromParent()
//    }
    
    // MARK: - Functions -
    private func configUI() {
        constraints()
        delegates()
        setFloatingPanel()
    }
    
    private func delegates() {
        travelCollectionView.delegate = self
        travelCollectionView.dataSource = self
    }
    
    private func setFloatingPanel() {
        // Initialize a 'FloatingPanelController'
        panel = FloatingPanelController()
        // Assign self as the delegate of the controller
        panel.delegate = self
        // Setup PanelViewController
        let panelVC = PanelViewController()
        panel.set(contentViewController: panelVC)
        // Track a scroll view in the PanelViewController
        panel.track(scrollView: panelVC.scrollView)
        // Adds the views managed by the FloatingPanelController object to self
        panel.addPanel(toParent: self)
        // Adds a corner radius to the FloatingPanel view.
        panel.surfaceView.appearance.cornerRadius = cellCornerRadius
    }
}

// MARK: - DestinationViewController Extensions -
extension DestinationViewController {
    // MARK: - Constraints -
    private func constraints() {
        // Explore Constraints
        view.addSubview(travelCollectionView)
        travelCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                    bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                    leading: view.leadingAnchor,
                                    trailing: view.trailingAnchor,
                                    paddingTop: standardPadding,
                                    paddingBottom: standardSpacing + 50)
    }
}

// MARK: - DestinationViewController UICollectionView -
extension DestinationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return firestoreController.destinationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCollectionViewCell.identifier, for: indexPath) as! DefaultCollectionViewCell
        let destination = firestoreController.destinationArray[indexPath.item]
        
        guard let urlString = destination.downloadLink,
              let url = URL(string: urlString) else { return UICollectionViewCell() }
        
        cell.locationName.text = destination.locationCountry
        cell.locationImageView.loadImageWithUrl(url)
        cell.layer.cornerRadius = cellCornerRadius
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationArray = firestoreController.destinationArray[indexPath.item]
        let float = PanelViewController()
        
        float.destination = destinationArray
        panel.show(animated: true, completion: { [self] in
//            panel.move(to: .full, animated: true)
            panel.modalPresentationStyle = .popover
            panel.present(float, animated: true, completion: nil)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: standardPadding, bottom: 0, right: standardPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 50, height: collectionView.frame.height)
    }
}

// MARK: - DestinationViewController FloatingPanelController Delegate -
extension DestinationViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return FloatingPanelStocksLayout()
    }
    
    class FloatingPanelStocksLayout: FloatingPanelLayout {
        let position: FloatingPanelPosition = .bottom
        let initialState: FloatingPanelState = .tip
        
        let full: CGFloat = 0
        let half: CGFloat = 422
        let tip: CGFloat = 45.0
        
        var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
            return [
                .full: FloatingPanelLayoutAnchor(absoluteInset: full, edge: .top, referenceGuide: .safeArea),
                .half: FloatingPanelLayoutAnchor(absoluteInset: half, edge: .bottom, referenceGuide: .superview),
                .tip: FloatingPanelLayoutAnchor(absoluteInset: tip, edge: .bottom, referenceGuide: .safeArea),
            ]
        }
        
        func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
            return 0.0
        }
    }
}
