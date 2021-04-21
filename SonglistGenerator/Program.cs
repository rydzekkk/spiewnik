using System.IO;

namespace SonglistGenerator
{
    class Program
    {
        const string latexFileExtension = ".tex";
        public const string ChapterMasterFile = "master" + latexFileExtension;
        public const string SongbookMainFile = "main" + latexFileExtension;
        public const string LatexFileFilter = "*" + latexFileExtension;

        static void Main(string[] args)
        {            
            var logger = new Logger();
            var songlist = new Songlist(logger);
            logger.WriteLine("Hello World!");

            if (args.Length != 2)
            {
                logger.WriteLine("Program should be executed with two arguments: " +
                    "input folder with song repository (containing subfolders with artists), " +
                    "and output folder where generated songbook would be saved.");
                return;
            }

            var songRepositoryFolder = args[0];
            logger.WriteLine($"Program will generate list of songs from {songRepositoryFolder}");

            var outputPath = args[1];
            logger.WriteLine($"Folder with full songbook (including new main and master files) would be saved at {outputPath}");

            Utilities.CopyAll(new DirectoryInfo(songRepositoryFolder), new DirectoryInfo(outputPath));

            var folders = Directory.GetDirectories(outputPath);
            songlist.CreateListOfChapters(folders);
            songlist.CreateListOfSongs();
            songlist.Initialize();
            songlist.WrapCarets();
            songlist.ReplaceMainMasters(outputPath);
        }
    }
}
