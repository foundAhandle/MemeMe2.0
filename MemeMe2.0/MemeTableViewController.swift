import Foundation
import UIKit

// MARK: - MemeCollectionViewController: UICollectionViewController

class MemeTableViewController: UITableViewController {

    // MARK: Properties
    
	var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
	
    // MARK: Table View Data Source

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
		tableView!.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath)

        let meme = memes[indexPath.row]

        cell.imageView?.image = meme.composite

		cell.textLabel?.text = meme.topTxt + " " +
		  meme.btmTxt

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController

        detailController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }
}
