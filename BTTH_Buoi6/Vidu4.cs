using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BTTH_Buoi6
{
	internal class Vidu4
	{
		static void Main(string[] args)
		{
			Console.InputEncoding = Encoding.UTF8;
			Console.OutputEncoding = Encoding.UTF8;
			Console.WriteLine("Nhập số N:");
			int N = int.Parse(Console.ReadLine());

			if (N <= 0)
			{
				Console.WriteLine("N phải lớn hơn 0");
				return;
			}

			int[] numbers = new int[N];
			for (int i = 0; i < N; i++)
			{
				Console.WriteLine($"Nhập số thứ {i+1}:");
				numbers[i] = int.Parse(Console.ReadLine());
			}
			int max = numbers[0];
			for (int i = 1; i < N; i++)
			{
				if (numbers[i] > max)
				{
					max = numbers[i];
				}
			}
            Console.WriteLine($"Số lớn nhất là {max}");	
			} 		
		}
	}

