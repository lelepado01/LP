(*
Compila con :
    > ocamlc str.cma -o es5 es5.ml
 *)


let s = "ci,aouo aic.";;


let rec is_palindrome = fun i str ->
    let s = Str.global_replace (Str.regexp "[ ,.;:]+") "" str
    in 
        if s.[i] == s.[(String.length s) -1 -i] then
            if i < ((String.length s)/2) then
                is_palindrome (i+1) s
            else true
        else false;;

let bool_to_string = fun b ->
    if b then
        "true"
    else 
        "false";;
    
(*
Printf.printf "%s" (bool_to_string(is_palindrome 0 s));;*)

let sub_letter = fun l str ->
    Str.global_replace (Str.regexp (String.concat "" ["[";l;"]+"])) "" str;;

(*
Printf.printf "%s\n" (sub_letter "c" s);;
*)

let dict = ["ciao";"mamma";"come";"va"];;

;;

let anagram = fun str1 str2 ->
    if (String.length str1) <> (String.length str2) then
        false
    else
        let remove = fun c ->
            Str.replace_first (Str.regexp (String.make 1 c)) "" str2
        in 
            if (String.iter remove str1) = "" then
                true
            else
                false;;

    
Printf.printf "%s\n" (bool_to_string (anagram "ciao" "oaic"));;

