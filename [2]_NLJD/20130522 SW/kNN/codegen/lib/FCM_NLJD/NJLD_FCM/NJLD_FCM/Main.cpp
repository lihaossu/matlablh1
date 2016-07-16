// Fuzzy c-means  
#include "stdio.h"
#include "string.h"
#include "math.h"
#include "stdlib.h"
#include "ctime"

// Sample�� ������ ���� (������ �˾ƾ� ��) 
#define Samples 30
// Error Ratio�� ����
#define Ratio 10
// �������� ���� ��ȣ
#define NEdata Samples-(Samples*Ratio/100)
// 2�� �������� ũ��
#define nd 1000
// 3�� �������� ũ��
#define rd 1000
// Noise�� ���� Variance
#define variance 500
// Iteration Ƚ��
#define Iteration 1
// Cluster�� ������ ���� (2�� ���� �� ��) 
#define Clusters 3
// Sample�� ���� (Dimension)�� 2�� �ؾ���  
#define dSamples 2



// Sample 
struct samples
{
	float Dsample[dSamples];
}Nsamples[Samples], Ncluster[Clusters],class1[Samples],class2[Samples],class3[Samples];//�� Ŭ�������� ���е� ���ڵ��� �Ǵ��ϱ����� ���� �߰�


// ��� (Degree of Membership) 
struct member
{
	float membership[Clusters];
}data[Samples], distance[Samples], tmp[Samples];

struct decision
{
	float NLJD_Detection[1];
}Original[Iteration], Decision[Iteration], Class[Iteration];


// Sample Data�� �ҷ����� �κ� 
/*
void Measure()
{
float Dsample[dSamples];
int i,j;
FILE *fp;
fp = fopen("NLJD.txt","r"); 
for(i=0;i<Samples;i++)
{
for(j=0;j<dSamples;j++)
{
fscanf(fp,"%f",&Dsample[j]);
Nsamples[i].Dsample[j]=Dsample[j];
}
}
fclose(fp);
}
*/


void Measure()
{
	int Mesure_i;
/*	for(Mesure_i=0; Mesure_i<10; Mesure_i++)
	{
		Nsamples[Mesure_i].Dsample[0] = data2nd[Mesure_i];
		Nsamples[Mesure_i].Dsample[1] = data3rd[Mesure_i];
	}
	*/
	for(Mesure_i=0; Mesure_i<Samples; Mesure_i++)
	{
		Nsamples[Mesure_i].Dsample[0] = (float) nd + rand() % variance;
		Nsamples[Mesure_i].Dsample[1] = (float) rd + rand() % variance;
	}
	
	
	for(Mesure_i=0; Mesure_i<Samples; Mesure_i++)
	{
      printf("2nd : %4.0f  3rd : %4.0f\r\n", Nsamples[Mesure_i].Dsample[0], Nsamples[Mesure_i].Dsample[1]);
	}
	
}


// Membership�� �ʱ�ȭ 
void init_members()
{
	int mem_i;
	int rand_index;
	
	for(mem_i=0; mem_i<Samples; mem_i++)
	{
		// Cluster �ȿ� �ִ� Sample�� �Ҽ� ���� 
		//data[mem_i].membership[0] = (float)1/(rand()%320);
		do
		{
			rand_index=rand()%10;
		}while(rand_index<2);
		data[mem_i].membership[0] = (float)1/rand_index;
		data[mem_i].membership[1] = (float)(((1-data[mem_i].membership[0])*rand())/RAND_MAX);
		data[mem_i].membership[2] = 1-(data[mem_i].membership[0]+data[mem_i].membership[1]);
	}
}


// FCM�� Centeroid ���� ��� 
void centroids_cal()
{
	int m=2, cen_i=0, cen_j=0, cen_k=0;
	float a, b;
	for(cen_i=0; cen_i<dSamples; cen_i++)
	{
		for(cen_k=0; cen_k<Clusters; cen_k++)
		{
			a=0; b=0;
			for(cen_j=0; cen_j<Samples; cen_j++)
			{
				a=a+(pow(data[cen_j].membership[cen_k],m)*Nsamples[cen_j].Dsample[cen_i]);
				b=b+(pow(data[cen_j].membership[cen_k],m));
			}
			Ncluster[cen_k].Dsample[cen_i]=a/b;
		}
	}

	/*
	printf("\n\n***** Centroids Matrix *****\n");

	for(cen_i=0; cen_i<Clusters; cen_i++)
	{
	for(cen_j=0; cen_j<dSamples; cen_j++)
	printf("%f\t",Ncluster[cen_i].Dsample[cen_j]);
	printf("\n");
	}
	*/

}


