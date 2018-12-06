From: "Steven Miao (Arm Technology China)" <Steven.Miao@arm.com>
Subject: KVM arm realtime performance optimization
Date: Thu, 6 Dec 2018 07:05:17 +0000
Message-ID: <DB7PR08MB360939B98F8943EF9BE9FF40F0A90@DB7PR08MB3609.eurprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8252081381474518226=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5E474A1F2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Dec 2018 02:05:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LR6wiL+cxXuS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Dec 2018 02:05:19 -0500 (EST)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-eopbgr80070.outbound.protection.outlook.com [40.107.8.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E0244A1E5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Dec 2018 02:05:19 -0500 (EST)
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

--===============8252081381474518226==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_DB7PR08MB360939B98F8943EF9BE9FF40F0A90DB7PR08MB3609eurp_"

--_000_DB7PR08MB360939B98F8943EF9BE9FF40F0A90DB7PR08MB3609eurp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Everyone,

I' currently testing KVM arm realtime performance on a hikey960 board. My t=
est benchmark is cyclictest to measure thread wake up latency both on Host =
linux OS and KVM Guest linux OS.

Host OS:

hikey960:/mnt/debian/usr/src/linux#  cyclictest -p 99 -t 4 -m -n -a 0-3 -l =
100000
# /dev/cpu_dma_latency set to 0us
WARN: Running on unknown kernel version...YMMV
policy: fifo: loadavg: 0.00 0.00 0.00 1/165 3270

T: 0 ( 3266) P:99 I:1000 C: 100000 Min:      4 Act:   15 Avg:   15 Max:    =
 139
T: 1 ( 3267) P:99 I:1500 C:  66736 Min:      4 Act:   15 Avg:   15 Max:    =
 239
T: 2 ( 3268) P:99 I:2000 C:  50051 Min:      4 Act:   19 Avg:   15 Max:    =
  43
T: 3 ( 3269) P:99 I:2500 C:  40039 Min:      5 Act:   15 Avg:   16 Max:    =
  74

Guest OS:
root@genericarmv8:~# cyclictest -p 99 -t 4 -m -n -a 0-3 -l 100000
# /dev/cpu_dma_latency set to 0us
WARN: Running on unknown kernel version...YMMV
policy: fifo: loadavg: 0.13 0.05 0.01 1/70 293

T: 0 (  290) P:99 I:1000 C: 100000 Min:      7 Act:   44 Avg:   85 Max:   1=
6111
T: 1 (  291) P:99 I:1500 C:  66665 Min:      7 Act:   81 Avg:   90 Max:   1=
5306
T: 2 (  292) P:99 I:2000 C:  49995 Min:      7 Act:   88 Avg:   87 Max:   1=
6703
T: 3 (  293) P:99 I:2500 C:  39992 Min:      8 Act:   72 Avg:   97 Max:   1=
4976


RT performance on KVM guest OS is poor compared to that on host OS. The ave=
rage wake up latency is about 6 - 7 times on Guest OS vs on Host OS.
I've tried some configurations to improve RT in KVM, like:
1 Can be combined with CPU isolation
2 Host OS and Guest OS use RT preempt kernel
3 Host CPU avoid frequency change
4 Configure NO_HZ_FULL for Guest OS

There could be a little improvement after apply above configuration, but th=
e RT performance is still very poor.

5 Guest OS use idle poll instead of WFI to avoid trap and switch out

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 2dc0f84..53aef78 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -83,7 +83,7 @@ void arch_cpu_idle(void)
         * tricks
         */
        trace_cpu_idle_rcuidle(1, smp_processor_id());
-       cpu_do_idle();
+       cpu_relax();
        local_irq_enable();
        trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }

root@genericarmv8:~# cyclictest -p 99 -t 4 -m -n  -l 100000
# /dev/cpu_dma_latency set to 0us
WARN: Running on unknown kernel version...YMMV
policy: fifo: loadavg: 0.07 0.03 0.00 1/99 328

