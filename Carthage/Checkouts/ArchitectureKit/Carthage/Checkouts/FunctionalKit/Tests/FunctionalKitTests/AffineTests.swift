import XCTest
import SwiftCheck
@testable import FunctionalKit

class AffineTests: XCTestCase {
	static var allTests = [
		("testArrayAffineWellBehaved", testArrayAffineWellBehaved),
		("testComposedAffineWellBehaved", testComposedAffineWellBehaved),
		("testAffineZipWellBehaved", testAffineZipWellBehaved),
		("testAffineFromLensWellBehaved", testAffineFromLensWellBehaved),
		("testAffineFromPrismWellBehaved", testAffineFromPrismWellBehaved)
	]

	func testArrayAffineWellBehaved() {
		property("TrySetTryGet") <- forAll { (aa: ArrayOf<Int>, v: Int, i: UInt) in
			let array = aa.getArray
			let affine = type(of: array).affine(at: Int(i))
			return AffineLaw.trySetTryGet(affine: affine, whole: array, part: v)
		}

		property("TryGetTrySet") <- forAll { (aa: ArrayOf<Int>, i: UInt) in
			let array = aa.getArray
			let affine = type(of: array).affine(at: Int(i))
			return AffineLaw.tryGetTrySet(affine: affine, whole: array)
		}

		property("TrySetTrySet") <- forAll { (aa: ArrayOf<Int>, v: Int, i: UInt) in
			let array = aa.getArray
			let affine = type(of: array).affine(at: Int(i))
			return AffineLaw.trySetTrySet(affine: affine, whole: array, part: v)
		}
	}

	func testComposedAffineWellBehaved() {
		property("TrySetTryGet") <- forAll { (a: TestInclusive<Int,TestInclusive<Int,Int>>, v: Int) in
			let affine1 = type(of: a).affine.right
			let affine2 = TestInclusive<Int,Int>.affine.left
			let composed = affine1..affine2

			return AffineLaw.trySetTryGet(affine: composed, whole: a, part: v)
		}

		property("TryGetTrySet") <- forAll { (a: TestInclusive<Int,TestInclusive<Int,Int>>) in
			let affine1 = type(of: a).affine.right
			let affine2 = TestInclusive<Int,Int>.affine.left
			let composed = affine1..affine2

			return AffineLaw.tryGetTrySet(affine: composed, whole: a)
		}

		property("TrySetTrySet") <- forAll { (a: TestInclusive<Int,TestInclusive<Int,Int>>, v: Int) in
			let affine1 = type(of: a).affine.right
			let affine2 = TestInclusive<Int,Int>.affine.left
			let composed = affine1..affine2

			return AffineLaw.trySetTrySet(affine: composed, whole: a, part: v)
		}
	}

	func testAffineZipWellBehaved() {
		property("TrySetTryGet") <- forAll { (a: TestInclusive<TestInclusive<Int,Int>,TestInclusive<Int,Int>>, av: TestProduct<Int,Int>) in
			let affine1 = type(of: a).affine.right..TestInclusive<Int,Int>.affine.left
			let affine2 = type(of: a).affine.left..TestInclusive<Int,Int>.affine.right
			let zipped = Affine.zip(affine1, affine2)

			return AffineLaw.trySetTryGet(affine: zipped, whole: a, part: av.unwrap.unwrap)
		}

		property("TryGetTrySet") <- forAll { (a: TestInclusive<TestInclusive<Int,Int>,TestInclusive<Int,Int>>) in
			let affine1 = type(of: a).affine.right..TestInclusive<Int,Int>.affine.left
			let affine2 = type(of: a).affine.left..TestInclusive<Int,Int>.affine.right
			let zipped = Affine.zip(affine1, affine2)

			return AffineLaw.tryGetTrySet(affine: zipped, whole: a)
		}

		property("TrySetTrySet") <- forAll { (a: TestInclusive<TestInclusive<Int,Int>,TestInclusive<Int,Int>>, av: TestProduct<Int,Int>) in
			let affine1 = type(of: a).affine.right..TestInclusive<Int,Int>.affine.left
			let affine2 = type(of: a).affine.left..TestInclusive<Int,Int>.affine.right
			let zipped = Affine.zip(affine1, affine2)

			return AffineLaw.trySetTrySet(affine: zipped, whole: a, part: av.unwrap.unwrap)
		}
	}

