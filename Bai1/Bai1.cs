using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bai1
{
	internal class Bai1
	{
		static void Main(string[] args)
		{
			Console.InputEncoding = Encoding.UTF8;
			Console.OutputEncoding = Encoding.UTF8;
			Console.Write("Nhập N:");
			int N;
			while(!int.TryParse(Console.ReadLine(), out N) && N>0)
			{
				Console.WriteLine("Nhập lại N:");
			}	

			int[] numbers = new int[N];
			//Nhập các phần tử của mảng
			for (int i = 0; i < N; i++)
			{
				Console.Write($"Nhập phần tử {i + 1}:");
				numbers[i] = int.Parse(Console.ReadLine());
			}
			//Nhập số cần kiểm tra
			Console.Write("Nhập số nguyên x:");
			int x = int.Parse(Console.ReadLine());
			//Kiểm tra x có trong mảng hay không
			bool tìm = false;
			for (int i = 0; i < N; i++)
			{
				if (numbers[i] == x)
				{
					tìm = true;
					break;
				}
			}
			if (tìm)
			{
				Console.WriteLine($"Số {x} có trong mảng");
			}
			else Console.WriteLine($"Số {x} không có trong mảng");	
		}
	}
}
