   M S B A M L   `   `   `  ����K  GSocketServerDemo, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null3clr-namespace:SocketServerDemoSocketServerDemo  5   	   !    SocketServerDemo.MainWindow   5   	   W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   0localclr-namespace:SocketServerDemo     5   	     � Title$  西邮快传Server��5   	   $	��350��6   $	��525��6)    � 	Resources 5	         TextBox.Static.Border �� Color  TextBox.MouseOver.Border  TextBox.Focus.Border  TextBoxStyle1 �� 
TargetType �� Property �� Value-  'System.Windows.Input.KeyboardNavigation �� 
TargetType ��Name J� SnapsToDevicePixels	 ��Name
 �� Triggers P� Property P� Value �� 
TargetName �� Triggers ]� 
Conditions �� Property �� Value  FocusVisual �� StrokeDashArray  Button.Static.Background  Button.Static.Border  Button.MouseOver.Background  Button.MouseOver.Border 	 Button.Pressed.Background 
 Button.Pressed.Border  Button.Disabled.Background  Button.Disabled.Border  Button.Disabled.Foreground  ButtonStyle1 �� CornerRadius ��Name��%�  &	        &	 !     &	 D     &	 g     7   7  &	 e    &	     &	 2    &	 U    &	 x    &		 �    &	
 �    &	 �    &	     &	 %    &	 H    7  7  7  7  7  7 	 7 
 7  7  7  �� 5   
   $ #1fa294��68   �� 5   
   $ 	#FF7EB4EA��6;   �� 5   
   $ 	#FF569DE5��67   �� 5   
   " ��6&   .�5      ��  � ��# � ��6+   �� 5       � ��8   6,   �� 5       � ��# � ��6+   �� 5       � ��$ 2q�60   �� 5       �@ TabNavigation$
 None=�6A   �� 5       � ��$
 Left=�6;   �� 5       �@�FocusVisualStyle 61   Z� �� 5       �@J�	AllowDrop . 6*   �� 5       �@��PanningMode$ VerticalFirst=�69   �� 5       �@��IsFlicksEnabled .  67   �� 5       � �� 5      �� 5      " ��6&   .R�5      �� $ border��6!   #��z��61   #��z��6]   #��z��6�    . ._�5      �� $	 PART_ContentHost��6+   |�.  $��Hidden=�6W   $��Hidden=�6~   5      
 5      P� 5        � {� .  . �5!   "   �� $ border��6<    �@J�Opacity$
 0.16Q�6P   5"      P� 5#       �@J�IsMouseOver . . �5$   "   �� $ border��6@   8   � ��6T   5%      P� 5&       �@J�IsKeyboardFocused . . �5'   "   �� $ border��6@    � ��
 �  ��6T   5(      5*      5,       5-      ]� 5.       5/      �� 50      + �@��#IsInactiveSelectionHighlightEnabled . 6S   �� 51       �@��IsSelectionActive .  6A   ./�53      ��  �@��SelectionBrush# � /�67   54      56      �� 57   
   .�58      ��  � �� 59      �� 5:      .R�5;      �� $��2q�6$    . #��� ��6J   $��1��6�   $	 1 2R�6�   5<      5>      5?      �� 5@   
   $ 	#FFDDDDDD��6;   �� 5A   
   $ 	#FF707070��67   �� 5B   
   $ 	#FFDDDDDD��6>   �� 5C   
   $ 	#FF3C7FB1��6:   �� 5D   
   $ #8E72D8��6<   �� 5E   
   $ 	#FF2C628B��68   �� 5F   
   $ 	#FFF4F4F4��6=   �� 5G   
   $ 	#FFADB2B5��69   �� 5H   
   $ 	#FF838383��6=   �� 5I   
   " ��6%   .�5J      ��  �@�FocusVisualStyle8   61   �� 5K       � ��8  6+   �� 5L       � ��8  6,   �� 5M       � ��# � ��6+   �� 5N       � ��$ 1q�60   �� 5O       � ��$ Center=�6;   �� 5P       � ��$ Center=�69   �� 5Q       � ��$ 1q�6(   �� 5R       � �� 5S      �� 5T      " ��6&   .R�5U      �� $ border��63   $ 10��6!   #��z��6C   $��2q�6o   #��z��6�    . ._�5V      �� $ contentPresenter��6/   |�.  #��z��6[   #��z��6�   ��. # z 6�   #��z��6  5W      
 5X      P� 5Y       �@��IsDefaulted . . �5Z   "   �� $ border��6@   # � ��6T    � ��5[      P� 5\       �@J�IsMouseOver . . �5]   "   �� $ border��6?   8   � ��6S   �� 5^   "   $ border��6@   8   � ��6T   5_      P� 5`       � �� . . �5a   "   �� $ border��6?   8   � ��6S   �� 5b   "   $ border��6@   8   � ��6T   5c      P� 5d       � {� .  . �5e   "   �� $ border��6?   8   � ��6S   �� 5f   "   $ border��6@   8   � ��6T   �� 5g   "   $ contentPresenter��6K   8 	  � ��6i   5h      5j      5l      5m      5o      .��5p      � ��5q   
   �� 5r       �� 
StartPoint$	 0,0&�6"    �� EndPoint$	 1,1&�63   .��5s      �  � Color$ #8E72D8��6    � Offset$ 0Q�6/   6<   � 5t      $ #229bc5��6   $ 1Q�6/   6<   5u       � RowDefinitions 5w   
   �� 5x      $��3* �6   �� 5y      $
��auto �6   �� 5z      $
��auto �6   .+�5�   
   �� -   5         ��Name$	 img��5�      $��0��6   $	��200��6*   $	��200��66   6E   �� 5�   
   -   5         ��Name$ ip��5�      $��1��6!   
������� �� TextAlignment$ Center=�6A   6Z   �� 5�   
   $��请扫描二维码连接��6   $ Center=�6$   $��0 0 0 50q�6;   $��2��6N   $��25(�6[   
�������6~   5�      5�      