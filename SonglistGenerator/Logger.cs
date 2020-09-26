using System;

namespace SonglistGenerator
{
    class Logger
    {
        public void WriteLine(string message)
        {
            Console.WriteLine($"{DateTime.Now}: {message}");
        }
    }
}
