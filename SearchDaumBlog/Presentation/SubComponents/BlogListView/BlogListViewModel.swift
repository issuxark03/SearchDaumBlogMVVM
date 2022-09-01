//
//  BlogListViewModel.swift
//  SearchDaumBlog
//
//  Created by Yongwoo Yoo on 2022/07/22.
//

import RxSwift
import RxCocoa

struct BlogListViewModel {
    let filterViewModel = FilterViewModel()
    
    //MainViewController -> BlogListView
    let blogCellData = PublishSubject<[BlogListCellData]>()
    let cellData: Driver<[BlogListCellData]>
    
    init() {
        self.cellData = blogCellData
            .asDriver(onErrorJustReturn: []) //만약에러나면 빈배열전달
    }
    
}
