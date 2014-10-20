import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate {
    var collectionView: UICollectionView?
    let datesViewModel = DatesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "Spool Days"
        loadCollectionView()
        loadAddButton()
    }

    override func viewWillAppear(animated: Bool) {
        datesViewModel.fetch()
        super.viewWillAppear(animated)
    }
    
    func loadCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let width = (view.bounds.width - 30) / 3
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView!.registerClass(DateCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView!.delegate = self
        collectionView!.dataSource = datesViewModel
        collectionView!.backgroundColor = UIColor.whiteColor()
        view.addSubview(collectionView!)

        datesViewModel.rac_valuesForKeyPath("dates", observer: datesViewModel).subscribeNext({
            obj in
            self.collectionView!.reloadData()
        })
    }

    func loadAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addButtonTapped:"))
        navigationItem.rightBarButtonItem = addButton
    }

    func addButtonTapped(sender: AnyObject) {
        let editViewController = EditViewController(dateViewModel: DateViewModel())
        let navigationController = UINavigationController(rootViewController: editViewController)
        navigationController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        presentViewController(navigationController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
