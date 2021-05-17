(* semantics: the cache will reset the expiration timer for a key everytime it
 * is [set] *)

(* represents entry that keys map to in underlying Hashtbl *)
type 'v entry

(* [Expiring_cache.t] is essentially a hashtable that holds elements whose
 * lifetime has not surpassed [max_age]. When the number of elements in the
 * cache exceeds [max_len], the cache evicts elements in FIFO fashion *)
type ('a, 'b) t

(* [create max_len max_age m] creates a [Expiring_cache.t] with the given
 * characteristics. [m] must be hashable, sexpable, and comparable due to the
 * underlying Base Hashtbl implementation *)
val create :
  ?max_len:int -> ?max_age:float -> 'a Base.Hashtbl.Key.t -> ('a, 'b) t

(* [find t key] returns an option around the data corresponding to the given
 * key. if the lifetime of [key] has exceeded [t.max_age], then the entry will
 * be evicted from the cache *)
val find : ('a, 'b) t -> key:'a -> 'b option

(* [mem t key] returns whether [key] is present in the cache, following the same
 * semantics as [find] *)
val mem : ('a, 'b) t -> key:'a -> bool

(* [set t key data] maps key to data in the cache. if the cache's size now
 * exceeds [t.max_len], then the oldest entry in the cache will be evicted *)
val set : ('a, 'b) t -> key:'a -> data:'b -> unit
