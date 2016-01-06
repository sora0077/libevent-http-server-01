//
//  main.swift
//  libevent-http-server-01
//
//  Created by 林達也 on 2016/01/06.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import libevent

let HTTPD_ADDR = "0.0.0.0"
let HTTPD_PORT: UInt16 = 8080

func req_handler(req: UnsafeMutablePointer<evhttp_request>, arg: UnsafeMutablePointer<Void>) {
    
    if req.memory.type != EVHTTP_REQ_GET {
        evhttp_send_error(req, HTTP_BADREQUEST, "Available GET only")
    } else {
        evhttp_send_error(req, HTTP_NOTFOUND, "Not Found")
    }
}


let ev_base = event_base_new()
let httpd = evhttp_new(ev_base)

if evhttp_bind_socket(httpd, HTTPD_ADDR, HTTPD_PORT) < 0 {
    perror("evhttp_bind_socket()")
    exit(EXIT_FAILURE)
}

evhttp_set_gencb(httpd, req_handler, nil)
event_base_dispatch(ev_base)
evhttp_free(httpd)
event_base_free(ev_base)
