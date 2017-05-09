import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.Scanner;

public class VerilogSprite
{
	public static final int PIXEL_ROWS = 32;
	public static final int PIXEL_COLUMNS = 32;
	
	public String fileName;
	
	
	public int[][] data;
	
	public VerilogSprite()
	{
		data = new int[PIXEL_ROWS][PIXEL_COLUMNS];
		fileName = "";
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
	
	private static String getFileContents(String fileName)
	{
		String out = "";
		try{
			Scanner scan = new Scanner(new File(fileName));
			while(scan.hasNextLine())
			{
				out += scan.nextLine() + "\r\n";
			}
			scan.close();
			
		}catch(Exception e)
		{
			e.printStackTrace();
			createFile("alphabet.super","hi");
		}
		
		return out;
	}
	
	public static String reverse(String me)
	{
		char[] pleasetho = new char[32];
		//code works for even-length strings i guess
		for (int x = 0; x < me.length()/2; x++)
		{
			
			pleasetho[x] = me.charAt(me.length()-1-x);
			pleasetho[me.length()-1-x] = me.charAt(x);
		}
		
		return new String(pleasetho);
		
		
	}
	
	public static char binaryFourBitsToHex(String binary)
	{
		switch (binary)
		{
		case "0000":return '0';
			
		case "0001":return '1';
			
		case "0010":return '2';
			
		case "0011":return '3';
			
		case "0100":return '4';
			
		case "0101":return '5';
			
		case "0110":return '6';
			
		case "0111":return '7';
			
		case "1000":return '8';
			
		case "1001":return '9';
			
		case "1010":return 'a';
			
		case "1011":return 'b';
			
		case "1100":return 'c';
			
		case "1101":return 'd';
			
		case "1110":return 'e';
			
		case "1111":return 'f';
			
			
		
		}
		return 'w';
		
	}
	
	public void saveToFile(String fileName)
	{
		/*
		 * append each one to the alphabet.super file.
		 * 
		 * it has to reverse the pixels across the entire row
		 * it also has to compress it to hex
		 * 
		 * 
		 * cG [0:31] = '{'h00000000,'h00000000,'h00000000,'h007f8000,'h0780e000,'h0c003000,'h00001800,'h00000c00,'h00000600,'h00000200,'h00000300,'h00000100,'h00000180,'h00000080,'h00000080,'h000000c0,'h00000040,'h00000040,'h0f800040,'h0fff0040,'h083f8040,'h04000040,'h060000c0,'h02000080,'h03000080,'h00c00100,'h00780300,'h000ffc00,'h00000000,'h00000000,'h00000000,'h00000000},
cH [0:31] = '{'h00000000,'h00000000,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h01fff860,'h00ffffe0,'h00c007e0,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00000060,'h00000000,'h00000000},
cI [0:31] = '{'h00000000,'h00000000,'h00fffff0,'h00fffff0,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h007fffe0,'h007fffe0,'h00000000,'h00000000,'h00000000},
cJ [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h3fffff80,'h03fdc000,'h00018000,'h00038000,'h00030000,'h00030000,'h00070000,'h00060000,'h00060000,'h00060000,'h00060000,'h00060000,'h00020000,'h00030000,'h00030000,'h00018000,'h0001c000,'h0000e060,'h0000ffc0,'h00007f80,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
cK [0:31] = '{'h00000000,'h00000000,'h00000060,'h00000060,'h00100060,'h00180060,'h000c0060,'h00060060,'h00010060,'h0000c060,'h00006060,'h00001860,'h00000660,'h00000360,'h000001e0,'h000000e0,'h000000e0,'h000001e0,'h00000360,'h00000c60,'h00001860,'h00006060,'h00038060,'h00060060,'h001c0060,'h00300060,'h00200060,'h00000060,'h00000000,'h00000000,'h00000000,'h00000000},
cL [0:31] = '{'h00000000,'h00000000,'h000000c0,'h000000c0,'h000000c0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000c0,'h000000c0,'h000000c0,'h000001c0,'h000000c0,'h000000c0,'h000000c0,'h000000c0,'h000000c0,'h0fffe0c0,'h0ffffec0,'h007fffe0,'h0001ff80,'h000001c0,'h00000000},
cM [0:31] = '{'h00000000,'h00000000,'h00000004,'h02000004,'h03000004,'h0780000c,'h0280000e,'h0240000a,'h02600012,'h02300036,'h02100024,'h02080064,'h020c0044,'h020600c4,'h02030184,'h02010104,'h02008304,'h0200cc04,'h02007804,'h02003004,'h02002004,'h02000004,'h02000004,'h02000004,'h02000004,'h02000004,'h02000004,'h02000004,'h02000004,'h00000004,'h00000000,'h00000000},
cN [0:31] = '{'h00000000,'
		 */
		
		//appending to file
		String out = getFileContents("alphabet.super");
		//now write this sprite to the file
		out += "c" + fileName.toUpperCase() + " [0:31] = '{";
		
		for (int r = 0; r < data.length; r++)
		{
			String rowBits = "";
			for (int c = 0; c < data[0].length; c++)
			{
				rowBits += data[r][c];
			}
			rowBits = reverse(rowBits);
			
			String hexRow = "";
			for (int makeHex = 0; makeHex < 32; makeHex += 4)
			{
				hexRow += 
					binaryFourBitsToHex(
							rowBits.substring(makeHex, //skip the 32'b
											makeHex+4)
							);
				
			}
			
				out += "'h" + hexRow;
				if (r != data.length-1)
					out += ",";
		}
		out += "},";
		out += "\r\n";
		
		
			
			
		
		createFile("alphabet.super",out);
	}
	
	public void loadFromFile(String fileName)
	{
		try
		{
		setFileName(fileName);
		Scanner scan = new Scanner(new File(fileName));
		scan.nextLine();
		for (int r = 0; r < PIXEL_ROWS; r++)
		{
		String entireLine = scan.nextLine();
		String bitLine = entireLine.substring(4);
		for (int c = 0; c < bitLine.length(); c++)
		{
			data[r][c] = Integer.parseInt(bitLine.substring(c,c+1));
		}
		
		}
			
			scan.close();
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		
	}
	
	int getBit(char f, int bit)//returns a, 1 or , a 0
	{
		char[] options = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
		boolean bit0=false,bit1=false,bit2=false,bit3=false;
		switch(f)
		{
		case('0'):
			bit0=false;
		bit1=false;
		bit2=false;
		bit3=false;
			break;
		case('1'):
			bit0=true;
		bit1=false;
		bit2=false;
		bit3=false;
			break;
		case('2'):bit0=false;
		bit1=true;
		bit2=false;
		bit3=false;
			break;
		case('3'):bit0=true;
		bit1=true;
		bit2=false;
		bit3=false;
			break;
		case('4'):bit0=false;
		bit1=false;
		bit2=true;
		bit3=false;
			break;
		case('5'):bit0=true;
		bit1=false;
		bit2=true;
		bit3=false;
			break;
		case('6'):bit0=false;
		bit1=true;
		bit2=true;
		bit3=false;
			break;
		case('7'):bit0=true;
		bit1=true;
		bit2=true;
		bit3=false;
			break;
		case('8'):bit0=false;
		bit1=false;
		bit2=false;
		bit3=true;
			break;
		case('9'):bit0=true;
		bit1=false;
		bit2=false;
		bit3=true;
			break;
		case('a'):bit0=false;
		bit1=true;
		bit2=false;
		bit3=true;
			break;
		case('b'):bit0=true;
		bit1=true;
		bit2=false;
		bit3=true;
			break;
		case('c'):bit0=false;
		bit1=false;
		bit2=true;
		bit3=true;
			break;
		case('d'):bit0=true;
		bit1=false;
		bit2=true;
		bit3=true;
			break;
		case('e'):bit0=false;
		bit1=true;
		bit2=true;
		bit3=true;
			break;
		case('f'):bit0=true;
		bit1=true;
		bit2=true;
		bit3=true;
			break;
		
		}
		
		switch(bit)
		{
		case 0:
			return getTrue(bit0);
case 1:
	return getTrue(bit1); 	
case 2:
	return getTrue(bit2);
case 3:
	return getTrue(bit3);
		}
		return -1;
		
	}
	
	public int getTrue(boolean f)
	{
		if (f) return 1;
		else
			return 0;
	}
	
	
	
	
	public void setFileName(String fileName)
	{
		this.fileName = fileName;
	}
	
	public String getFileName()
	{
		return fileName;
	}
	
	
	
}