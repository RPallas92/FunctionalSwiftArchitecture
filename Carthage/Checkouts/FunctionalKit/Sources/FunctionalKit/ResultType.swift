#if !XCODE_BUILD
	import Operadics
#endif
import Abstract

// MARK: - Definiton

// sourcery: functor
// sourcery: traversable
// sourcery: monad
// sourcery: concrete = "Result"
// sourcery: secondaryParameter = "ErrorType"
public protocol ResultType: TypeConstructor, CoproductType {
	associatedtype ErrorType: Error

	static func from(concrete: Concrete<ErrorType,ParameterType>) -> Self
	func run() throws -> ParameterType
	func fold <A> (onSuccess: (ParameterType) -> A, onFailure: (ErrorType) -> A) -> A
}

extension ResultType {
	public func fold<U>(onLeft: (ErrorType) -> U, onRight: (ParameterType) -> U) -> U {
		return fold(onSuccess: onRight, onFailure: onLeft)
	}
}

// MARK: - Data
// sourcery: testFunctor
// sourcery: testApplicative
// sourcery: testMonad
// sourcery: testConstruct = "success(x)"
// sourcery: testSecondaryParameter
public enum Result<E,T>: ResultType where E: Error {
	public typealias ErrorType = E
	public typealias ParameterType = T

	case success(T)
	case failure(E)

	public static func from(concrete: Result<E, T>) -> Result<E, T> {
		return concrete
	}
	
	public func run() throws -> T {
		switch self {
		case .success(let value):
			return value
		case .failure(let error):
			throw error
		}
	}

	public func fold<A>(onSuccess: (T) -> A, onFailure: (E) -> A) -> A {
		switch self {
		case .success(let value):
			return onSuccess(value)
		case .failure(let error):
			return onFailure(error)
		}
	}
}

// MARK: - Concrete

extension ResultType {
	public typealias Concrete<E,T> = Result<E,T> where E: Error
}

// MARK: - Equatable

extension ResultType where ErrorType: Equatable, ParameterType: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.fold(
			onSuccess: { value in
				rhs.fold(
					onSuccess: { value == $0 },
					onFailure: { _ in false })
		},
			onFailure: { error in
				rhs.fold(
					onSuccess: { _ in false },
					onFailure: { error == $0 })
		})
	}
}

// MARK: - Functor

extension ResultType {
	public func map <A> (_ transform: (ParameterType) -> A) -> Result<ErrorType,A> {
		return withoutActuallyEscaping(transform) { transform in
			fold(
				onSuccess: transform..Result.success,
				onFailure: Result.failure)
		}
	}

	public func mapError <A> (_ transform: (ErrorType) -> A) -> Result<A,ParameterType> {
		return withoutActuallyEscaping(transform) { transform in
			fold(
				onSuccess: Result.success,
				onFailure: transform..Result.failure)
		}
	}
    
    public static func lift<A>(_ function: @escaping (ParameterType) -> A) -> (Self) -> Result<ErrorType,A> {
        return { $0.map(function) }
    }
    
    public static func lift<A,Applicative2>(_ function: @escaping (ParameterType, Applicative2.ParameterType) -> A) -> (Self, Applicative2) -> Result<ErrorType, A> where Applicative2: ResultType, Applicative2.ErrorType == ErrorType {
        return { ap1, ap2 in
            Concrete.pure(fcurry(function)) <*> ap1 <*> ap2
        }
    }
    
    public static func lift<A,Applicative2,Applicative3>(_ function: @escaping (ParameterType, Applicative2.ParameterType, Applicative3.ParameterType) -> A) -> (Self, Applicative2, Applicative3) -> Result<ErrorType, A> where Applicative2: ResultType, Applicative3: ResultType, Applicative2.ErrorType == ErrorType, Applicative3.ErrorType == ErrorType {
        return { ap1, ap2, ap3 in
            Concrete.pure(fcurry(function)) <*> ap1 <*> ap2 <*> ap3
        }
    }
}

