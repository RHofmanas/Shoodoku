class Piece
{
  int[][] p;
  int id, n, m;

  Piece(int id,int n, int m)
  {
    this.n = n;
    this.m = m;
    this.id = id;
    p = new int[n][m];
  }
  
  int size()
  {
    int size = 0;
    for(int i = 0; i < n; i++)
      for(int j = 0; j < m; j++)
        if(p[i][j] == 1)
          size++;
    return size;
  }
}
