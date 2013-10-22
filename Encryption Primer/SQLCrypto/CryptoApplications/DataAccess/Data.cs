using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Data.SqlClient;

namespace DataAccess
{
    public class Data
    {
        private static string connectionString = null;

        private static pubsDataContext ctx = null;

        public static pubsDataContext Context { get { return ctx; } }

        public Data()
        {}

        public Data(string conn)
        {
            Connect(conn);
        }

        public static bool Connect(string userName, string password)
        {
            bool retVal = false;
            try
            {
                SqlConnectionStringBuilder builder =
                    new SqlConnectionStringBuilder(ConfigurationManager.ConnectionStrings["pubs"].ConnectionString);
                builder.Password = password;
                builder.UserID = userName;
                retVal = Connect(builder.ToString());
            }
            catch (Exception ex)
            { }
            return retVal;
        }

        public static bool Connect(string conn)
        {
            bool retVal = false;
            try
            {
                connectionString = conn;
                ctx = new DataAccess.pubsDataContext(connectionString);
                retVal = true;
            }
            catch (Exception ex)
            { }
            return retVal;

        }

        public Author GetAuthor(string authorId)
        {
            var retval = new Author();
            var auth = ctx.GetAuthor(authorId).ToList().First();
            if (null != auth )
            {
                retval.FirstName = auth.au_fname;
                retval.LastName = auth.au_lname;
                retval.BatPhone = auth.bat_phone;
                retval.SSN = auth.ssn;
            }
            return retval;
        }

        public List<Draft> Drafts(string authorId)
        {
            return ctx.ListDrafts(authorId).Select(d => new Draft { ID = d.draft_id, Title = d.title }).ToList();
        }

    }
}
