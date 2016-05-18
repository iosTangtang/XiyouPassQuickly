using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SocketServerDemo.Common
{
    public class Msg : INotifyPropertyChanged
    {
        public  event PropertyChangedEventHandler PropertyChanged;
        private   string sndmsg;
        public   string sndMsg
        {
            get
            {
                return sndmsg;
            }
            set
            {
                
                if (sndmsg  != value)
                {
                    sndmsg  = value;
                    NotifyPropertyChanged("sndMsg");
                }
            }
        }
        private   string rcvmsg;
        public   string rcvMsg
        {
            get
            {
                return rcvmsg;
            }
            set
            {
               
                if (rcvmsg!=value)
                {
                    rcvmsg = value;
                    NotifyPropertyChanged("rcvMsg");
                }
            }
        }
        private void NotifyPropertyChanged(String info)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(info));
            }
        }

        public  static string HandleRcvMsg( string info)
        {
            for (int i = 0; i < info.Length; i++)
            {
                if (info[i] == '\0')
                {

                    info = info.Remove(i, info.Length - i);
                    break;
                }
            }
            return info;
        }
    }
}
