Return-Path: <SRS0=8enQ=NL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 680EEC4338F
	for <kvmarm@archiver.kernel.org>; Fri, 20 Aug 2021 23:01:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D1FD86115B
	for <kvmarm@archiver.kernel.org>; Fri, 20 Aug 2021 23:01:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D1FD86115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 287F54B09C;
	Fri, 20 Aug 2021 19:01:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NPV9zwPAu3Dg; Fri, 20 Aug 2021 19:01:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31AC24B12D;
	Fri, 20 Aug 2021 19:01:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 341244B0F9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Aug 2021 19:01:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GMHSEjsAVmLR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Aug 2021 19:01:35 -0400 (EDT)
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com
 [209.85.221.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E575A4B09C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Aug 2021 19:01:35 -0400 (EDT)
Received: by mail-vk1-f176.google.com with SMTP id d15so2879097vko.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Aug 2021 16:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=MxHV2tp/iK+q5TmTlRZvJDv5bmB7s3sxhWGzAclwKWI=;
 b=tMGZIhseL9oriwWGUXkMbKht5LaDjQHJaQnwe+SNu24BIHOHqtCRdqpc/qiMQK2zGL
 1W3LtsgjT6Nsg+dOUHjfYUaWmt7zPZocQyLBWs8IKhUlNy8YSviv+w7e3uirxE7fu87D
 9qn/atUzaD/vsWn7NAcI0Gqgg53Nhim22FFDB8oSkTKwDle+TK7PK6YYOhU1vdf/s9i+
 ZOYz73BTKSW+28CIlPrL/umz0fiph9tN2TqZeNEmyu+oNqWflIA1Ai19pnWAV9cYhyVn
 SO2yVH7KQ5DE/EFfF9Mq8/hUSkmLMOSA2ZqpOw/70GqozGaPC1iSp4ws9T3XWTXE/0Ej
 EOUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=MxHV2tp/iK+q5TmTlRZvJDv5bmB7s3sxhWGzAclwKWI=;
 b=lDxb7LaKLuwZnC1QwgM3hiye8hm65GtHiVITDAzccT3l58EJwIPndz070ptuoScxws
 wKeGShEBj3hu5bO5ddhH4xAUDTPShgyzB9hncL/iuBEnr0vuRK0Q0lfcZBhNwMfakSpi
 hA9KKoKlGuoRkul3w8TuL+BLb7RmykTMW80M1IPJ90VM5lxKaC2m1cfA9F3SyDr3gvDP
 pWEmD35G2BMPPCTXTiuK7MqUE7zf9qQk+IpdhrCPURNvjLAZelk+54aZkTcljnczMUpZ
 fz4LVPdLfm03UyXLe3ALQgWwIaa0vrkv6gTMm+7QEUKFE107MBq+PBrV9sT5IkcGvh0X
 7jHA==
X-Gm-Message-State: AOAM530CxyIlgNF77xA53dup/4DYWIRmIEJocDmJvVhgqc54yruGSboQ
 9Y2P1uVPbWwSSIs4FgN4rZe+U82kmHsGeKgcY594rQ==
X-Google-Smtp-Source: ABdhPJyCtTQJz8GZHxPhWrSGprNtCmFCxXdjIFYVbclWAqNAw/ycqZBqiuhQCer2LIxSU+L2eEo8UlFWDVu+Ii81yTg=
X-Received: by 2002:a1f:a006:: with SMTP id j6mr17574680vke.14.1629500495235; 
 Fri, 20 Aug 2021 16:01:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210819223406.1132426-1-rananta@google.com>
 <87sfz4qx9r.wl-maz@kernel.org>
In-Reply-To: <87sfz4qx9r.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 20 Aug 2021 16:01:24 -0700
Message-ID: <CAJHc60wn7PP1zQ5EKOGQDFbZsf=d9codWTuWbtMT5AHegfbVHw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Ratelimit error log during guest debug
 exception
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3165373575672180969=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============3165373575672180969==
Content-Type: multipart/alternative; boundary="0000000000002e7da305ca05a621"

--0000000000002e7da305ca05a621
Content-Type: text/plain; charset="UTF-8"

On Fri, Aug 20, 2021 at 2:29 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 19 Aug 2021 23:34:06 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > Potentially, the guests could trigger a debug exception that's
> > outside the exception class range.
>
> How? All the exception classes that lead to this functions are already
> handled in the switch/case statement.
>
I guess I didn't think this through. Landing into kvm_handle_guest_debug()
itself is not possible :)

