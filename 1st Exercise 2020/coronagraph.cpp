#include <iostream>
#include <sstream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <stdio.h>
#include <stdlib.h>

using namespace std; 
typedef vector<int> myvector;

myvector cycle;
vector<int> color;
vector<int> parent;
vector<int> acount;
vector<int> goodcount;
int cur = 0;




void findcycle(myvector *list, int i , int j ){ //se antistoixia me : https://www.geeksforgeeks.org/print-all-the-cycles-in-an-undirected-graph/?ref=rp
    if (color[i]==2) {
        return;
    }

    if(color[i]==1) {
        cur = j;
        cycle.push_back(cur);
        while(cur!=i){
            cur = parent[cur];
            cycle.push_back(cur);
        }
        return;
    }
    
    parent[i]=j;
    color[i] = 1;
    
    
     
    for(int it : list[i]){
            if (it==parent[i]) {
                continue;
            }
            findcycle(list , it ,i  );
    }   

    color[i] = 2;
    
    
    
}



void countnodesbelow( myvector *list  ,vector<int> &acount ,int i ,int from ) {
    acount[i]=1;
    
    for (int it : list[i]) {
        if(it!=0) {
            if (it == from)
                continue;

            if ( find (cycle.begin() ,cycle.end() ,it ) != cycle.end() )
                continue;

            countnodesbelow(list,acount,it,i);
            acount[i] += acount[it];
        }
    }
    
}


int main ( int argc, char *argv[] ) {
    FILE *myfile = fopen(argv[1], "r");

    int T;
    fscanf(myfile, "%u", &T);
    int N , M , start , dest;
    int sum;
    while (T > 0){
        
        fscanf(myfile, "%u %u", &N , &M);
        
        myvector *list = new myvector[N+1];

        for (int m = M; m > 0; m-- ){
            fscanf(myfile , "%u %u", &start ,&dest );
            if(start<=N && dest<=N){
                list[start].push_back(dest);
                list[dest].push_back(start);
            }
        }
          
            if (N==M){
                cycle.reserve(N);
                color.resize(N+1);
                parent.resize(N+1);
                acount.resize(N+1);
                goodcount.reserve(N);
                
                findcycle(list,1,0);
                
                cycle.shrink_to_fit();
                vector<int>().swap(color);
                vector<int>().swap(parent);
                
                auto it = cycle.begin();
                while (it != cycle.end()) {
                    countnodesbelow( list , acount, *it , 0);
                    it++;
                }

                acount.shrink_to_fit();

                for (int u = 1; u <= M; u++) {
                    myvector().swap(list[u]);
                }
                delete[] list;

                for (int j=1; j <= N; j++){
                    if(find(cycle.begin(), cycle.end(), j) != cycle.end())
                        goodcount.push_back(acount[j]);
                }

                goodcount.shrink_to_fit();
                vector<int>().swap(acount);

                sort(goodcount.begin(), goodcount.end());
                sum=0;
                for (long unsigned int k = 0; k < goodcount.size(); k++) {
                    sum+=goodcount[k];
                }
                
                if (sum == N) {
                    printf("CORONA %lu\n",cycle.size());
                    for ( long unsigned int k = 0; k < goodcount.size(); k++) {
                        if (k==goodcount.size() - 1)
                            printf("%d\n",goodcount[k]);
                        else 
                            printf("%d ",goodcount[k]);
                    }
                }
                else 
                    printf("NO CORONA\n");
                
                myvector().swap(cycle);
                vector<int>().swap(goodcount);
        }
        else 
            printf("NO CORONA\n");
        
        

    T--;
    }
    fclose(myfile);
}
    