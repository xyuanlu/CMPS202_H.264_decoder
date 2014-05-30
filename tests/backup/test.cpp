#include <iostream>
#include <ctime>
#include <cstdlib>
#include <iomanip>
#include <time.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
using namespace std;
int deTbi(int j);

int main()
{
    FILE *ifp;
    int i,k;
    uint32_t     BitStream_ram[1000];
    char buffer[6];
    char buffer2[16];
    char buffer3[1];
    int j;  //the 10s number
    unsigned int result;
    ifp = fopen("/Users/xiaoyuan/Documents/MS_school/third_quarter/CMPE202/H_264_project/CMPS202_H.264_decoder/bitstream/akiyo300_1ref.txt", "rw");
    //ifp = fopen("bitstream/akiyo300_1ref.txt", mode);

    //buffer = (char*) malloc (2);
    for(i=0;i<30;i++){
        //fread(buffer, 2,2, ifp);
        fgets(buffer, sizeof(buffer), ifp);
        //if(i%2==0){
            printf("%s|",buffer);
            //for(k=0;k<4;k++){
                //buffer3[0]=buffer[k];
                sscanf(buffer,"%x", &j);
                printf("%d %x \n", j, j);
                //result=deTbi(j);
                //printf("k:%d r:%d-",k,result);
            //}
            //printf("\n");
        //}
    }
    //
    fclose(ifp);
    return 0;
}

int deTbi(int x){
    int result;
    result=0;
    if(x/4>=2){
        result=1000;
        x=x%8;
    }
    if((x/4>=1)&&(x/4<2)){
        result=result+100;
        x=x%4;
    }
    if((x/2>=1)&&(x/4<1)){
        result=result+10;
        x=x%2;
    }
    if(x%2==1)
        result=result+1;
    return result;
}