> > This could lead to an excessive syslog flooding. Hence, ratelimit
> > the error message.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/handle_exit.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index 04ebab299aa4..c7cec7ffe93c 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -134,7 +134,7 @@ static int kvm_handle_guest_debug(struct kvm_vcpu
*vcpu)
> >       case ESR_ELx_EC_BRK64:
> >               break;
> >       default:
> > -             kvm_err("%s: un-handled case esr: %#08x\n",
> > +             kvm_pr_unimpl("%s: un-handled case esr: %#08x\n",
> >                       __func__, (unsigned int) esr);
> >               ret = -1;
> >               break;
>
> My take on this is that this code isn't reachable, and that it could
> be better rewritten as:
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 6f48336b1d86..ae7ec086827b 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -119,28 +119,14 @@ static int kvm_handle_guest_debug(struct kvm_vcpu
*vcpu)
>  {
>         struct kvm_run *run = vcpu->run;
>         u32 esr = kvm_vcpu_get_esr(vcpu);
> -       int ret = 0;
>
>         run->exit_reason = KVM_EXIT_DEBUG;
>         run->debug.arch.hsr = esr;
>
> -       switch (ESR_ELx_EC(esr)) {
> -       case ESR_ELx_EC_WATCHPT_LOW:
> +       if (ESR_ELx_EC(esr) ==  ESR_ELx_EC_WATCHPT_LOW)
>                 run->debug.arch.far = vcpu->arch.fault.far_el2;
> -               fallthrough;
> -       case ESR_ELx_EC_SOFTSTP_LOW:
> -       case ESR_ELx_EC_BREAKPT_LOW:
> -       case ESR_ELx_EC_BKPT32:
> -       case ESR_ELx_EC_BRK64:
> -               break;
> -       default:
> -               kvm_err("%s: un-handled case esr: %#08x\n",
> -                       __func__, (unsigned int) esr);
> -               ret = -1;
> -               break;
> -       }
>
> -       return ret;
> +       return 0;
>  }
>
This looks better, but do you think we would be compromising on readability?

Regards,
Raghavendra

>  static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

--0000000000002e7da305ca05a621
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br>On Fri, Aug 20, 2021 at 2:29 AM Marc Zyngier &lt;<=
a href=3D"mailto:maz@kernel.org">maz@kernel.org</a>&gt; wrote:<br>&gt;<br>&=
gt; On Thu, 19 Aug 2021 23:34:06 +0100,<br>&gt; Raghavendra Rao Ananta &lt;=
<a href=3D"mailto:rananta@google.com">rananta@google.com</a>&gt; wrote:<br>=
&gt; &gt;<br>&gt; &gt; Potentially, the guests could trigger a debug except=
ion that&#39;s<br>&gt; &gt; outside the exception class range.<br>&gt;<br>&=
gt; How? All the exception classes that lead to this functions are already<=
br>&gt; handled in the switch/case statement.<br>&gt;<br>I guess I didn&#39=
;t think this through. Landing into kvm_handle_guest_debug()<br>itself is n=
ot possible :)<br><br>&gt; &gt; This could lead to an excessive syslog floo=
ding. Hence, ratelimit<br>&gt; &gt; the error message.<br>&gt; &gt;<br>&gt;=
 &gt; Signed-off-by: Raghavendra Rao Ananta &lt;<a href=3D"mailto:rananta@g=
oogle.com">rananta@google.com</a>&gt;<br>&gt; &gt; ---<br>&gt; &gt; =C2=A0a=
rch/arm64/kvm/handle_exit.c | 2 +-<br>&gt; &gt; =C2=A01 file changed, 1 ins=
ertion(+), 1 deletion(-)<br>&gt; &gt;<br>&gt; &gt; diff --git a/arch/arm64/=
kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c<br>&gt; &gt; index 04ebab2=
99aa4..c7cec7ffe93c 100644<br>&gt; &gt; --- a/arch/arm64/kvm/handle_exit.c<=
br>&gt; &gt; +++ b/arch/arm64/kvm/handle_exit.c<br>&gt; &gt; @@ -134,7 +134=
,7 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)<br>&gt; &gt;=
 =C2=A0 =C2=A0 =C2=A0 case ESR_ELx_EC_BRK64:<br>&gt; &gt; =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 de=
