open Base

(******************************************************************************
  Association list implementation.
  ******************************************************************************)

(*
   type t = (string * int) list

   let empty = []
   let to_list x = x

   let touch counts line =
     let count =
       match List.Assoc.find ~equal:String.equal counts line with
       | None -> 0
       | Some x -> x
     in
     List.Assoc.add ~equal:String.equal counts line (count + 1) *)

(******************************************************************************
  Map implementation.
  ******************************************************************************)
type t = int Map.M(String).t

let empty = Map.empty (module String)
let to_list t = Map.to_alist t

let touch t s =
  let count = match Map.find t s with None -> 0 | Some x -> x in
  Map.set t ~key:s ~data:(count + 1)

(* Awkward duplication to expose in mli. *)
type median = Median of string | Before_and_after of string * string

let median t =
  let sorted_strings =
    List.sort (Map.to_alist t) ~compare:(fun (_, x) (_, y) ->
        Int.descending x y)
  in
  let len = List.length sorted_strings in
  if len = 0 then failwith "median: empty frequency count";
  let nth n = fst (List.nth_exn sorted_strings n) in
  if len % 2 = 1 then Median (nth (len / 2))
  else Before_and_after (nth ((len / 2) - 1), nth (len / 2))
