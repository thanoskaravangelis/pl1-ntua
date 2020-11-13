import java.io.*; 
import java.util.*;
import javafx.util.*;
import java.lang.*;

public class Stayhome
{ 
    int n = 0;
    int m = 0;
    Pair<Integer,Integer> target = new Pair<>(0,0);
    char [][] grid;
    static int [][] virus;
    static Queue <int []> myqueue = new LinkedList<int []> ();
    Queue <int []> airports = new LinkedList<int []> ();
    Queue <int []> sotq = new LinkedList<int []> ();
    static Stack <Character> output = new Stack<Character>();  // a stack for the output 
    HashMap<Pair<Integer,Integer> , Pair<Integer,Integer>> visited = new HashMap<Pair<Integer,Integer> , Pair<Integer,Integer>>();
    //above we define something like a "dictionary" that links children with their parent positions(where they came from)
    
    public void virus_flood(int flag){ //the flood fill algorithm for the virus
        int[] thisarr = Arrays.copyOf(myqueue.poll(),4);
        int x = thisarr[0];
        int y = thisarr[1];
        int time = thisarr[2];
        int bool = thisarr[3];

        if(virus[x][y]==-1) {
            virus[x][y]= time ;
        }
        else {
            if (virus[x][y] > time)
                virus[x][y] = time ;
            else 
                return;
        }
        
        bool = flag;

        if (x<n-1) {
            if (grid[x+1][y]!='X'){
                if(grid[x+1][y]=='A' && bool == 0) {
                    while(airports.peek() != null) {
                        int[] a = Arrays.copyOf(airports.poll(),4);
                        a[2] = time + 7;
                        myqueue.add(a);
                    }
                    bool = 1;
                }
                int [] newarr1 = new int[] {x+1,y,time+2,bool};
                myqueue.add(newarr1);
            }
            else 
                virus[x+1][y] = -10;
        }

        if (y>=1) {
            if (grid[x][y-1]!='X'){
                if(grid[x][y-1]=='A' && bool == 0) {
                    while(airports.peek() != null) {
                        int[] a = Arrays.copyOf(airports.poll(),4);
                        a[2] = time + 7;
                        myqueue.add(a);
                    }
                    bool = 1;
                }
                int [] newarr2 = new int[] {x,y-1,time+2,bool};
                myqueue.add(newarr2);
            }
            else 
                virus[x][y-1] = -10;
        }

        if (y< m-1) {
            if (grid[x][y+1]!='X'){
                if(grid[x][y+1]=='A' && bool == 0) {
                    while(airports.peek() != null) {
                        int[] a =  Arrays.copyOf(airports.poll(),4);
                        a[2] = time + 7;
                        myqueue.add(a);
                    }
                    bool = 1;
                }
                int [] newarr3 = new int[] {x,y+1,time+2,bool};
                myqueue.add(newarr3);
            }
            else 
                virus[x][y+1] = -10;
        }

        if (x>=1) {
            if (grid[x-1][y]!='X'){
                if(grid[x-1][y]=='A' && bool == 0) {
                    while(airports.peek() != null) {
                        int[] a = Arrays.copyOf(airports.poll(),4);
                        a[2] = time + 7;
                        myqueue.add(a);
                    }
                    bool = 1;
                }
                int [] newarr4 = new int[] {x-1,y,time+2,bool};
                myqueue.add(newarr4);
            }
            else 
                virus[x-1][y] = -10;
        }
    }

