//
//  MainViewModel.swift
//  SearchDaumBlog
//
//  Created by Yongwoo Yoo on 2022/07/22.
//

import RxSwift
import RxCocoa
import Foundation

struct MainViewModel {
    let disposeBag = DisposeBag()
    
    let blogListViewModel = BlogListViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    let alertActionTapped = PublishRelay<MainViewController.AlertAction>()
    let shoudPresentAlert: Signal<MainViewController.Alert>
    
    init(model: MainModel = MainModel()) {
        let blogResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest(model.searchBlog)
            .share()
        
        let blogValue = blogResult
            .compactMap(model.getBlogValue)
        
        let blogError = blogResult
            .compactMap(model.getBlogError)
        
        //네트워크로 가져온값을 cellData로 변환
        let cellData = blogValue
            .map(model.getBlogListCellData)
        
        //FilterView를 선택했을때 나오는 alertsheet를 선택했을 때 type
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)
        
        //MainViewController -> ListView
        Observable
            .combineLatest(
                sortedType,
                cellData,
                resultSelector: model.sort)
            .bind(to: blogListViewModel.blogCellData)
            .disposed(by: disposeBag)
        
        let alertSheetForSortting = blogListViewModel.filterViewModel.sortButtonTapped
            .map { _ -> MainViewController.Alert in
                return MainViewController.Alert(title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        let alertForErrorMessage = blogError
            .map { message -> MainViewController.Alert in
                return (title: "앗!",
                        message: "예상치 못한 오류가 발생했습니다. 잠시후 다시 시도해주세요. \(message)",
                        actions: [.confirm],
                        style: .alert
                        )
                
            }
        
        self.shoudPresentAlert = Observable
            .merge(
                alertSheetForSortting,
                alertForErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
        
    }
}
