type couleur = Blanc | Noir 
type quadtree = Feuille of couleur | Noeud of quadtree * quadtree * quadtree * quadtree

(*Question1*)

let quadtree_full = fun n ->
  let rec aux = fun n1->
    if n1 <=1 then Feuille Noir
    else Noeud(aux(n1-1),aux(n1-1),aux(n1-1),aux(n1-1))
  in
  aux n ;;
(*---------------------------------------------------------------------------------------------------------------------------------------------------------*)
let quadtree_empty = fun n ->

  let rec aux = fun n1 ->
    if n1<=1 then Feuille Blanc
    else Noeud (aux(n1-1),aux(n1-1),aux(n1-1),aux(n1-1))
  in
  aux n;;
(*question 2*)
let rec inverse = fun t ->
  match t with
    |Feuille Blanc -> Feuille Noir
    |Feuille Noir ->Feuille Blanc
    |Noeud (a,b,c,d)-> Noeud (inverse a ,inverse b , inverse c , inverse d);;
(*Question 3*)
let rec rotate =fun a ->
  match a with
    |Feuille _ -> a
    |Noeud (a,b,c,d) -> Noeud(rotate b , rotate c ,rotate d, rotate a );;
(*Question 4*)

(**
  Renvoie le r�sultat quadtree de l'union de deux quadtree donn�s.
  Si un pixel de l'union quadtree est noir, alors ce pixel est noir dans le premier ou le deuxi�me quadtree donn�.*)
let rec union a b =
  match (a,b) with
    | (Noeud (q11, q12, q13, q14), Noeud (q21, q22, q23, q24)) ->
      let res = Noeud (union q11 q21, union q12 q22, union q13 q23, union q14 q24)
      in (match res with
        | Noeud (Feuille Noir, Feuille Noir, Feuille Noir, Feuille Noir) -> Feuille Noir
        | _ -> res)
    | (Feuille Blanc, Noeud (q1, q2, q3, q4)) | (Noeud (q1, q2, q3, q4), Feuille Blanc) ->
      Noeud ((union (Feuille Blanc) q1), (union (Feuille Blanc) q3),
        (union (Feuille Blanc) q3), (union (Feuille Blanc) q4))
    | (Feuille Blanc, Feuille Blanc) -> Feuille Blanc
    | _ -> Feuille Noir;;

	     
(*QUESTION5*)
(** Renvoie le r�sultat rquadtree de l'intersection de deux rquadtree donn�s.
 Si un pixel de l'intersection rquadtree est noir, alors ce pixel est noir dans le premier et le deuxi�me rquadtree donn�. *)
let rec intersection a b=
  match (a,b) with
    | (Noeud (q11, q12, q13, q14), Noeud (q21, q22, q23, q24)) ->
        Noeud (intersection q11 q21, intersection q12 q22, intersection q13 q23,
          intersection q14 q24)
    | (Feuille Noir, Noeud (q1, q2, q3, q4)) | (Noeud (q1, q2, q3, q4), Feuille Noir) ->
      Noeud ((intersection (Feuille Noir) q1), (intersection (Feuille Noir) q2),
        (intersection (Feuille Noir) q3), (intersection (Feuille Noir) q4))
    | (Feuille Noir, Feuille Noir) -> Feuille Noir
    | _ -> Feuille Blanc;;
(*Question6*)

(*Question 7*)
let sqrt_q = fun n -> let rec aux = fun n n2 -> if n2*n2 > n then failwith "erreur nombre" else
    if n2*n2 = n then n2 else aux n (n2+1)
              in
              aux n 1;;
let modify = fun a i ops -> let i2 = sqrt_q i
                in
                let rec aux = fun a i ops (x, y) ->
                  match a with
                |Noeud(Feuille f1, Feuille f2, Feuille f3, Feuille f4) ->
                  Noeud(Feuille(ops x y f1), Feuille(ops (x+1) y f2), Feuille(ops (x+1) (y+1) f3), Feuille(ops x (y+1) f4))
                |Noeud(a1,a2,a3,a4) -> Noeud( aux a1 (i/2) ops (x,y), aux a2 (i/2) ops (x+(i/2),y), aux a3 (i/2) ops (x+(i/2),y+(i/2)),aux a4 (i/2) ops (x,y+(i/2)))
                in
                aux a i2 ops (0,0);;
(*Question 8*)
let rec  optimise = fun a ->
  match a with
    |Feuille(x)->Feuille(x)
    |Noeud(Feuille Blanc , Feuille Blanc,Feuille Blanc,Feuille Blanc )-> Feuille Blanc
    |Noeud(Feuille Noir , Feuille Noir , Feuille Noir, Feuille Noir)-> Feuille Noir
    |Noeud(a,b,c,d)->optimise(Noeud(optimise a,optimise b , optimise c ,optimise d));;
	
(*--------------------------------------------------------------------------------------------*)
type bit = Zero | Un
(*Question 9*)

let rec arbre_vers_liste i = 
  match i with 
    | Feuille Blanc -> [Zero ; Zero] 
    | Feuille Noir -> [Zero ; Un ] 
    | Noeud (a1,a2,a3,a4) ->
      Un::arbre_vers_liste a1
	@ arbre_vers_liste a2
	@ arbre_vers_liste a3
	@ arbre_vers_liste a4  ;;

(*Question 10 *)		
let rec fct1  l = 
  match l with 
    | Zero::Zero::rap -> Feuille Blanc, rap 
    | Zero::Un::rap -> Feuille Noir, rap 
    | Un::rap ->
      let a1,rap = do_parse rap in
      let a2,rap = do_parse rap in 
      let a3,rap = do_parse rap in
      let a4,rap = do_parse rap in 
	Noeud (a1,a2,a3,a4),rap
    | _ -> assert false ;;

let liste_vers_arbre l = let a,_ = fct1 l in a ;;

 