// MARK: - Cartesian

extension ResultType {
	public typealias Zipped<R1,R2> = Result<InclusiveError<R1.ErrorType,R2.ErrorType>,(R1.ParameterType,R2.ParameterType)> where R1: ResultType, R2: ResultType

	public static func zip<R1,R2>(_ first: R1, _ second: R2) -> Zipped<R1,R2> where R1: ResultType, R2: ResultType, ParameterType == (R1.ParameterType,R2.ParameterType), ErrorType == InclusiveError<R1.ErrorType,R2.ErrorType> {
		return first.fold(
			onSuccess: { firstValue in
				second.fold(
					onSuccess: { secondValue in
						Zipped<R1,R2>.success((firstValue,secondValue))
				},
					onFailure: { secondError in
						Zipped<R1,R2>.failure(InclusiveError.right(secondError))
				})
		},
			onFailure: { firstError in
				second.fold(
					onSuccess: { _ in
						Zipped<R1,R2>.failure(InclusiveError.left(firstError))
				},
					onFailure: { secondError in
						Zipped<R1,R2>.failure(InclusiveError.center(firstError, secondError))
				})
		})
	}
}

// MARK: - Applicative

extension ResultType {
	public static func pure(_ value: ParameterType) -> Result<ErrorType,ParameterType> {
		return Result<ErrorType,ParameterType>.success(value)
	}

	public func apply<R,T>(_ transform: R) -> Result<ErrorType,T> where R: ResultType, R.ErrorType == ErrorType, R.ParameterType == (ParameterType) -> T {
		return Result.zip(self, transform)
			.map { value, function in function(value) }
			.mapError { $0.left }
	}

	public static func <*> <R,T> (lhs: R, rhs: Self) -> Result<ErrorType,T> where R: ResultType, R.ErrorType == ErrorType, R.ParameterType == (ParameterType) -> T {
		return Result.zip(lhs, rhs)
			.map { function, value in function(value) }
			.mapError { $0.left }
	}
    
}

extension ResultType where ErrorType: Semigroup {
	public func applyMerge<R,T>(_ transform: R) -> Result<ErrorType,T> where R: ResultType, R.ErrorType == ErrorType, R.ParameterType == (ParameterType) -> T {
		return Result.zip(self, transform)
			.map { value, function in function(value) }
			.mapError { $0.merged() }
	}

	public static func <*> <R,T> (lhs: R, rhs: Self) -> Result<ErrorType,T> where R: ResultType, R.ErrorType == ErrorType, R.ParameterType == (ParameterType) -> T {
		return Result.zip(lhs, rhs)
			.map { function, value in function(value) }
			.mapError { $0.merged() }
	}
}

// MARK: - Traversable

extension ResultType {
	public typealias Traversed<Applicative> = Result<ErrorType,Applicative.ParameterType> where Applicative: TypeConstructor

	public func traverse<Applicative>(_ transform: (ParameterType) -> Applicative) -> [Traversed<Applicative>] where Applicative: ArrayType {
		typealias Returned = [Traversed<Applicative>]

		return fold(
			onSuccess: { (value) -> Returned in
				Applicative.Concrete.pure(Traversed<Applicative>.success) <*> transform(value)
		},
			onFailure: { (error) -> Returned in
				Returned.pure(Traversed<Applicative>.failure(error))
		})
	}

	public func traverse<Applicative>(_ transform: (ParameterType) -> Applicative) -> Future<Traversed<Applicative>> where Applicative: FutureType {
		typealias Returned = Future<Traversed<Applicative>>

		return fold(
			onSuccess: { (value) -> Returned in
				Applicative.Concrete.pure(Traversed<Applicative>.success) <*> transform(value)
		},
			onFailure: { (error) -> Returned in
				Returned.pure(Traversed<Applicative>.failure(error))
		})
	}

