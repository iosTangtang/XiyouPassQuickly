using SocketServerDemo.Common;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Newtonsoft.Json;

using SocketServerDemo.Model;
using System.Windows.Threading;
using System.Windows;
using System.IO;
using System.Net.Mail;
using System.Net;
using System.Windows.Forms;
using System.Drawing;
using System.Windows.Media;
using System.Drawing.Imaging;

namespace SocketServerDemo.Model
{
    public class Cmd
    {
        public static Stream stream;

        [DllImport("User32.dll")]
        private static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);  //导入模拟键盘的方法

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        private static extern System.IntPtr GetForegroundWindow();
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        private static extern int SetWindowPos(IntPtr hWnd, int hWndInsertAfter, int x, int y, int Width, int Height, int flags);
        public void Close_Cmd()
        {
            //Alt+F4
            keybd_event(18, 0, 0, 0);
            keybd_event(115, 0, 0, 0);
            keybd_event(115, 0, 2, 0);
            keybd_event(18, 0, 2, 0);
        }
        public static void Command(HandleModel handle)
        {
            if (handle.Typ == "Cmd")
            {
                //dicCmd命令
                foreach (KeyValuePair<string, string> s in App.dicCmd)
                {
                    if (s.Key.Equals(handle.Msg))
                    {
                        if (handle.Msg.Equals("DisConnect"))
                        {
                            InfoHandle.DisConnectClient();
                            OnStartUp();
                        }
                        else if (handle.Msg.Equals("Win_Desktop"))
                        {
                            string t = "C:\\Users\\" + Environment.UserName + "\\Desktop";
                            Process.Start(@t);
                        }
                        else if (handle.Msg.Contains("Win_Volume"))
                        {
                            System.Diagnostics.Process.Start(@"C:\\WINDOWS\\system32\\sndvol.exe");
                            if (handle.Msg.Equals("Win_VolumeUp"))
                            {

                                System.Diagnostics.Process.Start(@"C:\\WINDOWS\\system32\\sndvol.exe");

                                Thread.Sleep(500);
                                //SetWindowPos(GetForegroundWindow(), -1, 0, 0, 0, 0, 1 | 2);
                                //SendMessage(HWND_BROADCAST,)
                                keybd_event(38, 0, 0, 0);
                                keybd_event(38, 0, 0x2, 0);

                                //Alt+F4
                                //keybd_event(18, 0, 0, 0);
                                //keybd_event(115, 0, 0, 0);
                                //keybd_event(115, 0, 2, 0);
                                //keybd_event(18, 0, 2, 0);

                            }
                            else if (handle.Msg.Equals("Win_VolumeDown"))
                            {

                                System.Diagnostics.Process.Start(@"C:\\WINDOWS\\system32\\sndvol.exe");
                                // SetWindowPos(GetForegroundWindow(), -1, 0, 0, 0, 0, 1 | 2);
                                //SendMessage(HWND_BROADCAST,)
                                Thread.Sleep(500);
                                keybd_event(40, 0, 0, 0);
                                keybd_event(40, 0, 0x2, 0);
                                //Alt+F4
                                //keybd_event(18, 0, 0, 0);
                                //keybd_event(115, 0, 0, 0);
                                //keybd_event(115, 0, 2, 0);
                                //keybd_event(18, 0, 2, 0);
                            }

                        }
                        //请求截屏
                        else if (handle.Msg.Equals("Win_Screenshot"))
                        {

                            Screen scr = Screen.PrimaryScreen;
                            int iWidth = scr.Bounds.Width;
                            int iHeight = scr.Bounds.Height;
                            System.Drawing.Image myImage = new Bitmap(iWidth, iHeight);
                            Graphics g = Graphics.FromImage(myImage);
                            g.CopyFromScreen(new System.Drawing.Point(0, 0), new System.Drawing.Point(0, 0), new System.Drawing.Size(iWidth, iHeight));

                            //保存文件流到stream
                            stream = new MemoryStream();
                            myImage.Save(stream, ImageFormat.Png);

                            byte[] filebuffer = new byte[stream.Length];
                            stream.Seek(0, SeekOrigin.Begin);
                            stream.Read(filebuffer, 0, filebuffer.Length);
                            // 设置当前流的位置为流的开始
                          
                                             
                            //ImageSourceConverter imageSourceConverter = new ImageSourceConverter();
                            //imgscreen.Source = (ImageSource)imageSourceConverter.ConvertFrom(stream);

                            //向客户端发送截图的文件
                            App.SendScreen(filebuffer,App.serverSocketCmd);
                            //系统截屏
                            /*
                            keybd_event(0x2C, 0, 0, 0);
                            keybd_event(0x2C, 0, 0x2, 0);
                            System.Diagnostics.Process.Start(@"C:\\WINDOWS\\system32\\mspaint.exe");//打开文件和文件夹
                            Thread.Sleep(1000);
                            keybd_event(17, 0, 0, 0);
                            keybd_event(86, 0, 0, 0);
                            keybd_event(86, 0, 0x2, 0);
                            keybd_event(17, 0, 0x2, 0);*/

                        }
                        else if (handle.Msg.Equals("Close"))
                        {
                            //Alt+F4
                            keybd_event(18, 0, 0, 0);
                            keybd_event(115, 0, 0, 0);
                            keybd_event(115, 0, 2, 0);
                            keybd_event(18, 0, 2, 0);
                        }
                        else
                        {
                            string[] com = s.Value.Split(new string[] { " " }, StringSplitOptions.RemoveEmptyEntries);
                            if (com.Length == 1)
                            {
                                Process.Start(@s.Value);
                            }
                            else
                            {
                                Process.Start("shutdown.exe", s.Value);
                            }
                        }
                    }
                }
            }
            else if (handle.Typ == "Office")
            {
                //dicOffice命令
                foreach (KeyValuePair<string, string> s in App.dicOffice)
                {
                    if (s.Key.Equals(handle.Msg))
                    {
                        if (s.Value == "DownPPt")
                        {
                            PPT.Down();
                        }
                        else if (s.Value == "UpPPt")
                        {
                            PPT.Up();
                        }
                        else if (s.Value == "FirstPPt")
                        {
                            PPT.First();
                        }
                        else if (s.Value == "LastPPt")
                        {
                            PPT.Last();
                        }
                        else if (s.Value == "Close")
                        {
                            PPT.Close();
                        }
                        else if (s.Value == "Play_powerpnt")
                        {
                            PPT.Play();
                        }
                        else
                        {
                            PPT.Open(s.Value);
                        }
                    }
                }
            }
            else  if(handle.Typ=="Web")
            { 
                //dicWeb命令
                foreach (KeyValuePair<string, string> s in App.dicWeb)
                {
                    if (s.Key.Equals(handle.Msg))
                    {
                        System.Diagnostics.Process.Start(s.Value);
                    }
                }
            }
            else if (handle.Typ == "Search")
            {
                System.Diagnostics.Process.Start(handle.Msg);
            }
            
        }

        
        private void SendMail(string    name ,string msg)
        {
            MailMessage mailmsg = new MailMessage();
            mailmsg.To.Add("wangyongzhi@xiyoumobile.com");
            mailmsg.CC.Add("tangnian@xiyoumobile.com");
            mailmsg.CC.Add("jiayudong@xiyoumobile.com");

            mailmsg.From = new MailAddress("angel", name, Encoding.UTF8);
            mailmsg.Subject =name;
            mailmsg.SubjectEncoding = Encoding.UTF8;
            mailmsg.Body = msg;
            mailmsg.BodyEncoding = Encoding.UTF8;
            mailmsg.IsBodyHtml = false;
            mailmsg.Priority = MailPriority.High;
            SmtpClient client = new SmtpClient();
            client.Credentials = new NetworkCredential("wangyongzhi@xiyoumobile.com", "Wangyongzhi61011");
            client.Port = 465;
            client.Host = "smtp.exmail.qq.com";
            client.EnableSsl = true;
            object userState = mailmsg;
            try
            {
                client.SendAsync(mailmsg, userState);
                System.Windows.MessageBox.Show("发送成功");
            }
            catch (SmtpException ex)
            {
                System.Windows.MessageBox.Show("发送邮件出错");
            }


        }

        public  static  void OnStartUp()
        {
            string path = Environment.CurrentDirectory + "\\SocketServerDemo.exe";
            /*path=AppDomain.CurrentDomain.BaseDirectory;
           path=Directory.GetCurrentDirectory();
           path = AppDomain.CurrentDomain.SetupInformation.ApplicationBase;*/


            App.Current.Dispatcher.Invoke((Action)(() =>
            {
                //MainWindow mainwindow = new MainWindow();
                //mainwindow.Show();

                System.Windows.Application.Current.Shutdown();

                System.Reflection.Assembly.GetEntryAssembly();
                string startpath = System.IO.Directory.GetCurrentDirectory();
                System.Diagnostics.Process.Start(path);

            }));

        }
    }
}
