From: Raz <raziebe@gmail.com>
Subject: unmap_ptes is not complete
Date: Mon, 27 Nov 2017 21:10:56 +0000
Message-ID: <CAPB=Z-piv-Fe+7p9xH8TuZ=xH6oJHmh2+g+Dk6gJRagixseL_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5464724126174458183=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A102E49D95
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Nov 2017 16:08:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qPXgLrHydNbC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Nov 2017 16:08:29 -0500 (EST)
Received: from mail-lf0-f53.google.com (mail-lf0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A497949D6C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Nov 2017 16:08:29 -0500 (EST)
Received: by mail-lf0-f53.google.com with SMTP id o41so34402113lfi.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Nov 2017 13:11:19 -0800 (PST)
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

--===============5464724126174458183==
Content-Type: multipart/alternative; boundary="94eb2c1a66c4d98bd5055efd5774"

--94eb2c1a66c4d98bd5055efd5774
Content-Type: text/plain; charset="UTF-8"

Hey
in mmu.c unmap_ptes() you invalidate *pte but not the pte itself. This
leads to inconsistency in el2 translation tables. ie; the pte entry is
cleared in the cached memory but not in the RAM, so the entry may still be
valid in EL2 translation tables.
You should also clear pte itself.

Kind Regards
Raz

--94eb2c1a66c4d98bd5055efd5774
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Hey <br></div>in mmu.c unmap_ptes() you inv=
alidate *pte but not the pte itself. This leads to inconsistency in el2 tra=
nslation tables. ie; the pte entry is cleared in the cached memory but not =
in the RAM, so the entry may still be valid in EL2 translation tables. <br>=
</div>You should also clear pte itself.<br>=C2=A0<br></div><div>Kind Regard=
s<br></div>Raz<br></div>

--94eb2c1a66c4d98bd5055efd5774--

--===============5464724126174458183==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5464724126174458183==--
