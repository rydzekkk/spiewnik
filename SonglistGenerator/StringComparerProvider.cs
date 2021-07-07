using System;
using System.Globalization;

namespace SonglistGenerator
{
    static class StringComparerProvider
    {
        public static StringComparer PolishComparer = StringComparer.Create(new CultureInfo("pl-PL"), true);
    }
}
