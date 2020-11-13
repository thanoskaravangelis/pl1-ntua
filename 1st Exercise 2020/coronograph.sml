fun sumlist (x::xs) = x + sumlist xs
    | sumlist [] = 0

fun printlist list =(
    if(list = nil) then print "\n" 
    else if (length list = 1) then ( print (Int.toString(hd list)); printlist (tl list) )
    else
        (print (Int.toString(hd list)); print " "; printlist (tl list))
) 
fun addanedge (start:int ) (dest:int) (array : int list array ) = (
        Array.update(array,start,(Array.sub(array,start))@[dest]);
        Array.update(array,dest,(Array.sub(array,dest))@[start])
)
                
 fun findcycle (graph:int list array ) (cycle : int list array) (color : int array) (parent : int array) (i:int) (j:int) = (*//se antistoixia me : https://www.geeksforgeeks.org/print-all-the-cycles-in-an-undirected-graph/?ref=rp*)
    if (Array.sub(color,i) = 2) then ()
    else (if (Array.sub(color,i) = 1) then (
        let
            val k = Array.sub(cycle,0)
            fun loop1 k =
                if (k <> i) then (
                    let 
                        val cur2 = Array.sub(parent,k)
                        val y = Array.sub(cycle,0)
                    in  
                        ( Array.update(cycle,0,y@[cur2]); loop1(cur2) )
                    end)
                else () 
        in
            (Array.update(cycle,0,k@[j]); loop1 j)
        end )
        else 
            if (Array.sub(color,i) = 0) then (
                Array.update(parent,i,j) ;
                Array.update(color,i,1) ;
                let
                    val x = Array.sub(graph,i)
                    fun for1 [] = ()
                    |for1 (hd::tl) = (
                        if (hd <> (Array.sub(parent,i))) then(
                            findcycle graph cycle color parent hd i;
                            for1 tl
                        )
                        else  for1 tl 
                    )
                    
                in
                    for1 x;
                    Array.update(color,i,2)
                end 
            )
            else () )

fun countnodesbelow (graph:int list array ) (cycle :int list array) (count:int array) (i:int) (from : int) = ( 
    Array.update(count,i,1);
    let 
        val x = Array.sub(graph,i)
        fun loop (hd::tl) =   
            if (hd<>0) then (
                if (hd = from) then loop tl
                else 
                    let 
                        val g = Array.sub(count,i)
                        val y = Array.sub(cycle,0)
                        
                        fun find (x::xs) (it:int) = 
                            if (x = it ) then () else find xs it
                        |find (nil) (it:int) =  (
                            countnodesbelow graph cycle count it i ;
                            Array.update(count,i,(g+Array.sub(count,it))))
                    in
                        find y hd ;
                        loop tl
                    end
            )
            else loop tl
        | loop nil = ()
    in
        loop x 
    end 
)


fun coronograph file =
    let 
    (* from parse function given by the course's professors *)
    (*A function to read an integer from specified input *)
        
        fun readInt input = 
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

        (* Open input file. *)
        val inStream = TextIO.openIn file

        (* Read an integer (number of graphs) and consume newline. *)
        val T = readInt inStream
        val _ = TextIO.inputLine inStream

        fun howmanygraphs i = (
            if (i < T) then (
                let 
                    val N = readInt inStream
                    val M = readInt inStream
                    val list = Array.array (N+1, []:int list)
                    val cycle = Array.array(1,[]:int list)
                    val color = Array.array (N+1 , 0)
                    val parent = Array.array (N+1 , 0)
                    val count = Array.array (N+1 , 0)
                    val goodcount = Array.array(1,[]:int list)

                in (
                    let
                        fun addedges (i:int) = (
                            if (i< (M+1)) then (
                                let 
                                    val start = readInt inStream
                                    val dest = readInt inStream
                                in (
                                    addanedge start dest list ;
                                    addedges  (i+1) 
                                )
                                end
                            )
                            else ()
                        )
                    in
                        addedges 1;
                        print "diavasa akmes \n "
                    end ;
    
                    if (N=M) then (
            
                            findcycle list cycle color parent 1 0 ;
                            print "ekana findcycle \n";
                            let
                                val ccl = Array.sub(cycle,0)
                                fun yaloop (x::xs) = (
                                    countnodesbelow list cycle count x 0 ;
                                    yaloop xs )
                                |yaloop nil = ()
                                
                                fun yafind (hd::tl) (it:int)  = 
                                    let 
                                        val gdcnt = Array.sub(goodcount,0)
                                    in
                                        if (hd = it ) then Array.update(goodcount, 0 , gdcnt@[Array.sub(count,it)])
                                        else yafind tl it 
                                    end
                                |yafind (nil) (it:int) = ()

                                fun forloop (j:int) (alist:int list) = 
                                        (if (j<>1) then (
                                            yafind (alist) j ;
                                            forloop (j-1) alist 
                                        )
                                        else (yafind (alist) j ) 
                                        )

                            in (
                                yaloop ccl;
                                forloop N ccl;
                                print " mphka yaloop \n";
                                if ((sumlist (Array.sub(goodcount,0))) <> N) then (
                                    print "NO CORONA\n";
                                    howmanygraphs (i+1)
                                )
                                else (
                                    let
                                        val results =  ListMergeSort.sort (op >) (Array.sub(goodcount,0))
                                    in (
                                        print "CORONA "; print (Int.toString (length ccl)); print "\n";
                                        printlist results ;
                                        howmanygraphs (i+1)
                                    )
                                    end
                                )
                            )
                            end
                    )                
                    else (
                        print "NO CORONA\n";
                        howmanygraphs (i+1)
                    )
                )
                end
            )
            else () 
    )    
    in 
        howmanygraphs 0
    end
