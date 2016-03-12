From: Fernando Endo <fernando.endo2@gmail.com>
Subject: [Question] Linux 3.10 supporting AArch64 KVM
Date: Sat, 12 Mar 2016 12:22:17 +0100
Message-ID: <CAG=tD+-ChHd4c+f0Y8PGcJUpb32nWSv34yfNDwY3JEU7AV+KQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1325801373717811695=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96D9140FA2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Mar 2016 06:22:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qUJhrkIm6dDq for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Mar 2016 06:22:05 -0500 (EST)
Received: from mail-oi0-f53.google.com (mail-oi0-f53.google.com
 [209.85.218.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88EE840F90
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Mar 2016 06:22:05 -0500 (EST)
Received: by mail-oi0-f53.google.com with SMTP id c203so103597619oia.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Mar 2016 03:22:17 -0800 (PST)
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

--===============1325801373717811695==
Content-Type: multipart/alternative; boundary=001a113ceea699c9ee052dd84262

--001a113ceea699c9ee052dd84262
Content-Type: text/plain; charset=UTF-8

Hello,

I'd like to know what kernel versions KVM is known to work for AArch64.
More specifically, if the Linux 3.10 of the Nvidia Tegra TX1 could support
KVM.

The released 3.10 kernel does not have the KVM flags enabled, so I suspect
that this version does not actually support KVM for AArch64.

Thanks in advance,

--
Fernando A. Endo, Post-doc

INRIA Rennes-Bretagne Atlantique
France

--001a113ceea699c9ee052dd84262
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hello,</div><div><br></div><div>I&#39;d like to know =
what kernel versions KVM is known to work for AArch64. More specifically, i=
f the Linux 3.10 of the Nvidia Tegra TX1 could support KVM.</div><div><br><=
/div><div>The released 3.10 kernel does not have the KVM flags enabled, so =
I suspect that this version does not actually support KVM for AArch64.</div=
><div><br></div><div>Thanks in advance,</div><br clear=3D"all"><div><div cl=
ass=3D"gmail_signature"><div dir=3D"ltr"><div>--<br>Fernando A. Endo, Post-=
doc<br><br>INRIA Rennes-Bretagne Atlantique<br>France<br><br></div></div></=
div></div>
</div>

--001a113ceea699c9ee052dd84262--

--===============1325801373717811695==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1325801373717811695==--