	public func traverse<Applicative>(_ transform: (ParameterType) -> Applicative) -> Optional<Traversed<Applicative>> where Applicative: OptionalType {
		typealias Returned = Optional<Traversed<Applicative>>

		return fold(
			onSuccess: { (value) -> Returned in
				Applicative.Concrete.pure(Traversed<Applicative>.success) <*> transform(value)
		},
			onFailure: { (error) -> Returned in
				Returned.pure(Traversed<Applicative>.failure(error))
		})
	}

	public func traverse<Applicative>(_ transform: (ParameterType) -> Applicative) -> Reader<Applicative.EnvironmentType,Traversed<Applicative>> where Applicative: ReaderType {
		typealias Returned = Reader<Applicative.EnvironmentType,Traversed<Applicative>>

		return fold(
			onSuccess: { (value) -> Returned in
				Applicative.Concrete.pure(Traversed<Applicative>.success) <*> transform(value)
		},
			onFailure: { (error) -> Returned in
				Returned.pure(Traversed<Applicative>.failure(error))
		})
	}

	public func traverse<Applicative>(_ transform: (ParameterType) -> Applicative) -> Result<Applicative.ErrorType,Traversed<Applicative>> where Applicative: ResultType {
		typealias Returned = Result<Applicative.ErrorType,Traversed<Applicative>>

		return fold(
			onSuccess: { (value) -> Returned in
				Applicative.Concrete.pure(Traversed<Applicative>.success) <*> transform(value)
		},
			onFailure: { (error) -> Returned in
				Returned.pure(Traversed<Applicative>.failure(error))
		})
	}

    public func traverse<Applicative>(_ transform: (ParameterType) -> Applicative) -> State<Applicative.StateParameterType,Traversed<Applicative>> where Applicative: StateType {
        typealias Returned = State<Applicative.StateParameterType,Traversed<Applicative>>
        
        return fold(
            onSuccess: { (value) -> Returned in
                Applicative.Concrete.pure(Traversed<Applicative>.success) <*> transform(value)
        },
            onFailure: { (error) -> Returned in
                Returned.pure(Traversed<Applicative>.failure(error))
        })
    }

	public func traverse<Applicative>(_ transform: (ParameterType) -> Applicative) -> Writer<Applicative.LogType,Traversed<Applicative>> where Applicative: WriterType {
		typealias Returned = Writer<Applicative.LogType,Traversed<Applicative>>

		return fold(
			onSuccess: { (value) -> Returned in
				Applicative.Concrete.pure(Traversed<Applicative>.success) <*> transform(value)
		},
			onFailure: { (error) -> Returned in
				Returned.pure(Traversed<Applicative>.failure(error))
		})
	}
}

// MARK: - Monad

extension ResultType where ParameterType: ResultType, ParameterType.ErrorType == ErrorType {
	public var joined: Result<ErrorType,ParameterType.ParameterType> {
		return fold(
			onSuccess: { subresult in
				subresult.fold(
					onSuccess: { value in Result.success(value) },
					onFailure: { error in Result.failure(error) })
		},
			onFailure: { error in
				Result.failure(error)
		})
	}
}

extension ResultType {
	public func flatMap<R>(_ transform: (ParameterType) -> R) -> Result<ErrorType,R.ParameterType> where R: ResultType, R.ErrorType == ErrorType {
		return map(transform).joined
	}
}

// MARK: - Utility

extension ResultType {
	public var toOptionalError: ErrorType? {
		return fold(
			onSuccess: fconstant(nil),
			onFailure: fidentity)
	}

	public var toOptionalValue: ParameterType? {
		return fold(
			onSuccess: fidentity,
			onFailure: fconstant(nil))
	}

	public func fallback(to defaultValue: @autoclosure () -> ParameterType) -> Result<ErrorType,ParameterType> {
		return fold(
			onSuccess: Result.success,
			onFailure: { _ in Result.success(defaultValue()) })
	}
}
