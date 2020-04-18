using System.Collections.Generic;
using System.IO;

namespace SonglistGenerator
{
    class Chapter : IDiskLocationRepresentation
    {
        public Chapter(string folder)
        {
            this.Path = folder;
            this.FolderName = new DirectoryInfo(folder).Name;
        }

        /// <summary>
        /// Path to folder, which constains all songs and master.tex file.
        /// </summary>
        public string Path { get; set ; }

        /// <summary>
        /// Defines whether \Zespoltrue and \Zespolfalse sections are added to master.tex.
        /// </summary>
        public bool UseArtists { get; }

        public string FolderName { get; }

        public string ChapterName { get; }

        public List<Song> Songs { get; }
    }
}
