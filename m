From: Vishnu Pajjuri <vishnu.socialac@gmail.com>
Subject: Nested Virtualization on ARM v8.0
Date: Mon, 29 Oct 2018 12:06:16 +0530
Message-ID: <CAPtinC099M+AdQZGb46xAVJ5JfVUZ-ZriYe1fu-vvm9jc5SVRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8474604080581356812=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A36D14A2E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Oct 2018 02:36:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7evAXbfqitqD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Oct 2018 02:36:29 -0400 (EDT)
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com
 [209.85.160.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BDA564A0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Oct 2018 02:36:29 -0400 (EDT)
Received: by mail-qt1-f171.google.com with SMTP id u34-v6so7999852qth.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Oct 2018 23:36:29 -0700 (PDT)
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

--===============8474604080581356812==
Content-Type: multipart/alternative; boundary="0000000000000223460579584a6d"

--0000000000000223460579584a6d
Content-Type: text/plain; charset="UTF-8"

Hi all,
     I'm trying Nested Virtualization feature on eMAG(ARMv8) platform,
could you please tell us the setup details in detail. Means how you guys
ran Nested Virtualization on ARM platform.
Also could you please tell us the kernel version and kernel source from any
git repo(mention kernel parameters if used any) and QEMU version and QEMU
source from git repo with parameters passed.

If you guys have any VM disks used to verify this feature, could you please
share those details as well. Share if any other details required

Appreciate your help, cooperation, and patience

*Regards*,
-Vishnu.

--0000000000000223460579584a6d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div style=3D"color:rgb(0,0,0);font-family:Calibri,Helveti=
ca,sans-serif;font-size:16px;margin-top:0px;margin-bottom:0px">Hi all,</div=
><div style=3D"color:rgb(0,0,0);font-family:Calibri,Helvetica,sans-serif;fo=
nt-size:16px;margin-top:0px;margin-bottom:0px">=C2=A0 =C2=A0 =C2=A0I&#39;m =
trying Nested Virtualization feature on eMAG(ARMv8) platform, could you ple=
ase tell us the setup details in detail. Means how you guys ran Nested Virt=
ualization on ARM=C2=A0platform.</div><div style=3D"color:rgb(0,0,0);font-f=
amily:Calibri,Helvetica,sans-serif;font-size:16px;margin-top:0px;margin-bot=
tom:0px">Also could you please tell us the kernel version and kernel source=
 from any git repo(mention kernel parameters if used any) and QEMU version =
and QEMU source from git repo with parameters passed.</div><div style=3D"co=
lor:rgb(0,0,0);font-family:Calibri,Helvetica,sans-serif;font-size:16px;marg=
in-top:0px;margin-bottom:0px"><br></div><div style=3D"color:rgb(0,0,0);font=
-family:Calibri,Helvetica,sans-serif;font-size:16px;margin-top:0px;margin-b=
ottom:0px">If you guys have any VM disks used to verify this feature, could=
 you please share those details as well. Share if any other details require=
d</div><div style=3D"color:rgb(0,0,0);font-family:Calibri,Helvetica,sans-se=
rif;font-size:16px;margin-top:0px;margin-bottom:0px"><br></div><div style=
=3D"color:rgb(0,0,0);font-family:Calibri,Helvetica,sans-serif;font-size:16p=
x;margin-top:0px;margin-bottom:0px">Appreciate your help, cooperation, and =
patience</div><div style=3D"color:rgb(0,0,0);font-family:Calibri,Helvetica,=
sans-serif;font-size:16px;margin-top:0px;margin-bottom:0px"><br></div><div =
style=3D"color:rgb(0,0,0);font-family:Calibri,Helvetica,sans-serif;font-siz=
e:16px;margin-top:0px;margin-bottom:0px"><u>Regards</u>,</div><div style=3D=
"color:rgb(0,0,0);font-family:Calibri,Helvetica,sans-serif;font-size:16px;m=
argin-top:0px;margin-bottom:0px">-Vishnu.</div></div>

--0000000000000223460579584a6d--

--===============8474604080581356812==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8474604080581356812==--
