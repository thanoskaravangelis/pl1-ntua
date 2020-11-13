import java.util.*;
import java.io.*;
import java.lang.Runtime;

public class Vaccine {
  // The main function.
  public static void main(String args[]) {
    try {
            Vaccine obj = new Vaccine();
            obj.start (args);
        }
        catch (Exception e)
        {
            e.printStackTrace() ;
        }
  }
  public void start(String args[]) throws Exception {
    Stack <Character> stack1 = new Stack<Character>();
    Stack <Character> stack2 = new Stack<Character>();
    File file = new File(args[0]);
    BufferedReader br = new BufferedReader(new FileReader(file)); 
    String st = br.readLine();
    int no = Integer.parseInt(st);

    Solver solver = new BFSolver();

    while (no >= 1) {
        st = br.readLine();
        for (int i = 0; i< st.length(); i++) {
            stack1.push(st.charAt(i));
        }
        State initial = new NewvaccineState(stack1,stack2,null,'p');
        State result = solver.solve(initial);
        if (result == null) {
            System.out.println("No solution found.");
        } 
        else {
            printSolution(result);
            System.out.println("");
        }
        no--;
        stack1.clear();
        stack2.clear();
        
        
    }
  }
     /*public static long getUsedMemory() {
        return Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
    }*/
  // A recursive function to print the states from the initial to the final.
    private static void printSolution(State s) {
        if (s.getPrevious() != null) {
            printSolution(s.getPrevious());
        }
        System.out.print(s.getAction());
    }
    
    
}