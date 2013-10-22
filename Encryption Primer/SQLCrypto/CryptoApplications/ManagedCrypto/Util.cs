using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ManagedCrypto
{
    public static class Extensions
    {

        public static byte[] GetBytes(this string value)
        {
            byte[] retval = null;
            if (null != value)
            {
                try
                {
                    retval = Encoding.Unicode.GetBytes(value);
                }
                catch (Exception)
                {
                    retval = null;
                }
            }
            return retval;
        }

        public static string ToBase64(this byte[] value)
        {
            string retval = null;
            if (null != value)
            {
                try
                {
                    retval = Convert.ToBase64String(value);
                }
                catch (Exception)
                {
                    retval = null;
                }
            }
            return retval;
        }

        public static byte[] FromBase64(this string value)
        {
            byte[] retval = null;
            if (null != value)
            {
                try
                {
                    retval = Convert.FromBase64String(value);
                }
                catch (Exception)
                {
                    retval = null;
                }
            }
            return retval;
        }

        public static string AsString(this byte[] value)
        {
            string retval = null;
            if (null != value)
            {
                try
                {
                    retval = Encoding.Unicode.GetString(value, 0, value.Length);
                }
                catch (Exception)
                {
                    retval = null;
                }
            }
            return retval;
        }

        public static bool Compare(this byte[] one, byte[] two)
        {
            bool retval = false;
            if ((null != one) && (null != two) && (one.Length == two.Length))
            {
                retval = true;
                for (int i = 0; i < one.Length; i++)
                {
                    if (one[i] != two[i])
                    {
                        retval = false;
                        break;
                    }
                }
            }
            return retval;
        }

    }
}
