#include<stdlib.h>
#include<stdio.h>
#include<time.h>
#include<math.h>

#define TOTAL_NUM 50 // the total number of measurement
#define CATEGORY 3 // the total number of class

void main()
{
	void generation(int array_x[], int array_y[], int n); 
	void Normalize(double *point1);
	void fcm_method(int x_second[], int y_third[], double *point2,double *point3);

	srand((int)time(0));
	
	// Generate information database
	int data_x[TOTAL_NUM], data_y[TOTAL_NUM];
	generation(data_x, data_y, TOTAL_NUM);

	//Get the initial membership matrix
	double u[3][50], *p1;
	p1 = u[0];
	Normalize(p1);

	// FCM algorithm
	int class_fcm[TOTAL_NUM] = {0};
	double center_point[2][3];
	double *p2, *p3;
	p2 = u[0];
	p3 = center_point[0];
	fcm_method(data_x, data_y, p2, p3);

	// proof
	for(int i = 0; i < 3;i++)
	{
		for(int j = 0;j < 50;j++)
		{
			printf(" %f ",u[i][j]);
		}
		printf("\n");
	}
	for(int i = 0; i < 2;i++)
	{
		for(int j = 0;j < 3;j++)
		{
			printf(" %f ",center_point[i][j]);
		}
		printf("\n");
	}


	// Out put database and center_point as a text file!
	FILE *fp;
	if( (fp = fopen("data.txt","w")) == NULL )
	{
		printf("cannot open file\n");
		exit(0);
	}
	fprintf(fp,"Measurement\n");
	fprintf(fp,"x,y\n");
	for(int i = 0;i < 50; i++)
	{
		fprintf(fp,"%d,%d\n",data_x[i],data_y[i]);	
	}
	fprintf(fp,"Center\n");
	fprintf(fp,"x,y\n");
	for(int i = 0; i < 3 ; i++)
	{
		fprintf(fp,"%f,%f\n",center_point[0][i],center_point[1][i]);
	}
	fclose(fp);
	
	FILE *fp_1;
	if( (fp_1 = fopen("degree.txt","w")) == NULL )
	{
		printf("cannot open file\n");
		exit(0);
	}
	for(int i = 0;i < 3; i++)
	{
		for(int j = 0;j < 50; j++)
		{
			fprintf(fp_1," %f ",u[i][j]);
		}
		fprintf(fp_1,"\n");
	}
	fclose(fp_1);

	getchar();
}

