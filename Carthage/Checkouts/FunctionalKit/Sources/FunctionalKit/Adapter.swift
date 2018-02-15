#if SWIFT_PACKAGE
	import Operadics
#endif
import Abstract

/// An Adapter establishes a one-to-one relationship from the Whole values to the Part values; the simplified case is an Iso, i.e. an isomorphism, and should behave as such.

public protocol AdapterType: OpticsType {
	var from: (SType) -> AType { get }
	var to: (BType) -> TType { get }
}

public struct Adapter<S,T,A,B>: AdapterType {
	public typealias SType = S
	public typealias TType = T
	public typealias AType = A
	public typealias BType = B

	public let from: (S) -> A
	public let to: (B) -> T

	public init(from: @escaping (S) -> A, to: @escaping (B) -> T) {
		self.from = from
		self.to = to
	}
}

public typealias Iso<Whole,Part> = Adapter<Whole,Whole,Part,Part>

// MARK: - Utility

extension Writer {
	public enum iso {
		public static var product: Iso<Writer,Product<L,A>> {
			return Iso<Writer,Product<L,A>>.init(
				from: { $0.toProduct },
				to: { $0.fold(Writer.init) })
		}
	}
}

extension Result {
	public enum iso {
		public static var coproduct: Iso<Result,Coproduct<E,T>> {
			return Iso<Result,Coproduct<E,T>>.init(
				from: { $0.toCoproduct },
				to: { $0.fold(onLeft: Result.failure, onRight: Result.success)})
		}
	}
}

// MARK: - Iso Laws

extension AdapterType {
	public func compose <OtherAdapter> (_ other: OtherAdapter) -> Adapter<SType,TType,OtherAdapter.AType,OtherAdapter.BType> where OtherAdapter: AdapterType, OtherAdapter.SType == AType, OtherAdapter.TType == BType {
		return Adapter.init(
			from: from..other.from,
			to: other.to..to)
	}

	public static func .. <OtherAdapter> (lhs: Self, rhs: OtherAdapter) -> Adapter<SType,TType,OtherAdapter.AType,OtherAdapter.BType> where OtherAdapter: AdapterType, OtherAdapter.SType == AType, OtherAdapter.TType == BType {
		return lhs.compose(rhs)
	}

	public var inverted: Adapter<BType,AType,TType,SType> {
		return Adapter.init(from: to, to: from)
	}

	public func under(_ transform: @escaping (TType) -> SType) -> (BType) -> AType {
		return to..transform..from
	}

	public var toLens: LensFull<SType,TType,AType,BType> {
		return LensFull.init(get: from, set: to..f.constant)
	}

	public static func .. <OtherLens> (lhs: Self, rhs: OtherLens) -> LensFull<SType,TType,OtherLens.AType,OtherLens.BType> where OtherLens: LensType, OtherLens.SType == AType, OtherLens.TType == BType {
		return lhs.toLens.compose(rhs)
	}

	public static func .. <OtherLens> (lhs: OtherLens, rhs: Self) -> LensFull<OtherLens.SType,OtherLens.TType,AType,BType> where OtherLens: LensType, OtherLens.AType == SType, OtherLens.BType == TType {
		return lhs.compose(rhs.toLens)
	}

	public var toPrism: PrismFull<SType,TType,AType,BType> {
		return PrismFull.init(tryGet: from, inject: to)
	}

	public static func .. <OtherPrism> (lhs: Self, rhs: OtherPrism) -> PrismFull<SType,TType,OtherPrism.AType,OtherPrism.BType> where OtherPrism: PrismType, OtherPrism.SType == AType, OtherPrism.TType == BType {
		return lhs.toPrism.compose(rhs)
	}

	public static func .. <OtherPrism> (lhs: OtherPrism, rhs: Self) -> PrismFull<OtherPrism.SType,OtherPrism.TType,AType,BType> where OtherPrism: PrismType, OtherPrism.AType == SType, OtherPrism.BType == TType {
		return lhs.compose(rhs.toPrism)
	}

	public var toAffine: AffineFull<SType,TType,AType,BType> {
		return AffineFull.init(tryGet: from, trySet: to..f.constant)
	}

	public static func .. <OtherAffine> (lhs: Self, rhs: OtherAffine) -> AffineFull<SType,TType,OtherAffine.AType,OtherAffine.BType> where OtherAffine: AffineType, OtherAffine.SType == AType, OtherAffine.TType == BType {
		return lhs.toAffine.compose(rhs)
	}

	public static func .. <OtherAffine> (lhs: OtherAffine, rhs: Self) -> AffineFull<OtherAffine.SType,OtherAffine.TType,AType,BType> where OtherAffine: AffineType, OtherAffine.AType == SType, OtherAffine.BType == TType {
		return lhs.compose(rhs.toAffine)
	}

}

// MARK: - Adapter Laws

/*:
## Enforcing Iso laws

An `Iso` should actually represent an isomorphism: this means that there's a one-to-one correspondence between instances of `Whole` and `Part` and I can always obtain a `Part` from a `Whole` and viceversa without gain or loss of information.

In other words this means that calling `from..to` on a `Whole` returns the same `Whole`, and `to..from` on a `Part` returns the same `Part`.
:*/

public enum IsoLaw {
	public static func fromTo<SomeIso>(whole: SomeIso.SType, iso: SomeIso) -> Bool where SomeIso: AdapterType, SomeIso.SType == SomeIso.TType, SomeIso.AType == SomeIso.BType, SomeIso.SType: Equatable {
		return (whole |> iso.from |> iso.to) == whole
	}

	public static func toFrom<SomeIso>(part: SomeIso.AType, iso: SomeIso) -> Bool where SomeIso: AdapterType, SomeIso.SType == SomeIso.TType, SomeIso.AType == SomeIso.BType, SomeIso.AType: Equatable {
		return (part |> iso.to |> iso.from) == part
	}

	public static func toFrom<SomeIso,T>(part: SomeIso.AType, iso: SomeIso) -> Bool where SomeIso: AdapterType, SomeIso.SType == SomeIso.TType, SomeIso.AType == SomeIso.BType, SomeIso.AType == Optional<T>, T: Equatable {
		return (part |> iso.to |> iso.from) == part
	}

	public static func toFrom<SomeIso,T>(part: SomeIso.AType, iso: SomeIso) -> Bool where SomeIso: AdapterType, SomeIso.SType == SomeIso.TType, SomeIso.AType == SomeIso.BType, SomeIso.AType == Array<T>, T: Equatable {
		return (part |> iso.to |> iso.from) == part
	}

	public static func toFrom<SomeIso,T>(part: SomeIso.AType, iso: SomeIso) -> Bool where SomeIso: AdapterType, SomeIso.SType == SomeIso.TType, SomeIso.AType == SomeIso.BType, SomeIso.AType == Dictionary<String,T>, T: Equatable {
		return (part |> iso.to |> iso.from) == part
	}

	public static func toFrom<SomeIso,T,U>(part: SomeIso.AType, iso: SomeIso) -> Bool where SomeIso: AdapterType, SomeIso.SType == SomeIso.TType, SomeIso.AType == SomeIso.BType, SomeIso.AType == (T,U), T: Equatable, U: Equatable {
		return (part |> iso.to |> iso.from) == part
	}
}
