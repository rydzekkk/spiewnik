using System.Collections.Generic;
using System.IO;

namespace SonglistGenerator
{
    class Program
    {
        const string latexFileExtension = ".tex";
        const string chapterMasterFile = "master" + latexFileExtension;
        const string songbookMainFile = "main" + latexFileExtension;
        
        static void Main(string[] args)
        {            
            var logger = new Logger();
            logger.WriteLine("Hello World!");

            var songRepositoryFolder = args[0];
            logger.WriteLine($"Program will generate list of songs from {songRepositoryFolder}");

            var chapters = new List<Chapter>();       
            var folders = Directory.GetDirectories(songRepositoryFolder);
            foreach (var folder in folders)
            {
                if (!File.Exists(Path.Combine(folder, chapterMasterFile)))
                {
                    logger.WriteLine($"Folder {folder} does not cotain {chapterMasterFile}, ignoring");
                    continue;
                }

                var chapter = new Chapter(folder);
                chapters.Add(chapter);
                logger.WriteLine($"Created new chapter from folder {chapter.FolderName}");
            }
            logger.WriteLine($"Found {chapters.Count} chapters.");


            /*
            var songs = new List<Song>();
            var latexFilesInsideFolder = Directory.GetFiles(folder, "*" + latexFileExtension);
            foreach (var latexFile in latexFilesInsideFolder)
            {

                if (Path.GetFileName(latexFile) == chapterMasterFile)
                {
                    // Ignore chapter master file
                    continue;
                }

                // handle normal song file
            }
            */
        }
    }
}
