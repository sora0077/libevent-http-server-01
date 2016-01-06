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
    
    let evbuf = evbuffer_new()
    if evbuf == nil {
        evhttp_send_error(req, HTTP_SERVUNAVAIL, "Failed to create buffer")
        return
    }
    
    let message = "Hello world"
    evhttp_add_header(req.memory.output_headers, "Content-Type", "text/plain")
    evhttp_add_header(req.memory.output_headers, "Content-Length", "\(message.utf8.count)")
    evbuffer_add(evbuf, message, message.utf8.count)
    evhttp_send_reply(req, HTTP_OK, "", evbuf)
    evbuffer_free(evbuf)
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
