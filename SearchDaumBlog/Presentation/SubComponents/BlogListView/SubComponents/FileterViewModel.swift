//
//  FileterViewModel.swift
//  SearchDaumBlog
//
//  Created by Yongwoo Yoo on 2022/07/22.
//

import RxSwift
import RxCocoa

struct FilterViewModel {
    //FilterView 외부에서 관찰할
    let sortButtonTapped = PublishRelay<Void>()

    
}
