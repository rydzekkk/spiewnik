using System.Collections.Generic;

namespace SonglistGenerator
{
    /// <summary>
    /// Representation of each song_title.tex file
    /// </summary>
    class Song : IDiskLocationRepresentation
    {
        public Song(string file)
        {
            this.Path = file;
        }

        public string Path { get; private set; }

        /// <summary>
        /// Filename with, this string is used in master.tex file
        /// </summary>
        string FilePath { get; }

        /// <summary>
        /// Song title, first {} in \tytul section.
        /// </summary>
        string Title { get; }

        /// <summary>
        /// Song author (text, music), second {} in \tytul section.
        /// </summary>
        string Author { get; }

        /// <summary>
        /// Song artist, third {} in \tytul section.
        /// Additionally used in "Rozne" directory, to allow multiple artists in one category.
        /// Visible if "\Zespoltrue" set in chapter master.tex file, otherwise ignored.
        /// </summary>
        string Artist { get; }

        /// <summary>
        /// First line of song, to use in alphabetical table of content.
        /// </summary>
        string FirstLine { get; }

        /// <summary>
        /// First line of chorus, to use in alphabetical table of content.
        /// </summary>
        string FirstLineOfChorus { get; }

        List<string> Text { get; }

        List<string> Chords { get; }
    }
}
