From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v7 1/6] KVM: arm/arm64: Add VGICv3 save/restore API
 documentation
Date: Wed, 20 Apr 2016 12:03:02 +0100
Message-ID: <CAMJs5B_Q63ta90vG7jb+0vm9v2dsKxmVcaGUHUU6_ZQAOQQVYg@mail.gmail.com>
References: <cover.1449491035.git.p.fedin@samsung.com>
 <204d6b178e611ee0b5aede2b945516e0a6048c3c.1449491035.git.p.fedin@samsung.com>
 <CAFEAcA_N7F4r6fpQTW8Duyu577=uGcRyS7VhAMxumwTDN3khcw@mail.gmail.com>
 <CAFEAcA9qodmWdmEnB9e-0F3RdTtC5N6x82-dKHVJnncdhau+tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0055030427735698226=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5275449B82
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2016 07:01:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wp647SqyxwE7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2016 07:01:04 -0400 (EDT)
Received: from mail-yw0-f180.google.com (mail-yw0-f180.google.com
 [209.85.161.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 237BB49B81
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2016 07:01:03 -0400 (EDT)
Received: by mail-yw0-f180.google.com with SMTP id o66so49009719ywc.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2016 04:03:03 -0700 (PDT)
In-Reply-To: <CAFEAcA9qodmWdmEnB9e-0F3RdTtC5N6x82-dKHVJnncdhau+tw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

--===============0055030427735698226==
Content-Type: multipart/alternative; boundary=001a1143e690a04f680530e88968

--001a1143e690a04f680530e88968
Content-Type: text/plain; charset=UTF-8

On Monday, 18 April 2016, Peter Maydell <peter.maydell@linaro.org> wrote:

> On 15 April 2016 at 14:58, Peter Maydell <peter.maydell@linaro.org
> <javascript:;>> wrote:
> > Nothing in here describes a mechanism for reading or writing the
> > current interrupt line_level state from the kernel (which doesn't
> > matter for edge triggered interrupts but does for level triggered
> > interrupts). Do we need accessors for these or does somebody
> > have a good rationale for why we don't need to migrate that data?
> > (Christoffer?)
>
> Relatedly, we should have a mechanism for directly reading and
> writing the pending-latch state in the KVM GIC, which for
> a level triggered interrupt is not the same as the behaviour
> of reading and writing the PENDING register.
>
>
Strictly speaking, yes. But can we think of a use case that would really
need this?

(I saw this as a thing that was implemented for software to capture the
state of the gic and restore it, but since that's what we're doing here, it
seems redundant)

Thanks,
-Christoffer

--001a1143e690a04f680530e88968
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br>On Monday, 18 April 2016, Peter Maydell &lt;<a href=3D"mailto:peter=
.maydell@linaro.org">peter.maydell@linaro.org</a>&gt; wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">On 15 April 2016 at 14:58, Peter Maydell &lt;<a href=3D=
"javascript:;" onclick=3D"_e(event, &#39;cvml&#39;, &#39;peter.maydell@lina=
ro.org&#39;)">peter.maydell@linaro.org</a>&gt; wrote:<br>
&gt; Nothing in here describes a mechanism for reading or writing the<br>
&gt; current interrupt line_level state from the kernel (which doesn&#39;t<=
br>
&gt; matter for edge triggered interrupts but does for level triggered<br>
&gt; interrupts). Do we need accessors for these or does somebody<br>
&gt; have a good rationale for why we don&#39;t need to migrate that data?<=
br>
&gt; (Christoffer?)<br>
<br>
Relatedly, we should have a mechanism for directly reading and<br>
writing the pending-latch state in the KVM GIC, which for<br>
a level triggered interrupt is not the same as the behaviour<br>
of reading and writing the PENDING register.<br><br>
</blockquote><div><br></div><div>Strictly speaking, yes. But can we think o=
f a use case that would really need this?</div><div><br></div><div>(I saw t=
his as a thing that was implemented for software to capture the state of th=
e gic=C2=A0and restore it, but since that&#39;s what we&#39;re doing here, =
it seems redundant)</div><div><br></div><div>Thanks,</div><div>-Christoffer=
</div>

--001a1143e690a04f680530e88968--

--===============0055030427735698226==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0055030427735698226==--
