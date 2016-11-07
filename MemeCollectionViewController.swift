import Foundation
import UIKit

// MARK: - MemeCollectionViewController: UICollectionViewController

class MemeCollectionViewController: UICollectionViewController {

	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
	
    // MARK: Properties
    
	var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
	
    // MARK: Table View Data Source

    override func viewDidLoad() {
        super.viewDidLoad()

//		let space: CGFloat = 2.0
		let dimension = (self.view.frame.size.width/* - (2 * space)*/) / 3.0

		flowLayout.minimumInteritemSpacing = 0
		flowLayout.minimumLineSpacing = 0
		flowLayout.itemSize = CGSize(width: dimension, height: dimension)

//collectionView?.allowsSelection = true
//collectionView?.isUserInteractionEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
		collectionView!.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell

        let meme = self.memes[indexPath.row]
//		cell.memeImageView.contentMode = UIViewContentMode.scaleAspectFit
        cell.memeImageView?.image = meme.composite

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
print("")
print("didSelectItemAtIndexPath")
print("")
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}
