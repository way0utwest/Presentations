using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace ClientApplication
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {

        public MainWindow()
        {
            InitializeComponent();
            var login = new Login();
            login.ShowDialog();
            if ((bool) login.DialogResult)
            {
                if(DataAccess.Data.Connect(login.UserName, login.Password))
                {
                    var authors = DataAccess.Data.Context.ListAuthors();
                    grdAuthorDetail.ItemsSource = authors.ToList();            
                }
                else
                {
                    MessageBox.Show("Unable to connect to database");
                    this.Close();
                }
            }
        }

        private void btnSearch_Click(object sender, RoutedEventArgs e)
        {
            if (null != DataAccess.Data.Context)
            {
                var results = DataAccess.Data.Context.SearchForAuthor(txtSearch.Text);
                var msg = "Found {0} results: ";
                var cnt = 0;
                foreach (var res in results)
                {
                    cnt++;
                    msg += "\n" + res.au_fname + " " + res.au_lname;
                }
                MessageBox.Show(String.Format(msg, cnt));
            }
        }
    }
}
