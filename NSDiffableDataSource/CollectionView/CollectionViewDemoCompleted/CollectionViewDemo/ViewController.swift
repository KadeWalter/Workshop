//
//  ViewController.swift
//  CollectionViewDemo
//
//  Created by Kade Walter on 3/22/22.
//

import UIKit

class ViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, CityInformation>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        configureDataSource()
        configureInitialSnapshotWithListHeaderCells()
    }
    
    private func configureDataSource() {
        // Cell Registrations
        let stateHeaderCellRegistration = createHeaderListCellRegistration()
        let cityCellRegistration = createCityCellRegistration()
        
        // Configure the data source.
        self.dataSource = UICollectionViewDiffableDataSource<Section, CityInformation>(collectionView: self.collectionView) { (collectionView, indexPath, info) -> UICollectionViewListCell in
            switch info.rowType {
            case .Header:
                return collectionView.dequeueConfiguredReusableCell(using: stateHeaderCellRegistration, for: indexPath, item: info.name)
            case .City:
                return collectionView.dequeueConfiguredReusableCell(using: cityCellRegistration, for: indexPath, item: info)
            }
        }
    }
    
    private func createCityCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, CityInformation> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, CityInformation> { cell, indexPath, cityInfo in
            // 1. Grab the content configuration
            var config = cell.defaultContentConfiguration()
            
            // 2. Set the primary text to the city name:
            config.text = cityInfo.name
            
            // 3. Convert the population into a readable string
            //    and set the secondary text to the population.
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let pop = numberFormatter.string(from: NSNumber(value:cityInfo.population ?? 0))
            config.secondaryText = "Population \(pop ?? "")"
            
            // 4. Update the cells content configuration
            cell.contentConfiguration = config
        }
    }
    
    private func createHeaderListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, title in
            var content = cell.defaultContentConfiguration()
            content.text = title
            cell.contentConfiguration = content
            cell.accessories = [.outlineDisclosure(options: .init(style: .header))]
        }
    }
}

// MARK: - CollectionView Delegate information
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
        print(item.name)
        print(item.population ?? "Population Not Found")
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return false }
        return item.rowType == .Header ? false : true
    }
}

// MARK: - View Initializations
extension ViewController {
    private func initializeViews() {
        configureCollectionView()
        
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: configureCollectionViewLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return NSCollectionLayoutSection.list(using: .init(appearance: .insetGrouped), layoutEnvironment: layoutEnvironment)
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func configureInitialSnapshot() {
        // 1. Create the new snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, CityInformation>()
        
        // 2. Add Illinois section to the snapshot
        snapshot.appendSections([.Illinois])
        
        // 3. Add cities to the Illinois section
        let chicago = CityInformation(name: "Chicago", population: 2710000)
        let springfieldIL = CityInformation(name: "Springfield", population: 115888)
        let champaign = CityInformation(name: "Champaign", population: 87636)
        let bloomington = CityInformation(name: "Bloomington", population: 132600)
        snapshot.appendItems([chicago, springfieldIL, champaign, bloomington], toSection: .Illinois)
        
        // 4. Add Missouri section to the snapshot
        snapshot.appendSections([.Missouri])
        
        // 3. Add cities to the Missouri section
        let stl = CityInformation(name: "St Louis", population: 308174)
        let springfieldMO = CityInformation(name: "Springfield", population: 167051)
        let columbia = CityInformation(name: "Columbia", population: 121230)
        snapshot.appendItems([stl, springfieldMO, columbia], toSection: .Missouri)
        
        // 5. Now that we are done adding sections and row data, apply it to the data source
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureInitialSnapshotWithListHeaderCells() {
        // 1. Create the new snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, CityInformation>()
        
        // 2. Add the sections to the snapshot
        snapshot.appendSections(Section.allCases)
        
        // 3. Create a section snapshot for Illinois
        var illSnap = NSDiffableDataSourceSectionSnapshot<CityInformation>()
        
        // 4. Add a header cell for the Illinois section
        let illHeader = CityInformation(name: Section.Illinois.headerForSection(), rowType: .Header)
        illSnap.append([illHeader])
        // 5. Create the rows for the Illinois section
        let chicago = CityInformation(name: "Chicago", population: 2710000)
        let springfieldIL = CityInformation(name: "Springfield", population: 115888)
        let champaign = CityInformation(name: "Champaign", population: 87636)
        let bloomington = CityInformation(name: "Bloomington", population: 132600)
        // 6. Append the rows to the section header.
        illSnap.append([chicago, springfieldIL, champaign, bloomington], to: illHeader)
        
        
        // 7. Repeat for Missouri
        var moSnap = NSDiffableDataSourceSectionSnapshot<CityInformation>()
        let moHeader = CityInformation(name: Section.Missouri.headerForSection(), rowType: .Header)
        moSnap.append([moHeader])
        
        let stl = CityInformation(name: "St Louis", population: 308174)
        let springfieldMO = CityInformation(name: "Springfield", population: 167051)
        let columbia = CityInformation(name: "Columbia", population: 121230)
        moSnap.append([stl, springfieldMO, columbia], to: moHeader)
        
        // 8. Now that we are done adding sections and row data, apply it to the data source
        self.dataSource.apply(snapshot, animatingDifferences: false)
        self.dataSource.apply(illSnap, to: .Illinois, animatingDifferences: false)
        self.dataSource.apply(moSnap, to: .Missouri, animatingDifferences: false)
    }
}

// MARK: - Collection Modelling Data
extension ViewController {
    enum Section: Int, CaseIterable {
        case Illinois
        case Missouri
        
        func headerForSection() -> String {
            switch self {
            case .Illinois:
                return "Cities of Illinois"
            case .Missouri:
                return "Cities of Missouri"
            }
        }
    }
    
    enum RowType {
        case Header
        case City
    }
    
    struct CityInformation: Hashable {
        var name: String
        var population: Int?
        var rowType: RowType
        
        init(name: String, population: Int) {
            self.name = name
            self.population = population
            self.rowType = .City
        }
        
        init(name: String, rowType: RowType) {
            self.name = name
            self.rowType = rowType
        }
        
        private let identifier: UUID = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.identifier)
        }
    }
}
