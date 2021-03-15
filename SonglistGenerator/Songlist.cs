using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace SonglistGenerator
{
    public class Songlist
    {
        private List<Chapter> chapters = new List<Chapter>();
        private Logger logger;

        public IEnumerable<Chapter> OrderedChapters => this.chapters.OrderBy(x => x.ChapterName);

        public Songlist(Logger logger)
        {
            this.logger = logger;
        }

        public void CreateListOfChapters(string[] folders)
        {
            foreach (var folder in folders)
            {
                if (!File.Exists(Path.Combine(folder, Program.ChapterMasterFile)))
                {
                    logger.WriteLine($"Folder {folder} does not cotain {Program.ChapterMasterFile}, ignoring");
                    continue;
                }

                var chapter = new Chapter(folder);
                chapters.Add(chapter);
            }

            logger.WriteLine($"Found {chapters.Count} chapters.");
        }

        public void CreateListOfSongs()
        {
            foreach (var chapter in chapters)
            {
                var latexFilesInsideChapter = Directory.GetFiles(chapter.Path, Program.LatexFileFilter);

                foreach (var latexFilePath in latexFilesInsideChapter)
                {
                    if (Path.GetFileName(latexFilePath) == Program.ChapterMasterFile)
                    {
                        // Ignore chapter master file
                        continue;
                    }

                    var song = new Song(latexFilePath, chapter.FolderName);
                    chapter.Songs.Add(song);
                }

                logger.WriteLine($"Found {chapter.Songs.Count} songs in chapter {chapter.FolderName} (path: {chapter.Path})");
            }
        }

        public void Initialize()
        {
            foreach (var chapter in chapters)
            {
                chapter.Initialize();
                logger.WriteLine($"   Chapter \"{chapter.ChapterName}\" is located in folder \"{chapter.FolderName}\", UseArtists: {chapter.UseArtists}, contains {chapter.Songs.Count} songs");
                foreach (var song in chapter.Songs)
                {
                    song.Initialize();
                    logger.WriteLine($"      Song \"{song.Title}\", author \"{song.Author}\", artist \"{song.Artist}\"");
                }
            }
        }

        public string NewMainFile()
        {
            var listOfChapters = new List<string>();
            foreach (var chapter in this.OrderedChapters)
            {
                listOfChapters.Add($"\\include{{{chapter.FolderName}/master}}");
            }

            return string.Join(Environment.NewLine, listOfChapters);
        }

        public void CreateOutputFile(string songRepositoryFolder, string outputPath)
        {
            var fileCreator = new OutputFileCreator(songRepositoryFolder);
            fileCreator.ReplaceMainFile(this.NewMainFile());
            foreach (var chapter in this.chapters)
            {
                fileCreator.ReplaceMasterFile(chapter.FolderName, chapter.NewMasterFile());
            }

            fileCreator.SaveZipArchive(outputPath);
        }

        public void ConsolidateChapters()
        {
            var newChaptersList = new List<Chapter>();
            newChaptersList.AddRange(this.chapters.Where(x => x.Songs.Count > 1));
            var othersChapter = new Chapter(null)
            {
                ChapterName = "Pozostałe",
                UseArtists = true,
            };
        }
    }
}
