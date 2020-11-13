from array import *
import queue
import sys

def virus_flood(flag):
    global grid,virus,myqueue,N,M,airports
    this = myqueue.get()
    x = this[0]
    y = this[1]
    time = this[2]
    bool = this[3]

    if virus[x][y] == -1 :
        virus[x][y] = time
    else :
        if virus[x][y] > time :
            virus[x][y] = time
        else :
            return

    bool = flag

    if x < N-1: #DOWN 
        if grid[x+1][y]!='X' :
            if grid[x+1][y] == 'A' and bool == False :
                while not airports.empty() :
                    a = airports.get()
                    a[2]=time+7
                    myqueue.put(a)
                bool == True
            myqueue.put([x+1,y,time+2,bool])
        else:
            virus[x+1][y]='X'
    

    if y >= 1:  #LEFT
        if grid[x][y-1]!='X':
            if grid[x][y-1] == 'A' and bool == False :
                while not airports.empty() :
                    a = airports.get()
                    a[2]=time+7
                    myqueue.put(a)
                bool == True
            myqueue.put([x,y-1,time+2,bool])
        else :
            virus[x][y-1]='X'
    
    if y < M-1 :  #RIGHT
        if grid[x][y+1]!='X':
            if grid[x][y+1] == 'A' and bool == False:
                while not airports.empty() :
                    a = airports.get()
                    a[2]=time+7
                    myqueue.put(a)
                bool = True
            myqueue.put([x,y+1,time+2,bool])
        else :
            virus[x][y+1]='X'
    
    if x >= 1 :  #UP
        if grid[x-1][y]!='X':
            if grid[x-1][y] == 'A' and bool == False:
                while not airports.empty() :
                    a = airports.get()
                    a[2]=time+7
                    myqueue.put(a)
                bool = True
            myqueue.put([x-1,y,time+2,bool])
        else :
            virus[x-1][y]='X'
    
def backtrack() :
    tuple = target                  #start backtracking from target
    while (tuple!=(-2,-2)) :
        current = tuple             
        came_from = visited[tuple]
        x_prev ,y_prev = came_from[0] , came_from[1]
        x , y = tuple[0] , tuple[1]

        if(x_prev == x + 1) : #up
            output.put('U')
        if(x_prev == x - 1) : #down 
            output.put('D')
        if(y_prev == y - 1) : #right
            output.put('R')
        if(y_prev == y + 1) : #left
            output.put('L')

        tuple = came_from           # we make the current tuple the parent of the last one checked


def sotiris_flood():
    global sotq,visited

    while not sotq.empty() :
        this = sotq.get()
        x = this[0]
        y = this[1]
        time = this[2]
        parent = this[3]
            
        if(x,y) not in visited:
            if(virus[x][y]!='X') :
                if virus[x][y] > time :
                    visited[(x,y)] = parent
                    if(grid[x][y]=='T') :
                        global target
                        target = (x,y)
                        backtrack()            #finished ,path found,start backtracking!
                        break 

                    if x < N-1:
                        sotq.put([x+1,y,time+1,(x,y)])
                    if y >= 1:
                        sotq.put([x,y-1,time+1,(x,y)])
                    if y < M-1:
                        sotq.put([x,y+1,time+1,(x,y)])
                    if x >= 1:
                        sotq.put([x-1,y,time+1,(x,y)])
                        

f = open(sys.argv[1])
grid = f.read().split('\n')[:-1]
N,M = len(grid),len(grid[0])

myqueue = queue.Queue(-1)
airports = queue.Queue(-1)
sotq = queue.Queue(-1)
virus=[[-1 for j in range(M)]for i in range(N)]


for i in range(N):     #inserting first virus tile in queue and airports in another queue 
    for j in range(M): #and for Sotiris in another queue
        if grid[i][j] == 'W':
            myqueue.put([i,j,0,False])
        elif grid[i][j] == 'A':
            airports.put([i,j,0,True])
        elif grid[i][j] == 'S':
            sotq.put([i,j,0,(-2,-2)])
            
visited = {}            #dictionary of tiles and their parents
output = queue.LifoQueue(-1)  #a LIFO queue for the output


while not myqueue.empty() :
    virus_flood(False)  #flood_fill for the Virus

sotiris_flood()         #begin the flood_fill for Sotiris
if (output.qsize()!=0) :
    print(output.qsize())
    while not output.empty() :
        print (output.get() , sep = "", end="")
else :
    print("IMPOSSIBLE")
print("\n")





