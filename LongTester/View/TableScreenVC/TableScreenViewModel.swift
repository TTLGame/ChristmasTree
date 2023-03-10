//
//  TableScreenViewModel.swift
//  LongTester
//
//  Created by Long on 1/4/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class TableScreenViewModel {
//    var cellViewModels: BehaviorRelay<[TableScreenCellViewModel]> = BehaviorRelay(value: [])
//    private(set) var listUser: BehaviorRelay<[User]> = BehaviorRelay(value: [])
//
//    let api: Provider<MultiTarget>
//    let limit: Int = 50
//    init(basicViewModel: BasicViewModel = BasicViewModelImpl(),
//         api: Provider<MultiTarget> = ProviderAPIWithAccessToken<MultiTarget>()) {
//        self.basicViewModel = basicViewModel
//        self.api = api
//        super.init()
//        bindToEvents()
//    }
//
//    func bindToEvents() {
//        articles.map {articles in
//            articles.map {article in
//                return ArticleTableCellViewModelImpl(categoryName: article.category,
//                                                     title: article.title,
//                                                     body: article.body,
//                                                     thumbnail: article.imagePath,
//                                                     defaultImage: UIImage(named: "no_image"),
//                                                     data: article)
//            }
//        }.bind(to: cellViewModels).disposed(by: rx.disposeBag)
//    }
//
//    func getArticlesWithLoadMore(loadMore: Bool, showIndicator: Bool) {
//        if showIndicator == true {
//            basicViewModel.showIndicator.accept(true)
//        }
//        let offset = loadMore ? articles.value.count : 0
//        api.request(MultiTarget(SampleTarget.articleList(limit: limit, offset: offset)))
//            .map([ArticleInfo].self, using: JSONDecoder.decoderAPI(), failsOnEmptyData: false)
//            .subscribe {[weak self] event in
//                guard let self = self else { return }
//                switch event {
//                case .success(let value):
//                    var mutableArticles = Array(self.articles.value)
//                    if loadMore == false {
//                        mutableArticles.removeAll()
//                    }
//                    mutableArticles.insert(contentsOf: value, at: mutableArticles.count)
//                    self.articles.accept(mutableArticles)
//                    self.showsInfiniteScrolling.accept(value.count < self.limit)
//                case .error:
//                    break
//                }
//                self.basicViewModel.showIndicator.accept(false)
//                self.endLoadingAnimation.onNext(())
//            }.disposed(by: rx.disposeBag)
//    }
//
//    func deleteArticleAtIndex(index: NSInteger) {
//        let articleInfo = self.articles.value[index]
//        if let articleId = articleInfo.id {
//            basicViewModel.showProgressHUD.accept(true)
//
//            api.request(MultiTarget(SampleTarget.deleteArticle(id: articleId))).subscribe({[weak self] (_) in
//                guard let self = self else { return }
//                var mutableArticles = Array(self.articles.value)
//                mutableArticles.remove(at: index)
//                self.articles.accept(mutableArticles)
//                self.basicViewModel.showProgressHUD.accept(false)
//            }).disposed(by: rx.disposeBag)
//        }
//    }
}
