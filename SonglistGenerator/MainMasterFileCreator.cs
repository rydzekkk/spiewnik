using System.IO;
using System.IO.Compression;

namespace SonglistGenerator
{
    class MainMasterFileCreator
    {
        private string temporaryFolder;

        public MainMasterFileCreator()
        {
            temporaryFolder = Path.Combine(Path.GetTempPath(), "SonglistGeneratorTemporaryFolder");
            Directory.CreateDirectory(temporaryFolder);
        }

        public void AddMainFile(string content)
        {
            File.WriteAllText(Path.Combine(temporaryFolder, Program.SongbookMainFile), content);
        }

        public void AddMasterFile(string folderName, string content)
        {
            Directory.CreateDirectory(Path.Combine(this.temporaryFolder, folderName));
            File.WriteAllText(Path.Combine(this.temporaryFolder, folderName, Program.ChapterMasterFile), content);
        }

        public void SaveZipArchive(string outputPath)
        {
            ZipFile.CreateFromDirectory(temporaryFolder, outputPath);
            Directory.Delete(this.temporaryFolder, true);
        }
    }
}
