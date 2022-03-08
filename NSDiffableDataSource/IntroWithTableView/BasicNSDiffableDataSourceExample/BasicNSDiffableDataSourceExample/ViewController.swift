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
            // 2. Assign the city name to the cell's text.
            // 3. Convert the population into a readable string
            // 4. Assign the population text to the cell
            // 5. Update the cell with the new configuration:
            return cell
        }
    }
    
    private func configureInitialSnapshot() {
        // 1. Create the new snapshot
        
        // 2. Add Illinois section to the snapshot
        
        // 3. Add cities to the Illinois section
        // let chicago = CityInformation(name: "Chicago", population: 2710000)
        // let springfieldIL = CityInformation(name: "Springfield", population: 115888)
        // let champaign = CityInformation(name: "Champaign", population: 87636)
        // let bloomington = CityInformation(name: "Bloomington", population: 132600)
        
        // 4. Add Missouri section to the snapshot
        
        // 3. Add cities to the Missouri section
        // let stl = CityInformation(name: "St Louis", population: 308174)
        // let springfieldMO = CityInformation(name: "Springfield", population: 167051)
        // let columbia = CityInformation(name: "Columbia", population: 121230)
        
        // 5. Now that we are done adding sections and row data, apply it to the data source
    }
    
    // MARK: - Access functions on the UITableView Data Source here:
    private class DataSource: UITableViewDiffableDataSource<Section, CityInformation> {
        // 1. Allow editing on the table view to remove cities
        //  2. Add header so we know which section is which
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
