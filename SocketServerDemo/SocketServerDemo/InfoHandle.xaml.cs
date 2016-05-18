using Newtonsoft.Json;
using SocketServerDemo.Common;
using SocketServerDemo.Model;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace SocketServerDemo
{
    /// <summary>
    /// InfoHandle.xaml 的交互逻辑
    /// </summary>
    public partial class InfoHandle : Window
    {
        public static Thread threadCmd = null;
        public static Thread threadDisk = null;
        public static Thread threadFile = null;
        public static Thread threadSignal = null;
        public static Msg m=new Msg();
        public InfoHandle()
        {
            InitializeComponent();

            m.rcvMsg = "待接收";
            m.sndMsg = "待接收";
           // sendtext.DataContext = m;
            //receivetext.DataContext = m;

            threadCmd = new Thread(new ParameterizedThreadStart(ReceiveCmd));
            threadDisk = new Thread(new ParameterizedThreadStart(App.ReceiveDiskSocket));
            threadFile = new Thread(new ParameterizedThreadStart(App.ReceiveFileSocket));
            threadSignal = new Thread(new ParameterizedThreadStart(App.ReceiveSignalSocket));
            if(App.serverSocketCmd!=null)
                threadCmd.Start(App.serverSocketCmd);
            if (App.serverSocketDisk != null)
                threadDisk.Start(App.serverSocketDisk);
            if (App.serverSocketFile != null)
                threadFile.Start(App.serverSocketFile);
            if (App.serverSocketSignal != null)
                threadSignal.Start(App.serverSocketSignal);
        }
       
        public static void ReceiveCmd(object obj)
        {
        
            Socket s = obj as Socket;
            byte[] buffer = null;
            while (true)
            {
                try
                {
                    buffer = new byte[1024];
                    s.Receive(buffer);
                }
                catch (ArgumentNullException )
                {
                    //MessageBox.Show("发送的东西为空");
                    // s.Dispose();
                    //InfoHandle.threadDisk.Abort();
                    return;
                }
                catch (SocketException )
                {
                    //MessageBox.Show("访问套接字失败");
                    return;
                }
                catch (ObjectDisposedException )
                {
                    Debug.WriteLine("连接已断开");
                    //MessageBox.Show("连接已断开");
                    //DisConnect();
                    //Cmd.OnStartUp();
                    return;
                }
                string info = Encoding.UTF8.GetString(buffer);
                info = Msg.HandleRcvMsg(info);
                //考虑是否有#
                if (info.Contains("#"))
                {
                    string[] sendinfo1 = Regex.Split(info, "#");
                    string[] sendinfo = Regex.Split(sendinfo1[1], "}");
                    sendinfo[0] = sendinfo[0]+"}";
                    m.rcvMsg = sendinfo[0];
                    HandleModel handle = JsonConvert.DeserializeObject<HandleModel>(sendinfo[0]);
                    Cmd.Command(handle);
                }
            
            }
        }


        public   void Button_Click(object sender, RoutedEventArgs e)
        {
           
            if (btn.Content.ToString() == "断开连接")
            {
                btn.Content = "服务器启动";
                DisConnectServer();
            }
            if (btn.Content.ToString() == "服务器启动")
            {
                Dispatcher.Invoke((Action)(() =>
                {
                    MainWindow mainwindow = new MainWindow();
                    mainwindow.Show();
                    this.Close();
                }));
            
            }      
        }
        public static void DisConnect()
        {


            if (App.serverSocketCmd != null)
            {
                App.serverSocketCmd.Dispose();
                App.serverSocketDisk.Dispose();
                App.serverSocketFile.Dispose();
                App.serverSocketSignal.Dispose();
            }
            if (MainWindow.serverSocketCmd != null)
            {
                MainWindow.serverSocketCmd.Dispose();
                MainWindow.serverSocketDisk.Dispose();
                MainWindow.serverSocketFile.Dispose();
                MainWindow.serverSocketSignal.Dispose();
            }
         


            /*threadCmd.Abort();
            threadDisk.Abort();
            threadFile.Abort();
            threadSignal.Abort();*/
  
        }
        public static void DisConnectClient()
        {
            DisConnect();
        }
        public static void DisConnectServer()
        {
            DisConnect();
            MainWindow.serverSocketCmd = null;
            MainWindow.serverSocketDisk = null;
            MainWindow.serverSocketFile = null;
            MainWindow.serverSocketSignal = null;
          

        }

    }
}
