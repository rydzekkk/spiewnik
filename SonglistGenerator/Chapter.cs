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
            this.FilePath = folder;            
        }

        public void Initialize()
        {            
            this.masterFileContent = File.ReadAllText(Path.Combine(this.FilePath, Program.ChapterMasterFile));
            this.UseArtists = masterFileContent.Contains("\\Zespoltrue") && masterFileContent.Contains("\\Zespolfalse");
            this.FolderName = new DirectoryInfo(this.FilePath).Name;
            this.ChapterName = Regex.Match(masterFileContent, @"(?<=\\chapter{).*?(?=})").Value;
        }

        public string FilePath { get; private set; }

        /// <summary>
        /// Defines whether \Zespoltrue and \Zespolfalse sections are added to master.tex.
        /// </summary>
        public bool UseArtists { get; set; }

        /// <summary>
        /// Name of subfolder which contains master.tex file.
        /// </summary>
        public string FolderName { get; set; }

        /// <summary>
        /// Name of chapter read from master.tex file.
        /// </summary>
        public string ChapterName { get; set; }

        public List<Song> Songs { get; } = new List<Song>();

        public string NewMasterFile()
        {
            var fileContent = new List<string>();
            fileContent.Add($"\\chapter{{{this.ChapterName}}}");

            if (this.UseArtists)
            {
                fileContent.Add("\\Zespoltrue");
            }

            var orderedSongs = Songs.OrderBy(x => x.Title, StringComparerProvider.PolishComparer);
            foreach (var song in orderedSongs)
            {
                fileContent.Add($"\\input{{{song.ContainingFolder}/{song.FileName}}}");
            }

            if (this.UseArtists)
            {
                fileContent.Add("\\Zespolfalse");
            }

            return string.Join(Environment.NewLine, fileContent);
        }

        public override string ToString()
        {
            return $"{this.ChapterName} ({this.Songs.Count} songs)";
        }
    }
}
