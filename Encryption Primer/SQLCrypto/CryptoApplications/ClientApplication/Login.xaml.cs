using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Security;
using System.Runtime.InteropServices;

namespace ClientApplication
{
    /// <summary>
    /// Interaction logic for Password.xaml
    /// </summary>
    //[System.Reflection.Obfuscation(Exclude = true, StripAfterObfuscation = true, ApplyToMembers = true)]
    public partial class Login : Window
    {

        public string UserName { get { return tbUserName.Text; } }
        public string Password { get { return SecureStringToString(tbPassword.SecurePassword); } } 
 
        public Login()
        {
            InitializeComponent();
        }

        private void btnLogin_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = true;
            this.Close();
        }

        private void btnCancel_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            this.Close();
        }

        private string SecureStringToString(SecureString value)
        {
            IntPtr bstr = Marshal.SecureStringToBSTR(value);

            try
            {
                return Marshal.PtrToStringBSTR(bstr);
            }
            finally
            {
                Marshal.FreeBSTR(bstr);
            }
        }
    }
}
