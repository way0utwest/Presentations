using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DataAccess
{
    public class Draft
    {
        public int ID { get; set; }

        public string EncryptionKey { get; set; }

        public string Title { get; set; }

        public string Data { get; set; }

    }
}
