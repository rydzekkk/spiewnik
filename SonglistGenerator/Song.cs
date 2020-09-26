using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace SonglistGenerator
{
    /// <summary>
    /// Representation of each song_title.tex file
    /// </summary>
    class Song : IDiskLocationRepresentation
    {
        string[] songFileContent;

        public Song(string filePath)
        {
            this.Path = filePath;
        }

        public void Initialize()
        {
            this.songFileContent = File.ReadAllLines(this.Path);

            var titleLine = this.songFileContent.Single(x => x.StartsWith("\\tytul"));

            if (titleLine.Count(x => (x =='{')) != 3)
            {
                // Title section is split into separate lines
                var mergedContent = string.Join("", this.songFileContent);
                var from = mergedContent.IndexOf("\\tytul") + "\\tytul".Length;
                var to = mergedContent.IndexOf("\\begin");
                titleLine = mergedContent[from..to];
            }

            var splitTitleLine = Regex.Matches(titleLine, "\\{(.*?)\\}");

            this.Title = splitTitleLine[0].Value;
            this.Author = splitTitleLine[1].Value;
            this.Artist = splitTitleLine[2].Value;
        }

        public string Path { get; private set; }

        /// <summary>
        /// Song title, first {} in \tytul section.
        /// </summary>
        public string Title { get; private set; }

        /// <summary>
        /// Song author (text, music), second {} in \tytul section.
        /// </summary>
        public string Author { get; private set; }

        /// <summary>
        /// Song artist, third {} in \tytul section.
        /// Additionally used in "Rozne" directory, to allow multiple artists in one category.
        /// Visible if "\Zespoltrue" set in chapter master.tex file, otherwise ignored.
        /// </summary>
        public string Artist { get; private set; }

        /// <summary>
        /// First line of song, to use in alphabetical table of content.
        /// </summary>
        //string FirstLine { get; }

        /// <summary>
        /// First line of chorus, to use in alphabetical table of content.
        /// </summary>
        //string FirstLineOfChorus { get; }

        //List<string> Text { get; }

        //List<string> Chords { get; }
    }
}
