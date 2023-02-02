class Game
{
  PVector spot;
  int s, score;
  int[][] state;
  int I, J;
  
  Game(int s)
  {
    this.s = s;
    state = new int[9][9];
    reset();
  }
  
  boolean find(int x, int y, Piece e)
  {
    for(int i = x; i + e.n < 10; i++)
      for(int j = y; j + e.m < 10; j++)
      {
        if(can(i, j, e))
        {
          spot = new PVector(i, j);
          return true;
        }
      }
    return false;
  }
  
  boolean can(int x, int y, Piece e)
  {
    for(int i = 0; i < e.n; i++)
      for(int j = 0; j < e.m; j++)
        if(state[i + x][j + y] == 1 && e.p[i][j] == 1)
          return false;
    return true;
  }
  
  boolean add(int x, int y, Piece e)
  {
    if(can(x, y, e))
    {
      for(int i = 0; i < e.n; i++)
        for(int j = 0; j < e.m; j++)
          if(e.p[i][j] == 1) 
            state[i + x][j + y] = 1;
            return true;  
    } 
    return false;
  }
  
  void reset()
  {
    for(int i = 0; i < 9; i++)
      for(int j = 0; j < 9; j++)
        state[i][j] = 0;
    score = 0;
    spot = new PVector(0, 0); 
  }
  
  void count()
  {
    ArrayList<Integer> tr = new ArrayList();
    ArrayList<Integer> tc = new ArrayList();
    ArrayList<PVector> ts = squares();
    int tscore = 0;
    int multi = 0;  
    for(int i = 0; i < 9; i++)
    {
      if(row(i)) 
        tr.add(i);
      if(col(i)) 
        tc.add(i);
    }
    for(int i = 0; i < tr.size(); i++)
    { 
      drow(tr.get(i));
      tscore += 18;
      multi++;
    }
    for(int i = 0; i < tc.size(); i++)
    {
      dcol(tc.get(i));
      tscore += 18;
      multi++;
    }
    for(int i = 0; i < ts.size(); i++)
    {
      dsquare(int(ts.get(i).x), int(ts.get(i).y));
      tscore += 18;
      multi++;
    }
    score += tscore * multi;
  }
  
  boolean row(int i)
  {
    for(int j = 0; j < 9; j++)
      if(state[j][i] == 0)
        return false;
    return true;
  }
  
  void drow(int i)
  {
    for(int j = 0; j < 9; j++)
      state[j][i] = 0;
  }
  
  boolean col(int i)
  {
    for(int j = 0; j < 9; j++)
      if(state[i][j] == 0)
        return false;
    return true;
  }
  
  void dcol(int i)
  {
    for(int j = 0; j < 9; j++)
      state[i][j] = 0;
  }
  
  ArrayList<PVector> squares()
  {
    ArrayList<PVector> e = new ArrayList();
    for(int i = 0; i < 9; i += 3)
      for(int j = 0; j < 9; j += 3)
         if(square(i, j))
           e.add(new PVector(i, j));
    return e;
  }
  
  boolean square(int k, int l)
  {
    for(int i = 0; i < 3; i++)
      for(int j = 0; j < 3; j++)
        if(state[j + k][i + l] == 0)
        return false;
    return true;
  }
  
  void dsquare(int k, int l)
  {
    for(int i = k; i < 3 + k; i++)
      for(int j = l; j < 3 + l; j++)
        state[i][j] = 0;
  }
  
  void drawpiece(float x, float y, Piece e)
  {
    if(x < 0) 
      x = 0;
    if(y < 0) 
      y = 0;
    for(int i = 0; i < e.n; i++)
      for(int j = 0; j < e.m; j++)
      {
        fill(0, 0, 255);
        stroke(0);
        strokeWeight(4);
        if (e.p[i][j] == 0) 
          continue;
        if (e.p[i][j] == 1)
        {
          float tx = x + i * s;
          float ty = y + j * s;
          if(tx + (e.n - i) * s > 9 * s) 
            tx = 9 * s - (e.n - i) * s;                    
          if(ty + (e.m - j) * s > 9 * s) 
            ty = 9 * s - (e.m - j) * s;           
          rect(tx, ty, s, s);
          I = int((tx + s/2)/s) - i;
          J = int((ty + s/2)/s) - j;
        }
      }
  }
  
  void drawset(int slot, Piece e)
  {
    for(int i = 0; i < e.n; i++)
      for(int j = 0; j < e.m; j++)
      {
        fill(0, 0, 255);
        stroke(25);
        strokeWeight(4);
        if (e.p[i][j] == 0) 
          continue;
        if (e.p[i][j] == 1)          
          rect(90 + slot * 235 + i * 25, 775 + j * 25, 25, 25);
       }
  }

  void drawgame()
  {
    boolean dark = false;
    for(int i = 0; i < 3; i++)
      for(int j = 0; j < 3; j++)
      {
        dark = !dark;
        fill(dark ? 200 : 255);
        stroke(0);
        strokeWeight(4);
        rect(i * 3 * s, j * 3 * s, 3 * s, 3 * s);
        drawlines(i * 3 * s, j * 3 * s);
      }
    drawstate();
  }
  
  void drawlines(float x, float y)
  {
    stroke(0);
    strokeWeight(2);  
    for(int i = 1; i < 3; i++)   
      for(int j = 1; j < 3; j++)
      {
        line(x, y + s * j, x + 3 * s, y + s * j);
        line(x + s * i, y, x + s * i, y + 3 * s);
      }
  }
  
  void drawstate()
  {  
    fill(0, 0, 255);
    strokeWeight(4);
    for(int i = 0; i < 9; i++)
      for(int j = 0; j < 9; j++)         
        if (state[i][j] == 1)
          rect(i * s, j * s, s, s);  
  }
}
