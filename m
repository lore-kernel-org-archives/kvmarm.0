From: Jan Bolke <jan.bolke@synopsys.com>
Subject: Instruction/Cycle Counting in Guest Using the Kvm PMU
Date: Fri, 23 Nov 2018 09:36:07 +0000
Message-ID: <93B846538060DA46A9945E98A2E521E9A87A9C@DE02WEMBXB.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7421706474231865704=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6A124A300
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 04:36:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id prQxjHv4cctj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Nov 2018 04:36:10 -0500 (EST)
Received: from smtprelay.synopsys.com (smtprelay.synopsys.com [198.182.47.9])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7D234A1E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 04:36:10 -0500 (EST)
Received: from mailhost.synopsys.com (mailhost1.synopsys.com [10.12.238.239])
 by smtprelay.synopsys.com (Postfix) with ESMTP id E407F24E169C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 01:36:09 -0800 (PST)
Received: from US01WEHTC3.internal.synopsys.com
 (us01wehtc3.internal.synopsys.com [10.15.84.232])
 by mailhost.synopsys.com (Postfix) with ESMTP id BD60450E4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 01:36:09 -0800 (PST)
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

--===============7421706474231865704==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_93B846538060DA46A9945E98A2E521E9A87A9CDE02WEMBXBinterna_"

--_000_93B846538060DA46A9945E98A2E521E9A87A9CDE02WEMBXBinterna_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I am not sure if this question is well-placed here, so sorry if it misses t=
he purpose of this mailing list.

My name is Jan and i am currently writing my master's thesis.
I am using the Kvm Api and try to integrate it as an instruction set simula=
tor in a SystemC environment.

Anyway,

I need some mechanism to count executed instructions in the guest (or cycle=
s).
Currently I am trying to use the emulated PMU cycle counter in the guest to=
 get the number of executed cycles in the guest.

I am working on Arm64 and use Linux Kernel 4.14.33.
I create the PMU device without creating a in-kernel vgic.

Basically I create a vcpu and run some bare metal code.
For convienence, I append the critical assembler snippet.

I configure the counter, then start the counter, execute 3 or 4 dummy instr=
uctions and read the counter again and then exit the guest with an exit_mmi=
o.
I assumed the value should be a very small number, as the guest only execut=
ed a few instructions.

The thing is as I read the counter, the value is something like 2970 or 0 (=
changes in each run).
So to me it looks like the counter is also counting the cycles for instruct=
ion emulation in the host, am I right?

Is it possible to just count the cycles in the guest from the guests's poin=
t of view?
I read the kvm-api.txt Documentation and the other documents a few times an=
d tried different approaches, so this mailing list is my last resort.

Thanks in advance!

Regards
Jan

--------------------------------------------------

APPENDIX:
// we are in el1
// init system registers
LDR X1, =3D0x30C50838
MSR SCTLR_EL1, X1

// enable access to pmu counters from el0
mov x0, 0xff
mrs x1, currentel
mrs x7, pmuserenr_el0
orr x7, x7, #0b1111
msr pmuserenr_el0, x7

// set pmcr register (control register)
//enable long counter, count every cycle and enable counters
mrs x5, pmcr_el0
orr x5, x5, #0b1
orr x5, x5, #(1<<6)
eor x5, x5, #(1<<3)
eor x5, x5, #(1<<5)
msr pmcr_el0, x5

// read mvccfiltr register (only enable counting of el1)
mrs x6, pmccfiltr_el0
mov x6, #(1<<30)
msr pmccfiltr_el0, x6

// get interrupt configuration and clear overflow bit
mrs x9, pmintenset_el1
mov x8, #(1<<31)
msr pmovsclr_el0, x8

// write counter
mov x0, #0x0
msr pmccntr_el0, x0 // write counter

// enable cycle counter
mov x1, #(1<<31)
msr pmcntenset_el0, x1
mov x0, #0x2 */

// dummy instruction and provoke mmio-exit
mov x1, #0x3
add x2, x0, x1
mov x2, 0x5000

//read counter
mrs x1, pmccntr_el0

// read overflow
mrs x8, pmovsclr_el0

// provoke mmio exit (0x500 is not mapped)
ldr x3, [x2]

--_000_93B846538060DA46A9945E98A2E521E9A87A9CDE02WEMBXBinterna_
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
<p class=3D"MsoNormal">Hi,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I am not sure if this question is well-placed here, =
so sorry if it misses the purpose of this mailing list.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">My name is Jan and i am currently writing my master&=
#8217;s thesis.<o:p></o:p></p>
<p class=3D"MsoNormal">I am using the Kvm Api and try to integrate it as an=
 instruction set simulator in a SystemC environment.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Anyway,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I need some mechanism to count executed instructions=
 in the guest (or cycles).<o:p></o:p></p>
<p class=3D"MsoNormal">Currently I am trying to use the emulated PMU cycle =
counter in the guest to get the number of executed cycles in the guest.<o:p=
></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I am working on Arm64 and use Linux Kernel 4.14.33.<=
o:p></o:p></p>
<p class=3D"MsoNormal">I create the PMU device without creating a in-kernel=
 vgic.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Basically I create a vcpu and run some bare metal co=
