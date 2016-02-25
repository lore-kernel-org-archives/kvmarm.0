From: xu mike <upennmike@gmail.com>
Subject: [Question] Can KVM run on Freescale IMX6 SABRE board?
Date: Thu, 25 Feb 2016 10:17:18 -0500
Message-ID: <CAPSnSYoxmmDm--vuigyHb2xPr1GpSf22meO59kDQh1s2HFySiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8309639251725582970=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C8DE4852F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 10:10:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ktzh490VAE1u for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Feb 2016 10:10:30 -0500 (EST)
Received: from mail-yw0-f169.google.com (mail-yw0-f169.google.com
 [209.85.161.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE68248529
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 10:10:30 -0500 (EST)
Received: by mail-yw0-f169.google.com with SMTP id e63so44687521ywc.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 07:17:19 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============8309639251725582970==
Content-Type: multipart/alternative; boundary=001a114e4598a60333052c99ad83

--001a114e4598a60333052c99ad83
Content-Type: text/plain; charset=UTF-8

Hi,

I'm a student from the University of Pennsylvania. I want to try KVM on ARM
boards.

I have a Freescale IMX6 board [1] which has ARM Cortex A9 processors.
I'm wondering if KVM can run on the Freescale IMX6 board? or
Can KVM run on any ARM board with ARM Cortex A9 processors?

I noticed at [2] that " KVM/ARM is designed specifically to work on ARM
processors with the virtualization extensions enabled to run unmodified
guest operating systems."
I'm wondering if this statement is still true?


 [1]
http://www.nxp.com/products/microcontrollers-and-processors/arm-processors/i.mx-applications-processors-based-on-arm-cores/i.mx-6-processors/i.mx6qp/sabre-board-for-smart-devices-reference-design-based-on-the-i.mx-6-series:RDIMX6SABREBRD
[2] https://lwn.net/Articles/557132/

Thank you very much for your time and help!

Best regards,

Mike

--001a114e4598a60333052c99ad83
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><br>I&#39;m a student from the University of Pennsy=
lvania. I want to try KVM on ARM boards.<br><br>I have a Freescale IMX6 boa=
rd [1] which has ARM Cortex A9 processors. <br>I&#39;m wondering if KVM can=
 run on the Freescale IMX6 board? or<br>Can KVM run on any ARM board with A=
RM Cortex A9 processors?<br><br>I noticed at [2] that &quot; KVM/ARM is des=
igned specifically to work on ARM processors with the virtualization extens=
ions enabled to run unmodified guest operating systems.&quot;<div>I&#39;m w=
ondering if this statement is still true?=C2=A0<br><br><br>=C2=A0[1] <a hre=
f=3D"http://www.nxp.com/products/microcontrollers-and-processors/arm-proces=
sors/i.mx-applications-processors-based-on-arm-cores/i.mx-6-processors/i.mx=
6qp/sabre-board-for-smart-devices-reference-design-based-on-the-i.mx-6-seri=
es:RDIMX6SABREBRD">http://www.nxp.com/products/microcontrollers-and-process=
ors/arm-processors/i.mx-applications-processors-based-on-arm-cores/i.mx-6-p=
rocessors/i.mx6qp/sabre-board-for-smart-devices-reference-design-based-on-t=
he-i.mx-6-series:RDIMX6SABREBRD</a><br>[2] <a href=3D"https://lwn.net/Artic=
les/557132/">https://lwn.net/Articles/557132/</a></div><div><br></div><div>=
Thank you very much for your time and help!</div><div><br></div><div>Best r=
egards,</div><div><br></div><div>Mike</div></div>

--001a114e4598a60333052c99ad83--

--===============8309639251725582970==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8309639251725582970==--
