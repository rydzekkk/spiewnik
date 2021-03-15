using SonglistGenerator;
using System.Collections.Generic;
using System.IO;
using System.Windows;

namespace SongChooser
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private Logger logger;
        private Songlist songlist;
        private List<DisplaySong> displayedSongs;

        public MainWindow()
        {
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            this.logger = new Logger();
            this.songlist = new Songlist(logger);
            this.displayedSongs = new List<DisplaySong>();
        }

        private void LoadFolder(object sender, RoutedEventArgs e)
        {
            this.displayedSongs = new List<DisplaySong>();
            var folders = Directory.GetDirectories(folderPath.Text);
            songlist.CreateListOfChapters(folders);
            songlist.CreateListOfSongs();
            songlist.Initialize();

            foreach (var chapter in songlist.Chapters)
            {
                foreach (var song in chapter.Songs)
                {
                    this.displayedSongs.Add(new DisplaySong(song, chapter.ChapterName));
                }
            }

            this.dataGrid.ItemsSource = this.displayedSongs;
        }

        private void LoadSettings(object sender, RoutedEventArgs e)
        {

        }

        private void SaveSettings(object sender, RoutedEventArgs e)
        {

        }

        private void GenerateSongbook(object sender, RoutedEventArgs e)
        {
            foreach (var chapter in songlist.Chapters)
            {
                chapter.Songs.RemoveAll(x => this.displayedSongs.Exists(y => !y.Print && y.Path == x.FilePath));
            }
            songlist.ConsolidateChapters();
            songlist.CreateOutputFile(folderPath.Text, Path.Combine(folderPath.Text, "output.zip"));
        }
    }
}
