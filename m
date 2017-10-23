From: Raz <raziebe@gmail.com>
Subject: MAIR_EL2 Attributes
Date: Mon, 23 Oct 2017 21:33:28 +0000
Message-ID: <CAPB=Z-qpezQAQ84hwpYVvqLuRczx-oMcjQvDQtH-T7u4B9YD6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2153107367879319886=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B06EA41185
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 17:32:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WaYHlURKYrn9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Oct 2017 17:32:35 -0400 (EDT)
Received: from mail-lf0-f41.google.com (mail-lf0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9670B40A74
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 17:32:35 -0400 (EDT)
Received: by mail-lf0-f41.google.com with SMTP id w21so21759141lfc.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 14:33:50 -0700 (PDT)
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

--===============2153107367879319886==
Content-Type: multipart/alternative; boundary="001a11402234ff1f55055c3d936f"

--001a11402234ff1f55055c3d936f
Content-Type: text/plain; charset="UTF-8"

1. According the documentation of MAIR_EL2 there are 8 attributes but
in the code you present only 6. Why ?
2. Why there are names to the attributes ? Does it make a difference if I
assign
an attribute index 2 or attribute index 0 in the page while the two attr

/*
 * Memory types available.
 */
#define MT_DEVICE_nGnRnE    0
#define MT_DEVICE_nGnRE        1
#define MT_DEVICE_GRE        2
#define MT_NORMAL_NC        3
#define MT_NORMAL        4
#define MT_NORMAL_WT        5

--001a11402234ff1f55055c3d936f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>1. According the documentation of MAIR_EL2 =
there are 8 attributes but<br></div>in the code you present only 6. Why ?<b=
r></div>2. Why there are names to the attributes ? Does it make a differenc=
e if I assign <br></div>an attribute index 2 or attribute index 0 in the pa=
ge while the two attr<br><div><div><div><br><div>/*<br>=C2=A0* Memory types=
 available.<br>=C2=A0*/<br>#define MT_DEVICE_nGnRnE=C2=A0=C2=A0=C2=A0 0<br>=
#define MT_DEVICE_nGnRE=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 1<br>#define M=
T_DEVICE_GRE=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 2<br>#define MT_NORMAL_NC=
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 3<br>#define MT_NORMAL=C2=A0=C2=A0=C2=
=A0 =C2=A0=C2=A0=C2=A0 4<br>#define MT_NORMAL_WT=C2=A0=C2=A0=C2=A0 =C2=A0=
=C2=A0=C2=A0 5<br><br><br></div></div></div></div></div>

--001a11402234ff1f55055c3d936f--

--===============2153107367879319886==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2153107367879319886==--
