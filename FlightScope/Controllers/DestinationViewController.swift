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
    let searchBar = UISearchBar()
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove the views managed by the `FloatingPanelController` object from self.view.
        panel.removeFromParent()
    }
    
    // MARK: - Functions -
    private func configUI() {
        constraints()
        delegates()
        setFloatingPanel()
        
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = UIColor(red:0.73, green:0.76, blue:0.78, alpha:1.0)
    }
    
    private func delegates() {
        travelCollectionView.delegate = self
        travelCollectionView.dataSource = self
        searchBar.delegate = self
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
    
    // MARK: - Actions -
}

// MARK: - DestinationViewController Extensions -
extension DestinationViewController {
    // MARK: - Constraints -
    private func constraints() {
        // Explore Constraints
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        searchBar.setDimensions(width: view.frame.width, height: 60)
        
        view.addSubview(travelCollectionView)
        travelCollectionView.anchor(top: searchBar.bottomAnchor,
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
        let destination = firestoreController.destinationArray[indexPath.row]
        
        guard let urlString = destination.downloadLink,
              let url = URL(string: urlString) else { return UICollectionViewCell() }
        
        cell.locationName.text = destination.locationCountry
        cell.locationImageView.loadImageWithUrl(url)
        cell.layer.cornerRadius = cellCornerRadius
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let panel = PanelViewController()
        let destArray = firestoreController.destinationArray[indexPath.row]
        
        //Briefly fade the cell on selection
        UIView.animate(withDuration: 0.5, animations: {
            //Fade-out
            cell?.alpha = 0.5
        }) { (completed) in
            UIView.animate(withDuration: 0.5, animations: {
                //Fade-out
                cell?.alpha = 1
                UIView.animate(withDuration: 0.25) {
                    self.panel.move(to: .full, animated: false)
                }
            })
        }
        panel.panelTitle.text = destArray.locationCountry
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

// MARK: - DestinationViewController UISearchBarDelegate -
extension DestinationViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //            if searchText.count == 0 {
    //                isSearch = false
    //                self.maintableView.reloadData()
    //            } else {
    //                filteredTableData = tableData.filter({ (text) -> Bool in
    //                    let tmp: NSString = text as NSString
    //                    let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
    //                    return range.location != NSNotFound
    //                })
    //                if(filteredTableData.count == 0){
    //                    isSearch = false
    //                } else {
    //                    isSearch = true
    //                }
    //                self.maintableView.reloadData()
    //            }
    //        }
}
