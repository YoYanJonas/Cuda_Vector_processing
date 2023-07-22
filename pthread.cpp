#include<iostream>
#include<pthread.h>
#include<unistd.h>
#include <vector>
#include <algorithm>

using namespace std;

vector<int> h_a(1000000,0);
vector<int> h_b(1000000,0);
vector<int> h_c(1000000,0);

void* Addition(void* offset) {
    int *local_offset = (int*)offset;
    for(int i = ((*local_offset) * 250000); i < ((*local_offset)+1)*250000; ++i) {
            h_c[i] = h_a[i] + h_b[i];
    }
    pthread_exit(0);
}

int main() {

        clock_t start_cpu, end_cpu;
        double CLOCK_PER_SECOND = 1000000.0;
        start_cpu = clock();

        long int size = 1000000;
        pthread_t thread_id[4];
        void* status;



        srand(100);
        generate(h_a.begin(), h_a.end(), rand);

        srand(102);
        generate(h_b.begin(), h_b.end(), rand);


        int offset[4] = {0,1,2,3}; // offset.

        // create 4 thread with equal load
        for(int i = 0; i < 4; ++i) {
                int result = pthread_create(&thread_id[i], NULL,Addition,&offset[i]);
                if(result) cout << "Thread creation failed" << endl;
        }

        // join the 4-threads
        for(int i = 0; i < 4; ++i) {
                int result = pthread_join(thread_id[i], &status);
                if(result) cout << "Join failed " << i << endl;
        }

        // print output buffer, the output buffer not updated properly, 
        // noticed"0" for 1 & 2 thread randomly 
        // for(int i =0; i < size; ++i)
                // cout << i << " " << h_c[i] << endl;

        pthread_exit(NULL);
}


