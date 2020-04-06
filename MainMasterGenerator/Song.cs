using System.Collections.Generic;

namespace SonglistGenerator
{
    /// <summary>
    /// Representation of each song_title.tex file
    /// </summary>
    class Song
    {
        /// <summary>
        /// Filename with subfolder if exists, this string is used in master.tex file
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

        List<string> Text { get; }

        List<string> Chords { get; }
    }
}