fault:<br>&gt; &gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kvm_err(&qu=
ot;%s: un-handled case esr: %#08x\n&quot;,<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 kvm_pr_unimpl(&quot;%s: un-handled case esr: %#08x=
\n&quot;,<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 __func__, (unsigned int) esr);<br>&gt; &gt; =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -1;<br>&gt; &gt; =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>&gt;<br>&gt; My take on=
 this is that this code isn&#39;t reachable, and that it could<br>&gt; be b=
etter rewritten as:<br>&gt;<br>&gt; diff --git a/arch/arm64/kvm/handle_exit=
.c b/arch/arm64/kvm/handle_exit.c<br>&gt; index 6f48336b1d86..ae7ec086827b =
100644<br>&gt; --- a/arch/arm64/kvm/handle_exit.c<br>&gt; +++ b/arch/arm64/=
kvm/handle_exit.c<br>&gt; @@ -119,28 +119,14 @@ static int kvm_handle_guest=
_debug(struct kvm_vcpu *vcpu)<br>&gt; =C2=A0{<br>&gt; =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 struct kvm_run *run =3D vcpu-&gt;run;<br>&gt; =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 u32 esr =3D kvm_vcpu_get_esr(vcpu);<br>&gt; - =C2=A0 =C2=A0 =C2=A0 i=
nt ret =3D 0;<br>&gt;<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 run-&gt;exit_reas=
on =3D KVM_EXIT_DEBUG;<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 run-&gt;debug.ar=
ch.hsr =3D esr;<br>&gt;<br>&gt; - =C2=A0 =C2=A0 =C2=A0 switch (ESR_ELx_EC(e=
sr)) {<br>&gt; - =C2=A0 =C2=A0 =C2=A0 case ESR_ELx_EC_WATCHPT_LOW:<br>&gt; =
+ =C2=A0 =C2=A0 =C2=A0 if (ESR_ELx_EC(esr) =3D=3D =C2=A0ESR_ELx_EC_WATCHPT_=
LOW)<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 run-&g=
t;debug.arch.far =3D vcpu-&gt;arch.fault.far_el2;<br>&gt; - =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fallthrough;<br>&gt; - =C2=A0 =C2=A0 =C2=
=A0 case ESR_ELx_EC_SOFTSTP_LOW:<br>&gt; - =C2=A0 =C2=A0 =C2=A0 case ESR_EL=
x_EC_BREAKPT_LOW:<br>&gt; - =C2=A0 =C2=A0 =C2=A0 case ESR_ELx_EC_BKPT32:<br=
>&gt; - =C2=A0 =C2=A0 =C2=A0 case ESR_ELx_EC_BRK64:<br>&gt; - =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>&gt; - =C2=A0 =C2=A0 =C2=A0 d=
efault:<br>&gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kvm_err(=
&quot;%s: un-handled case esr: %#08x\n&quot;,<br>&gt; - =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__, (unsi=
gned int) esr);<br>&gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
ret =3D -1;<br>&gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 brea=
k;<br>&gt; - =C2=A0 =C2=A0 =C2=A0 }<br>&gt;<br>&gt; - =C2=A0 =C2=A0 =C2=A0 =
return ret;<br>&gt; + =C2=A0 =C2=A0 =C2=A0 return 0;<br>&gt; =C2=A0}<br>&gt=
;<div>This looks better, but do you think we would be compromising on reada=
bility?</div><div><br></div><div>Regards,</div><div>Raghavendra</div><div><=
br>&gt; =C2=A0static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)<br>&g=
t;<br>&gt; Thanks,<br>&gt;<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 M.<br>&gt;<b=
r>&gt; --<br>&gt; Without deviation from the norm, progress is not possible=
.</div></div>

--0000000000002e7da305ca05a621--

--===============3165373575672180969==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3165373575672180969==--
