//
//  MainViewController.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/13/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbToday: UILabel!
    @IBOutlet weak var lbNumOfCreated: UILabel!
    @IBOutlet weak var lbNumOfCompleted: UILabel!
    @IBOutlet weak var clvTaskLists: UICollectionView!
    @IBOutlet weak var btnAddTaskList: UIButton!
    
    var taskLists: Results<TaskList>!
    let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
    }
    
    private func setupUI() {
        let today = Date()
        let dayString = today.dayOfWeek()
        let todayString = dayString + ", " + today.getSortDate()
        lbToday.attributedText = UtilsFunc.attributedText(withString: todayString, boldString: dayString, font: lbToday.font)
        btnAddTaskList.roundedButton(byCorners: [.topLeft])
    }
    
    private func setupCollectionView() {
        clvTaskLists.delegate = self
        clvTaskLists.dataSource = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        clvTaskLists.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    func reloadData() {
        taskLists = RealmService.shared.reference().objects(TaskList.self)
        let tasks = RealmService.shared.reference().objects(Task.self)
        lbNumOfCompleted.text = "\(tasks.filter("isCompleted = true").count)"
        lbNumOfCreated.text = "\(tasks.count)"
    }
    
    @IBAction func btnUserSettingPressed(_ sender: Any) {
        
    }
    
    @IBAction func btnAddPressed(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "newTaskList") else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
//        present(TaskListViewController(), animated: true, completion: nil)
    }
    
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taskListCell", for: indexPath) as? TaskListCollectionViewCell else {
            return UICollectionViewCell()
        }
        let taskList = taskLists[indexPath.row]
        cell.update(with: taskList)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * itemsPerRow * 2
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
