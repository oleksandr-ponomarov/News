//   
//  ViperPresenter.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

protocol ExplorePresenterType {
    var numberOfRowsInSection: Int { get }
    var hasMoreNews: Bool { get }
    
    func articleCellModel(at indexPath: IndexPath) -> ArticleTableViewCellModel?
    func fetchNews(serchText: String)
    func fetchNextPage()
}

final class ExplorePresenter: ExplorePresenterType {
    
    private let interactor: ExploreInteractorType
    private let router: ExploreRouterType
    private weak var view: ExploreViewType?
    
    private var serchText: String = ""
    
    var numberOfRowsInSection: Int {
        interactor.articleEntity?.articles.count ?? 0
    }
    
    var hasMoreNews: Bool {
        !interactor.isLoading && !interactor.isLastPage
    }
    
    init(interactor: ExploreInteractorType,
         router: ExploreRouterType,
         view: ExploreViewType) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func articleCellModel(at indexPath: IndexPath) -> ArticleTableViewCellModel? {
        return interactor.articleEntity?.articles[indexPath.row]
    }
    
    func fetchNews(serchText: String) {
        interactor.fetchNews(serchText: serchText, page: 1, completion: fetchNewsCompletion)
    }
    
    func fetchNextPage() {
        interactor.fetchNextPage(completion: fetchNewsCompletion)
    }
}

// MARK: - Private methods
private extension ExplorePresenter {
    func fetchNewsCompletion(result: (Response<Bool>)) {
        switch result {
        case .success:
            self.view?.updateTableView()
        case .failure(let error):
            self.view?.hideTableFooterView()
        }
    }
}
