using System.IO;
using System.IO.Compression;

namespace SonglistGenerator
{
    class OutputFileCreator
    {
        private string songRepositoryFolder;

        public OutputFileCreator(string songRepositoryFolder)
        {
            this.songRepositoryFolder = songRepositoryFolder;
        }

        public void ReplaceMainFile(string content)
        {
            File.WriteAllText(Path.Combine(songRepositoryFolder, Program.SongbookMainFile), content);
        }

        public void ReplaceMasterFile(string folderName, string content)
        {
            File.WriteAllText(Path.Combine(this.songRepositoryFolder, folderName, Program.ChapterMasterFile), content);
        }

        public void SaveZipArchive(string outputPath)
        {
            ZipFile.CreateFromDirectory(songRepositoryFolder, outputPath);
        }
    }
}
