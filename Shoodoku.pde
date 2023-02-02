ArrayList<Piece> set;
boolean over, hold;
boolean auto = true;
boolean slow = false;
boolean calc = true;
boolean save = false;
boolean fair = false;
int s, r, runs, best;
int target = 40000;
String[] data;
String str = "";
PImage img;
Game G, T;
Piece[] P;
Move M;

void setup()
{
  size(720,920);
  frameRate(slow ? 2 : 200);
  img = loadImage("pic.png");
  load(fair ? "p.txt" : "peasy.txt");
  G = new Game(s = width/9); 
  M = new Move();
  set = fill();
}

void draw()
{
  image(img, 0, 0);
  if(!calc)
  {
    fill(225);
    stroke(255);
    strokeWeight(4);
    textSize(80);
    text("GAME OVER", 160, 400);
    text("Score: " + G.score, 180, 496);
    stroke(225, 193, 110);
    rect(230, 533, 270, 64, 8);
    fill(225, 193, 110);
    textSize(50);
    text("New game", 255, 580); 
  }
  else
  {
    textSize(50);
    text("Runs: " + runs, 260, 480);
  }
  if(!over)
  {
    if(!calc)
    {
      fill(255);
      textSize(50);
      text("Points " + G.score, 8, 765);
      G.drawgame(); 
      for(int i = 0; i < set.size(); i++) 
        G.drawset(i, set.get(i));
    }
    if(auto)
    {
      next();
      if(M.score == 0)
      {
        over = true;
        runs++;
        if(G.score > best)
        {
          best = G.score;
          String s = runs + ": " + best;
          println(s);
          if(save)
          {
            s = s + ".";
            str = str + s;
            data = split(str,".");
            saveStrings("data.txt", data);
          }
        }
        if(best < target)
        {
          over = false;
          G.reset();
          set = fill();
        }
      }
      else  
        make(); 
    }
    else
    {  
      if (mousePressed)
      {
        if(!over)
        {
          if(!hold && mouseY > 765 && mouseY < 900)
          {
            if(mouseX > 0 && mouseX < 3 * s)
            {
              r = set.get(0).id;
              set.remove(0);
              hold = true;
            } 
            else if(mouseX > 216 && mouseX < 6 * s && set.size() > 1)
            {
              r = set.get(1).id;
              set.remove(1);
              hold = true;
            }
            else if(mouseX > 432 && mouseX < 9 * s && set.size() > 2)
            {
              r = set.get(2).id;
              set.remove(2);
              hold = true;
            }
          }
          if(hold)
            G.drawpiece(mouseX, mouseY, P[r]);
        }
      }
    }
  }
}

void mouseClicked()
{
  if(mouseX > 255 && mouseX < 512 && mouseY > 550 && mouseY< 600 && over)
  {
    over = false;
    G.reset();
    set = fill();
  }
}

void mouseReleased()
{
  if(hold){
    if(G.add(G.I, G.J, P[r]))
    {
      G.score += P[r].size();
      G.count();
    }
    else if(!G.find(0, 0, P[r]))
    {
      over = true;
      hold = false;
      return;
    }
    else
      set.add(P[r]);
    hold = false;
  }
  if(set.size() == 0) 
    set = fill();
}

void make()
{
  if(M.m.size() == 0) 
    return;
  for(int i = 0; i < 3; i++)
  {
    G.add(int(M.m.get(i).x), int(M.m.get(i).y), P[int(M.m.get(i).z)]);
    G.score += P[r].size();
    G.count();
  }
  set = fill();
  M = new Move();
}

void next()
{
  for (int i = 0; i < 9; i++)
    for (int j = 0; j < 9; j++)
    {
      Move e = eval(i, j, 0, 1, 2, set);
      if(e.score > M.score) 
        M = copy(e);
      e = eval(i, j, 0, 2, 1, set);
      if(e.score > M.score) 
        M = copy(e);
      e = eval(i, j, 1, 2, 0, set);
      if(e.score > M.score) 
        M = copy(e);
      e = eval(i, j, 1, 0, 2, set);
      if(e.score > M.score) 
        M = copy(e);
      e = eval(i, j, 2, 1, 0, set);
      if(e.score > M.score) 
        M = copy(e);
      e = eval(i, j, 2, 0, 1, set);
      if(e.score > M.score) 
        M = copy(e);
    }
}

Move eval(int x, int y, int a, int b, int c, ArrayList<Piece> set){
  Move e = new Move();
  COPY();
  r = set.get(a).id;
  if(T.find(x, y, P[r]))
  {
    T.add(int(T.spot.x), int(T.spot.y), P[r]);
    T.score += P[r].size();
    T.count();
    e.m.add(new PVector(T.spot.x, T.spot.y, r));
  }
  else
  {
    e.score = 0;
    return e;
  }
  r = set.get(b).id;
  if(T.find(x, y, P[r]))
  {
    T.add(int(T.spot.x), int(T.spot.y), P[r]);
    T.score += P[r].size();
    T.count();
    e.m.add(new PVector(T.spot.x, T.spot.y, r));
  }
  else
  {
    e.score = 0;
    return e;
  }
  r = set.get(c).id;
  if(T.find(x, y, P[r]))
  {
    T.add(int(T.spot.x), int(T.spot.y), P[r]);
    T.score += P[r].size();
    T.count();
    e.m.add(new PVector(T.spot.x, T.spot.y, r));
  }
  else
  {
    e.score = 0;
    return e;
  }
  e.score = T.score;
  return e;
}

Move copy(Move e)
{
  Move copy = new Move();
  for(int i = 0; i < e.m.size(); i++)
    copy.m.add(e.m.get(i));
  copy.score = e.score;
  return copy;
}

void COPY()
{
  T = new Game(s);
    for(int i = 0; i < 9; i++)
      for(int j = 0; j < 9; j++)
        T.state[i][j] = G.state[i][j];
}

ArrayList<Piece> fill()
{
  ArrayList<Piece> p = new ArrayList();
  for(int i = 0; i < 3; i++)
    p.add(P[(int)random(P.length - 1)]);
  return p;
}

void load(String file){
  int n, m;
  String[] lines = loadStrings(file);
  P = new Piece[lines.length];
  for (int i = 0; i < lines.length; i++) 
  {   
    String[] piece = lines[i].split(";");
    n = piece.length;
    m = 0;
    for(int j = 0; j < n; j++)
    {
      String[] row = piece[j].split(",");
      if(row.length > m) 
        m = row.length;
    }
    P[i] = new Piece(i, n, m);
    for(int j = 0; j < n; j++)
    {
      String[] row = piece[j].split(",");
      for(int k = 0; k < m; k++)
        P[i].p[j][k] = row[k].equals("1") ? 1 : 0;     
    } 
  }
}
