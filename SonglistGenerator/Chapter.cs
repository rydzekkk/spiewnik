using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace SonglistGenerator
{
    public class Chapter : IDiskLocationRepresentation
    {
        string masterFileContent;

        public Chapter(string folder)
        {
            this.Path = folder;            
        }

        public void Initialize()
        {            
            this.masterFileContent = File.ReadAllText(System.IO.Path.Combine(this.Path, Program.ChapterMasterFile));
            this.UseArtists = masterFileContent.Contains("\\Zespoltrue") && masterFileContent.Contains("\\Zespolfalse");
            this.FolderName = new DirectoryInfo(this.Path).Name;
            this.ChapterName = Regex.Match(masterFileContent, @"(?<=\\chapter{).*?(?=})").Value;
        }

        public string Path { get; private set; }

        /// <summary>
        /// Defines whether \Zespoltrue and \Zespolfalse sections are added to master.tex.
        /// </summary>
        public bool UseArtists { get; private set; }

        /// <summary>
        /// Name of subfolder which contains master.tex file.
        /// </summary>
        public string FolderName { get; private set; }

        /// <summary>
        /// Name of chapter read from master.tex file.
        /// </summary>
        public string ChapterName { get; private set; }

        public List<Song> Songs { get; } = new List<Song>();

        public string NewMasterFile()
        {
            var listOfSongs = new List<string>();
            listOfSongs.Add($"\\chapter{{{this.ChapterName}}}");

            if (this.UseArtists)
            {
                listOfSongs.Add("\\Zespoltrue");
            }

            var orderedSongs = Songs.OrderBy(x => x.Title);
            foreach (var song in orderedSongs)
            {
                listOfSongs.Add($"\\input{{{this.FolderName}/{System.IO.Path.GetFileName(song.Path)}}}");
            }

            if (this.UseArtists)
            {
                listOfSongs.Add("\\Zespolfalse");
            }

            return string.Join(Environment.NewLine, listOfSongs);
        }
    }
}
