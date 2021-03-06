using System;

namespace SonglistGenerator
{
    public class Logger
    {
        public void WriteLine(string message)
        {
            Console.WriteLine($"{DateTime.Now}: {message}");
        }
    }
}
