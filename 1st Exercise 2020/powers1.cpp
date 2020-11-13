#include <iostream>
#include <vector>
#include <fstream>
using namespace std;

int main(int argc, char *argv[])
{
    ifstream myfile;
    myfile.open(argv[1]);
    int T;
    myfile >> T ;
    while (T > 0) {
        long unsigned int N, M;
        myfile >> N >> M;
        vector<int> myvector;
        vector<int>::iterator it;
        int d = 2;
        int i = N;
        while (i!=0) {                         //edw vriskw genika ton mikrotero leksikografika tropo me tis elaxistes dunates dunameis tou 2//
                int j = (i % d);
                if (j==0) {}
                else {
                        myvector.push_back(j);
                        i -= j;        
                }
                d=d*2; 
        }

        if ( N < M ||  M < myvector.size()) { //o arithmos de mporei na graftei se arithmo dinamewn megalutro apo ton idio ton arithmo
            cout << "[]" << endl;             //oute se arithmo dunamewn mikrotero ap'oti o elaxistos
        }

        else {                                //vriskw th leksikografika mikroterh anaparastash me vash ton arithmo dinamewn pou diavasa
            it = myvector.begin();
            int cnt = 0;
            while (myvector.size() < M) {
                it = myvector.begin() + cnt;
                if (*it==1){
                    cnt++;
                }
                else {
                    int d = *it / 2;
                    myvector.erase(it);
                    myvector.emplace ( it , d );
                    myvector.emplace ( it+1 , d);
                }                
            }
            vector<int> newvector;            //metatrepw ton leksikografika mikrotero tropo se monades pou exw apo kathe dunamh tou 2
            cnt=0;
            d = 1;
            int j = 0;
            while (it != myvector.end()) {
                it = myvector.begin() + cnt;
                    if (*it == d) {
                    j++;
                    cnt++;
                    }
                    else{
                    newvector.push_back(j);
                    j=0;
                    d=d*2;
                    }
            }
                
            
            it = newvector.begin();            //printing
            cout << "[";
            while (it != newvector.end()){
                cout << *it ;
                it++;
                if (it==newvector.end())
                    break;
                cout << ",";
            }
        cout << "]" << endl;
        } T--;
    }   
}