
void MADD1(float A, float B, float C, int n)

{
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            for (int k = 0; k < n; k++)
            {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}


// i = 0, j = 0 , k = 0 
// c[0][0] += A[0][0] * B[0][0]

// i = 0, j = 0 , k = 1
// c[0][0] += A[0][1] * B[1][0]