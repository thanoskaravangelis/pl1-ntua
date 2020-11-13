import queue 
import sys 

def isBad(list) :
    i=len(list)-1
    c1=list[i]
    while list[i] == c1 :
        i=i-1
        if i==-1:
            return False
        
    c2 = list[i]
    while list[i] == c2 :
        i=i-1
        if i==-1:
            return False
        
    c3 = list[i]
    if c3 == c1:
        return True;
    
    while list[i]==c3 :
        i=i-1
        if i==-1:
            return False
    
    c4 = list[i]
    if c4==c2 or c4==c1 :
        return True
    while list[i]==c4:
        i=i-1
        if i==-1:
            return False
    return True

def isFinal(list):
    if not list:
        return True

def VaccineState():
    while not myqueue.empty():
        this = myqueue.get()
        s1 = this[0]
        s2 = this[1]
        prevaction = this[2]
        out = this[3]
        outp = []
        outc = []
        outr = []
        if not isFinal(s1) :
            if prevaction == 'c':
                n = list()
                for i in s1:
                    if (i=='A') :
                        n.append('U')
                    elif i=='U' :
                        n.append('A')
                    elif i=='C' :
                        n.append('G')
                    elif i=='G' :
                        n.append('C')
                if [n,s2,'p'] not in seen:
                    for j in out:
                        outp.append(j)
                    outp.append('p')
                    myqueue.put([n,s2,'p',outp])
                    seen.append([n,s2,'p'])

                if [n,s2,'r'] not in seen:
                    for j in out:
                        outr.append(j)
                    outr.append('r')
                    myqueue.put([n,s2,'r',outr])
                    seen.append([n,s2,'r'])

            elif prevaction =='p':
                s11 = list()
                s22 = list()
                for i in s1:
                    s11.append(i)
                for i in s2:
                    s22.append(i)
                
                s22.insert(0,s11.pop(-1))
                
                if not isBad(s22) :
                    if [s11,s22,'c'] not in seen:
                        for j in out:
                            outc.append(j)
                        outc.append('c')
                        myqueue.put([s11,s22,'c',outc])
                        seen.append([s11,s22,'c'])
                    if [s11,s22,'p'] not in seen:
                        for j in out:
                            outp.append(j)
                        outp.append('p')
                        myqueue.put([s11,s22,'p',outp])
                        seen.append([s1,s22,'p'])

                    if [s11,s22,'r'] not in seen:
                        for j in out:
                            outr.append(j)
                        outr.append('r')
                        myqueue.put([s11,s22,'r',outr])
                        seen.append([s11,s22,'r'])

            elif prevaction == 'r' :
                p = list() 
                for i in s2:
                    p.append(s2.pop(-1))

                if [s1,p,'c'] not in seen:
                    for j in out:
                        outc.append(j)
                    outc.append('c')
                    myqueue.put([s1,p,'c',outc])
                    seen.append([s1,p,'c'])
                if [s1,p,'p'] not in seen:
                    for j in out:
                        outp.append(j)
                    outp.append('p')
                    myqueue.put([s1,p,'p',outp])
                    seen.append([s1,p,'p'])
        else:
            return out

            
"main"
f = open(sys.argv[1])
stack2 = []
file = f.read().splitlines()
global myqueue 
myqueue = queue.Queue(-1)
global seen 
seen = []
no = int(file[0])
i = 1
while i<=no :
    stack1 = list(file[i])
    myqueue.put([stack1,stack2,'p',['p']])
    seen.append([stack1,stack2,'p',['p']])
    result = VaccineState()
    result.pop(-1)
    print (result)
    print("/n")
    myqueue.queue.clear()
    seen.clear()
    i = i + 1

    