import java.awt.image.BufferedImage;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;

import javax.imageio.ImageIO;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JOptionPane;

public class HandleImagePlease {
	
	public HandleImagePlease() { }
	
	public int[][] red;
	public int[][] blue;
	public int[][] green;
	
	
	public void begin()
	{
		try{
			String fileName = JOptionPane.showInputDialog(null,
			        "enter full path to file", null);
		System.out.println("filename is " + fileName);
		BufferedImage image = null;
        try
        {
          image = ImageIO.read(new File(fileName));
        }
        catch (Exception e)
        {
          e.printStackTrace();
          System.exit(1);
        }
        
         
        red = new int[image.getHeight()][image.getWidth()];
        green = new int[image.getHeight()][image.getWidth()];
        blue = new int[image.getHeight()][image.getWidth()];
        for (int r = 0; r < image.getHeight(); r++)
        	for (int c = 0; c < image.getWidth(); c++)
        	{
        		int clr=  image.getRGB(r,c);
        		red[r][c] =(clr & 0x00ff0000) >> 16; 
        		green[r][c] = (clr & 0x0000ff00) >> 8; 
        		blue[r][c] =clr & 0x000000ff;
        	}
        
        //now put it in da file XD XD XD XD 
        
        String out = "";
        /*
        parameter reg[7:0] 
        testeroo [0:1] [0:1] = '{ '{'hff, 'hff}, '{'hff, 'hff} };
         */
        

        
        String[] imageColorNames = "imageRed imageGreen imageBlue".split(" ");
        
        for (int i = 0; i < imageColorNames.length; i++)
        {
        	out += imageColorNames[i]
        			+ " [0:31] [0:31] = '{ ";
        	
        for (int r = 0; r < image.getHeight(); r++)
        {
        	out += "'{";
        	for (int c = 0; c < image.getWidth(); c++)
        	{
        		int pls = please(r,c,i);
        		out += "'h" + hex(pls,1) + hex(pls,0);
        		
        		
        		if (c != image.getWidth()-1)
        			out += ",";
        	}
        	if (r != image.getHeight()-1)
        		out += "},";
        	else
        		out += "}";
        	
        	
        }
        if (i != imageColorNames.length-1)
        out += "},\r\n";
        else
        	out += "};\r\n";
        
        }


        
        
        
        createFile(fileName.substring(0, fileName.indexOf(".")) + ".please", out);
		}catch(Exception e){e.printStackTrace();};
	}
	private int please(int r, int c, int index)
	{
		if (index == 0)
			return red[r][c];
		if (index == 1)
			return green[r][c];
		if (index == 2)
			return blue[r][c];
		return 5;
	}
	private static String hex(int number, int place)
	{
		int choice = (number >> place*4) & 0xf;
		switch(choice) {
		case (0x0):return "0";
			
			
		case (0x1):return "1";
		
		case(0x2):return "2";
		
		case(0x3):return "3";
		
		case(0x4):return "4";
		
		case(0x5):return "5";
		
		case(0x6):return "6";
		
		case(0x7):return "7";
		
		case(0x8):return "8";
		
		case(0x9):return "9";
		
		case(0xa):return "a";
		
		case(0xb):return "b";
		
		case(0xc):return "c";
		
		case(0xd):return "d";
		
		case(0xe):return "e";
		
		case(0xf):return "f";
		
		}
		return "k";
	}
	public static void createFile(String fileName, String whatToWrite)//creates new File fileName, populated with String whatToWrite. If you want new lines, you will have to use \r\n's in the whatToWrite String.
	{
	try{
	FileWriter fstream = new FileWriter(fileName);
	BufferedWriter writer = new BufferedWriter(fstream);

	System.out.println(whatToWrite);
	writer.write(whatToWrite + "\r\n");

	writer.close();

	}catch(Exception e){e.printStackTrace();};
	}
	public static void main(String[]args)
	{
		
		HandleImagePlease h = new HandleImagePlease();
		h.begin();
		
	}
	
	
}

