(* Text statistics *)
type stats = int * int * int * int


(* Utility functions to retrieve parts of a stats value *)
let lines (l,_,_,_) = l
let characters (_,c,_,_) = c
let words (_,_,w,_) = w
let sentences (_,_,_,s) = s

(* Read statistics from a channel *)
let stats_from_channel in_channel = 
  let lines = ref 0 in
  let characters = ref 0 in
  let words = ref 0 in
  let sentences = ref 0 in
    try
      while true do
        let line = input_line in_channel in
          lines := !lines + 1;
          (* print_string line; *)
          characters := !characters + String.length line;
          String.iter (fun c -> 
            match c with
              '.'| '?'|'!' -> sentences := !sentences + 1
            | ' ' -> words := !words + 1
            | _ -> ()) 
            line;
      done;
      (0,0,0,0)
    with
      End_of_file -> 
        words := !words + !lines;
        characters := !characters + !lines;
        (!lines, !characters, !words, !sentences)

(* Read statistics, given a filename. *)
let stats_from_file filename =
  let channel = open_in filename in
    let result = stats_from_channel channel in
      close_in channel;
      result