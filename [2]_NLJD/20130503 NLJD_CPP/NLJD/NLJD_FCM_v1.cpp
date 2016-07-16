// Fuzzy c-means  

#include "stdio.h"
//#include "string.h"
#include "math.h"
#include "stdlib.h"

// Sample�� ������ ���� (������ �˾ƾ� ��) 
#define Samples 20
// Cluster�� ������ ���� (2�� ���� �� ��) 
#define Clusters 3
// Sample�� ���� (Dimension)�� 2�� �ؾ���  
#define dSamples 2


// Sample 
struct samples
{
	float f[dSamples];
}z[Samples],v[Clusters];


// ��� (Degree of Membership) 
struct member
{
	float f[Clusters];
}u[Samples],d[Samples],tmp[Samples];


// Sample Data�� �ҷ����� �κ� 
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


// Membership�� �ʱ�ȭ 
void init_members()
{
	int i,j;
	for(i=0;i<Samples;i++)
	{
        // u: Cluster �ȿ� �ִ� Sample�� �Ҽ� ���� 
		u[i].f[0]=(float)1/(rand()%320);
		u[i].f[1]=(float)(((1-u[i].f[0])*rand())/RAND_MAX);
		u[i].f[2]=1-(u[i].f[0]+u[i].f[1]);
	}
}


// FCM�� Centeroid ���� ��� 
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


// FCM�� �� Sample�� �Ÿ��� ��� 
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


// �� Sample�� Degree of Membership�� ���� 
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


// ���� ���α׷� 
int main()
{
	int k,i,j,c1=0,c2=0,c3=0;
	float e=10;
	int temp=0;
	// Sample Data�� �ҷ����� �Լ� 
	
	//�ݺ������� �����ϱ����Ͽ� �˰��� ��ü �ݺ�����
	for(k = 0;k<3;k++)
	{
		c1=0;
		c2=0;
		c3=0;
		temp=0;

		fetch();
		// Membership�� �ʱ�ȭ�ϴ� �Լ� 
		init_members();
		// e (�ԽǷ�)���� ������ų ������ Iteration ����
		// �ʹ� �۰��� ��쿡�� Iteration�� ������ �� ���� 
		while(e>0.001)
		{
			temp++;
			e=0;
			// Cluster�� Centroid�� ��� 
			centroids_cal();
			for(i=0;i<Samples;i++)
			{
				for(j=0;j<Clusters;j++)
				tmp[i].f[j]=u[i].f[j];
			}
			// FCM�� Centroid�� Sample�� �Ÿ��� ��� 
			dist_cal();
			// �� Sample�� Degree of Membership�� ���� 
			mem_update();
			for(i=0;i<Samples;i++)
			{
				for(j=0;j<Clusters;j++) 
				e+=pow((u[i].f[j]-tmp[i].f[j]),2);
			} 
		}
    
		printf("****************************%d\n\n\n",temp);
	
		// �� Cluster �ҼӵǾ� �ִ� Sample�� ������ ���
		for(i=0;i<Samples;i++)
		{
			if(u[i].f[0]>u[i].f[1] && u[i].f[0]>u[i].f[2])
			c1++; 
			else if(u[i].f[1]>u[i].f[2] && u[i].f[1]>u[i].f[0])
			c2++;
			else if(u[i].f[2]>u[i].f[0] && u[i].f[2]>u[i].f[1])
			c3++;
		}

		// �� Cluster�� ������ ���
		printf("\nCluster1 has no.of samples-->  %d\n",c1);
		printf("Cluster2 has no.of samples-->  %d\n",c2);
		printf("Cluster3 has no.of samples-->  %d\n",c3);
	}
	getchar();
}
