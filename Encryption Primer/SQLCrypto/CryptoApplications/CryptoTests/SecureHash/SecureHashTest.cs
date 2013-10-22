using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlTypes;
using Gallio.Framework;
using MbUnit.Framework;

using ManagedCrypto;

namespace CryptoTests.SecureHash
{
    [TestFixture]
    public class SecureHashTest
    {
        [Test]
        public void CreateInvalidHasher()
        {
            Assert.IsNull(UserDefinedFunctions.CreateHasher("undefined"));
        }

        [Test]
        public void CreateSHA256()
        {
            var hasher = UserDefinedFunctions.CreateHasher("SHA256");
            Assert.IsInstanceOfType(typeof(UserDefinedFunctions.MicrosoftSHA256), hasher);
        }

        [RowTest]
        [Row(null, null)]
        [Row("", "")]
        [Row("1234", "MQAyADMANAA=")]
        public void Validate_GetBytesFromString(string input, string result)
        {
            Assert.AreEqual(result, input.GetBytes().ToBase64());
        }

        [RowTest]
        [Row(null, null)]
        [Row("", null)]
        [Row("1234", "MTIzNA==")]
        public void Validate_ConvertToBase64String(string input, string result)
        {
            byte[] inputval = null;
            if (!String.IsNullOrEmpty(input))
            {
                inputval = Encoding.UTF8.GetBytes(input);
            }
            Assert.AreEqual(result, inputval.ToBase64());
        }

        [RowTest]
        [Row(null, null)]
        [Row("", "Dcmw4JAPDOcfNsNZy8+WjWNm8nYvVpmi9epf3Mtw8Mg=")]
        [Row("1234", "zPLYwZW6AAWwCvUEuAA/6D8tClLToUHOBrPI38/cQkc=")]
        public void TestMicrosoftSHA256(string input, string result)
        {
            var hasher = UserDefinedFunctions.CreateHasher("SHA256");
            var calc = hasher.ComputeHash(input.GetBytes()).ToBase64(); 
            Assert.AreEqual(result, calc);
        }

        [RowTest]
        [Row("56781234","JAAyAGEAJAAxADIAJABzAEYAWQAzADQAZgBzAE0ATABDAE8AZgA4AFMAdQAyAFkAMwA3AG0ANABlADQAcABpAHkASwBWAFUAVAB2AE8AZgB0AGkAQQBBAFcAdABTAGEAawAvAFYAZgA3AHoATwBqAGMASQB3AEcA")]
        public void TestBCrypt(string input, string result)
        {
            var hasher = UserDefinedFunctions.CreateHasher("BCRYPT");
            Assert.IsTrue(hasher.VerifyHash(input.GetBytes(), result.FromBase64()));
        }

        [RowTest]
        [Row("1234", "5678", "SHA256", "WoW9FkqVQR8swKa1KLl4RZywAoOz+kuvyoVGVvATDNU=")]
        [Row("1234", "5678", "SHA384", "9ZikAxcNUtvRD3ZspuhF9VIDHV+ZWHXqpwVvpm8to++uAIcYnGE786XQSSQx3q6I")]
        [Row("1234", "5678", "SHA512", "2T5ACkq7+KDbxesI3wVZPf9TvQ8fpUedUuFBjKF2bHyRm1FF3FZVy1bQ93PNJnNudYoKdiIJN1OZ0wVAQjCSDg==")]
        public void TestHash(string data, string salt, string hashType, string result)
        {
            var calc = UserDefinedFunctions.SecureHash(data, salt, hashType).Value.ToBase64();
            Assert.AreEqual(result,calc);
        }

        [RowTest]
        [Row("1234", "5678", "SHA256", "WoW9FkqVQR8swKa1KLl4RZywAoOz+kuvyoVGVvATDNU=")]
        [Row("1234", "5678", "SHA384", "9ZikAxcNUtvRD3ZspuhF9VIDHV+ZWHXqpwVvpm8to++uAIcYnGE786XQSSQx3q6I")]
        [Row("1234", "5678", "SHA512", "2T5ACkq7+KDbxesI3wVZPf9TvQ8fpUedUuFBjKF2bHyRm1FF3FZVy1bQ93PNJnNudYoKdiIJN1OZ0wVAQjCSDg==")]
        [Row("1234", "5678", "BCRYPT", "JAAyAGEAJAAxADIAJABzAEYAWQAzADQAZgBzAE0ATABDAE8AZgA4AFMAdQAyAFkAMwA3AG0ANABlADQAcABpAHkASwBWAFUAVAB2AE8AZgB0AGkAQQBBAFcAdABTAGEAawAvAFYAZgA3AHoATwBqAGMASQB3AEcA")]
        public void VerifyHash(string data, string salt, string hashType, string result)
        {
            Assert.IsTrue(UserDefinedFunctions.VerifyHash(data, salt, hashType, new SqlBytes(result.FromBase64())).Value);
        }

    }
}
