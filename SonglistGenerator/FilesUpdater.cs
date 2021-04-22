using System.IO;

namespace SonglistGenerator
{
    class FilesUpdater
    {
        private string songRepositoryFolder;

        public FilesUpdater(string songRepositoryFolder)
        {
            this.songRepositoryFolder = songRepositoryFolder;
        }

        public void ReplaceMainFile(string content)
        {
            File.WriteAllText(Path.Combine(this.songRepositoryFolder, Program.SongbookMainFile), content);
        }

        public void ReplaceMasterFile(string folderName, string content)
        {
            File.WriteAllText(Path.Combine(this.songRepositoryFolder, folderName, Program.ChapterMasterFile), content);
        }
    }
}
