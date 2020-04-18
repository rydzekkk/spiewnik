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

        public string Path { get; private set; }

        /// <summary>
        /// Defines whether \Zespoltrue and \Zespolfalse sections are added to master.tex.
        /// </summary>
        public bool UseArtists { get; }

        public string FolderName { get; }

        public string ChapterName { get; }

        public List<Song> Songs { get; } = new List<Song>();
    }
}
