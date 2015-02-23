From: Ronald Minnich <rminnich@google.com>
Subject: Re: stand-alone kvmtool
Date: Mon, 23 Feb 2015 16:35:43 +0000
Message-ID: <CAPAv03N7crW93BZYD34wg=yuKumE7NYjMKzsYTEQmGXgq200dQ@mail.gmail.com>
References: <54DDD465.3050300@arm.com> <54E5C16D.3060109@oracle.com>
 <20150223142721.GC5609@cbox>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1470676377825867010=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5010F465C3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 11:30:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dd+McRRQT88c for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Feb 2015 11:30:05 -0500 (EST)
Received: from mail-ob0-f178.google.com (mail-ob0-f178.google.com
 [209.85.214.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 735E54659C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 11:30:04 -0500 (EST)
Received: by mail-ob0-f178.google.com with SMTP id uz6so37425420obc.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 08:35:44 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Sasha Levin <sasha.levin@oracle.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>, Asias He <asias.hejun@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

--===============1470676377825867010==
Content-Type: multipart/alternative; boundary=001a113ce1ee5ddc61050fc3fe46

--001a113ce1ee5ddc61050fc3fe46
Content-Type: text/plain; charset=UTF-8

I much prefer kvmtool to be standalone outside the kernel tree. I don't see
any benefit in putting it in the kernel or putting the kernel in it.

I think Andre is doing the right thing here.

ron

--001a113ce1ee5ddc61050fc3fe46
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I much prefer kvmtool to be standalone outside the kernel =
tree. I don&#39;t see any benefit in putting it in the kernel or putting th=
e kernel in it.<div><br></div><div>I think Andre is doing the right thing h=
ere.</div><div><br></div><div>ron</div></div>

--001a113ce1ee5ddc61050fc3fe46--

--===============1470676377825867010==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1470676377825867010==--
