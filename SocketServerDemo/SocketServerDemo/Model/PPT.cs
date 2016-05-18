using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace SocketServerDemo.Model
{
    class PPT
    {
 
        [DllImport("User32.dll")]
        private static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);  //导入模拟键盘的方法
        public static void Open(string str)      //打开Office
        {
            System.Diagnostics.Process.Start(str);
        }
        public static void Down()//下一页
        {
            keybd_event(0x28, 0, 0, 0);
            keybd_event(0x28, 0, 2, 0);
        }
        public static void Up()//上一页
        {
            keybd_event(0x26, 0, 0, 0);
            keybd_event(0x26, 0, 2, 0);
        }
        public static void Last()//最后一页
        {
            keybd_event(0x23, 0, 0, 0);
            keybd_event(0x23, 0, 2, 0);
        }
        public static void First()//最后一页
        {

            keybd_event(0x24, 0, 0, 0);
            keybd_event(0x24, 0, 2, 0);
        }
        public static void Play()   //放映
        {
             //F5
             keybd_event(116, 0, 0, 0);
             keybd_event(116, 0, 0x2, 0);
            
        }
        public static void Close()  //关闭
        {
            //Alt+F4
            keybd_event(18, 0, 0, 0);
            keybd_event(0x73, 0, 0, 0);
            keybd_event(0x73, 0, 2, 0);
            keybd_event(18, 0, 2, 0);
        }

    }
}
