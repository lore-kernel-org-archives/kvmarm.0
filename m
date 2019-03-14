From: Jan Bolke <jan.bolke@synopsys.com>
Subject: Kick cpu when WFI in single-threaded kvm integration
Date: Thu, 14 Mar 2019 12:19:02 +0000
Message-ID: <93B846538060DA46A9945E98A2E521E901425BA9@DE02WEMBXB.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4652413843563210275=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 618CE4A2E9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Mar 2019 08:19:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id blAOLO2A6b4V for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Mar 2019 08:19:07 -0400 (EDT)
Received: from smtprelay.synopsys.com (us01smtprelay-2.synopsys.com
 [198.182.47.9])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED9EE4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Mar 2019 08:19:06 -0400 (EDT)
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com
 [10.13.135.210])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by smtprelay.synopsys.com (Postfix) with ESMTPS id 0C4DC24E2CE7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Mar 2019 05:19:05 -0700 (PDT)
Received: from us01wehtc1.internal.synopsys.com
 (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by mailhost.synopsys.com (Postfix) with ESMTPS id E34BDA0062
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Mar 2019 12:19:05 +0000 (UTC)
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

--===============4652413843563210275==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_93B846538060DA46A9945E98A2E521E901425BA9DE02WEMBXBinter_"

--_000_93B846538060DA46A9945E98A2E521E901425BA9DE02WEMBXBinter_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi all,

Currently I am working on a SystemC integration of kvm on arm.
Therefore, I use the kvm api and of course SystemC (library to simulate har=
dware platforms with C++).

As I need the virtual cpu to interrupt its execution loop from time to time=
 to let the rest of the SystemC simulation execute,
I use a perf_event and let the kernel send a signal on overflow to the simu=
lation thread which kicks the virtual cpu (suggested by this mailing list, =
thanks again).
Thus I am able to simulate a quantum mechanism for the virtual cpu.

As I am running benchmarks (e.g. Coremark) on my virtual platform this work=
s fine.

I also get to boot Linux until it spawns the terminal and then wait for int=
errupts from my virtual uart.
Here comes the problem:
The perf event counting mechanism does increment its counted instructions v=
ery very slowly when the virtual cpu executes wfi.
Thus my whole simulation starts to hang.
As my simulation is single threaded I need the signal from the kernel to ki=
ck my cpu to let the virtual uart deliver its interrupt to react to my inpu=
t.
I tried to use the request_interrupt_window flag but this does not seem to =
work.

Is there a way to kick the virtual cpu when it is waiting for interrupts? O=
r do I have to patch my kvm code?

Thanks in advance
Jan B=F6lke


--_000_93B846538060DA46A9945E98A2E521E901425BA9DE02WEMBXBinter_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
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
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
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
<p class=3D"MsoNormal">Hi all,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Currently I am working on a SystemC integration of k=
vm on arm.
<o:p></o:p></p>
<p class=3D"MsoNormal">Therefore, I use the kvm api and of course SystemC (=
library to simulate hardware platforms with C&#43;&#43;).<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">As I need the virtual cpu to interrupt its execution=
 loop from time to time to let the rest of the SystemC simulation execute,<=
o:p></o:p></p>
<p class=3D"MsoNormal">I use a perf_event and let the kernel send a signal =
on overflow to the simulation thread which kicks the virtual cpu (suggested=
 by this mailing list, thanks again).<o:p></o:p></p>
<p class=3D"MsoNormal">Thus I am able to simulate a quantum mechanism for t=
he virtual cpu.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">As I am running benchmarks (e.g. Coremark) on my vir=
tual platform this works fine.
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I also get to boot Linux until it spawns the termina=
l and then wait for interrupts from my virtual uart.<o:p></o:p></p>
<p class=3D"MsoNormal">Here comes the problem:<o:p></o:p></p>
<p class=3D"MsoNormal">The perf event counting mechanism does increment its=
 counted instructions very very slowly when the virtual cpu executes wfi.<o=
:p></o:p></p>
<p class=3D"MsoNormal">Thus my whole simulation starts to hang.<o:p></o:p><=
/p>
<p class=3D"MsoNormal">As my simulation is single threaded I need the signa=
l from the kernel to kick my cpu to let the virtual uart deliver its interr=
upt to react to my input.<o:p></o:p></p>
<p class=3D"MsoNormal">I tried to use the request_interrupt_window flag but=
 this does not seem to work.
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Is there a way to kick the virtual cpu when it is wa=
iting for interrupts? Or do I have to patch my kvm code?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks in advance<o:p></o:p></p>
<p class=3D"MsoNormal">Jan B=F6lke<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_93B846538060DA46A9945E98A2E521E901425BA9DE02WEMBXBinter_--

--===============4652413843563210275==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4652413843563210275==--
