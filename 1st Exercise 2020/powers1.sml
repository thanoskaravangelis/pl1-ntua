fun parse file = (* function parse and its contents were given with the exercise's description by the professors of the course *)
    let
	(* A function to read an integer from specified input. *)
        fun readInt input = 
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

	(* Open input file. *)
    	val inStream = TextIO.openIn file

        (* Read an integer (number of countries) and consume newline. *)
	val n = readInt inStream*2
	val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
	fun readInts 0 acc = List.rev acc (* Replace with 'rev acc' for proper order. *)
	  | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
   	    (n, readInts n [])
    end

fun showme (n,k)=
    
    let 
        val N = IntInf.fromInt n
        fun loop 0 ( d:IntInf.int, list) = List.rev list
            |loop a ( d :IntInf.int , list) = 
                    if (a mod d)=0 then
                        (loop a (d*2, list) )
                    else 
                        loop (a-(a mod d)) (d*2, (a mod d)::list)
        
        val mylist = map (fn x => (IntInf.toInt x))(loop N (2,[]))
        val times = k - (List.length mylist)
    in
        if ( (times<0) orelse (k > n) ) then  print "[]\n"
        else
            let
                fun loop_with_k_powers cnt (0,alist) = 
                    (let
                        fun add_aces (0,list) = list
                        | add_aces (h,list) = 
                            add_aces(h-1, (1::list))
                    in
                        add_aces (cnt, alist)
                    end)
                | loop_with_k_powers cnt (times,alist) =
                    if (hd alist = 1) then 
                        loop_with_k_powers (cnt+1) (times, tl alist)
                    else (
                        let
                            val d = ((hd alist) div 2)
                        in 
                            loop_with_k_powers cnt ((times-1), (d::d::(tl alist)))
                        end)
            in
                let
                    val mylist = loop_with_k_powers 0 (times , mylist)
            
                    fun final_list ( (d,blist:int list) , (j,[]) ) = List.rev (j::blist)
                    | final_list ( (d,blist:int list), (j,alist) )=
                        if(hd alist = d) then
                            final_list ( (d,blist) , ((j+1),(tl alist)) )
                        else 
                            final_list ( (d*2, (j::blist) ) , (0 ,alist) )
                        
                    val mylistis =  (final_list ( (1,[]) , (0,mylist) ))
                in
                    let 
                        fun println (alist :int list) = 
                                if ( alist = []) then
                                     print "]\n"
                                else if (length alist = 1) then
                                    (print (Int.toString (hd alist)); println (tl alist) )
                                else
                                    (print (Int.toString (hd alist)); print "," ; println (tl alist) )

                    in
                            (
                            print "[" ;
                            println ( mylistis ) 
                            )
                    end 
                end
            end
    end 
fun powers2 fileName = 
    let
        fun myloop (cnt , list ) = 
            if(length list = 2 )  then 
                showme (hd list, hd (tl list))
            else
                (showme (hd list , hd (tl list))  ;
                myloop (cnt - 2 , tl (tl list)) ) 
    in
        myloop (parse fileName)
    end

