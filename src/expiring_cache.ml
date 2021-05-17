open Core

type 'v entry =
  { mutable data: 'v
  ; mutable created: float
  }

type ('a, 'b) t =
  { ht: ('a, ('a Doubly_linked.Elt.t * 'b entry)) Hashtbl.t
  ; fifo: 'a Doubly_linked.t
  ; max_len: int
  ; max_age: float (* note: max_age is in ms *)
  }

let create ?(max_len = 100) ?(max_age = 100.) m =
  { ht = Hashtbl.create m
  ; fifo = Doubly_linked.create ()
  ; max_len = max_len
  ; max_age = max_age
  }

let find t ~key =
  let entry = Hashtbl.find_exn t.ht key |> snd in
  let time_passed = Unix.gettimeofday () -. entry.created  in
  if Float.compare time_passed t.max_age < 0 then
    Some entry.data
  else begin
    Hashtbl.remove t.ht key;
    None
  end

let mem t ~key =
  match find t ~key with
  | None -> false
  | Some _ -> true

let set t ~key ~data =
  match Hashtbl.find t.ht key with
  | None ->
    if Hashtbl.length t.ht = t.max_len then
      ignore (Doubly_linked.remove_first t.fifo);
    let elt = Doubly_linked.insert_last t.fifo key in
    let entry = {data = data; created = Unix.gettimeofday ()} in
    Hashtbl.set t.ht ~key ~data:(elt, entry)
  | Some (elt, entry) ->
    Doubly_linked.move_to_back t.fifo elt;
    entry.data <- data;
    entry.created <- Unix.gettimeofday ();