// FCM�� �� Sample�� �Ÿ��� ��� 
void dist_cal()
{
	int dist_i, dist_j, dist_k;
	for(dist_i=0;dist_i<Samples;dist_i++)
	{
		for(dist_j=0;dist_j<Clusters;dist_j++)
		{
			for(dist_k=0;dist_k<dSamples;dist_k++)
				distance[dist_i].membership[dist_j]+=(Nsamples[dist_i].Dsample[dist_k]-Ncluster[dist_j].Dsample[dist_k])*(Nsamples[dist_i].Dsample[dist_k]-Ncluster[dist_j].Dsample[dist_k]);
		}
	}
}


// �� Sample�� Degree of Membership�� ���� 
void mem_update()
{
	int mu_i, mu_j, mu_k;
	float temp;
	for(mu_i=0;mu_i<Samples;mu_i++)
	{
		for(mu_j=0;mu_j<dSamples;mu_j++)
		{
			temp = 0;
			for(mu_k=0;mu_k<Clusters;mu_k++)
			{
				temp+=(distance[mu_i].membership[mu_j]/distance[mu_i].membership[mu_k]);
			}
			data[mu_i].membership[mu_j]=1/temp;
		}
	}
}

void Fuzzy()
{
	FILE *fp;
	int k=0;
	int Class;
	printf("%d\r\n",k);
	int i=0, j=0, l=0, q=0, r=0, c1=0, c2=0, c3=0;
	float e=10;
	// Membership�� �ʱ�ȭ�ϴ� �Լ� 
	init_members();
	
	
	// e (�ԽǷ�)���� ������ų ������ Iteration ����
	// �ʹ� �۰��� ��쿡�� Iteration�� ������ �� ���� 
	
	while(e>0.1)
	{
		e=0;
		// Cluster�� Centroid�� ��� 
		centroids_cal();
		for(i=0; i<Samples; i++)
		{
			for(j=0;j<Clusters;j++)
				tmp[i].membership[j]=data[i].membership[j];
		}
		// FCM�� Centroid�� Sample�� �Ÿ��� ��� 
		dist_cal();
		// �� Sample�� Degree of Membership�� ���� 
		mem_update();
		for(l=0; l<Samples; l++)
		{
			for(q=0; q<Clusters; q++) 
				e+=pow((data[l].membership[q]-tmp[l].membership[q]),2);
		} 
	}

	// �� Cluster �ҼӵǾ� �ִ� Sample�� ������ ���
	// �� cluster �Ҽ��Ǿ� �ִ� sample ���� �о���� ���Ͽ� class1,2,3������ ������ ���� ����
	for(r=0; r<Samples; r++)
	{
		if(data[r].membership[0]>data[r].membership[1] && data[r].membership[0]>data[r].membership[2])
		{
			
			class1[c1].Dsample[0]=Nsamples[r].Dsample[0];
			class1[c1].Dsample[1]=Nsamples[r].Dsample[1];
			c1++;
			printf("C1 membership: %f %f %f\r\n",data[r].membership[0],data[r].membership[1],data[r].membership[2]);
			
		}
		else if(data[r].membership[1]>data[r].membership[2] && data[r].membership[1]>data[r].membership[0])
		{
			
			class2[c2].Dsample[0]=Nsamples[r].Dsample[0];
			class2[c2].Dsample[1]=Nsamples[r].Dsample[1];
			c2++;
			printf("C2 membership: %f %f %f\r\n",data[r].membership[0],data[r].membership[1],data[r].membership[2]);
		}
		else if(data[r].membership[2]>data[r].membership[0] && data[r].membership[2]>data[r].membership[1])
		{
			
			class3[c3].Dsample[0]=Nsamples[r].Dsample[0];
			class3[c3].Dsample[1]=Nsamples[r].Dsample[1];
			c3++;
			printf("C3 membership: %f %f %f\r\n",data[r].membership[0],data[r].membership[1],data[r].membership[2]);
			
		}

		
	}


	// �� Cluster�� ������ ���
	printf("\r\nCluster1 has no. of samples -->  %d\r\n",c1);
	printf("Cluster2 has no. of samples -->  %d\r\n",c2);
	printf("Cluster3 has no. of samples -->  %d\r\n",c3);


	// Classification
	if(c1 >= c2 && c2 >= c3)
		Class = 0;
	else if(c1 >= c3 && c3 >= c2)
		Class = 0;
	else if(c2 >= c1 && c1 >= c3)
		Class = 1;
	else if(c2 >= c3 && c3 >= c1)
		Class = 1;
	else if(c3 >= c2 && c2 >= c1)
		Class = 2;
	else if(c3 >= c1 && c1 >= c2)
		Class = 2;


	// Class ���
	//printf("%d\n", Class);

	//printf("\r\n������ȣ ũ��: %4d   %4d\r\n",nd,rd);
	for(i=0;i<3;i++)
	{
		printf("cluster%d_Center:%4.0f:%4.0f\r\n",i,Ncluster[i].Dsample[0], Ncluster[i].Dsample[1]);
		fprintf(fp,"cluster%d_Center:%4.0f:%4.0f\r\n",i,Ncluster[i].Dsample[0], Ncluster[i].Dsample[1]);
	}
	// �з� ��ȣ
	// Decision
	if(Ncluster[Class].Dsample[0]>Ncluster[Class].Dsample[1])
		printf("�з����: Electronics\r\n");
	else
	{
		printf("class = %d\r\n",Class);
		printf("�з����: Metal\r\n");

	}

	//�� cluster�� ���� ���
	printf("cluster1\r\n");
	fprintf(fp,"cluster1\r\n");
	for(i=0;i<c1;i++)
	{
		printf("c1:%d:%4.0f:%4.0f\r\n",i,class1[i].Dsample[0], class1[i].Dsample[1]);
		fprintf(fp,"c1:%d:%4.0f:%4.0f\r\n",i,class1[i].Dsample[0], class1[i].Dsample[1]);
	}
	printf("cluster2\r\n");
	fprintf(fp,"cluster2\r\n");
	for(i=0;i<c2;i++)
	{
		printf("c2:%d:%4.0f:%4.0f\r\n",i,class2[i].Dsample[0], class2[i].Dsample[1]);
		fprintf(fp,"c2:%d:%4.0f:%4.0f\r\n",i,class2[i].Dsample[0], class2[i].Dsample[1]);
	}
	printf("cluster3\r\n");
	fprintf(fp,"cluster3\r\n");
	for(i=0;i<c3;i++)
	{
		printf("c3:%d:%4.0f:%4.0f\r\n",i,class3[i].Dsample[0], class3[i].Dsample[1]);
		fprintf(fp,"c3:%d:%4.0f:%4.0f\r\n",i,class3[i].Dsample[0], class3[i].Dsample[1]);
	}
	//if(nd > rd)
	//	Original[k].NLJD_Detection[0] = 0;
	//else Original[k].NLJD_Detection[0] = 1;

	if(Ncluster[Class].Dsample[0] > Ncluster[Class].Dsample[1])
		Decision[k].NLJD_Detection[0] = 0;
	else Decision[k].NLJD_Detection[0] = 1;

	//printf("Original: %.0f\nDecision: %.0f\r\n", Original[k].NLJD_Detection[0], Decision[k].NLJD_Detection[0]);
	fclose(fp);
}

void Performance()
{
	int z, Good=0, Err=0;
	for(z=0; z<Iteration; z++)
	{
		if(Original[z].NLJD_Detection[0] == Decision[z].NLJD_Detection[0])
			Good++;
		else if(Original[z].NLJD_Detection[0] != Decision[z].NLJD_Detection[0])
			Err++;
	}

	printf("Good: %d\nError: %d\r\n", Good, Err);
	printf("CEP: %3.1f %% \r\n", (float) Err/Iteration*100);
}

// ���� ���α׷� 

int main()
{
	int k=0;
	srand((unsigned)time(0));
	Measure();
	// ���� �����͸� �ҷ����� �Լ� 
	//init_members();
	for(k=0; k<Iteration; k++)
	{
		FCM_NLJD();
	}

	Performance();

	getchar();
}

