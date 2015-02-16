From: Alexander Spyridakis <a.spyridakis@virtualopensystems.com>
Subject: Re: vexpress: Framebuffer broken with KVM enabled
Date: Mon, 16 Feb 2015 10:34:28 +0100
Message-ID: <CAJRNFKLG2k6+4v2p-A22v36TLFX=djkx9cH1wK_qAcQ0M_vCoQ@mail.gmail.com>
References: <54E1B4BA.3030705@web.de>
 <CAAhSdy3mNAm6Jt=s3Nt_fy_z=mMf3kG3DqYW3jROTo-ztUGzkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2265059051539688901=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D4B745C33
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Feb 2015 04:29:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NgZ8Gtf4Rh0J for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Feb 2015 04:29:10 -0500 (EST)
Received: from mail-qg0-f46.google.com (mail-qg0-f46.google.com
 [209.85.192.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C36745C30
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Feb 2015 04:29:09 -0500 (EST)
Received: by mail-qg0-f46.google.com with SMTP id z107so22490732qgd.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Feb 2015 01:34:30 -0800 (PST)
Received: from mail-yk0-f173.google.com (mail-yk0-f173.google.com.
 [209.85.160.173])
 by mx.google.com with ESMTPSA id 7sm3510338qhv.8.2015.02.16.01.34.28
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 16 Feb 2015 01:34:29 -0800 (PST)
Received: by mail-yk0-f173.google.com with SMTP id 19so12768939ykq.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Feb 2015 01:34:28 -0800 (PST)
In-Reply-To: <CAAhSdy3mNAm6Jt=s3Nt_fy_z=mMf3kG3DqYW3jROTo-ztUGzkw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jan Kiszka <jan.kiszka@web.de>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

--===============2265059051539688901==
Content-Type: multipart/alternative; boundary=089e0160cff6ed0d45050f314aa6

--089e0160cff6ed0d45050f314aa6
Content-Type: text/plain; charset=UTF-8

On Mon, Feb 16, 2015 at 2:43 PM, Jan Kiszka <jan.kiszka@web.de> wrote:
> Hi,
>
> next issue related to KVM/QEMU on the TK1: The guest image I'm running
> gives proper framebuffer output when in emulation mode. Once KVM is
> enabled, the screen is - at best - only initially updated. Sometimes I
> see the famous tux images and a bit of the console texts, but usually it
> stays black. Explanations?

Hello Jan,

If you want to force rendering, you can do something similar with the
following hack:
https://github.com/virtualopensystems/qemu/commit/64dd1b3e3a2353433edb9c63d00271f515bd06fb

Of course expect performance to not be up to par.

Best regards.

--089e0160cff6ed0d45050f314aa6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On M=
on, Feb 16, 2015 at 2:43 PM, Jan Kiszka &lt;<a href=3D"mailto:jan.kiszka@we=
b.de">jan.kiszka@web.de</a>&gt; wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; next issue related to KVM/QEMU on the TK1: The guest image I&#39;m run=
ning<br>
&gt; gives proper framebuffer output when in emulation mode. Once KVM is<br=
>
&gt; enabled, the screen is - at best - only initially updated. Sometimes I=
<br>
&gt; see the famous tux images and a bit of the console texts, but usually =
it<br>
&gt; stays black. Explanations?<br><br></div><div class=3D"gmail_quote">Hel=
lo Jan,<br><br></div><div class=3D"gmail_quote">If you want to force render=
ing, you can do something similar with the following hack:<br><a href=3D"ht=
tps://github.com/virtualopensystems/qemu/commit/64dd1b3e3a2353433edb9c63d00=
271f515bd06fb">https://github.com/virtualopensystems/qemu/commit/64dd1b3e3a=
2353433edb9c63d00271f515bd06fb</a><br><br></div><div class=3D"gmail_quote">=
Of course expect performance to not be up to par.<br><br></div><div class=
=3D"gmail_quote">Best regards.<br></div><div class=3D"gmail_quote"><br></di=
v></div></div>

--089e0160cff6ed0d45050f314aa6--

--===============2265059051539688901==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2265059051539688901==--
