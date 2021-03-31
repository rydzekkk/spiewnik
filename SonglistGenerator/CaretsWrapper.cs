using System.Collections.Generic;

namespace SonglistGenerator
{
    public static class CaretsWrapper
    {
        private const string startWrap = @"$\mathrm{";
        private const string endWrap = @"}$";

        public static string WrapCarets(string textToWrap)
        {
            var caretIndexes = new List<int>();
            for (int i = textToWrap.IndexOf('^'); i > -1; i = textToWrap.IndexOf('^', i + 1))
            {
                // for loop end when i=-1 ('a' not found)
                caretIndexes.Add(i);
            }

            caretIndexes.Reverse(); //to start replacing from the end

            foreach (var caret in caretIndexes)
            {
                if (textToWrap[caret + 1] == '{')
                {
                    var endOfBracedSection = textToWrap.IndexOf('}', caret);
                    textToWrap = textToWrap.Insert(endOfBracedSection + 1, endWrap);
                    textToWrap = textToWrap.Insert(caret - 1, startWrap);
                }
                else
                {
                    textToWrap = textToWrap.Insert(caret + 2, endWrap);
                    textToWrap = textToWrap.Insert(caret - 1, startWrap);
                }
            }

            return textToWrap;
        }
    }
}
