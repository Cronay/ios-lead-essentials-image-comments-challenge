//
//  ImageCommentsUIIntegrationTests.swift
//  EssentialAppTests
//
//  Created by Cronay on 22.12.20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

final class ImageCommentUIComposer {

	private init() {}

	static func makeUI() -> ImageCommentsViewController {
		let controller = ImageCommentsViewController()
		controller.title = ImageCommentsPresenter.title
		return controller
	}
}

class ImageCommentsViewController: UIViewController {

}

class ImageCommentsUIIntegrationTests: XCTestCase {

	func test_imageCommentsView_hasTitle() {
		let sut = ImageCommentUIComposer.makeUI()

		sut.loadViewIfNeeded()

		XCTAssertEqual(sut.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
	}

	func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
		let table = "ImageComments"
		let bundle = Bundle(for: ImageCommentsPresenter.self)
		let value = bundle.localizedString(forKey: key, value: nil, table: table)
		if value == key {
			XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
		}
		return value
	}

}
