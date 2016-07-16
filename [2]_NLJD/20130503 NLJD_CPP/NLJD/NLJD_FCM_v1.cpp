// Fuzzy c-means  

#include "stdio.h"
//#include "string.h"
#include "math.h"
#include "stdlib.h"

// Sample의 개수를 정의 (개수를 알아야 함) 
#define Samples 20
// Cluster의 개수를 정의 (2는 구현 안 됨) 
#define Clusters 3
// Sample의 차원 (Dimension)은 2로 해야함  
#define dSamples 2


// Sample 
struct samples
{
	float f[dSamples];
}z[Samples],v[Clusters];


// 멤버 (Degree of Membership) 
struct member
{
	float f[Clusters];
}u[Samples],d[Samples],tmp[Samples];


// Sample Data를 불러오는 부분 
void fetch()
{
	float f[dSamples];
	int i,j;
	FILE *fp;
	fp = fopen("NLJD.txt","r"); 
	for(i=0;i<Samples;i++)
	{
		for(j=0;j<dSamples;j++)
		{
			fscanf(fp,"%f",&f[j]);
			z[i].f[j]=f[j];
		}
	}
	fclose(fp);
}


// Membership을 초기화 
void init_members()
{
	int i,j;
	for(i=0;i<Samples;i++)
	{
        // u: Cluster 안에 있는 Sample의 소속 정도 
		u[i].f[0]=(float)1/(rand()%320);
		u[i].f[1]=(float)(((1-u[i].f[0])*rand())/RAND_MAX);
		u[i].f[2]=1-(u[i].f[0]+u[i].f[1]);
	}
}


// FCM의 Centeroid 값을 계산 
void centroids_cal()
{
	int m=2,i,j,k;
	float a=0,b=0;
	for(i=0;i<dSamples;i++)
	{
		for(k=0;k<Clusters;k++)
        {
			a=0;b=0;
			for(j=0;j<Samples;j++)
                {
					a=a+(pow(u[j].f[k],m)*z[j].f[i]);
					b=b+(pow(u[j].f[k],m));
				}

            v[k].f[i]=a/b;
		}
    }
	printf("***** Centroids Matrix *****\n");
	for(i=0;i<Clusters;i++)
	{
		for(j=0;j<dSamples;j++)
			printf("%f\t",v[i].f[j]);
			printf("\n");
   } 
}


// FCM과 각 Sample의 거리를 계산 
void dist_cal()
{
	int i,j,k;
	for(i=0;i<Samples;i++)
	{
		for(j=0;j<Clusters;j++)
		{
			for(k=0;k<dSamples;k++)
				d[i].f[j]+=(z[i].f[k]-v[j].f[k])*(z[i].f[k]-v[j].f[k]);
		}
	}
}


// 각 Sample의 Degree of Membership을 갱신 
void mem_update()
{
	int i,j,k;
	float temp=0;
	for(i=0;i<Samples;i++)
	{
		for(j=0;j<Clusters;j++)
		{
			temp=0;
			for(k=0;k<Clusters;k++)
			{
				temp+=(d[i].f[j]/d[i].f[k]);
			}
			u[i].f[j]=1/temp;
		}
	}
}


// 메인 프로그램 
int main()
{
	int k,i,j,c1=0,c2=0,c3=0;
	float e=10;
	int temp=0;
	// Sample Data를 불러오는 함수 
	
	//반복적으로 시험하기위하여 알고리즘 전체 반복루프
	for(k = 0;k<3;k++)
	{
		c1=0;
		c2=0;
		c3=0;
		temp=0;

		fetch();
		// Membership을 초기화하는 함수 
		init_members();
		// e (입실론)값을 만족시킬 때까지 Iteration 수행
		// 너무 작게할 경우에는 Iteration이 증가할 수 있음 
		while(e>0.001)
		{
			temp++;
			e=0;
			// Cluster의 Centroid를 계산 
			centroids_cal();
			for(i=0;i<Samples;i++)
			{
				for(j=0;j<Clusters;j++)
				tmp[i].f[j]=u[i].f[j];
			}
			// FCM의 Centroid와 Sample의 거리를 계산 
			dist_cal();
			// 각 Sample의 Degree of Membership을 갱신 
			mem_update();
			for(i=0;i<Samples;i++)
			{
				for(j=0;j<Clusters;j++) 
				e+=pow((u[i].f[j]-tmp[i].f[j]),2);
			} 
		}
    
		printf("****************************%d\n\n\n",temp);
	
		// 각 Cluster 소속되어 있는 Sample의 개수를 계산
		for(i=0;i<Samples;i++)
		{
			if(u[i].f[0]>u[i].f[1] && u[i].f[0]>u[i].f[2])
			c1++; 
			else if(u[i].f[1]>u[i].f[2] && u[i].f[1]>u[i].f[0])
			c2++;
			else if(u[i].f[2]>u[i].f[0] && u[i].f[2]>u[i].f[1])
			c3++;
		}

		// 각 Cluster의 개수를 출력
		printf("\nCluster1 has no.of samples-->  %d\n",c1);
		printf("Cluster2 has no.of samples-->  %d\n",c2);
		printf("Cluster3 has no.of samples-->  %d\n",c3);
	}
	getchar();
}
