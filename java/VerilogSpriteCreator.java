import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Toolkit;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.geom.Line2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.ArrayList;
import java.util.SortedMap;
import java.util.TreeMap;

import javax.swing.JApplet;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.filechooser.FileNameExtensionFilter;

public class VerilogSpriteCreator extends JApplet implements KeyListener,
		MouseListener, MouseMotionListener{
	
	private BufferedImage bi;
	private Graphics2D g;
	private Graphics2D g2;
	
	private Keyboard k = new Keyboard();
	
	public VerilogSprite sprite = new VerilogSprite();
	public VerilogSprite lastSprite = new VerilogSprite();
	
	int invert = 0;

	
	public VerilogSpriteCreator() {
		
		
	}
	
	private int getNumberIndex(String fileName)
	{
		int numberindex = -1;
		
		char[] numbers = {'0','1','2','3','4','5','6','7','8','9'};
		for (int i = 0; i < fileName.length(); i++)
		{
			for (int c = 0; c < numbers.length; c++)
			if (fileName.charAt(i) == numbers[c])
				{numberindex = i;
				
				break;}
			if (numberindex != -1) break;
		}
		
		return numberindex;
		
	}
	private boolean getGIFFriendos()
	{
		String fileName = sprite.fileName;
		String root = null;
		int numberindex = getNumberIndex(fileName);
		
		if (numberindex == -1)
			return false;
		
		root = fileName.substring(0,numberindex);
		
		int number = -1;
		
		File folder = new File(".");
		File[] listOfFiles = folder.listFiles();
		SortedMap<Integer,String> friendos = new TreeMap<Integer,String>();
		    for (int i = 0; i < listOfFiles.length; i++) {
		    	File xd = listOfFiles[i];
		    	
		      if (xd.isFile()) {
		    	  String xname = xd.getName();
		    	  if (xname.startsWith(root) && getNumberIndex(xname) == numberindex)
		    	  {
		    		  String numberString= xname.substring(numberindex,
		    			        xname.indexOf('.'));
		    		  
		    		  if (numberString.length() == 0)
		    			  continue;//if chicken.h and chicken1.h and chicken2.h
		    		  
		    		  number = Integer.parseInt(numberString);
		    		  friendos.put(number,xname);
		    	  }
		    	  
		      } 
		    }
		    keySet = new ArrayList<Integer>();
		    for (Integer i : friendos.keySet())
		    	keySet.add(i);
		    
		    loadedSprites = new ArrayList<VerilogSprite>();
		    for (int i = 0; i < keySet.size(); i++)
		    	{
		    	VerilogSprite currentGIF = new VerilogSprite();
			currentGIF.loadFromFile(friendos.get(keySet.get(i)));
			loadedSprites.add(currentGIF);
			}
		
		return true;
	}
	
	int currentIndex = 0;
	ArrayList<Integer> keySet;
	ArrayList<VerilogSprite> loadedSprites;
	SortedMap<Integer,String> sameRoot;
	
	public void doGifModeStuff()
	{
		g.setPaint(Color.GRAY.brighter());
		g.fillRect(0,0,width,height);
		
		VerilogSprite currentGIF = loadedSprites.get(currentIndex);
		
		g.setPaint(Color.BLACK);
		for (float r = 0; r < VerilogSprite.PIXEL_ROWS; r++)
			for (float c = 0; c < VerilogSprite.PIXEL_COLUMNS; c++)
				if (currentGIF.data[(int)r][(int)c] == 1)
					g.fillRect((int)(c/VerilogSprite.PIXEL_COLUMNS * width),
							(int)(r/VerilogSprite.PIXEL_ROWS*height),
							width/VerilogSprite.PIXEL_COLUMNS,
							height/VerilogSprite.PIXEL_ROWS);
		
		
		
		
		
		
		currentIndex++;
		if (currentIndex == keySet.size())
			currentIndex = 0;
		
	}
	
	long lastTimeGifMode = 0L;
	public void paint()
	{
		long currentTime = System.currentTimeMillis();
		if (width != getSize().width)
			width = getSize().width;
		if (height != getSize().height)
			height = getSize().height;
		
		if (gifMode)
		{
			if ((currentTime - lastTimeGifMode > 1000.0 / gifFPS))
			{
			lastTimeGifMode = currentTime;
			doGifModeStuff();
			}
			g2.drawImage(bi, null, 0, 0);
			return;
		}
		
		g.setPaint(Color.GREEN);
		g.fillRect(0, 0, width, height);
		
		g.setPaint(Color.BLUE);
		//draw the grid lines
		for (double c = 0; c < VerilogSprite.PIXEL_COLUMNS; c++)
		{
			g.draw(new Line2D.Double(
					c/VerilogSprite.PIXEL_COLUMNS * width,
					0,
					c/VerilogSprite.PIXEL_COLUMNS * width,
					height)
					);
		}
		
		for (double r = 0; r < VerilogSprite.PIXEL_ROWS; r++)
		{
			g.draw(new Line2D.Double(
					0,
					r/VerilogSprite.PIXEL_ROWS * height,
					width,
					r/VerilogSprite.PIXEL_ROWS * height 
					));
		}
		
		//fill in the squares
		for (double r = 0; r < VerilogSprite.PIXEL_ROWS; r++)
		{
			for (double c = 0; c < VerilogSprite.PIXEL_COLUMNS; c++)
			{
				if (lastSprite.data[(int)r][(int)c] == 1 
						&& !(invert==1 && sprite.data[(int)r][(int)c] == 1))
				{
				g.setPaint(Color.RED);
				g.fillRect((int)(c/VerilogSprite.PIXEL_COLUMNS * width),
						   (int)(r/VerilogSprite.PIXEL_ROWS * height),
						   width/VerilogSprite.PIXEL_COLUMNS,
						   height/VerilogSprite.PIXEL_ROWS);	
				}
				if (invert != sprite.data[(int)r][(int)c]
						&& !(invert==1 && lastSprite.data[(int)r][(int)c]==1))
				{
					g.setPaint(Color.BLUE);
				g.fillRect((int)(c/VerilogSprite.PIXEL_COLUMNS * width),
						   (int)(r/VerilogSprite.PIXEL_ROWS * height),
						   width/VerilogSprite.PIXEL_COLUMNS,
						   height/VerilogSprite.PIXEL_ROWS);	
				
				}
				
			}
			
		}
		
		
		
		
		g2.drawImage(bi, null, 0, 0);
	}
	JFrame frame;
	
	private void setupGraphics()
	{
		
		bi = new BufferedImage(getSize().width,getSize().height, 5);
		g = bi.createGraphics();
		g2 = (Graphics2D)(this.getGraphics());
		
	}
	
	
	
	private int width,height;
	
	
	public void begin()
	{
	
		
		frame = new JFrame("github.com/StevenVentura/NokiaSpriteCreator: press arrowkeys=move, i=invert, L=Load,S=Save, G=GIFMODE,Delete=CLEAR SCREEN");
		
		
		
		Toolkit tk = Toolkit.getDefaultToolkit();
		
		frame.setSize(tk.getScreenSize().width - 100, tk.getScreenSize().height - 100);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		frame.add(this);
		this.addKeyListener(this);
		this.addMouseListener(this);
		this.addMouseMotionListener(this);
		this.setFocusable(true);
		frame.setVisible(true);
		
		width = getSize().width;
		height = getSize().height;
		setupGraphics();
		
		while(true)
		{
			try{Thread.sleep(30);}catch(Exception e){;}
			paint();
			handleKeyPresses();
		}
		
		
		
	}
	
	
	
	
	
	
	public static void main(String[]args)
	{	
		String s = "static const byte p l e a s e [][84] = {0x00,0x00,0x00,0x";
		System.out.println(s.substring(s.indexOf('{')));
		
		
		VerilogSpriteCreator f = new VerilogSpriteCreator();
		f.begin();
		
		
		
	}







	@Override
	public void mouseClicked(MouseEvent arg0) {
		// TODO Auto-generated method stub
		
	}







	@Override
	public void mouseEntered(MouseEvent arg0) {
		// TODO Auto-generated method stub
		
	}







	@Override
	public void mouseExited(MouseEvent arg0) {
		// TODO Auto-generated method stub
		
	}






	boolean leftDown = false;
	boolean rightDown = false;
	
	
	public static final int LEFT_CLICK = 1, RIGHT_CLICK = 3;
	@Override
	public void mousePressed(MouseEvent arg0) {
		if (gifMode) return;
		// TODO Auto-generated method stub
		double x = arg0.getX();
		double y = arg0.getY();
		int row, column;
		
		
		column = (int) (x * VerilogSprite.PIXEL_COLUMNS / width);
		row = (int) (y * VerilogSprite.PIXEL_ROWS / height);
		
		int keycode = arg0.getButton();
		if (keycode == LEFT_CLICK)
		{
			leftDown = true;
			sprite.data[row][column] = 1;
		}
		
		
		if (keycode == RIGHT_CLICK)
		{
			rightDown = true;
			sprite.data[row][column] = 0;
		}
		
	}
	@Override
	public void mouseMoved(MouseEvent arg0) {
		// TODO Auto-generated method stub
		
		double x = arg0.getX();
		double y = arg0.getY();
		int row, column;
		
		column = (int) (x * VerilogSprite.PIXEL_COLUMNS / width);
		row = (int) (y * VerilogSprite.PIXEL_ROWS / height);
		
		if (leftDown) {
			
			sprite.data[row][column] = 1;
		}
		if (rightDown)
		{
			
			sprite.data[row][column] = 0;
		}
		
		
		
	}

	@Override
	public void mouseReleased(MouseEvent arg0) {
		// TODO Auto-generated method stub
		int keycode = arg0.getButton();
		if (keycode == LEFT_CLICK)
		{
			leftDown = false;
		}
		if (keycode == RIGHT_CLICK)
		{
			rightDown = false;
			
		}
	}
	
	private void deleteErrything()
	{
		
		for (int r = 0; r < VerilogSprite.PIXEL_ROWS; r++)
			for (int c = 0; c < VerilogSprite.PIXEL_COLUMNS; c++)
			{
				sprite.data[r][c] = 0;
				lastSprite.data[r][c] = 0;
			}
		
	}
	boolean gifMode = false;
	float gifFPS;
	
	public void handleKeyPresses()
    {
		if (k.t("g"))
		{
			System.out.println("enabled desu");
			gifMode = !gifMode;
			if (gifMode)
			{
				if (getGIFFriendos() == false){
					gifMode = false;
					k.untype();
					return;
				}
				else
				{
					long safetyTimeout = System.currentTimeMillis();
					String fpsString = null;
					fpsString = JOptionPane.showInputDialog(null,
					        "how many fps? (0.1 to 8)", null);
					while (fpsString == null)
				{
				if (System.currentTimeMillis() - safetyTimeout > 8000)	
				{
					gifMode = false;
					k.untype();
						return;
				}
				}
					
					try{
					gifFPS = Float.parseFloat(fpsString);
					if (gifFPS <= 0)
					{
						gifMode = false;
						k.untype();
							return;
					}
					}catch(NumberFormatException e)
					{
						gifMode = false;
						k.untype();
							return;
					}
					
					
				}
				 
				
				
			}
			/*assumes your naming is like "yoloscope1, yoloscope2" up to 9.
			 */
			
			
			
			
			
		}
		if (k.t("delete"))
		{
			JDialog.setDefaultLookAndFeelDecorated(true);
		    int response = JOptionPane.showConfirmDialog(null, "realy delete tho?", "Confirm",
		        JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
		    if (response == JOptionPane.NO_OPTION) {
		    	System.out.println("he hit no xd");
		    } else if (response == JOptionPane.YES_OPTION) {
		      
		    	deleteErrything();
		    	
		    	
		    	
		    	
		    } else if (response == JOptionPane.CLOSED_OPTION) {
		      System.out.println("retard closed dialog");
		    }
		}
		if (k.k("down"))
		{
			int[] bottomrow = new int[VerilogSprite.PIXEL_COLUMNS];
			for (int c = 0; c < VerilogSprite.PIXEL_COLUMNS; c++)
				bottomrow[c] = sprite.data[VerilogSprite.PIXEL_ROWS-1][c];
			
			
			for (int r = VerilogSprite.PIXEL_ROWS-1; r > 0; r--)
			{
				for (int c = 0; c < VerilogSprite.PIXEL_COLUMNS; c++)
				{
					sprite.data[r][c] = sprite.data[r-1][c];
					
					
				}
			}
			
			for (int c = 0; c < VerilogSprite.PIXEL_COLUMNS; c++)
				sprite.data[0][c] = bottomrow[c];
			
			
			
			
			
		}
		if (k.k("up"))
		{
			int[] toprow = new int[VerilogSprite.PIXEL_COLUMNS];
			for (int c = 0; c < VerilogSprite.PIXEL_COLUMNS; c++)
				toprow[c] = sprite.data[0][c];
			
			
			for (int r = 1; r < VerilogSprite.PIXEL_ROWS; r++)
			{
				for (int c = 0; c < VerilogSprite.PIXEL_COLUMNS; c++)
				{
					sprite.data[r-1][c] = sprite.data[r][c];
					
				}
			}
			
			for (int c = 0; c < VerilogSprite.PIXEL_COLUMNS; c++)
				sprite.data[VerilogSprite.PIXEL_ROWS-1][c] = toprow[c];
			
		}
		if (k.k("left"))
		{
			int[] leftColumn = new int[VerilogSprite.PIXEL_ROWS];
			for (int r = 0; r < VerilogSprite.PIXEL_ROWS; r++)
				leftColumn[r] = sprite.data[r][0];
			
			for (int c = 1; c < VerilogSprite.PIXEL_COLUMNS; c++)
			{
				for (int r = 0; r < VerilogSprite.PIXEL_ROWS; r++)
				{
					sprite.data[r][c-1] = sprite.data[r][c];
				}
			}
			
			for (int r = 0; r < VerilogSprite.PIXEL_ROWS; r++)
				sprite.data[r][VerilogSprite.PIXEL_COLUMNS-1] = leftColumn[r];
			
		}
		if (k.k("right"))
		{
			int[] rightColumn = new int[VerilogSprite.PIXEL_ROWS];
			for (int r = 0; r < VerilogSprite.PIXEL_ROWS; r++)
				rightColumn[r] = sprite.data[r][VerilogSprite.PIXEL_COLUMNS-1];
			
			for (int c = VerilogSprite.PIXEL_COLUMNS-2; c >= 0; c--)
			{
				for (int r = 0; r < VerilogSprite.PIXEL_ROWS; r++)
				{
					sprite.data[r][c+1] = sprite.data[r][c];
				}
			}
			
			
			for (int r = 0; r < VerilogSprite.PIXEL_ROWS; r++)
				sprite.data[r][0] = rightColumn[r];
			
			
		}
		if (k.t("s"))
		{
			String fileName = null;
			fileName = JOptionPane.showInputDialog(null,
			        "save to wat file", null);
			while (fileName == null)
		{
		if (System.currentTimeMillis() - lastTime > 5000)	
		{
			
			k.untype();
				return;
		}
		}
			
			sprite.saveToFile(fileName);
		}
		if (k.t("i"))
			invert = (invert==1) ? 0 : 1;
		
		
		if (k.t("l"))
		{
			lastTime = System.currentTimeMillis();
			String fileName = null;
			JFileChooser fc = new JFileChooser();
			fc.setCurrentDirectory(new File("."));
			FileNameExtensionFilter filter = 
					new FileNameExtensionFilter("sprite files", "h");
			fc.setFileFilter(filter);
			int rv = fc.showOpenDialog(new JFrame());
			if (rv == fc.APPROVE_OPTION)
			{
			File file = fc.getSelectedFile();
			try{
				
				for (int r = 0; r < sprite.data.length; r++)
				{
					for (int c = 0; c < sprite.data[0].length; c++)
					{
						lastSprite.data[r][c] = sprite.data[r][c];
					}
				}
				sprite.loadFromFile(file.getName());
				
				
			}catch(Exception exc){exc.printStackTrace();};
			}
		}
		
		k.untype();
    return;
    }





	@Override
	public void keyPressed(KeyEvent arg0) {
		// TODO Auto-generated method stub
		k.keyPress(KeyEvent.getKeyText(arg0.getKeyCode()).toLowerCase());
	}





long lastTime = 0;
long lastTimeArrow = 0;

	@Override
	public void keyReleased(KeyEvent arg0) {
		k.keyRelease(KeyEvent.getKeyText(arg0.getKeyCode()).toLowerCase());
		// TODO Auto-generated method stub
		
	}







	@Override
	public void keyTyped(KeyEvent arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseDragged(MouseEvent arg0) {
		// TODO Auto-generated method stub
		
		double x = arg0.getX();
		double y = arg0.getY();
		if ( x < 0 )
			 x = 0;
		if ( y < 0)
			 y = 0;
		int row, column;
		
		column = (int) (x * VerilogSprite.PIXEL_COLUMNS / width);
		row = (int) (y * VerilogSprite.PIXEL_ROWS / height);
		
		if (leftDown) {
			
			sprite.data[row][column] = 1;
		}
		if (rightDown)
		{
			
			sprite.data[row][column] = 0;
		}
	}

	
}