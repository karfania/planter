import XCTest
@testable import Planter

class AuthViewModelTests: XCTestCase {

    var authViewModel: AuthViewModel!

    override func setUpWithError() throws {
        // Initialize the AuthViewModel for testing
        authViewModel = AuthViewModel()
    }

    override func tearDownWithError() throws {
        // Clean up resources if needed
        authViewModel = nil
    }

    func testSignInSuccess() {
        let expectation = XCTestExpectation(description: "Sign in successful")

        authViewModel.signIn(email: "test@example.com", password: "password") { result in
            switch result {
            case .success(let user):
                XCTAssertNotNil(user)
                XCTAssertTrue(self.authViewModel.isAuthenticated)
            case .failure(let error):
                XCTFail("Sign-in should not fail: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testSignInFailure() {
        let expectation = XCTestExpectation(description: "Sign in failure")

        authViewModel.signIn(email: "nonexistent@example.com", password: "wrongpassword") { result in
            switch result {
            case .success:
                XCTFail("Sign-in should fail")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertFalse(self.authViewModel.isAuthenticated)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    // Additional tests for signUp, signOut, and other AuthViewModel functionality...

}
