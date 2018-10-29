From: Vishnu Pajjuri <Vishnu.Pajjuri@amperecomputing.com>
Subject: Nested Virtualization on ARM v8.0
Date: Mon, 29 Oct 2018 06:37:10 +0000
Message-ID: <DM5PR01MB2219E3F549A69A81C9D7818285F30@DM5PR01MB2219.prod.exchangelabs.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7638038404506825681=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 334784A2E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Oct 2018 02:37:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JZvELCMisZf7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Oct 2018 02:37:12 -0400 (EDT)
Received: from NAM02-CY1-obe.outbound.protection.outlook.com
 (mail-cys01nam02on0135.outbound.protection.outlook.com [104.47.37.135])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22DBE4A0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Oct 2018 02:37:12 -0400 (EDT)
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

--===============7638038404506825681==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_DM5PR01MB2219E3F549A69A81C9D7818285F30DM5PR01MB2219prod_"

--_000_DM5PR01MB2219E3F549A69A81C9D7818285F30DM5PR01MB2219prod_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi all,
     I'm trying Nested Virtualization feature on eMAG(ARMv8) platform, coul=
d you please tell us the setup details in detail. Means how you guys ran Ne=
sted Virtualization on ARM platform.
Also could you please tell us the kernel version and kernel source from any=
 git repo(mention kernel parameters if used any) and QEMU version and QEMU =
source from git repo with parameters passed.

If you guys have any VM disks used to verify this feature, could you please=
 share those details as well. Share if any other details required

Appreciate your help, cooperation, and patience

Regards,
-Vishnu.


CONFIDENTIALITY NOTICE: This e-mail message, including any attachments, is =
for the sole use of the intended recipient(s) and contains information that=
 is confidential and proprietary to Ampere Computing or its subsidiaries. I=
t is to be used solely for the purpose of furthering the parties' business =
relationship. Any review, copying, or distribution of this email (or any at=
tachments thereto) is strictly prohibited. If you are not the intended reci=
pient, please contact the sender immediately and permanently delete the ori=
ginal and any copies of this email and any attachments thereto.

--_000_DM5PR01MB2219E3F549A69A81C9D7818285F30DM5PR01MB2219prod_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
</head>
<body dir=3D"ltr">
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;font=
-family:Calibri,Helvetica,sans-serif;" dir=3D"ltr">
<p style=3D"margin-top:0;margin-bottom:0"></p>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 16px;=
 margin-top: 0px; margin-bottom: 0px;">
Hi all,</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 16px;=
 margin-top: 0px; margin-bottom: 0px;">
&nbsp; &nbsp; &nbsp;I'm trying Nested Virtualization feature on eMAG(ARMv8)=
 platform, could you please tell us the setup details in detail. Means how =
you guys ran Nested Virtualization on ARM&nbsp;platform.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 16px;=
 margin-top: 0px; margin-bottom: 0px;">
Also could you please tell us the kernel version and kernel source from any=
 git repo(mention kernel parameters if used any) and QEMU version and QEMU =
source from git repo with parameters passed.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 16px;=
 margin-top: 0px; margin-bottom: 0px;">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 16px;=
 margin-top: 0px; margin-bottom: 0px;">
If you guys have any VM disks used to verify this feature, could you please=
 share those details as well. Share if any other details required</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 16px;=
 margin-top: 0px; margin-bottom: 0px;">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 16px;=
 margin-top: 0px; margin-bottom: 0px;">
Appreciate your help, cooperation, and patience</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 16px;=
 margin-top: 0px; margin-bottom: 0px;">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 16px;=
 margin-top: 0px; margin-bottom: 0px;">
<u>Regards</u>,</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 16px;=
 margin-top: 0px; margin-bottom: 0px;">
-Vishnu.</div>
<br>
<p></p>
</div>
CONFIDENTIALITY NOTICE: This e-mail message, including any attachments, is =
for the sole use of the intended recipient(s) and contains information that=
 is confidential and proprietary to Ampere Computing or its subsidiaries. I=
t is to be used solely for the purpose
 of furthering the parties' business relationship. Any review, copying, or =
distribution of this email (or any attachments thereto) is strictly prohibi=
ted. If you are not the intended recipient, please contact the sender immed=
iately and permanently delete the
 original and any copies of this email and any attachments thereto.
</body>
</html>

--_000_DM5PR01MB2219E3F549A69A81C9D7818285F30DM5PR01MB2219prod_--

--===============7638038404506825681==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7638038404506825681==--
