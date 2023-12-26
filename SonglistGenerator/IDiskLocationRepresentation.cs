namespace SonglistGenerator
{
    interface IDiskLocationRepresentation
    {
        /// <summary>
        /// Full path to file or folder on disk.
        /// </summary>
        string FilePath { get; }
    }
}
