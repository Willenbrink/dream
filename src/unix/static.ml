(* This file is part of Dream, released under the MIT license. See LICENSE.md
   for details, or visit https://github.com/aantron/dream.

   Copyright 2021 Anton Bachin *)



module Formats = Dream_pure.Formats
module Message = Dream_pure.Message
module Method = Dream_pure.Method
module Router = Dream__server.Router
module Stream = Dream_pure.Stream



(* TODO Not at all efficient; can at least stream the file, maybe even cache. *)
(* TODO Also mind newlines on Windows. *)

let mime_lookup' filename =
  match Magic_mime.lookup filename with
  | "text/html" -> Formats.text_html
  | content_type -> content_type

let mime_lookup filename = ["Content-Type", mime_lookup' filename]

(* TODO: this reads the entire file into memory as a string.
   [Eio.Path.with_open_in] gives us a read-only flow and
   [Cohttp_eio.Server.respond ~body] argument is a flow. Would be ideal to stream
   the response by connecting the source and sink directly. *)
let from_filesystem file _ =
  try
    let content = Eio.Path.load file in
    Message.response
      ~headers:(mime_lookup (snd file)) (Stream.string content) Stream.null
  with _exn ->
    Message.response ~status:`Not_Found Stream.empty Stream.null

(* TODO Add ETag handling. *)
(* TODO Add Content-Length handling? *)
(* TODO Support HEAD requests? *)

let static local_root = fun request ->
  if not @@ Method.methods_equal (Message.method_ request) `GET then
    Message.response ~status:`Method_Not_Allowed Stream.empty Stream.null

  else
    let path = List.fold_left Eio.Path.( / ) local_root (Router.path request) in
    let response = from_filesystem path request in
    if not (Message.has_header response "Content-Type") then begin
      match Message.status response with
      | `OK
      | `Non_Authoritative_Information
      | `No_Content
      | `Reset_Content
      | `Partial_Content ->
        Message.add_header response "Content-Type" (mime_lookup' (snd path))
      | _ ->
        ()
    end;
    response
