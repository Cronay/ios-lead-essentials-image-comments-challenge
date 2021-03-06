//
//  ImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by Cronay on 20.12.20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public protocol ImageCommentsLoadingView {
	func display(_ viewModel: ImageCommentsLoadingViewModel)
}

public protocol ImageCommentsErrorView {
	func display(_ viewModel: ImageCommentsErrorViewModel)
}

public protocol ImageCommentsView {
	func display(_ viewModel: ImageCommentsViewModel)
}

public final class ImageCommentsPresenter {
	private let loadingView: ImageCommentsLoadingView
	private let errorView: ImageCommentsErrorView
	private let commentsView: ImageCommentsView
	private let currentDate: () -> Date

	private let dateFormatter = RelativeDateTimeFormatter()

	private var errorMessage: String {
		return NSLocalizedString("IMAGE_COMMENTS_VIEW_CONNECTION_ERROR",
								 tableName: "ImageComments",
								 bundle: Bundle(for: ImageCommentsPresenter.self),
								 comment: "Error message when loading failed")
	}

	public init(
		loadingView: ImageCommentsLoadingView,
		errorView: ImageCommentsErrorView,
		commentsView: ImageCommentsView,
		currentDate: @escaping () -> Date = Date.init,
		locale: Locale = Locale.current
	) {
		self.currentDate = currentDate
		self.loadingView = loadingView
		self.errorView = errorView
		self.commentsView = commentsView
		dateFormatter.locale = locale
	}

	public static var title: String {
		return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE",
			 tableName: "ImageComments",
			 bundle: Bundle(for: ImageCommentsPresenter.self),
			 comment: "Title for Image Comments view")
	}

	public func didStartLoadingComments() {
		loadingView.display(ImageCommentsLoadingViewModel(isLoading: true))
		errorView.display(ImageCommentsErrorViewModel.noError)
	}

	public func didFinishLoadingComments(with comments: [ImageComment]) {
		loadingView.display(ImageCommentsLoadingViewModel(isLoading: false))
		commentsView.display(ImageCommentsViewModel(presentables: createPresentables(from: comments)))
	}

	public func didFinishLoadingComments(with error: Error) {
		loadingView.display(ImageCommentsLoadingViewModel(isLoading: false))
		errorView.display(ImageCommentsErrorViewModel.error(message: errorMessage))
	}

	private func createPresentables(from comments: [ImageComment]) -> [PresentableImageComment] {
		return comments.map {
			PresentableImageComment(username: $0.author.username, message: $0.message, date: format($0.createdAt))
		}
	}

	private func format(_ date: Date) -> String {
		return dateFormatter.localizedString(for: date, relativeTo: currentDate())
	}
}