de.<o:p></o:p></p>
<p class=3D"MsoNormal">For convienence, I append the critical assembler sni=
ppet.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I configure the counter, then start the counter, exe=
cute 3 or 4 dummy instructions and read the counter again and then exit the=
 guest with an exit_mmio.<o:p></o:p></p>
<p class=3D"MsoNormal">I assumed the value should be a very small number, a=
s the guest only executed a few instructions.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">The thing is as I read the counter, the value is som=
ething like 2970 or 0 (changes in each run).<o:p></o:p></p>
<p class=3D"MsoNormal">So to me it looks like the counter is also counting =
the cycles for instruction emulation in the host, am I right?<o:p></o:p></p=
>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Is it possible to just count the cycles in the guest=
 from the guests&#8217;s point of view?<o:p></o:p></p>
<p class=3D"MsoNormal">I read the kvm-api.txt Documentation and the other d=
ocuments a few times and tried different approaches, so this mailing list i=
s my last resort.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks in advance!<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Regards<o:p></o:p></p>
<p class=3D"MsoNormal">Jan<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">--------------------------------------------------<o=
:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">APPENDIX: <o:p></o:p></p>
<p class=3D"MsoNormal">// we are in el1<o:p></o:p></p>
<p class=3D"MsoNormal">// init system registers<o:p></o:p></p>
<p class=3D"MsoNormal">LDR X1, =3D0x30C50838<o:p></o:p></p>
<p class=3D"MsoNormal">MSR SCTLR_EL1, X1<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">// enable access to pmu counters from el0<o:p></o:p>=
</p>
<p class=3D"MsoNormal">mov x0, 0xff<o:p></o:p></p>
<p class=3D"MsoNormal">mrs x1, currentel<o:p></o:p></p>
<p class=3D"MsoNormal">mrs x7, pmuserenr_el0<o:p></o:p></p>
<p class=3D"MsoNormal">orr x7, x7, #0b1111<o:p></o:p></p>
<p class=3D"MsoNormal">msr pmuserenr_el0, x7<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">// set pmcr register (control register)<o:p></o:p></=
p>
<p class=3D"MsoNormal">//enable long counter, count every cycle and enable =
counters<o:p></o:p></p>
<p class=3D"MsoNormal">mrs x5, pmcr_el0<o:p></o:p></p>
<p class=3D"MsoNormal">orr x5, x5, #0b1<o:p></o:p></p>
<p class=3D"MsoNormal">orr x5, x5, #(1&lt;&lt;6)<o:p></o:p></p>
<p class=3D"MsoNormal">eor x5, x5, #(1&lt;&lt;3)<o:p></o:p></p>
<p class=3D"MsoNormal">eor x5, x5, #(1&lt;&lt;5)<o:p></o:p></p>
<p class=3D"MsoNormal">msr pmcr_el0, x5<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">// read mvccfiltr register (only enable counting of =
el1)<o:p></o:p></p>
<p class=3D"MsoNormal">mrs x6, pmccfiltr_el0<o:p></o:p></p>
<p class=3D"MsoNormal">mov x6, #(1&lt;&lt;30)<o:p></o:p></p>
<p class=3D"MsoNormal">msr pmccfiltr_el0, x6<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">// get interrupt configuration and clear overflow bi=
t<o:p></o:p></p>
<p class=3D"MsoNormal">mrs x9, pmintenset_el1<o:p></o:p></p>
<p class=3D"MsoNormal">mov x8, #(1&lt;&lt;31)<o:p></o:p></p>
<p class=3D"MsoNormal">msr pmovsclr_el0, x8<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">// write counter <o:p></o:p></p>
<p class=3D"MsoNormal">mov x0, #0x0<o:p></o:p></p>
<p class=3D"MsoNormal">msr pmccntr_el0, x0 // write counter<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">// enable cycle counter<o:p></o:p></p>
<p class=3D"MsoNormal">mov x1, #(1&lt;&lt;31)<o:p></o:p></p>
<p class=3D"MsoNormal">msr pmcntenset_el0, x1<o:p></o:p></p>
<p class=3D"MsoNormal">mov x0, #0x2 */<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">// dummy instruction and provoke mmio-exit<o:p></o:p=
></p>
<p class=3D"MsoNormal">mov x1, #0x3<o:p></o:p></p>
<p class=3D"MsoNormal">add x2, x0, x1<o:p></o:p></p>
<p class=3D"MsoNormal">mov x2, 0x5000<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">//read counter<o:p></o:p></p>
<p class=3D"MsoNormal">mrs x1, pmccntr_el0<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">// read overflow<o:p></o:p></p>
<p class=3D"MsoNormal">mrs x8, pmovsclr_el0<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">// provoke mmio exit (0x500 is not mapped)<o:p></o:p=
></p>
<p class=3D"MsoNormal">ldr x3, [x2]<o:p></o:p></p>
</div>
</body>
</html>

--_000_93B846538060DA46A9945E98A2E521E9A87A9CDE02WEMBXBinterna_--

--===============7421706474231865704==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7421706474231865704==--
