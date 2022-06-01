//
//  ViewController.swift
//  CompositionalEstimatedDynamicHeight
//
//  Created by Ting Yen Kuo on 2022/6/1.
//

import UIKit
import SnapKit

enum Section: Int, Hashable, CaseIterable {
    case image
}

enum ItemType: Hashable {
    case image(URL)
}

class Item: Hashable {
    let itemType: ItemType
    
    init(itemType: ItemType) {
        self.itemType = itemType
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.itemType == rhs.itemType
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(itemType)
    }
}

class ViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    private var dataSource: DataSource!
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupDataSource()
        populate(with: [.init(itemType: .image(URL(string: "https://lh3.googleusercontent.com/oxKosraI1W11cMRc6br9ITnM7ONDBThUyys2hZKJV16D47Hw5_8JWizoGf2LkfIyCJZx_HiMO0eho24H1cAzrlj1OvUTd5E-g9GH")!))])
    }
    
    private func populate(with items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
            snapshot.appendItems([items[0]], toSection: .image)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let heightDimension = NSCollectionLayoutDimension.estimated(44)
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: heightDimension)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: heightDimension)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.layoutMarginsGuide)
        }
    }
    
    private func setupDataSource() {
        let imageCellRegistration = UICollectionView.CellRegistration<ImageCell, Item> { (cell, indexPath, item) in
            guard case let .image(imageUrl) = item.itemType else { return }
            cell.populate(with: imageUrl)
        }
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: item)
        }
    }
}

