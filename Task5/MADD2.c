#define BLOCK_SIZE 4 // Cache size is 4 words per block

void MADD2(float *A, float *B, float *C, int n)
{
    int i, j, k, jj, kk;
    float sum;

    for (jj = 0; jj < n; jj += BLOCK_SIZE)
    {
        for (kk = 0; kk < n; kk += BLOCK_SIZE)
        {
            for (i = 0; i < n; i++)
            {
                for (j = jj; j < min(jj + BLOCK_SIZE, n); j++)
                {
                    sum = 0.0;
                    for (k = kk; k < min(kk + BLOCK_SIZE, n); k++)
                    {
                        sum += A[i * n + k] * B[k * n + j];
                    }
                    C[i * n + j] += sum;
                }
            }
        }
    }
}
