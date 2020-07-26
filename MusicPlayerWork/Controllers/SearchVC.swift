//
//  SearchVC.swift
//  MusicPlayerWork
//
//  Created by Mac on 26.07.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import CollectionKit

class SearchVC: UIViewController {
    var collectionView : CollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    func setCollectionView(){
        
        self.collectionView = CollectionView()
        let dataSource = ArrayDataSource(data: [1, 2, 3, 4])
        let viewSource = ClosureViewSource(viewUpdater: { (view: UILabel, data: Int, index: Int) in
          view.backgroundColor = .red
          view.text = "\(data)"
        })
        let sizeSource = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
          return CGSize(width: 100, height: 100)
        }
        let provider = BasicProvider(
          dataSource: dataSource,
          viewSource: viewSource,
          sizeSource: sizeSource
        )
       let inset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
      provider.layout = FlowLayout(spacing: 10).transposed().inset(by: inset)
        
        let dS2 = ArrayDataSource(data: [123,123,123,123])
        let vS2 = ClosureViewSource(viewUpdater: { (view: UILabel, data: Int, index: Int) in
          view.backgroundColor = .blue
          view.text = "\(data)"
        })
        let sS2 = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
          return CGSize(width: 100, height: 100)
        }
        
        let provider2 = BasicProvider(
                 dataSource: dS2,
                 viewSource: vS2,
                 sizeSource: sS2
               )
        
        self.collectionView.provider = ComposedProvider(sections: [provider, provider2])
        
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints  = false
        self.view.addSubview(self.collectionView)
        
        self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}