	func testAffineFromLensWellBehaved() {
		property("TrySetTryGet") <- forAll { (a: TestProduct<Int,TestProduct<Int,Int>>, v: Int) in
			let lens1 = type(of: a).lens.second
			let lens2 = TestProduct<Int,Int>.lens.first
			let composed = lens1..lens2
			let affine = composed.toAffine

			return AffineLaw.trySetTryGet(affine: affine, whole: a, part: v)
		}

		property("TryGetTrySet") <- forAll { (a: TestProduct<Int,TestProduct<Int,Int>>) in
			let lens1 = type(of: a).lens.second
			let lens2 = TestProduct<Int,Int>.lens.first
			let composed = lens1..lens2
			let affine = composed.toAffine

			return AffineLaw.tryGetTrySet(affine: affine, whole: a)
		}

		property("TrySetTrySet") <- forAll { (a: TestProduct<Int,TestProduct<Int,Int>>, v: Int) in
			let lens1 = type(of: a).lens.second
			let lens2 = TestProduct<Int,Int>.lens.first
			let composed = lens1..lens2
			let affine = composed.toAffine

			return AffineLaw.trySetTrySet(affine: affine, whole: a, part: v)
		}
	}

	func testAffineFromPrismWellBehaved() {
		property("TrySetTryGet") <- forAll { (a: TestCoproduct<Int,TestCoproduct<Int,Int>>, v: Int) in
			let prism1 = type(of: a).prism.right
			let prism2 = TestCoproduct<Int,Int>.prism.left
			let composed = prism1..prism2
			let affine = composed.toAffine

			return AffineLaw.trySetTryGet(affine: affine, whole: a, part: v)
		}

		property("TryGetTrySet") <- forAll { (a: TestCoproduct<Int,TestCoproduct<Int,Int>>) in
			let prism1 = type(of: a).prism.right
			let prism2 = TestCoproduct<Int,Int>.prism.left
			let composed = prism1..prism2
			let affine = composed.toAffine

			return AffineLaw.tryGetTrySet(affine: affine, whole: a)
		}

		property("TrySetTrySet") <- forAll { (a: TestCoproduct<Int,TestCoproduct<Int,Int>>, v: Int) in
			let prism1 = type(of: a).prism.right
			let prism2 = TestCoproduct<Int,Int>.prism.left
			let composed = prism1..prism2
			let affine = composed.toAffine

			return AffineLaw.trySetTrySet(affine: affine, whole: a, part: v)
		}
	}

	func testLensPrismCompositionWellBehaved() {
		property("TrySetTryGet") <- forAll { (a: TestProduct<Int,TestCoproduct<Int,Int>>, v: Int) in
			let lens = type(of: a).lens.second
			let prism = TestCoproduct<Int,Int>.prism.left
			let composed = lens..prism

			return AffineLaw.trySetTryGet(affine: composed, whole: a, part: v)
		}

		property("TryGetTrySet") <- forAll { (a: TestProduct<Int,TestCoproduct<Int,Int>>) in
			let lens = type(of: a).lens.second
			let prism = TestCoproduct<Int,Int>.prism.left
			let composed = lens..prism

			return AffineLaw.tryGetTrySet(affine: composed, whole: a)
		}

		property("TrySetTrySet") <- forAll { (a: TestProduct<Int,TestCoproduct<Int,Int>>, v: Int) in
			let lens = type(of: a).lens.second
			let prism = TestCoproduct<Int,Int>.prism.left
			let composed = lens..prism

			return AffineLaw.trySetTrySet(affine: composed, whole: a, part: v)
		}
	}

	func testPrismLensCompositionWellBehaved() {
		property("TrySetTryGet") <- forAll { (a: TestCoproduct<Int,TestProduct<Int,Int>>, v: Int) in
			let prism = type(of: a).prism.right
			let lens = TestProduct<Int,Int>.lens.first
			let composed = prism..lens

			return AffineLaw.trySetTryGet(affine: composed, whole: a, part: v)
		}

		property("TryGetTrySet") <- forAll { (a: TestCoproduct<Int,TestProduct<Int,Int>>) in
			let prism = type(of: a).prism.right
			let lens = TestProduct<Int,Int>.lens.first
			let composed = prism..lens

			return AffineLaw.tryGetTrySet(affine: composed, whole: a)
		}

		property("TrySetTrySet") <- forAll { (a: TestCoproduct<Int,TestProduct<Int,Int>>, v: Int) in
			let prism = type(of: a).prism.right
			let lens = TestProduct<Int,Int>.lens.first
			let composed = prism..lens

			return AffineLaw.trySetTrySet(affine: composed, whole: a, part: v)
		}
	}
}
