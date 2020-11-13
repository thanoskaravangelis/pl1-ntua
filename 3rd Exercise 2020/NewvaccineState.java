import java.util.*;

/* A class implementing the state of the Newvaccine problem 
 * with an RNA that has A,U,G and C as possible elements.
 */
public class NewvaccineState implements State {
  //stacks that define our state 
  private Stack <Character> stack1 = new Stack<Character>();
  private Stack <Character> stack2 = new Stack<Character>();
  // The previous state.
  private State previous;
  private char prevaction;
  
  public NewvaccineState(Stack<Character> s1, Stack<Character> s2, State s, char c) 
  {
    stack1 = s1;
    stack2 = s2;
    previous = s;
    prevaction = c;
  }

    @Override
    public Character getAction() {
        return prevaction;
    }

    @Override
    public boolean isFinal() {
      return stack1.isEmpty();
    }

  
  @Override
  public boolean isBad(Stack<Character> stack2) {
        int i=0;
        char c1,c2,c3,c4;
        c1= stack2.get(0);
        while(stack2.get(i)==c1){
            i++;
            if (i==stack2.size()){
                return false;
            }
        }
        //edo exoume ton kainourio char
        c2 = stack2.get(i);
        while(stack2.get(i)==c2){
            i++;
            if (i==stack2.size()){
                return false;
            }
        }
        //kainourio char
        c3=stack2.get(i);
        if (c3==c1){
            return true;
        }

        while(stack2.get(i)==c3){
            i++;
            if (i==stack2.size()){
                return false;
            }
        }

        c4= stack2.get(i);
        if (c4==c2 || c4==c1){
            return true;
        }

        while (stack2.get(i)==c4){
            i++;
            if (i==stack2.size()){
                return false;
            }
        }
        return true;
    }

  @Override
  public Collection<State> next() {
    Collection<State> states = new ArrayList<>();

            if(prevaction =='c') {
              Stack<Character> n = new Stack<>();
              for(int i =0; i < stack1.size(); i++){
                if (stack1.get(i)=='A') n.push('U');
                else if (stack1.get(i)=='U') n.push('A');
                else if (stack1.get(i)=='G') n.push('C');
                else if (stack1.get(i)=='C') n.push('G');
            }
              states.add(new NewvaccineState(n, stack2, this ,'p'));
              states.add(new NewvaccineState(n, stack2, this ,'r')); 
            }

            else if(prevaction =='p') {
              Stack<Character> s1 = new Stack<>();
              Stack<Character> s2 = new Stack<>();

              for (char x : stack1) {
                s1.push(x);
              }
              for (char x : stack2) {
                s2.push(x);
              }
              
              s2.push(s1.pop());
              
              if (!isBad(s2)){
                states.add(new NewvaccineState(s1, s2, this ,'c')); 
                states.add(new NewvaccineState(s1, s2, this ,'p'));
                states.add(new NewvaccineState(s1, s2, this ,'r')); 
              } 
            }

            else if(prevaction =='r'){
              Stack<Character> p = new Stack<>();
              for (int i=stack2.size()-1; i>=0; i--){
                p.push(stack2.get(i));
              }
              states.add(new NewvaccineState(stack1, p, this, 'p'));
            }
        
    return states;
  }

  @Override
  public State getPrevious() {
    return previous;
  }


  // Two states are equal if all four are on the same shore.
  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    NewvaccineState other = (NewvaccineState) o;
    return ison(this.stack1 , other.stack1) && ison(this.stack2,other.stack2) && prevaction == other.prevaction ;
  }

  public boolean ison(Stack<Character> s1,Stack<Character> s2){
    int i = 0;
    if (s1.isEmpty() && s2.isEmpty()) 
      return true;
    if(s1.size() != s2.size())
      return false;
    while (true) {
      if (s1.get(i)==s2.get(i)) {
        i++;
        if (i==s1.size())
          break;
      }
      else 
        return false;
    }
    return true;
  }

  // Hashing: consider the private elements except for the previous situation 
  @Override
  public int hashCode() {
    return Objects.hash(stack1,stack2,prevaction);
  }
}