    public void backtrack() { //the method that backtracks from the target to the initial position 
        Pair<Integer,Integer> tuple = new Pair<>(-1,-1);
        Pair<Integer,Integer> current = new Pair<>(0,0);
        Pair<Integer,Integer> came_from = new Pair<>(-1,-1);
        Pair<Integer,Integer> endingt = new Pair<>(-2,-2);
        int x_prev, y_prev, x, y;
        tuple = target;
        while ( ( tuple.getKey() != endingt.getKey() ) && 
               (tuple.getValue() != endingt.getValue() ) ){
            current = tuple;
            came_from = visited.get(tuple);
            x_prev = came_from.getKey();
            y_prev = came_from.getValue();
            x = tuple.getKey();
            y = tuple.getValue(); 

            if (x_prev == x + 1) 
                output.push('U');
            if (x_prev == x - 1)
                output.push('D');
            if (y_prev == y - 1)
                output.push('R');
            if (y_prev == y + 1)
                output.push('L');

            tuple = came_from;
        }
    }
    public void sotiris_flood(){ //the flood fill method for Sotiris
        while(sotq.isEmpty() == false) {
            int[] thisarr = Arrays.copyOf(sotq.poll(),5);
            int x = thisarr[0];
            int y = thisarr[1];
            int time = thisarr[2];
            int x_par = thisarr[3];
            int y_par = thisarr[4];
            Pair<Integer,Integer> child = new Pair<>(x,y); // storing current position
            Pair<Integer,Integer> parent = new Pair<>(x_par,y_par); //pair storing parent's position
            

            if(visited.get(child)==null){
                if (virus[x][y]!= -10) {
                    if (virus[x][y] > time){
                        visited.put(child,parent);
                        if(grid[x][y]=='T'){       // if we reach the target 
                            target = child;        // we stop and start backtracking
                            backtrack();
                            break;
                        }

                        
                        if (x < n-1) {
                            int [] newarr1 = new int[] {x+1,y,time+1,x,y};
                            sotq.add(newarr1);
                        }
                        if (y >= 1) {
                            int [] newarr2 = new int[] {x,y-1,time+1,x,y};
                            sotq.add(newarr2);
                        }
                        if (y<m-1) {
                            int [] newarr3 = new int[] {x,y+1,time+1,x,y};
                            sotq.add(newarr3);
                        }
                        if(x>=1) {
                            int [] newarr4 = new int [] {x-1,y,time+1,x,y};
                            sotq.add(newarr4);
                        }
                    }
                }
            }
        }
    }
    public static void main(String[] args) {
        try
        {
            //System.out.println("KB: " + (double) (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()) / 1024);
   
            Stayhome obj = new Stayhome ();
            obj.start (args);

            while (myqueue.isEmpty() == false )
                obj.virus_flood(0);

            myqueue.clear();
            obj.sotiris_flood();
            obj.sotq.clear();
            obj.grid = null;
            obj.virus = null;
            if (output.size() != 0) {
                System.out.println(output.size());
                while (!output.isEmpty())
                    System.out.print(output.pop());
            }
            else 
                System.out.print("IMPOSSIBLE");
            
            output.clear();
            //System.out.println("KB: " + (double) (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()) / 1024);
        }
        catch (Exception e)
        {
            e.printStackTrace ();
        }
    }

    public void start (String[] args) throws Exception
    { 
        File file = new File(args[0]); 
        BufferedReader br = new BufferedReader(new FileReader(file)); 
        String st; 
        while ((st = br.readLine()) != null)  { // reading n and m with this loop
            n++;
            m = st.length();
        }
        grid = new char [n][m];
        virus = new int[n][m];
        BufferedReader br2 = new BufferedReader(new FileReader(file));
        int i,j;
        for (i = 0; i<n; i++){                  //filling the "grid" and the "virus" arrays 
            st = br2.readLine();
            for (j =0; j<m; j++) {
                grid[i][j] = st.charAt(j);      
                virus[i][j] = -1;  
            }
        }

        for (i = 0; i<n; i++){
            for (j = 0; j<m; j++) { //traversing the "grid" to initialize our queues appropriately
                if (Character.compare(grid[i][j],'W') == 0){
                    int[] arr0 = new int[] {i,j,0,0};
                    myqueue.add(arr0);
                }
                else if(Character.compare(grid[i][j],'A') == 0){
                    int[] arr1 = new int[] {i,j,0,1};
                    airports.add(arr1);
                }
                else if (Character.compare(grid[i][j],'S') == 0){
                    int[] arr2 = new int[] {i, j, 0,-2,-2};
                    sotq.add(arr2);
                }
            }
        }
    
        
    }
} 