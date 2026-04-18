//
//  TableView.swift
//  
//
//  Created by Madina Samadzoda on 18/04/26.
//

import Foundation


extension DetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        let item = episodes[indexPath.row]

        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.date

        cell.backgroundColor = UIColor(white: 0.1, alpha: 1)
        cell.textLabel?.textColor = .white

        return cell
    }
}
