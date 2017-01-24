From: Raz <raziebe@gmail.com>
Subject: Booting a kernel to EL1 in Armv8.1
Date: Tue, 24 Jan 2017 21:50:04 +0000
Message-ID: <CAPB=Z-pGjZ398fZuUeR2EsOnVf-0Qp3m4ckdeCBniKZmjs25Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7701513298441636093=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66E5640969
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Jan 2017 16:50:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GR6vrzQvVPDy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Jan 2017 16:50:19 -0500 (EST)
Received: from mail-lf0-f67.google.com (mail-lf0-f67.google.com
 [209.85.215.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71C1140019
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Jan 2017 16:50:19 -0500 (EST)
Received: by mail-lf0-f67.google.com with SMTP id h65so18725514lfi.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Jan 2017 13:50:26 -0800 (PST)
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

--===============7701513298441636093==
Content-Type: multipart/alternative; boundary=94eb2c1a09e481df2e0546de1a8b

--94eb2c1a09e481df2e0546de1a8b
Content-Type: text/plain; charset=UTF-8

Hello

I am trying to boot EL1 kernel in a platform based on Armv8.1.
I am using fvp as a hardware.
What I am trying to achieve is to execute some kernel code in
EL2 exception level..

The current VHE patch is booting the kernel into EL2. So I took an older
kernel
and I tried to set  TTBR1_EL2 to access kernel memory as if it is TTBR1_EL1
.

It is theoretically possible ?
Setting TTBR1_EL2 to TTBR1_EL1
and enabling mmu  thtough sctlr_el2 does not work.

thank you
Raz

--94eb2c1a09e481df2e0546de1a8b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div><div><div><div><div><div><div>Hel=
lo<br><br></div>I am trying to boot EL1 kernel in a platform based on Armv8=
.1.<br></div>I am using fvp as a hardware.<br>What I am trying to achieve i=
s to execute some kernel code in<br></div>EL2 exception level..<br>=C2=A0 <=
br></div>The current VHE patch is booting the kernel into EL2. So I took an=
 older kernel <br></div>and I tried to set=C2=A0 TTBR1_EL2 to access kernel=
 memory as if it is TTBR1_EL1 .<br></div><br></div>It is theoretically poss=
ible ?<br></div>Setting TTBR1_EL2 to TTBR1_EL1<br></div>and enabling mmu=C2=
=A0 thtough sctlr_el2 does not work.<br><br></div>thank you<br></div>Raz<br=
><br></div>

--94eb2c1a09e481df2e0546de1a8b--

--===============7701513298441636093==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7701513298441636093==--