void fcm_method(int x_second[], int y_third[], double *point2,double *point3) 
{
	//get iformation membership matrix from main
	double u[3][50];
	double *point4;
	point4 = point2;
	for(int i = 0; i < 3; i++)
	{
		for(int j = 0; j < 50; j++)
		{
			u[i][j] = *point2;
			point2++;
		}
	}

	// iteration
	double epsilont, u_new[3][50], temp;
	double center_x[3], center_y[3], sum_denominator , sum_numerator_x, sum_numerator_y;
	double distance[3][50], Num[3];
	do
	{
		// calcluate  coodinate of center point
		for(int r= 0; r < 3; r++)
		{
			sum_denominator = 0;
			sum_numerator_x = 0;
			sum_numerator_y = 0;
			for(int c = 0; c < 50; c++)
			{
				sum_denominator = sum_denominator + u[r][c]*u[r][c];
				sum_numerator_x = sum_numerator_x + u[r][c]*u[r][c]*x_second[c];
				sum_numerator_y = sum_numerator_y + u[r][c]*u[r][c]*y_third[c];
			}
			center_x[r] = sum_numerator_x / sum_denominator;
			center_y[r] = sum_numerator_y / sum_denominator;
		}

		// calcluate distance between measurement point and center
		for(int r = 0; r < 3; r++)
		{
			for(int c = 0; c < 50; c++)
			{
				distance[r][c] = sqrt( (x_second[c]-center_x[r])*(x_second[c]-center_x[r]) + (y_third[c]-center_y[r])*(y_third[c]-center_y[r]) ); 
				//printf(" %f ",distance[r][c]);
			}
			//printf("\n");
		}
		// calcluate new membership matrix
		for(int r = 0; r < 3; r++)
		{
			for(int c = 0; c < 50; c++)
			{
				Num[0] = (distance[r][c]/distance[0][c])*(distance[r][c]/distance[0][c]);
				Num[1] = (distance[r][c]/distance[1][c])*(distance[r][c]/distance[1][c]);
				Num[2] = (distance[r][c]/distance[2][c])*(distance[r][c]/distance[2][c]);
				u_new[r][c] =1 / (Num[0] + Num[1] + Num[2] );
				//printf(" %f ",u_new[r][c]);
			}
			//printf("\n");
		}

		//calcluate epsilont
		for(int r = 0; r < 3; r++)
		{
			for(int c = 0; c < 50; c++)
			{
				if(r == 0 && c == 0)
				{
					temp = u_new[r][c]-u[r][c];
					if(temp < 0)
						temp = -temp;
					epsilont = temp;
				}
				else
				{
					temp = u_new[r][c]-u[r][c];
					if(temp < 0)
						temp = -temp;
					if(epsilont < temp)
						epsilont = temp;
				}
				u[r][c] = u_new[r][c];
			}
		}
	} while( epsilont > 0.01 );

	// return
	for(int i = 0; i < 3; i++)
	{
		for(int j = 0; j < 50; j++)
		{
			*point4 = u[i][j];
			point4++;
			// printf(" %f ",u[i][j]);
		}
		// printf("\n");
	} 
	for(int i = 0; i < 2; i++)
	{
		for(int j = 0; j < 3; j++)
		{
			if(i == 0)
				*point3 = center_x[j];
			else
				*point3 = center_y[j];
			point3++;
		}
	}
	//end
}




// Generate the initial membership matrix
void Normalize( double *point1)
{		  
	double u_initial[3][50], u_normalize[3][50];
	for(int i1 = 0;i1 < 50;i1++)
	{
		for(int j1 = 0;j1 < 3;j1++)
		{
			u_initial[j1][i1] = (double)rand()/RAND_MAX;
		}
	}
	double SUM[50], COUNT;
	for(int i2 = 0;i2 < 50;i2++)
	{
		COUNT = 0;
		for(int j2 = 0;j2 < 3;j2++)
		{
			COUNT = COUNT + u_initial[j2][i2];
		}
		SUM[i2] = COUNT;
	}
	//printf("initial matrix \n");
	//double corect_tt;
	for(int i3 = 0;i3 < 50;i3++)
	{
		//corect_tt = 0;
		for(int j3 = 0;j3 < 3;j3++)
		{
			u_normalize[j3][i3] = u_initial[j3][i3]/SUM[i3];
			//printf("%f $",u_normalize[j3][i3]);
			//corect_tt = u_normalize[j3][i3] + corect_tt;
		}
		//printf("  %f\n",corect_tt);
	}

	for(int i4 = 0;i4 < 3;i4++)
	{
		for(int j4 = 0;j4 < 50;j4++)
		{
			*point1 = u_normalize[i4][j4];
			point1++;
		}
	}
}





void generation(int array_x[], int array_y[],int n){
	// Generate information database (Electronic and metal)
	int row;
	int x,y;

	for(row = 0;row < n;row++)
	{
		if(row < 20)
		{
			x = 201+(int)(100.0*rand()/(RAND_MAX+1.0));
			y = 401+(int)(100.0*rand()/(RAND_MAX+1.0));
			array_x[row] = x;
			array_y[row] = y;
			//printf("%d,%d\n",array_x[row],array_y[row]);
		}
		else
		{
			x = 401+(int)(100.0*rand()/(RAND_MAX+1.0));
			y = 201+(int)(100.0*rand()/(RAND_MAX+1.0));
			array_x[row] = x;
			array_y[row] = y;
			//printf("%d,%d\n",array_x[row],array_y[row]);
		}

	}
}

