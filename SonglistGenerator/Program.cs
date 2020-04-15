using System.IO;

namespace SonglistGenerator
{
    class Program
    {
        const string latexFileExtension = "*.tex";
        const string chapterMasterFile = "master.tex";
        const string songbookMainFile = "main.tex";
        
        static void Main(string[] args)
        {
            var logger = new Logger();
            logger.WriteLine("Hello World!");

            var inputPath = args[0];
            var listOfFolders = Directory.GetDirectories(inputPath);
            foreach (var folder in listOfFolders)
            {
                if (!File.Exists(Path.Combine(folder, chapterMasterFile)))
                {
                    logger.WriteLine($"Folder {folder} does not cotain {chapterMasterFile}, ignoring.");
                    continue;
                }

                var listOfLatexFilesInsideFolder = Directory.GetFiles(folder, latexFileExtension);
            }
        }
    }
}
