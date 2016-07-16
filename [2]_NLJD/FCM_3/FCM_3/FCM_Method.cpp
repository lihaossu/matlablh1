#include<stdlib.h>
#include<stdio.h>
#include<time.h>
#include<math.h>

#define TOTAL_NUM 50 // the total number of measurement
#define CATEGORY 3 // the total number of class
#define ITERATION 10000
#define VAR1 50
#define VAR2 10

void main()
{
	void generation(int array_x[], int array_y[], double her); 
	void Normalize( double *point1);
	void fcm_method(int x_second[], int y_third[], double *point2,double *point3);
	void variance();
	void output_file(int x[], int y[], double *p_center);
	int classification(double *p_u, double *p_center);

	srand( (int)time(0));

	int data_x[TOTAL_NUM], data_y[TOTAL_NUM];

	double u[3][50], *p1;
	p1 = u[0];

	int class_fcm[TOTAL_NUM] = {0};
	double center_point[2][3];
	double *p2, *p3;
	p2 = u[0];
	p3 = center_point[0];


	//**********iteration***************
	int law;
	float error_num; //total number of error classification 
	float crp; //classification error probability
	double ratio[9] = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9}, HER;
	for(int it = 0; it < 9; it++) 
	{
		HER = ratio[it];
		error_num = 0;
		for(int iteration = 0; iteration < ITERATION; iteration++ )
		{
			// Generate information database
			generation(data_x, data_y, HER);

			//Get the initial membership matrix
			Normalize(p1);

			// FCM algorithm
			fcm_method(data_x, data_y, p2, p3);

			//classification
			law = classification(p2,p3);
			if(law == 1)
			error_num = error_num + 1;
		}
		crp = error_num / ITERATION;
		printf("Harmonics Error Ratio = %f\n",HER);
		printf("Classification Error Probability = %f\n",crp);
	}
	//***********end**************
	//printf("%d",law);
	//***********output file**************
	double *p_center;
	p_center = center_point[0];
	output_file(data_x, data_y, p_center);

	getchar();
}

int classification(double *p_u, double *p_center)
{
	int c1 = 0, c2 = 0, c3 = 0;
	double u[3][50], temp[3];
	for(int i = 0; i < 3; i++)
	{
		for(int j = 0; j < 50; j++)
		{
			u[i][j] = *p_u;
			p_u++;
			//printf(" %f ",u[i][j]);
		}
		//printf("\n");
	}

	for(int i =0; i < 50; i++)
	{
		for(int j = 0; j < 3; j++)
		{
			temp[j] = u[j][i];
		}
		if(temp[0] >= temp[1] && temp[1] >= temp[2])
			c1++;
		else if(temp[0] >= temp[2] && temp[2] >= temp[1])
			c1++;
		else if(temp[1] >= temp[2] && temp[2] >= temp[0])
			c2++;
		else if(temp[1] >= temp[0] && temp[0] >= temp[2])
			c2++;
		else
			c3++;
	}
	// Classification
	int Class;
	if(c1 >= c2 && c2 >= c3)
		Class = 0;
	else if(c1 >= c3 && c3 >= c2)
		Class = 0;
	else if(c2 >= c1 && c1 >= c3)
		Class = 1;
	else if(c2 >= c3 && c3 >= c1)
		Class = 1;
	else
		Class = 2;

	double center[2][3];
	for(int i = 0; i < 2; i++)
	{
		for(int j = 0; j < 3; j++)
		{
			center[i][j] = *p_center;
			p_center++;
			//printf(" %f ", center[i][j]);
		}
		//printf("\n");
	}
	double x, y;
	x = center[0][Class];
	y = center[1][Class];
	//printf("Class%d\n",Class);
	//printf("x = %f\n",x);
	//printf("y = %f\n",y);
	if(x > y)
		return(0);//전자소재
	else
		return(1);//금속류
}


void generation(int array_x[], int array_y[], double her){
	// Generate information database (Electronic and metal)
	int Num, H;
	int x, y; 
	H = (int)(her*TOTAL_NUM);
	for(Num = 0; Num < TOTAL_NUM; Num++)
	{
		if(Num < H)
		{
			x = 200 + (int)(rand()%VAR1);
			y = 400 + (int)(rand()%VAR1);
			array_x[Num] = x;
			array_y[Num] = y;
		}
		else
		{
			x = 400 + (int)(rand()%VAR2);
			y = 200 + (int)(rand()%VAR2);
			array_x[Num] = x;
			array_y[Num] = y;
		}
	}
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
			}
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
			}
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
		}
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
	for(int i3 = 0;i3 < 50;i3++)
	{
		for(int j3 = 0;j3 < 3;j3++)
		{
			u_normalize[j3][i3] = u_initial[j3][i3]/SUM[i3];
		}
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

void output_file(int x[], int y[], double *p_center)
{
	// Out put database and center_point as a text file!
	FILE *fp;
	if( (fp = fopen("data.txt","w")) == NULL )
	{
		printf("cannot open file\n");
		exit(0);
	}
	fprintf(fp,"Measurement\n");
	fprintf(fp,"x,y\n");
	for(int i = 0; i < 50; i++)
	{
		fprintf(fp,"%d,%d\n",x[i],y[i]);
	}
	fprintf(fp,"Center\n");
	fprintf(fp,"x\ny\n");
	fprintf(fp,"%f, %f, %f\n",*p_center,*(p_center+1),*(p_center+2));
	fprintf(fp,"%f, %f, %f\n",*(p_center+3),*(p_center+4),*(p_center+5));
	fclose(fp);

}