fun main (N:int) (M:int) (flist : char list list) = 
    let 
        val grid = Array2.fromList(flist)
        val virus = Array2.array(N,M,~2)
        val myqueue = Queue.mkQueue()
        val airports = Queue.mkQueue()
        val sotq = Queue.mkQueue()
        val visited = Array2.array(N,M,(~1,~1))
        val output = Array.array(1,[])

        fun printList xs = 
            print(String.concat xs);
        
        fun loopout (i:int)  = (
            let 
                fun loopin (j:int) = (
                    if j<M then (
                        let
                            val elem = Array2.sub(grid,i,j);
                        in
                            if (Char.compare(elem,#"W") = EQUAL) then (
                                Queue.enqueue(myqueue,[i,j,0,0]);
                                loopin (j+1)
                            )
                            else (
                                if (Char.compare(elem,#"A") = EQUAL) then ( 
                                    Queue.enqueue(airports,[i,j,0,1]);
                                    loopin (j+1)
                                    
                                )
                                else (
                                    if (Char.compare(elem,#"S") = EQUAL) then (
                                        Queue.enqueue(sotq,[i,j,0,~2,~2]);
                                        loopin (j+1)
                                    )
                                    else 
                                        loopin (j+1)
                                )
                            )
                        end
                        )
                        else ()
                )
            in  
                (if i<N then (
                    loopin 0;
                    loopout (i+1)
                    )
                else ())
            end 
        )
        

        fun virus_flood (grid) (virus) (myqueue) (flag) (N:int) (M:int) (airports) = (
            let
                val this = Queue.dequeue(myqueue)
                val x = List.nth(this,0)
                val y = List.nth(this,1)
                val time =List.nth(this,2)
                val boole = Array.array(1,flag) 
                val virus_cur = Array2.sub(virus,x,y)
                val grid_cur = Array2.sub(grid,x,y)
                val doit = Array.array(1,1)
            in (
                (if (virus_cur = (~2)) then 
                    Array2.update(virus,x,y,time)
                else 
                    if (virus_cur > time) then 
                        Array2.update(virus,x,y,time)
                    else (
                        Array.update(doit,0,0)
                    )
                );
                if Array.sub(doit,0) = 1 then (
                (if (Char.compare(grid_cur, #"X") = LESS orelse Char.compare(grid_cur, #"X") = GREATER ) then (
                    (if (Char.compare(grid_cur, #"A") = EQUAL andalso (Array.sub(boole,0) = 0) ) then (
                        while Queue.isEmpty(airports) = false do (
                            let 
                                val a = Queue.dequeue(airports)
                                val a0 = List.nth(a,0)
                                val a1 = List.nth(a,1)
                                val a3 = List.nth(a,3)
                            in
                                Queue.enqueue(myqueue,[a0,a1,time+5,a3])
                            end
                        );
                        Array.update(boole,0,1)
                    )
                    else ());

                    (if x < (N-1) then 
                        Queue.enqueue(myqueue,[x+1,y,time+2,Array.sub(boole,0)])
                    else () );
                    (if y >= 1 then 
                        Queue.enqueue(myqueue,[x,y-1,time+2,Array.sub(boole,0)])
                    else ());
                    (if y < (M-1) then 
                        Queue.enqueue(myqueue,[x,y+1,time+2,Array.sub(boole,0)])
                    else ());
                    if x >= 1 then 
                        Queue.enqueue(myqueue,[x-1,y,time+2,Array.sub(boole,0)])
                    else ()
                )
                else(
                    Array2.update(virus,x,y,~1)
                )
                )
                )
                else ()
            )
            end
        )
        fun backtrack target visited output = (
            let 
                val tuple = Array.array(1,target) 
            in 
                while (Array.sub(tuple,0) <> (~2,~2)) do (
                    let 
                        val current = Array.sub(tuple,0) 
                        val x = #1 current
                        val y = #2 current
                        val camefrom = Array2.sub(visited,x,y)
                        val x_prev = #1 camefrom 
                        val y_prev = #2 camefrom 
                        val outputl = Array.sub(output,0)
                    in  
                        (if x_prev = (x+1)  then
                            Array.update(output,0,"U"::outputl)
                        else
                            ());
                        (if x_prev = (x-1) then 
                            Array.update(output,0,"D"::outputl)
                        else
                            ());
                        (if y_prev = (y-1) then 
                            Array.update(output,0,"R"::outputl)
                        else
                            ());
                        (if y_prev = (y+1) then 
                            Array.update(output,0,"L"::outputl)
                        else
                            ());

                        Array.update(tuple,0,camefrom)
                    end
                )
            end
        )

        fun sotiris_flood grid virus visited sotq N M output  = (
                while Queue.isEmpty(sotq) = false do (
                    let
                        val this = Queue.dequeue(sotq)
                        val x = List.nth(this,0)
                        val y = List.nth(this,1)
                        val time = List.nth(this,2)
                        val parent_x = List.nth(this,3)
                        val parent_y = List.nth(this,4)
                        val parent = (parent_x , parent_y)
                        val virus_cur = Array2.sub(virus,x,y)
                        val grid_cur = Array2.sub(grid,x,y)
                        val visited_cur = Array2.sub(visited,x,y)
                        
                    in
                        if (visited_cur = (~1,~1)) then (
                            if(virus_cur <> ~1) then (
                                if( virus_cur > time) then (
                                    Array2.update(visited,x,y,parent);
                                    (
                                        if (Char.compare(grid_cur,#"T") = EQUAL) then(
                                            backtrack (x,y) visited output;
                                            Queue.clear(sotq)
                                        )
                                        else(
                                        (if x < (N-1) then 
                                            Queue.enqueue(sotq,[x+1,y,time+1,x,y])
                                        else());
                                        (if y >= 1 then
                                            Queue.enqueue(sotq,[x,y-1,time+1,x,y])
                                        else());
                                        (if y < (M-1) then 
                                            Queue.enqueue(sotq,[x,y+1,time+1,x,y])
                                        else());
                                        (if x >= 1 then 
                                            Queue.enqueue(sotq,[x-1,y,time+1,x,y])
                                        else())
                                        )
                                    )
                                )
                                else()
                            )
                            else ()
                        )
                        else()
                    end

                )
        )
    in 
        loopout 0 ;
        (while Queue.isEmpty(myqueue) = false do 
            virus_flood grid virus myqueue 0 N M airports);
        sotiris_flood grid virus visited sotq N M output;
        (if length (Array.sub(output,0)) = 0 then 
            print("IMPOSSIBLE\n")
        else (
            print (Int.toString(length (Array.sub(output,0))));
            print("\n");
            printList (Array.sub(output,0));
            print("\n")
        ))
    end



fun stayhome file = 
    let
    (* from parse function given by the course's professors *)
    (*A function to read an integer from specified input *)
        fun readInt input = 
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

        fun linelist file =
            let 
                val instr = TextIO.openIn file
                val str   = TextIO.inputAll instr
            in 
                String.tokens Char.isSpace str
                before
                TextIO.closeIn instr
            end
        fun getlist file   =
            map explode (linelist file);
    in (
        let 
            val list = getlist file 
            val N = length list
            val M = length (hd list)
        in 
            main N M list
        end
    )
    end

