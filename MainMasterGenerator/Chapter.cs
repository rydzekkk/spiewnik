using System.Collections.Generic;

namespace SonglistGenerator
{
    class Chapter
    {
        /// <summary>
        /// Defines whether \Zespoltrue and \Zespolfalse sections are added to master.tex
        /// </summary>
        bool UseArtists { get; }

        string FolderName { get; }

        string ChapterName { get; }

        List<Song> Songs { get; }
    }
}
