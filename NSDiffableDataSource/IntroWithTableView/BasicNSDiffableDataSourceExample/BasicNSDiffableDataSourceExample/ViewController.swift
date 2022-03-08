//
//  ViewController.swift
//  BasicNSDiffableDataSourceExample
//
//  Created by Kade Walter on 3/3/22.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        self.navigationItem.title = "Cities"
        initializeViews()
        configureDataSource()
        configureInitialSnapshot()
    }
    
    private func configureDataSource() {
        self.dataSource = DataSource(tableView: self.tableView) {
            (tableView: UITableView, indexPath: IndexPath, city: CityInformation) -> UITableViewCell? in
            
            // Configure the UITableViewCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell") else { return nil }
            
            // Edit the configuration:
            // 1. Get the default content configuration:
            var content = cell.defaultContentConfiguration()
            // 2. Assign the city name to the cell's text.
            content.text = city.name
            
            // Convert the population into a readable string
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let pop = numberFormatter.string(from: NSNumber(value:city.population))
            
            // 3. Assign the population text to the cell
            content.secondaryText = "Population \(pop ?? "")"
            
            // 3. Update the cell with the new configuration:
            cell.contentConfiguration = content
            
            return cell
        }
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
    
    // MARK: - Access functions on the UITableView Data Source here:
    private class DataSource: UITableViewDiffableDataSource<Section, CityInformation> {
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                removeRowFromSnapshot(at: indexPath)
            }
        }
        
        private func removeRowFromSnapshot(at indexPath: IndexPath) {
            DispatchQueue.main.async {
                // 1. Grab the identifier of the item we are deleting
                if let idToDelete = self.itemIdentifier(for: indexPath) {
                    // 2. Grab a reference to the snapshot
                    var snapshot = self.snapshot()
                    // 3. Delete the item from the snapshot
                    snapshot.deleteItems([idToDelete])
                    // 4. Apply the updated snapshot to the data source
                    self.apply(snapshot, animatingDifferences: true)
                }
            }
        }
        
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            // 1. Get the section from the data source
            guard let section = self.sectionIdentifier(for: section) else { return "" }
            // 2. Use the header for section function we created
            return section.headerForSection()
        }
    }
}

// MARK: - View Initializations
extension ViewController {
    private func initializeViews() {
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityTableViewCell")
        
        configureEditingButton()
    }
    
    private func configureEditingButton() {
        let editingButton = UIBarButtonItem(title: self.tableView.isEditing ? "Done" : "Edit", style: .plain, target: self, action: #selector(toggleEditingMode))
        self.navigationItem.rightBarButtonItem = editingButton
    }
    
    @objc private func toggleEditingMode() {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        self.configureEditingButton()
    }
}

// MARK: - Table Modelling Data
extension ViewController {
    enum Section {
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
    
    struct CityInformation: Hashable {
        var name: String
        var population: Int
        
        private let identifier: UUID = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.identifier)
        }
    }
}
