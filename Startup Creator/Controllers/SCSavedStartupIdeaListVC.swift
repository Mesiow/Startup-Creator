//
//  SCSavedStartupIdeaListVC.swift
//  Startup Creator
//
//  Created by Chris W on 1/5/25.
//

import UIKit

protocol SCSavedStartupIdeaListDelegate: AnyObject {
    func saveIdeaEntry(idea: Idea)
}

class SCSavedStartupIdeaListVC: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 15;
            flowLayout.minimumInteritemSpacing = 1;
        
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
            collectionView.register(SCStartupIdeaCell.self, forCellWithReuseIdentifier: SCStartupIdeaCell.identifier)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .clear
            collectionView.showsVerticalScrollIndicator = false
            collectionView.allowsSelection = true;
            collectionView.isScrollEnabled = true;
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            return collectionView
        }()
    
    var ideas: [Idea] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = SCColors.background
        navigationController?.navigationBar.prefersLargeTitles = true
        
        ideas = SCCoreDataManager.fetchData()
        
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func presentSavedStartupIdeaVC(idea: Idea){
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        let savedIdeaVC = SCSavedStartupIdeaVC(idea: idea)
        navigationController?.pushViewController(savedIdeaVC, animated: true)
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

//Collection view
extension SCSavedStartupIdeaListVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ideas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SCStartupIdeaCell.identifier, for: indexPath) as! SCStartupIdeaCell
        
        let content = ideas[indexPath.row].content!
        cell.set(content: content)
    
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
            //Animate cell selection
        UIView.animate(withDuration: 0.1,
                           animations: {
                        //Fade-out
                        cell?.alpha = 0.7
                        cell!.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (completed) in
                UIView.animate(withDuration: 0.1,
                               animations: {
                        //Fade-in
                        cell?.alpha = 1
                        cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
                    
                        //do something
                    let idea = self.ideas[indexPath.row]
                    self.presentSavedStartupIdeaVC(idea: idea)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        //index path count should always be one since we are only selecting one cell at a time
        if indexPaths.count == 1 {
            let indexPath = indexPaths.first!
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let delete = UIAction(
                    title: "Delete",
                    image: SCImages.trashImage,
                    identifier: nil,
                    discoverabilityTitle: nil,
                    attributes: .destructive,
                    state: .off
                ) { _ in
                     self.ideas = SCCoreDataManager.deleteIdeaFromCollection(in: self.ideas, at: indexPath);
                     
                     //perform deletion updates to the collection view
                     self.collectionView.performBatchUpdates {
                         self.collectionView.deleteItems(at: indexPaths)
                     } completion: { finished in
                         self.collectionView.reloadData()
                     }
                }
                
                return UIMenu(title: "Options", image: nil, identifier: nil,
                              options: .displayInline, children: [delete])
            }
            return config
        }
        return nil
    }
}

extension SCSavedStartupIdeaListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 10.0, bottom: 1.0, right: 10.0);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let widthPerItem = collectionView.frame.width /// 2 - layout.minimumInteritemSpacing;
            return CGSize(width: widthPerItem - 40, height: 85)
    }
}
//

//Delegate
extension SCSavedStartupIdeaListVC : SCSavedStartupIdeaListDelegate {
    func saveIdeaEntry(idea: Idea) {
        self.ideas.append(idea)
        
        //refresh data and table
        self.ideas = SCCoreDataManager.reloadData() //saves, then fetches newly updated data
        self.collectionView.reloadData()
    }
}
