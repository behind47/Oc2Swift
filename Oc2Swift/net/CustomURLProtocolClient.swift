//
//  CustomURLProtocolClient.swift
//  Oc2Swift
//
//  Created by behind47 on 2024/8/18.
//

import UIKit

class CustomURLProtocolClient: NSObject, URLProtocolClient  {
    
    
    /**
     @method URLProtocol:wasRedirectedToRequest:
     @abstract Indicates to an NSURLProtocolClient that a redirect has
     occurred.
     @param protocol the NSURLProtocol object sending the message.
     @param request the NSURLRequest to which the protocol implementation
     has redirected.
     */
    func urlProtocol(_ protocol: URLProtocol, wasRedirectedTo request: URLRequest, redirectResponse: URLResponse) {
        
    }

    
    /**
         @method URLProtocol:cachedResponseIsValid:
         @abstract Indicates to an NSURLProtocolClient that the protocol
         implementation has examined a cached response and has
         determined that it is valid.
         @param protocol the NSURLProtocol object sending the message.
         @param cachedResponse the NSCachedURLResponse object that has
         examined and is valid.
         */
    func urlProtocol(_ protocol: URLProtocol, cachedResponseIsValid cachedResponse: CachedURLResponse) {
        
    }

    
    /**
         @method URLProtocol:didReceiveResponse:
         @abstract Indicates to an NSURLProtocolClient that the protocol
         implementation has created an NSURLResponse for the current load.
         @param protocol the NSURLProtocol object sending the message.
         @param response the NSURLResponse object the protocol implementation
         has created.
         @param policy The NSURLCacheStoragePolicy the protocol
         has determined should be used for the given response if the
         response is to be stored in a cache.
         */
    func urlProtocol(_ protocol: URLProtocol, didReceive response: URLResponse, cacheStoragePolicy policy: URLCache.StoragePolicy) {
        
    }

    
    /**
         @method URLProtocol:didLoadData:
         @abstract Indicates to an NSURLProtocolClient that the protocol
         implementation has loaded URL data.
         @discussion The data object must contain only new data loaded since
         the previous call to this method (if any), not cumulative data for
         the entire load.
         @param protocol the NSURLProtocol object sending the message.
         @param data URL load data being made available.
         */
    func urlProtocol(_ protocol: URLProtocol, didLoad data: Data) {
        
    }

    
    /**
    @method URLProtocolDidFinishLoading:
         @abstract Indicates to an NSURLProtocolClient that the protocol
         implementation has finished loading successfully.
         @param protocol the NSURLProtocol object sending the message.
         */
    func urlProtocolDidFinishLoading(_ protocol: URLProtocol) {
        
    }

    
    /**
                @method URLProtocol:didFailWithError:
     @abstract Indicates to an NSURLProtocolClient that the protocol
     implementation has failed to load successfully.
     @param protocol the NSURLProtocol object sending the message.
     @param error The error that caused the load to fail.
     */
    func urlProtocol(_ protocol: URLProtocol, didFailWithError error: Error) {
        
    }

    
    /**
    @method URLProtocol:didReceiveAuthenticationChallenge:
         @abstract Start authentication for the specified request
         @param protocol The protocol object requesting authentication.
         @param challenge The authentication challenge.
         @discussion The protocol client guarantees that it will answer the
         request on the same thread that called this method. It may add a
         default credential to the challenge it issues to the connection delegate,
         if the protocol did not provide one.
         */
    func urlProtocol(_ protocol: URLProtocol, didReceive challenge: URLAuthenticationChallenge) {
        
    }

    
    /**
    @method URLProtocol:didCancelAuthenticationChallenge:
         @abstract Cancel authentication for the specified request
         @param protocol The protocol object cancelling authentication.
         @param challenge The authentication challenge.
         */
    func urlProtocol(_ protocol: URLProtocol, didCancel challenge: URLAuthenticationChallenge) {
        
    }
}
