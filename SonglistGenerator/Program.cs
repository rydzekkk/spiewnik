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

            var songRepositoryFolder = args[0];
            logger.WriteLine($"Program will generate list of songs from {songRepositoryFolder}");

            var outputPath = args[1];
            logger.WriteLine($"Zip file with full songbook including new main and master files would be saved at {outputPath}");

            var workingCopyOfSongRepository = Path.Combine(Path.GetDirectoryName(outputPath), "!workingSongRepo");
            logger.WriteLine($"Program will use copy located in {workingCopyOfSongRepository}");
            Utilities.CopyAll(new DirectoryInfo(songRepositoryFolder), new DirectoryInfo(workingCopyOfSongRepository));

            var folders = Directory.GetDirectories(workingCopyOfSongRepository);
            songlist.CreateListOfChapters(folders);
            songlist.CreateListOfSongs();
            songlist.Initialize();
            songlist.WrapCarets();
            songlist.CreateOutputFile(workingCopyOfSongRepository, outputPath);
        }
    }
}
