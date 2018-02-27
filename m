From: <bthakur@codeaurora.org>
Subject: VCPU hotplug on KVM/ARM
Date: Tue, 27 Feb 2018 15:01:17 +0530
Message-ID: <000e01d3afad$b9a13830$2ce3a890$@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1094332515934909775=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EA0340257
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 04:24:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sBOpmd+3B0IA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Feb 2018 04:24:29 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 070B1401CD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 04:24:29 -0500 (EST)
Received: from BTHAKUR (blr-bdr-fw-01_globalnat_allzones-outside.qualcomm.com
 [103.229.18.19])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 (Authenticated sender: bthakur@codeaurora.org)
 by smtp.codeaurora.org (Postfix) with ESMTPSA id DEB8C6024C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 09:31:19 +0000 (UTC)
Content-Language: en-us
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

This is a multipart message in MIME format.

--===============1094332515934909775==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_000F_01D3AFDB.D359E960"
Content-Language: en-us

This is a multipart message in MIME format.

------=_NextPart_000_000F_01D3AFDB.D359E960
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

 

I hope it is the right forum to post my query.

 

I am currently looking at the possibility of adding a new VCPU to a running
guest VM in KVM/ARM. I see that currently, it is not allowed to add a new
VCPU to a guest VM, if it is already initialized. The first check in
kvm_arch_vcpu_create() returns failure if it is already initialized.

 

There was some work done in QEMU to add support for VCPU hotplug:
https://lists.gnu.org/archive/html/qemu-arm/2017-05/msg00404.html

 

But I am looking at the KVM side for enabling adding a new VCPU. If you can
point me to any relevant work/resources, which I can refer to then it will
help me.

 

Thanks.

 

Regards,

Bhupinder


------=_NextPart_000_000F_01D3AFDB.D359E960
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><meta =
http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii"><meta name=3DGenerator content=3D"Microsoft Word 15 =
(filtered medium)"><style><!--
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
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US =
link=3D"#0563C1" vlink=3D"#954F72"><div class=3DWordSection1><p =
class=3DMsoNormal>Hi,<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>I hope it is =
the right forum to post my query.<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>I am =
currently looking at the possibility of adding a new VCPU to a running =
guest VM in KVM/ARM. I see that currently, it is not allowed to add a =
new VCPU to a guest VM, if it is already initialized. The first check in =
kvm_arch_vcpu_create() returns failure if it is already =
initialized.<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>There was some work done in QEMU to add support for =
VCPU hotplug: <a =
href=3D"https://lists.gnu.org/archive/html/qemu-arm/2017-05/msg00404.html=
">https://lists.gnu.org/archive/html/qemu-arm/2017-05/msg00404.html</a><o=
:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>But I am looking at the KVM side for enabling adding a =
new VCPU. If you can point me to any relevant work/resources, which I =
can refer to then it will help me.<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>Thanks.<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>Regards,<o:p></o:p></p><p =
class=3DMsoNormal>Bhupinder<o:p></o:p></p></div></body></html>
------=_NextPart_000_000F_01D3AFDB.D359E960--


--===============1094332515934909775==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1094332515934909775==--