T: 0 (  325) P:99 I:1000 C: 100000 Min:      3 Act:    6 Avg:   13 Max:    =
4999
T: 1 (  326) P:99 I:1500 C:  66659 Min:      5 Act:    7 Avg:   14 Max:    =
3449
T: 2 (  327) P:99 I:2000 C:  49989 Min:      4 Act:    7 Avg:    9 Max:   1=
1471
T: 3 (  328) P:99 I:2500 C:  39986 Min:      4 Act:   14 Avg:   14 Max:   1=
1253

The method 5 can improve Guest OS RT performance a lot, the average thread =
wake up latency on Guest OS is almost same as its on Host OS, but the Max w=
ake up latency is still very poor.

Anyone has any idea to improve RT performance on KVM Guest OS? Although met=
hod 5 can improve RT performance on Guest OS a lot, I think it is not good =
idea.

Thanks,
Steven


IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

--_000_DB7PR08MB360939B98F8943EF9BE9FF40F0A90DB7PR08MB3609eurp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:DengXian;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"\@DengXian";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:Consolas;
	panose-1:2 11 6 9 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
code
	{mso-style-priority:99;
	font-family:"Courier New";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi <span style=3D"font-size:12.0pt;font-family:&quot=
;Arial&quot;,sans-serif;color:#222222;background:white">
Everyone</span>,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I&#8217; currently testing KVM arm realtime performa=
nce on a hikey960 board. My test benchmark is cyclictest to measure thread =
wake up latency both on Host linux OS and KVM Guest linux OS.<o:p></o:p></p=
>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Host OS:<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:=
none windowtext 1.0pt;padding:0in">hikey960:/mnt/debian/usr/src/linux#&nbsp=
; cyclictest -p&nbsp;99</span><span style=3D"font-size:10.5pt;font-family:C=
onsolas;color:#333333">&nbsp;</span><span style=3D"font-size:10.5pt;font-fa=
mily:Consolas;color:#333333;border:none windowtext 1.0pt;padding:0in">-t&nb=
sp;4</span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#3333=
33">&nbsp;</span><span style=3D"font-size:10.5pt;font-family:Consolas;color=
:#333333;border:none windowtext 1.0pt;padding:0in">-m
 -n -a&nbsp;0-3</span><span style=3D"font-size:10.5pt;font-family:Consolas;=
color:#333333">&nbsp;</span><span style=3D"font-size:10.5pt;font-family:Con=
solas;color:#333333;border:none windowtext 1.0pt;padding:0in">-l&nbsp;10000=
0</span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333"=
><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:=
none windowtext 1.0pt;padding:0in"># /dev/cpu_dma_latency set to 0us</span>=
<span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333"><o:p></=
o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:=
none windowtext 1.0pt;padding:0in">WARN: Running on unknown kernel version.=
..YMMV</span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#33=
3333"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:=
none windowtext 1.0pt;padding:0in">policy: fifo: loadavg:&nbsp;0.00</span><=
span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</=
span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;bor=
der:none windowtext 1.0pt;padding:0in">0.00</span><span style=3D"font-size:=
10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=3D"font=
-size:10.5pt;font-family:Consolas;color:#333333;border:none windowtext 1.0p=
t;padding:0in">0.00</span><span style=3D"font-size:10.5pt;font-family:Conso=
las;color:#333333">&nbsp;</span><span style=3D"font-size:10.5pt;font-family=
:Consolas;color:#333333;border:none windowtext 1.0pt;padding:0in">1/165</sp=
an><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbs=
p;</span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333=
;border:none windowtext 1.0pt;padding:0in">3270</span><span style=3D"font-s=
ize:10.5pt;font-family:Consolas;color:#333333"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;=
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:=
none windowtext 1.0pt;padding:0in">T:&nbsp;0</span><span style=3D"font-size=
:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=3D"fon=
t-size:10.5pt;font-family:Consolas;color:#333333;border:none windowtext 1.0=
pt;padding:0in">(&nbsp;3266)
 P:99</span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333=
333">&nbsp;</span><span style=3D"font-size:10.5pt;font-family:Consolas;colo=
r:#333333;border:none windowtext 1.0pt;padding:0in">I:1000</span><span styl=
e=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><spa=
n style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none =
windowtext 1.0pt;padding:0in">C:&nbsp;100000</span><span style=3D"font-size=
:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=3D"fon=
t-size:10.5pt;font-family:Consolas;color:#333333;border:none windowtext 1.0=
pt;padding:0in">Min:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span=
 style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none w=
indowtext 1.0pt;padding:0in">Act:&nbsp;&nbsp;&nbsp;15</span><span style=3D"=
font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span sty=
le=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none windo=
wtext 1.0pt;padding:0in">Avg:&nbsp;&nbsp;&nbsp;15</span><span style=3D"font=
-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none windowt=
ext 1.0pt;padding:0in">Max:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;139</span><span st=
yle=3D"font-size:10.5pt;font-family:Consolas;color:#333333"><o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:=
none windowtext 1.0pt;padding:0in">T:&nbsp;1</span><span style=3D"font-size=
:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=3D"fon=
t-size:10.5pt;font-family:Consolas;color:#333333;border:none windowtext 1.0=
pt;padding:0in">(&nbsp;3267)
 P:99</span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333=
333">&nbsp;</span><span style=3D"font-size:10.5pt;font-family:Consolas;colo=
r:#333333;border:none windowtext 1.0pt;padding:0in">I:1500</span><span styl=
e=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><spa=
n style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none =
windowtext 1.0pt;padding:0in">C:&nbsp;&nbsp;66736</span><span style=3D"font=
-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none windowt=
ext 1.0pt;padding:0in">Min:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4</span><spa=
n style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</spa=
n><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border=
:none windowtext 1.0pt;padding:0in">Act:&nbsp;&nbsp;&nbsp;15</span><span st=
yle=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><s=
pan style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:non=
e windowtext 1.0pt;padding:0in">Avg:&nbsp;&nbsp;&nbsp;15</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span=
 style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none w=
indowtext 1.0pt;padding:0in">Max:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;239</span><s=
pan style=3D"font-size:10.5pt;font-family:Consolas;color:#333333"><o:p></o:=
p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:=
none windowtext 1.0pt;padding:0in">T:&nbsp;2</span><span style=3D"font-size=
:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=3D"fon=
t-size:10.5pt;font-family:Consolas;color:#333333;border:none windowtext 1.0=
pt;padding:0in">(&nbsp;3268)
 P:99</span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333=
333">&nbsp;</span><span style=3D"font-size:10.5pt;font-family:Consolas;colo=
r:#333333;border:none windowtext 1.0pt;padding:0in">I:2000</span><span styl=
e=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><spa=
n style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none =
windowtext 1.0pt;padding:0in">C:&nbsp;&nbsp;50051</span><span style=3D"font=
-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none windowt=
ext 1.0pt;padding:0in">Min:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4</span><spa=
n style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</spa=
n><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border=
:none windowtext 1.0pt;padding:0in">Act:&nbsp;&nbsp;&nbsp;19</span><span st=
yle=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><s=
pan style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:non=
e windowtext 1.0pt;padding:0in">Avg:&nbsp;&nbsp;&nbsp;15</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span=
 style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none w=
indowtext 1.0pt;padding:0in">Max:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;43</sp=
an><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333"><o:p=
></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:=
none windowtext 1.0pt;padding:0in">T:&nbsp;3</span><span style=3D"font-size=
:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=3D"fon=
t-size:10.5pt;font-family:Consolas;color:#333333;border:none windowtext 1.0=
pt;padding:0in">(&nbsp;3269)
 P:99</span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333=
333">&nbsp;</span><span style=3D"font-size:10.5pt;font-family:Consolas;colo=
r:#333333;border:none windowtext 1.0pt;padding:0in">I:2500</span><span styl=
e=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><spa=
n style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none =
windowtext 1.0pt;padding:0in">C:&nbsp;&nbsp;40039</span><span style=3D"font=
-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none windowt=
ext 1.0pt;padding:0in">Min:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5</span><spa=
n style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</spa=
n><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border=
:none windowtext 1.0pt;padding:0in">Act:&nbsp;&nbsp;&nbsp;15</span><span st=
yle=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><s=
pan style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:non=
e windowtext 1.0pt;padding:0in">Avg:&nbsp;&nbsp;&nbsp;16</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span=
 style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none w=
indowtext 1.0pt;padding:0in">Max:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;74</sp=
an><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333"><o:p=
></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Guest OS:<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span lang=3D"FR" style=3D"font-size:10.5pt;font-family:Consolas;color:#33=
3333;border:none windowtext 1.0pt;padding:0in">root@genericarmv8:~# cyclict=
est -p&nbsp;99</span><span lang=3D"FR" style=3D"font-size:10.5pt;font-famil=
y:Consolas;color:#333333">&nbsp;</span><span lang=3D"FR" style=3D"font-size=
:10.5pt;font-family:Consolas;color:#333333;border:none windowtext 1.0pt;pad=
ding:0in">-t&nbsp;4</span><span lang=3D"FR" style=3D"font-size:10.5pt;font-=
family:Consolas;color:#333333">&nbsp;</span><span lang=3D"FR" style=3D"font=
-size:10.5pt;font-family:Consolas;color:#333333;border:none windowtext 1.0p=
t;padding:0in">-m
 -n -a&nbsp;0-3</span><span lang=3D"FR" style=3D"font-size:10.5pt;font-fami=
ly:Consolas;color:#333333">&nbsp;</span><span lang=3D"FR" style=3D"font-siz=
e:10.5pt;font-family:Consolas;color:#333333;border:none windowtext 1.0pt;pa=
dding:0in">-l&nbsp;100000</span><span lang=3D"FR" style=3D"font-size:10.5pt=
;font-family:Consolas;color:#333333"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:=
none windowtext 1.0pt;padding:0in"># /dev/cpu_dma_latency set to 0us</span>=
<span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333"><o:p></=
o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:=
none windowtext 1.0pt;padding:0in">WARN: Running on unknown kernel version.=
..YMMV</span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#33=
3333"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:=
none windowtext 1.0pt;padding:0in">policy: fifo: loadavg:&nbsp;0.13</span><=
span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</=
span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;bor=
der:none windowtext 1.0pt;padding:0in">0.05</span><span style=3D"font-size:=
10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=3D"font=
-size:10.5pt;font-family:Consolas;color:#333333;border:none windowtext 1.0p=
t;padding:0in">0.01</span><span style=3D"font-size:10.5pt;font-family:Conso=
las;color:#333333">&nbsp;</span><span style=3D"font-size:10.5pt;font-family=
:Consolas;color:#333333;border:none windowtext 1.0pt;padding:0in">1/70</spa=
n><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp=
;</span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;=
border:none windowtext 1.0pt;padding:0in">293</span><span style=3D"font-siz=
e:10.5pt;font-family:Consolas;color:#333333"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;=
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:=
none windowtext 1.0pt;padding:0in">T:&nbsp;0</span><span style=3D"font-size=
:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=3D"fon=
t-size:10.5pt;font-family:Consolas;color:#333333;border:none windowtext 1.0=
pt;padding:0in">(&nbsp;&nbsp;290)
 P:99</span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333=
333">&nbsp;</span><span style=3D"font-size:10.5pt;font-family:Consolas;colo=
r:#333333;border:none windowtext 1.0pt;padding:0in">I:1000</span><span styl=
e=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><spa=
n style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none =
windowtext 1.0pt;padding:0in">C:&nbsp;100000</span><span style=3D"font-size=
:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=3D"fon=
t-size:10.5pt;font-family:Consolas;color:#333333;border:none windowtext 1.0=
pt;padding:0in">Min:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;7</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span=
 style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none w=
indowtext 1.0pt;padding:0in">Act:&nbsp;&nbsp;&nbsp;44</span><span style=3D"=
font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span sty=
le=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none windo=
wtext 1.0pt;padding:0in">Avg:&nbsp;&nbsp;&nbsp;85</span><span style=3D"font=
-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none windowt=
ext 1.0pt;padding:0in">Max:&nbsp;&nbsp;&nbsp;16111</span><span style=3D"fon=
t-size:10.5pt;font-family:Consolas;color:#333333"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:=
none windowtext 1.0pt;padding:0in">T:&nbsp;1</span><span style=3D"font-size=
:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=3D"fon=
t-size:10.5pt;font-family:Consolas;color:#333333;border:none windowtext 1.0=
pt;padding:0in">(&nbsp;&nbsp;291)
 P:99</span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333=
333">&nbsp;</span><span style=3D"font-size:10.5pt;font-family:Consolas;colo=
r:#333333;border:none windowtext 1.0pt;padding:0in">I:1500</span><span styl=
e=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><spa=
n style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none =
windowtext 1.0pt;padding:0in">C:&nbsp;&nbsp;66665</span><span style=3D"font=
-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none windowt=
ext 1.0pt;padding:0in">Min:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;7</span><spa=
n style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</spa=
n><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border=
:none windowtext 1.0pt;padding:0in">Act:&nbsp;&nbsp;&nbsp;81</span><span st=
yle=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><s=
pan style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:non=
e windowtext 1.0pt;padding:0in">Avg:&nbsp;&nbsp;&nbsp;90</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span=
 style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none w=
indowtext 1.0pt;padding:0in">Max:&nbsp;&nbsp;&nbsp;15306</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333"><o:p></o:p></span>=
</p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:=
none windowtext 1.0pt;padding:0in">T:&nbsp;2</span><span style=3D"font-size=
:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=3D"fon=
t-size:10.5pt;font-family:Consolas;color:#333333;border:none windowtext 1.0=
pt;padding:0in">(&nbsp;&nbsp;292)
 P:99</span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333=
333">&nbsp;</span><span style=3D"font-size:10.5pt;font-family:Consolas;colo=
r:#333333;border:none windowtext 1.0pt;padding:0in">I:2000</span><span styl=
e=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><spa=
n style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none =
windowtext 1.0pt;padding:0in">C:&nbsp;&nbsp;49995</span><span style=3D"font=
-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none windowt=
ext 1.0pt;padding:0in">Min:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;7</span><spa=
n style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</spa=
n><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border=
:none windowtext 1.0pt;padding:0in">Act:&nbsp;&nbsp;&nbsp;88</span><span st=
yle=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><s=
pan style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:non=
e windowtext 1.0pt;padding:0in">Avg:&nbsp;&nbsp;&nbsp;87</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span=
 style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none w=
indowtext 1.0pt;padding:0in">Max:&nbsp;&nbsp;&nbsp;16703</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333"><o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.5pt;font-family:Consolas=
;color:#333333;border:none windowtext 1.0pt;padding:0in">T:&nbsp;3</span><s=
pan style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</s=
pan><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;bord=
er:none windowtext 1.0pt;padding:0in">(&nbsp;&nbsp;293)
 P:99</span><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333=
333">&nbsp;</span><span style=3D"font-size:10.5pt;font-family:Consolas;colo=
r:#333333;border:none windowtext 1.0pt;padding:0in">I:2500</span><span styl=
e=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><spa=
n style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none =
windowtext 1.0pt;padding:0in">C:&nbsp;&nbsp;39992</span><span style=3D"font=
-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none windowt=
ext 1.0pt;padding:0in">Min:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;8</span><spa=
n style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</spa=
n><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border=
:none windowtext 1.0pt;padding:0in">Act:&nbsp;&nbsp;&nbsp;72</span><span st=
yle=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><s=
pan style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:non=
e windowtext 1.0pt;padding:0in">Avg:&nbsp;&nbsp;&nbsp;97</span><span style=
=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;</span><span=
 style=3D"font-size:10.5pt;font-family:Consolas;color:#333333;border:none w=
indowtext 1.0pt;padding:0in">Max:&nbsp;&nbsp;&nbsp;14976<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-size:10.5pt;font-family:&quot;Ar=
ial&quot;,sans-serif;color:#333333;background:white">RT performance on KVM =
guest OS is poor compared to that on host OS. The average wake up latency i=
s about 6 &#8211; 7 times on Guest OS vs on Host OS.<o:p></o:p></span></p>
<p class=3D"MsoNormal">I&#8217;ve tried <span style=3D"font-family:&quot;Ar=
ial&quot;,sans-serif">some configurations to improve RT in KVM, like:<o:p><=
/o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Arial&quot;,sans-se=
rif">1 Can be combined with CPU isolation</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Arial&quot;,sans-se=
rif">2 Host OS and Guest OS use RT preempt kernel</span><o:p></o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Arial&quot;,sans-se=
rif">3 Host CPU avoid frequency change<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Arial&quot;,sans-se=
rif">4 Configure NO_HZ_FULL for Guest OS<o:p></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">There could be a little improvement after apply abov=
e configuration, but the RT performance is still very poor.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Arial&quot;,sans-se=
rif">5 Guest OS use idle poll instead of WFI to avoid trap and switch out</=
span><o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">diff -=
-git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">index =
2dc0f84..53aef78 100644<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">--- a/=
arch/arm64/kernel/process.c<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&#43;&=
#43;&#43; b/arch/arm64/kernel/process.c<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">@@ -83=
,7 &#43;83,7 @@ void arch_cpu_idle(void)<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp;* tricks<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp;*/<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;=
 &nbsp; &nbsp; &nbsp; trace_cpu_idle_rcuidle(1, smp_processor_id());<o:p></=
o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">-&nbsp=
; &nbsp; &nbsp; &nbsp;cpu_do_idle();<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&#43;&=
nbsp; &nbsp; &nbsp; &nbsp;cpu_relax();<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;=
 &nbsp; &nbsp; &nbsp; local_irq_enable();<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;=
 &nbsp; &nbsp; &nbsp; trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_=
id());<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">&nbsp;=
}<o:p></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">root@g=
enericarmv8:~# cyclictest -p 99 -t 4 -m -n&nbsp; -l 100000<o:p></o:p></span=
></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333"># /dev=
/cpu_dma_latency set to 0us<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">WARN: =
Running on unknown kernel version...YMMV<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">policy=
: fifo: loadavg: 0.07 0.03 0.00 1/99 328<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333"><o:p>&=
nbsp;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">T: 0 (=
&nbsp; 325) P:99 I:1000 C: 100000 Min:&nbsp; &nbsp; &nbsp; 3 Act:&nbsp; &nb=
sp; 6 Avg:&nbsp; &nbsp;13 Max:&nbsp; &nbsp; 4999<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">T: 1 (=
&nbsp; 326) P:99 I:1500 C:&nbsp; 66659 Min:&nbsp; &nbsp; &nbsp; 5 Act:&nbsp=
; &nbsp; 7 Avg:&nbsp; &nbsp;14 Max:&nbsp; &nbsp; 3449<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">T: 2 (=
&nbsp; 327) P:99 I:2000 C:&nbsp; 49989 Min:&nbsp; &nbsp; &nbsp; 4 Act:&nbsp=
; &nbsp; 7 Avg:&nbsp; &nbsp; 9 Max:&nbsp; &nbsp;11471<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:15.0pt;vertical-align:baseline"=
><span style=3D"font-size:10.5pt;font-family:Consolas;color:#333333">T: 3 (=
&nbsp; 328) P:99 I:2500 C:&nbsp; 39986 Min:&nbsp; &nbsp; &nbsp; 4 Act:&nbsp=
; &nbsp;14 Avg:&nbsp; &nbsp;14 Max:&nbsp; &nbsp;11253<o:p></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">The method 5 can improve Guest OS RT performance a l=
ot, the average thread wake up latency on Guest OS is almost same as its on=
 Host OS, but the Max wake up latency is still very poor.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Anyone has any idea to improve RT performance on KVM=
 Guest OS? Although method 5 can improve RT performance on Guest OS a lot, =
I think it is not good idea.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks,<o:p></o:p></p>
<p class=3D"MsoNormal">Steven<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose,
 or store or copy the information in any medium. Thank you.
</body>
</html>

--_000_DB7PR08MB360939B98F8943EF9BE9FF40F0A90DB7PR08MB3609eurp_--

--===============8252081381474518226==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8252081381474518226==--
