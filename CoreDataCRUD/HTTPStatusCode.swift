//
//  HTTPStatusCode.swift
//  CoreDataCRUD
//
//  Copyright © 2016 Jongens van Techniek. All rights reserved.
//

import Foundation

/**
Enum for HTTP response codes.
*/
enum HTTPStatusCode: Int {

    //1xx Informationals
    case `continue` = 100
    case switchingProtocols = 101

    //2xx Successfuls
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInformation = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206

    //3xx Redirections
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case unused = 306
    case temporaryRedirect = 307

    //4xx Client Errors
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case requestEntityTooLarge = 413
    case requestURITooLong = 414
    case unsupportedMediaType = 415
    case requestedRangeNotSatisfiable = 416
    case expectationFailed = 417

    //5xx Server Errors
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505

    static let getAll = [
        `continue`,
        switchingProtocols,
        ok,
        created,
        accepted,
        nonAuthoritativeInformation,
        noContent,
        resetContent,
        partialContent,
        multipleChoices,
        movedPermanently,
        found,
        seeOther,
        notModified,
        useProxy,
        unused,
        temporaryRedirect,
        badRequest,
        unauthorized,
        paymentRequired,
        forbidden,
        notFound,
        methodNotAllowed,
        notAcceptable,
        proxyAuthenticationRequired,
        requestTimeout,
        conflict,
        gone,
        lengthRequired,
        preconditionFailed,
        requestEntityTooLarge,
        requestURITooLong,
        unsupportedMediaType,
        requestedRangeNotSatisfiable,
        expectationFailed,
        internalServerError,
        notImplemented,
        badGateway,
        serviceUnavailable,
        gatewayTimeout,
        httpVersionNotSupported
    ]

}
