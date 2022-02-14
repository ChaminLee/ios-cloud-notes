//
//  MemoTableViewController.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/08.
//

import UIKit

class MemoTableViewController: UITableViewController {
    private let memoStorage = MemoStorage()
    private var memo = [Memo]()
    private let initialIndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellWithClass: MemoTableViewCell.self)
        fetchMemo()
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEmptyMemo))
    }
    
    private func configureTableView() {
        if self.splitViewController?.isCollapsed == false && memo.isEmpty == false {
            tableView.delegate?.tableView?(tableView, didSelectRowAt: initialIndexPath)
        }
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    private func fetchMemo() {
        memo = memoStorage.fetchAll()
    }
    
    @objc private func addEmptyMemo() {
        memoStorage.create()
        fetchMemo()
        tableView.insertRows(at: [initialIndexPath], with: .fade)
        tableView.scrollToRow(at: initialIndexPath, at: .bottom, animated: true)
    }
    
    private func deleteMemo(at indexPath: IndexPath) {
        self.memoStorage.delete(memo: self.memo[indexPath.row])
        fetchMemo()
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func presentDeleteAlert(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { action in
            self.deleteMemo(at: indexPath)
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MemoTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MemoTableViewCell.self, for: indexPath)
        
        let data = memo[indexPath.row]
        cell.configureCellContent(from: data)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MemoTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = memo[indexPath.row]
        
        guard let memoSplitViewController = self.splitViewController as? MemoSplitViewController else {
            return
        }
        
        memoSplitViewController.showSecondaryView(with: data, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
            self.deleteMemo(at: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .systemRed
        
        let shareAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            // TODO: 메모 공유 메서드
            completionHandler(true)
        }
        shareAction.image = UIImage(systemName: "square.and.arrow.up.fill")
        shareAction.backgroundColor = .systemIndigo
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
}
