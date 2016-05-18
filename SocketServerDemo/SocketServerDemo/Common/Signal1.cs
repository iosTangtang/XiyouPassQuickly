using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SocketServerDemo.Common
{
    class Signal1
    {
    
        public double x { get; set; }
        public double y { get; set; }
        public string mode { get; set; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dwFlags"> 鼠标事件，在VB与C#，要调用事件需要定义常量，赋与对应值（下面的MOUSEVENTF_MOVE））</param>
        /// <param name="dx"> x标的绝对地位或相对地位</param>
        /// <param name="dy"> y标的绝对地位或相对地位</param>
        /// <param name="dwData"> 如果dwFlags为MOUSEEVENTF_WHEEL，则dwData指定鼠标轮移动的数量。正值表明鼠标轮向前转动，即远离用户
        ///的方向；负值表明鼠标轮向后转动，即朝向用户。一个轮击定义为WHEEL_DELTA，即120.
        ///如果dwFlagsS不是MOUSEEVENTF_WHEEL，则dWData应为零。
        ///</param>
        /// <param name="dwExtraInfo"> 指定与鼠标事件相关的附加32位值。应用程序调用函数GetMessageExtraInfo来获得此附加信息。</param>
        /// <returns></returns>
        [System.Runtime.InteropServices.DllImport("user32")]
       
        private static extern int mouse_event(int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="bVk">虚拟键值</param>
        /// <param name="bScan">一般为0</param>
        /// <param name="dwFlags">int类型，0为按下，2为释放</param>
        /// <param name="dwExtraInfo">一般为0</param>
        [System.Runtime.InteropServices.DllImport("user32")]
        public static extern void keybd_event(Byte bVk, Byte bScan, Int32 dwFlags, Int32 dwExtraInfo);

        const int MOUSEEVENTF_MOVE = 0x0001;     // 移动鼠标           (十):1
        const int MOUSEEVENTF_LEFTDOWN = 0x0002; //模仿鼠标左键按下    (十):2
        const int MOUSEEVENTF_LEFTUP = 0x0004; //模仿鼠标左键抬起    (十):4
        const int MOUSEEVENTF_RIGHTDOWN = 0x0008; //模仿鼠标右键按下    (十):8
        const int MOUSEEVENTF_RIGHTUP = 0x0010; //模仿鼠标右键抬起    (十):16
        const int MOUSEEVENTF_MIDDLEDOWN = 0x0020;// 模仿鼠标中键按下    (十):32
        const int MOUSEEVENTF_MIDDLEUP = 0x0040;// 模仿鼠标中键抬起    (十):64
        const int MOUSEEVENTF_ABSOLUTE = 0x8000; //标示是否采取绝对坐标    (十):32768
        const int MOUSEEVENTF_WHEEL = 0x800;    //模拟鼠标滚轮事件

        const int VK_CTRL = 0x11;                //模拟键盘Ctrl键
        const int VK_ADD = 0x6B;                  //模拟键盘+键
        const int VK_REDUCE = 0x6D;              //模拟键盘-键
        public static void  DoMouseEvent(Signal1 sgl)
        {
            int x = Convert.ToInt32(sgl.x);
            int y = Convert.ToInt32(sgl.y);
            string mode = sgl.mode;
            switch (mode)
            {
                case "WheelUp":
                    mouse_event(MOUSEEVENTF_WHEEL, 0, 0, +100, 0);
                    break;
                case "WheelDown":
                    mouse_event(MOUSEEVENTF_WHEEL, 0, 0, -100, 0);
                    break;
                case "Move":
                    mouse_event(MOUSEEVENTF_MOVE, (int)x, (int)y, 0, 0);
                    break;
                case "Left":
                    mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
                    mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
                    break;
                case "Right":
                    mouse_event(MOUSEEVENTF_RIGHTDOWN,0,0,0,0);
                    mouse_event(MOUSEEVENTF_RIGHTUP,0,0,0,0);
                    break;
                case "Big":
                    keybd_event(VK_CTRL,0,0,0);
                    keybd_event(VK_ADD, 0, 0, 0);
                    keybd_event(VK_ADD, 0, 2, 0);
                    keybd_event(VK_CTRL, 0, 2, 0);
                    break;
                case "Small":
                    keybd_event(VK_CTRL, 0, 0, 0);
                    keybd_event(VK_REDUCE, 0, 0, 0);
                    keybd_event(VK_REDUCE, 0, 2, 0);
                    keybd_event(VK_CTRL, 0, 2, 0);
                    break;
            }    
        }
    }
}
