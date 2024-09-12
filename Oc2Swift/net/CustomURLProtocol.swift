//
//  CustomURLProtocol.swift
//  Oc2Swift
//
//  Created by behind47 on 2024/8/18.
//

import UIKit

class CustomURLProtocol: URLProtocol {
    
    
    /**
        @method initWithRequest:cachedResponse:client:
        @abstract Initializes an NSURLProtocol given request,
        cached response, and client.
        @param request The request to load.
        @param cachedResponse A response that has been retrieved from the
        cache for the given request. The protocol implementation should
        apply protocol-specific validity checks if such tests are
        necessary.
        @param client The NSURLProtocolClient object that serves as the
        interface the protocol implementation can use to report results back
        to the URL loading system.
    */
    override public init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
    }

    
    /**
        @method canInitWithRequest:
        @abstract This method determines whether this protocol can handle
        the given request.
        @discussion A concrete subclass should inspect the given request and
        determine whether or not the implementation can perform a load with
        that request. This is an abstract method. Subclasses must provide an
        implementation.
        @param request A request to inspect.
        @result YES if the protocol can handle the given request, NO if not.
    */
    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    
    /**
        @method canonicalRequestForRequest:
        @abstract This method returns a canonical version of the given
        request.
        @discussion It is up to each concrete protocol implementation to
        define what "canonical" means. However, a protocol should
        guarantee that the same input request always yields the same
        canonical form. Special consideration should be given when
        implementing this method since the canonical form of a request is
        used to look up objects in the URL cache, a process which performs
        equality checks between NSURLRequest objects.
        <p>
        This is an abstract method; subclasses must provide an
        implementation.
        @param request A request to make canonical.
        @result The canonical form of the given request.
    */
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    
    /**
        @method startLoading
        @abstract Starts protocol-specific loading of a request.
        @discussion When this method is called, the protocol implementation
        should start loading a request.
    */
    override open func startLoading() {
        
    }

    
    /**
        @method stopLoading
        @abstract Stops protocol-specific loading of a request.
        @discussion When this method is called, the protocol implementation
        should end the work of loading a request. This could be in response
        to a cancel operation, so protocol implementations must be able to
        handle this call while a load is in progress.
    */
    override open func stopLoading() {
        
    }

}
