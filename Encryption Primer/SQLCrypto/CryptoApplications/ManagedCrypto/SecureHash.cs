using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Security.Cryptography;

using ManagedCrypto;

public partial class UserDefinedFunctions
{
    public static readonly int STRETCH = 1000;

    [Microsoft.SqlServer.Server.SqlFunction(IsDeterministic=true,DataAccess=DataAccessKind.None,Name="SecureHash")]
    public static SqlBytes SecureHash(SqlString value, SqlString salt, SqlString HashType)
    {
        SqlBytes retVal = null;
        IHash hasher = CreateHasher(HashType.ToString());
        if ( (null != hasher)) 
        {
            SqlString data = null;
            if (!value.IsNull)
            {
                if (!salt.IsNull)
                {
                    data = salt + value;
                }
                else
                {
                    data = value;
                }
            }
            if (!data.IsNull)
            {
                retVal = new SqlBytes(hasher.ComputeHash(data.GetUnicodeBytes()));
            }
        }
        return retVal;
    }

    [Microsoft.SqlServer.Server.SqlFunction(IsDeterministic = true, DataAccess = DataAccessKind.None, Name = "VerifyHash")]
    public static SqlBoolean VerifyHash(SqlString value, SqlString salt, SqlString HashType, SqlBytes hashValue)
    {
        SqlBoolean retVal = false;
        IHash hasher = CreateHasher(HashType.ToString());
        if ((null != hasher))
        {
            SqlString data = null;
            if (!value.IsNull)
            {
                if (!salt.IsNull)
                {
                    data = salt + value;
                }
                else
                {
                    data = value;
                }
            }
            if (!data.IsNull)
            {
                retVal = hasher.VerifyHash(data.GetUnicodeBytes(), hashValue.Buffer);
            }
        }
        return retVal;
    }

    public static IHash CreateHasher(string hashType)
    {
        IHash retVal = null;
        switch(hashType.ToUpper())
        {
            case "SHA256":
                retVal = new MicrosoftSHA256();
                break;
            case "SHA384" :
                retVal = new MicrosoftSHA384();
                break;
            case "SHA512":
                retVal = new MicrosoftSHA512();
                break;
            case "BCRYPT":
                retVal = new BC();
                break;
        }
        return retVal;
    }
    
    public interface IHash
    {
        byte[] ComputeHash(byte[]  data);
        bool VerifyHash(byte[] data, byte[] hash);
    }

    public class MicrosoftSHA256 : IHash
    {
        private SHA256Managed hasher = new SHA256Managed();

        public byte[] ComputeHash(byte[] data)
        {
            byte[] retVal = null;
            if (null != data)
            {
                // stretch the hash 
                for (int i = 0; i < STRETCH; i++)
                {
                    data = hasher.ComputeHash(data);
                }
                retVal = hasher.ComputeHash(data);
            }
            return retVal;
        }

        public bool VerifyHash(byte[] data, byte[] hashValue)
        {
            return ComputeHash(data).Compare(hashValue);
        }
    }

    public class MicrosoftSHA384 : IHash
    {
        private SHA384Managed hasher = new SHA384Managed();

        public byte[] ComputeHash(byte[] data)
        {
            byte[] retVal = null;
            if (null != data)
            {
                // stretch the hash 
                for (int i = 0; i < STRETCH; i++)
                {
                    data = hasher.ComputeHash(data);
                }
                retVal = hasher.ComputeHash(data);
            }
            return retVal;
        }

        public bool VerifyHash(byte[] data, byte[] hashValue)
        {
            return ComputeHash(data).Compare(hashValue);
        }
    }

    public class MicrosoftSHA512 : IHash
    {
        private SHA512Managed hasher = new SHA512Managed();

        public byte[] ComputeHash(byte[] data)
        {
            byte[] retVal = null;
            if (null != data)
            {
                // stretch the hash 
                for (int i = 0; i < STRETCH; i++)
                {
                    data = hasher.ComputeHash(data);
                }
                retVal = hasher.ComputeHash(data);
            }
            return retVal;
        }

        public bool VerifyHash(byte[] data, byte[] hashValue)
        {
            return ComputeHash(data).Compare(hashValue);
        }
    }

    public class BC : IHash
    {

        public byte[] ComputeHash(byte[] data)
        {
            byte[] retVal = null;
            if(null != data )
            {
                retVal = BCrypt.HashPassword(data.AsString(), BCrypt.GenerateSalt(12)).GetBytes();
            }
            return retVal;
        }

        public bool VerifyHash(byte[] data, byte[] hashValue)
        {
            return BCrypt.CheckPassword(data.AsString(),hashValue.AsString());
        }

    }

};

