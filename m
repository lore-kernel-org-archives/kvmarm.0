From: Raz <raziebe@gmail.com>
Subject: A question about TTBRs
Date: Fri, 24 Feb 2017 09:55:09 +0000
Message-ID: <CAPB=Z-omrvPjkjmQWfLNWtA86XJzEM1wCB1Rbc-2dnd0iUtaDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8793467008463196927=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C881F40C3E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 04:54:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zeGzPDmvDauN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Feb 2017 04:54:31 -0500 (EST)
Received: from mail-lf0-f51.google.com (mail-lf0-f51.google.com
 [209.85.215.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC29440B5E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 04:54:30 -0500 (EST)
Received: by mail-lf0-f51.google.com with SMTP id b80so6768242lfe.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 01:55:32 -0800 (PST)
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

--===============8793467008463196927==
Content-Type: multipart/alternative; boundary=001a1140805edd6e32054943ba6c

--001a1140805edd6e32054943ba6c
Content-Type: text/plain; charset=UTF-8

Hello
I am reading the arm8a book. According to the documentation the output
address of each level 3 entry in TTBRx_EL1points to an address in the
physical memory.
By looking in the mmu tab in the DS5 studio I can see the TTBRs tables.

What I do not understand is why while I have 2GB of RAM in the FVP (
/proc/meminfo ) some page entries ( level 3 ) of the ttbr points to memory
above 4GB; for instance:

Output address NP:0xF794D000

Doesn't the physical memory starts at address zero ? if not, where its
starting point is configured?

Thank you
Raz

--001a1140805edd6e32054943ba6c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>Hello<br>I am reading the arm8a book. =
According to the documentation the output address of each level 3 entry in =
TTBRx_EL1points to an address in the physical memory.<br></div>By looking i=
n the mmu tab in the DS5 studio I can see the TTBRs tables. <br><br>What I =
do not understand is why while I have 2GB of RAM in the FVP ( /proc/meminfo=
 ) some page entries ( level 3 ) of the ttbr points to memory above 4GB; fo=
r instance:<br><br>Output address NP:0xF794D000<br><br> </div>Doesn&#39;t t=
he physical memory starts at address zero ? if not, where its starting poin=
t is configured? <br><br></div>Thank you<br></div>Raz<br></div>

--001a1140805edd6e32054943ba6c--

--===============8793467008463196927==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8793467008463196927==--
