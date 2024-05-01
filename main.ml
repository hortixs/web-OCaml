open Unix;;
open Printf;;

let port = 8080;;
let web_root = "www";;

let read_file filename =
  let channel = open_in filename in
  let lines = ref [] in
  try
    while true; do
      lines := input_line channel :: !lines
    done; !lines
  with End_of_file ->
    close_in channel;
    String.concat "\n" (List.rev !lines);;

let serve_file out_channel filename =
  try
    let content = read_file (web_root ^ "/" ^ filename) in
    fprintf out_channel "HTTP/1.1 200 OK\r\n\r\n%s" content;
    flush out_channel;
  with Sys_error _ ->
    fprintf out_channel "HTTP/1.1 404 Not Found\r\n\r\n404 Not Found";
    flush out_channel;;

(* Fonction pour gérer les connexions entrantes *)
let handle_connection sockfd =
  let in_channel = in_channel_of_descr sockfd in
  let out_channel = out_channel_of_descr sockfd in
  try
    (* Lire la requête du client *)
    let line = input_line in_channel in
    let reg = Str.regexp "GET /\\([^ ]*\\) " in
    if Str.string_match reg line 0 then
      let filename = Str.matched_group 1 line in
      if filename = "" then
        serve_file out_channel "index.html" 
      else
        serve_file out_channel filename 
    else
      fprintf out_channel "HTTP/1.1 400 Bad Request\r\n\r\n400 Bad Request";
      flush out_channel;
    close_in in_channel;
    close_out out_channel
  with
  | End_of_file -> close_in in_channel;;

let start_server () =
  let start_server () =
    let sockaddr = ADDR_INET (inet_addr_any, port) in
    let sockfd = socket PF_INET SOCK_STREAM 0 in
    bind sockfd sockaddr;
    listen sockfd 10;
    printf "Serveur démarré sur le port %d...\n" port;
    flush stdout;
  
    while true do
      let (clientfd, _clientaddr) = accept sockfd in
      handle_connection clientfd
    done;;  
;;

start_server ();;
