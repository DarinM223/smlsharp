_interface "cleanup.smi"
infix 4 =
(* cleanup.sml
 *
 * COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 *
 * This provides a mechanism for registering actions that should be performed
 * at initialization or termination time.  We define five distinct contexts
 * for a hook:
 *
 *	AtExportML	just prior to exporting a heap image (exportML).
 *	AtExportFn	exit because of exportFn.
 *	AtExit		normal program exit.
 *	AtInit		initialization of a program that was generated by exportML.
 *	AtInitFn	initialization of a program that was generated by exportFn.
 *
 *)

(*
structure CleanUp : CLEAN_UP =
*)
structure SMLSharpSMLNJ_CleanUp : CLEAN_UP =
  struct

    datatype when = AtExportML | AtExportFn | AtExit | AtInit | AtInitFn

    val atAll = [AtExportML, AtExportFn, AtExit, AtInit, AtInitFn]

    val hooks = ref ([] : (string * when list * (when -> unit)) list)

  (* return the list of hooks that apply at when. *)
    fun filter when = let
	  fun f [] = []
	    | f ((item as (_, whenLst, _))::r) =
		  if (List.exists when whenLst) then item :: (f r) else (f r)
	  in
	    f (!hooks)
	  end

  (* apply the clean-up function for the given time.  In some cases, this
   * causes the list of hooks to be redefined.
   * NOTE: we reverse the order of application at initialization time.
   *)
    fun clean when = let
	  val cleanFns = (case when
(*
		 of (AtInit | AtInitFn) => List.rev (filter (fn w => (w = when)))
*)
		 of AtInit => List.rev (filter (fn w => (w = when)))
		  | AtInitFn => List.rev (filter (fn w => (w = when)))
		  | _ => filter (fn w => (w = when))
		(* end case *))
(*
	  fun exportFnPred (AtInitFn | AtExit) = true
*)
	  fun exportFnPred AtInitFn = true
	    | exportFnPred AtExit = true
	    | exportFnPred _ = false
	  fun initFnPred AtExit = true
	    | initFnPred _ = false
	  in
	  (* remove uneccesary clean-up routines *)
	    case when
	     of AtExportFn => hooks := filter exportFnPred
	      | AtInitFn => hooks := filter initFnPred
	      | _ => ()
	    (* end case *);
	  (* now apply the clean-up routines *)
	    List.app (fn (_, _, f) => (f when) handle _ => ()) cleanFns
	  end

  (* find and remove the named hook from the hook list; return the hook
   * and the new hook list; if the named hook doesn't exist, then return NONE.
   *)
    fun removeHook name = let
	  fun remove [] = NONE
	    | remove ((hook as (name', whenLst, cleanFn)) :: r) =
		if (name = name')
		  then SOME((whenLst, cleanFn), r)
		  else (case (remove r)
		     of NONE => NONE
		      | SOME(hook', r') => SOME(hook', hook::r')
		    (* end case *))
	  in
	    remove (! hooks)
	  end

  (* add the named cleaner.  This returns the previous definition, or NONE. *)
    fun addCleaner (arg as (name, _, _)) = (case (removeHook name)
	   of NONE => (hooks := arg :: !hooks; NONE)
	    | (SOME(oldHook, hookLst)) => (
		hooks := arg :: hookLst; SOME oldHook)
	  (* end case *))

  (* remove and return the named cleaner; return NONE if it is not found *)
    fun removeCleaner name = (case (removeHook name)
	   of NONE => NONE
	    | (SOME(oldHook, hookLst)) => (
		hooks := hookLst; SOME oldHook)
	  (* end case *))

  end (* CleanUp *)

