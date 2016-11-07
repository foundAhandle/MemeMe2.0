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
		let dimension = (view.frame.size.width/* - (2 * space)*/) / 3.0

		flowLayout.minimumInteritemSpacing = 0
		flowLayout.minimumLineSpacing = 0
		flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
		collectionView!.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell

        let meme = memes[indexPath.row]
//		cell.memeImageView.contentMode = UIViewContentMode.scaleAspectFit
        cell.memeImageView?.image = meme.composite

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController

        detailController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }
}
