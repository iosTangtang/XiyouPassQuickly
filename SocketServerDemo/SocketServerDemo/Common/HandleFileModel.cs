using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SocketServerDemo.Common
{
    public class HandleFileModel :HandleModel
    {
        public long Size { get; set; }

        public string Name { get; set; }

        public static long IsFileExists(string path)
        {

            if (File.Exists(path) == true)
            {
                FileStream fstream = new FileStream(path, FileMode.Open);
                return fstream.Length;
            }
            else
                return 0;
        }
    }
}
