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
        self.tabBarController?.tabBar.isHidden = false
		tableView!.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath)

        let meme = self.memes[indexPath.row]

		cell.imageView?.contentMode = UIViewContentMode.scaleToFill

        cell.imageView?.image = meme.composite

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {        
print("")
print("didSelectRowAtIndexPath")
print("")
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController

        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
