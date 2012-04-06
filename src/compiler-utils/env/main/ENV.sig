signature ENV =
sig
    type key
    type 'a map
    val compare : key * key -> order
    val empty : 'a map
    val isEmpty : 'a map -> bool
    val singleton : (key * 'a) -> 'a map
    val insert  : 'a map * key * 'a -> 'a map
    val insert' : ((key * 'a) * 'a map) -> 'a map
    val find : 'a map * key -> 'a option
    val lookup : 'a map * key -> 'a
    val inDomain : ('a map * key) -> bool
    val remove : 'a map * key -> 'a map * 'a
    val first : 'a map -> 'a option
    val firsti : 'a map -> (key * 'a) option
    val numItems : 'a map ->  int
    val listItems  : 'a map -> 'a list
    val listItemsi : 'a map -> (key * 'a) list
    val listKeys : 'a map -> key list
    val collate : ('a * 'a -> order) -> ('a map * 'a map) -> order
    val unionWith  : ('a * 'a -> 'a) -> ('a map * 'a map) -> 'a map
    val unionWithi : (key * 'a * 'a -> 'a) -> ('a map * 'a map) -> 'a map
    val intersectWith  : ('a * 'b -> 'c) -> ('a map * 'b map) -> 'c map
    val intersectWithi : (key * 'a * 'b -> 'c) -> ('a map * 'b map) -> 'c map
    val mergeWith : ('a option * 'b option -> 'c option)
	  -> ('a map * 'b map) -> 'c map
    val mergeWithi : (key * 'a option * 'b option -> 'c option)
	  -> ('a map * 'b map) -> 'c map
    val app  : ('a -> unit) -> 'a map -> unit
    val appi : ((key * 'a) -> unit) -> 'a map -> unit
    val map  : ('a -> 'b) -> 'a map -> 'b map
    val mapi : (key * 'a -> 'b) -> 'a map -> 'b map
    val foldl  : ('a * 'b -> 'b) -> 'b -> 'a map -> 'b
    val foldli : (key * 'a * 'b -> 'b) -> 'b -> 'a map -> 'b
    val foldr  : ('a * 'b -> 'b) -> 'b -> 'a map -> 'b
    val foldri : (key * 'a * 'b -> 'b) -> 'b -> 'a map -> 'b
    val filter  : ('a -> bool) -> 'a map -> 'a map
    val filteri : (key * 'a -> bool) -> 'a map -> 'a map
    val mapPartial  : ('a -> 'b option) -> 'a map -> 'b map
    val mapPartiali : (key * 'a -> 'b option) -> 'a map -> 'b map
    val insertWith : ('a -> unit) -> 'a map * key * 'a -> 'a map
    val fromList : (key * 'item) list -> 'item map
  end 
