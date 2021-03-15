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

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.dataGrid.ItemsSource = null;
            var folders = Directory.GetDirectories(folderPath.Text);
            songlist.CreateListOfChapters(folders);
            songlist.CreateListOfSongs();
            songlist.Initialize();

            foreach (var chapter in songlist.OrderedChapters)
            {
                foreach (var song in chapter.Songs)
                {
                    this.displayedSongs.Add(new DisplaySong(song, chapter.ChapterName));
                }
            }

            this.dataGrid.ItemsSource = this.displayedSongs;
        }
    }
}
