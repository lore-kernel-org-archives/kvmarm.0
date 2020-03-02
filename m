Return-Path: <SRS0=2z/n=4T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 955EBC3F2CD
	for <kvmarm@archiver.kernel.org>; Mon,  2 Mar 2020 16:04:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17EB52146E
	for <kvmarm@archiver.kernel.org>; Mon,  2 Mar 2020 16:04:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ER8y9PoR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17EB52146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 846604AF90;
	Mon,  2 Mar 2020 11:04:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dxErxaEt28eB; Mon,  2 Mar 2020 11:04:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 312E84AF21;
	Mon,  2 Mar 2020 11:04:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59D874AF21
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2020 11:04:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d9pcdJK9wa65 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2020 11:04:54 -0500 (EST)
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com
 [209.85.215.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1DBA4AEEC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2020 11:04:53 -0500 (EST)
Received: by mail-pg1-f193.google.com with SMTP id y30so10093pga.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Mar 2020 08:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sSa1eH4ZH11eFODx5TI1xPwlwerRZwEVTtJkpUSazx4=;
 b=ER8y9PoRQhbCZIOnspmjvj6Yim3isUv+qfgVqV9XDPWoQJIIVMGxnAWNuChmsuBwAK
 psZeaRDXpoonLyW7DgqSvEeev/tohJTYObx4VPfJpm6ESC2wrOk1ncqqy8/UKYJCzKhZ
 HkJeyWMs5q1+IzB0qHHPimOztMz5AxB6OSiWlvTFgCEDfsCyRSv0jVk5FoediOw7Hoka
 FaWwCWg2BUZgf40STze3GymJvAwuHReyUGXCjZid6yPhTP+TDu/a1qNF0ytgSUvhaQD2
 Q9ykPUhyS/BQX54QCo1iy0O5etCf+XNojzTGiauDe0sMc0X4d6125AUO5SAjc1UWT2H+
 5gRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sSa1eH4ZH11eFODx5TI1xPwlwerRZwEVTtJkpUSazx4=;
 b=XnbLaZ9Fh2lJEa4GcA46I7uPruhUv5pYLuW+rVCN+8AqerHpNmL4LNhI+/rCHBs+PU
 7HL5/6McuIh8QCXUSfAYe78iHcI8FS2hXiMp/oUG/dU3DHsw2pkkl3wxcI8lLnCr0/KC
 FufufEWQ8FJ6By6LcKO++v3M0SQiD+kby1ySe2tmWDRrdPLWsRjHnYWAsbK7MxjzPO63
 6BL4+SBISkBshKAf4L/pOzRCxSdhFm+jAmgJYmnBZnbBF58e3FV72f55peF2eCZbN96B
 2Qrdq3/REFr6CMOTVst+dg1yhgRrHcgdCLDzfmq29gtok/NPl/JShKKBIqpcIT6nKtai
 f8qA==
X-Gm-Message-State: ANhLgQ3lCXdaZKGl6erifT2s+n4F/jRemLSWhZDcZFplDtUH+KEtxM2L
 K2dR9X5jSW/pjUkWUmQWuRz6fXbxTqNt1YM2il45PDTpiE8=
X-Google-Smtp-Source: APXvYqyoj1lJ5davJoBfWPGpKAgYAezAZUIETTPTIC0FrrimfcQ3rVOOzB3PC985fOYZtEvRmD67zWE/XIeiMCtgV5s=
X-Received: by 2002:a5e:cb07:: with SMTP id p7mr12603773iom.243.1583158891259; 
 Mon, 02 Mar 2020 06:21:31 -0800 (PST)
MIME-Version: 1.0
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-9-maz@kernel.org>
 <4b7f71f1-5e7f-e6af-f47d-7ed0d3a8739f@huawei.com>
 <75597af0d2373ac4d92d8162a1338cbb@kernel.org>
 <19a7c193f0e4b97343e822a35f0911ed@kernel.org>
 <3d725ede-6631-59fb-1a10-9fb9890f3df6@huawei.com>
 <dd9f1224b3b21ad793862406bd8855ba@kernel.org>
 <54c52057161f925c818446953050c951@kernel.org>
 <4f8f3958-2976-b0a7-8d17-440ecaba0fc8@huawei.com>
 <db819547d4be8daa458bcd56aac2efcd@kernel.org>
In-Reply-To: <db819547d4be8daa458bcd56aac2efcd@kernel.org>
From: Bill Barrow <billbarrow2888@gmail.com>
Date: Mon, 2 Mar 2020 14:21:20 +0000
Message-ID: <CAD5xw9rOg-cRnqxVtoSzxfG5cQQxBZpj=SVJ+m19CCLASd9e8w@mail.gmail.com>
Subject: Re: [PATCH v4 08/20] irqchip/gic-v4.1: Plumb get/set_irqchip_state
 SGI callbacks
To: Marc Zyngier <maz@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: multipart/mixed; boundary="===============4820938914917584356=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4820938914917584356==
Content-Type: multipart/alternative; boundary="000000000000562895059fdfe748"

--000000000000562895059fdfe748
Content-Type: text/plain; charset="UTF-8"

What  the hell?


On Mon, 2 Mar 2020 at 12:09, Marc Zyngier <maz@kernel.org> wrote:

> Hi Zenghui,
>
> On 2020-03-02 08:18, Zenghui Yu wrote:
> > On 2020/3/2 3:00, Marc Zyngier wrote:
> >> On 2020-02-28 19:37, Marc Zyngier wrote:
> >>> On 2020-02-20 03:11, Zenghui Yu wrote:
> >>
> >>>> Do we really need to grab the vpe_lock for those which are belong to
> >>>> the same irqchip with its_vpe_set_affinity()? The IRQ core code
> >>>> should
> >>>> already ensure the mutual exclusion among them, wrong?
> >>>
> >>> I've been trying to think about that, but jet-lag keeps getting in
> >>> the way.
> >>> I empirically think that you are right, but I need to go and check
> >>> the various
> >>> code paths to be sure. Hopefully I'll have a bit more brain space
> >>> next week.
> >>
> >> So I slept on it and came back to my senses. The only case we actually
> >> need
> >> to deal with is when an affinity change impacts *another* interrupt.
> >>
> >> There is only two instances of this issue:
> >>
> >> - vLPIs have their *physical* affinity impacted by the affinity of the
> >>    vPE. Their virtual affinity is of course unchanged, but the
> >> physical
> >>    one becomes important with direct invalidation. Taking a per-VPE
> >> lock
> >>    in such context should address the issue.
> >>
> >> - vSGIs have the exact same issue, plus the matter of requiring some
> >>    *extra* one when reading the pending state, which requires a RMW
> >>    on two different registers. This requires an extra per-RD lock.
> >
> > Agreed with both!
> >
> >>
> >> My original patch was stupidly complex, and the irq_desc lock is
> >> perfectly enough to deal with anything that only affects the interrupt
> >> state itself.
> >>
> >> GICv4 + direct invalidation for vLPIs breaks this by bypassing the
> >> serialization initially provided by the ITS, as the RD is completely
> >> out of band. The per-vPE lock brings back this serialization.
> >>
> >> I've updated the branch, which seems to run OK on D05. I still need
> >> to run the usual tests on the FVP model though.
> >
> > I have pulled the latest branch and it looks good to me, except for
> > one remaining concern:
> >
> > GICR_INV{LPI, ALL}R + GICR_SYNCR can also be accessed concurrently
> > by multiple direct invalidation, should we also use the per-RD lock
> > to ensure mutual exclusion?  It looks not so harmful though, as this
> > will only increase one's polling time against the Busy bit (in my
> > view).
> >
> > But I point it out again for confirmation.
>
> I was about to say that it doesn't really matter because it is only a
> performance optimisation (and we're noty quite there yet), until I
> spotted
> this great nugget in the spec:
>
> <quote>
> Writing GICR_INVLPIR or GICR_INVALLR when GICR_SYNCR.Busy==1 is
> CONSTRAINED
> UNPREDICTABLE:
> - The write is IGNORED .
> - The invalidate specified by the write is performed.
> </quote>
>
> So we really need some form of mutual exclusion on a per-RD basis to
> ensure
> that no two invalidations occur at the same time, ensuring that Busy
> clears
> between the two.
>
> Thanks for the heads up,
>
>          M.
> --
> Jazz is not dead. It just smells funny...
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>

--000000000000562895059fdfe748
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">What=C2=A0 the hell?<div><br></div></div><br><div class=3D=
"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, 2 Mar 2020 at 1=
2:09, Marc Zyngier &lt;<a href=3D"mailto:maz@kernel.org">maz@kernel.org</a>=
&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px =
0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hi Z=
enghui,<br>
<br>
On 2020-03-02 08:18, Zenghui Yu wrote:<br>
&gt; On 2020/3/2 3:00, Marc Zyngier wrote:<br>
&gt;&gt; On 2020-02-28 19:37, Marc Zyngier wrote:<br>
&gt;&gt;&gt; On 2020-02-20 03:11, Zenghui Yu wrote:<br>
&gt;&gt; <br>
&gt;&gt;&gt;&gt; Do we really need to grab the vpe_lock for those which are=
 belong to<br>
&gt;&gt;&gt;&gt; the same irqchip with its_vpe_set_affinity()? The IRQ core=
 code <br>
&gt;&gt;&gt;&gt; should<br>
&gt;&gt;&gt;&gt; already ensure the mutual exclusion among them, wrong?<br>
&gt;&gt;&gt; <br>
&gt;&gt;&gt; I&#39;ve been trying to think about that, but jet-lag keeps ge=
tting in <br>
&gt;&gt;&gt; the way.<br>
&gt;&gt;&gt; I empirically think that you are right, but I need to go and c=
heck <br>
&gt;&gt;&gt; the various<br>
&gt;&gt;&gt; code paths to be sure. Hopefully I&#39;ll have a bit more brai=
n space <br>
&gt;&gt;&gt; next week.<br>
&gt;&gt; <br>
&gt;&gt; So I slept on it and came back to my senses. The only case we actu=
ally <br>
&gt;&gt; need<br>
&gt;&gt; to deal with is when an affinity change impacts *another* interrup=
t.<br>
&gt;&gt; <br>
&gt;&gt; There is only two instances of this issue:<br>
&gt;&gt; <br>
&gt;&gt; - vLPIs have their *physical* affinity impacted by the affinity of=
 the<br>
&gt;&gt;=C2=A0 =C2=A0 vPE. Their virtual affinity is of course unchanged, b=
ut the <br>
&gt;&gt; physical<br>
&gt;&gt;=C2=A0 =C2=A0 one becomes important with direct invalidation. Takin=
g a per-VPE <br>
&gt;&gt; lock<br>
&gt;&gt;=C2=A0 =C2=A0 in such context should address the issue.<br>
&gt;&gt; <br>
&gt;&gt; - vSGIs have the exact same issue, plus the matter of requiring so=
me<br>
&gt;&gt;=C2=A0 =C2=A0 *extra* one when reading the pending state, which req=
uires a RMW<br>
&gt;&gt;=C2=A0 =C2=A0 on two different registers. This requires an extra pe=
r-RD lock.<br>
&gt; <br>
&gt; Agreed with both!<br>
&gt; <br>
&gt;&gt; <br>
&gt;&gt; My original patch was stupidly complex, and the irq_desc lock is<b=
r>
&gt;&gt; perfectly enough to deal with anything that only affects the inter=
rupt<br>
&gt;&gt; state itself.<br>
&gt;&gt; <br>
&gt;&gt; GICv4 + direct invalidation for vLPIs breaks this by bypassing the=
<br>
&gt;&gt; serialization initially provided by the ITS, as the RD is complete=
ly<br>
&gt;&gt; out of band. The per-vPE lock brings back this serialization.<br>
&gt;&gt; <br>
&gt;&gt; I&#39;ve updated the branch, which seems to run OK on D05. I still=
 need<br>
&gt;&gt; to run the usual tests on the FVP model though.<br>
&gt; <br>
&gt; I have pulled the latest branch and it looks good to me, except for<br=
>
&gt; one remaining concern:<br>
&gt; <br>
&gt; GICR_INV{LPI, ALL}R + GICR_SYNCR can also be accessed concurrently<br>
&gt; by multiple direct invalidation, should we also use the per-RD lock<br=
>
&gt; to ensure mutual exclusion?=C2=A0 It looks not so harmful though, as t=
his<br>
&gt; will only increase one&#39;s polling time against the Busy bit (in my =
<br>
&gt; view).<br>
&gt; <br>
&gt; But I point it out again for confirmation.<br>
<br>
I was about to say that it doesn&#39;t really matter because it is only a<b=
r>
performance optimisation (and we&#39;re noty quite there yet), until I <br>
spotted<br>
this great nugget in the spec:<br>
<br>
&lt;quote&gt;<br>
Writing GICR_INVLPIR or GICR_INVALLR when GICR_SYNCR.Busy=3D=3D1 is <br>
CONSTRAINED<br>
UNPREDICTABLE:<br>
- The write is IGNORED .<br>
- The invalidate specified by the write is performed.<br>
&lt;/quote&gt;<br>
<br>
So we really need some form of mutual exclusion on a per-RD basis to <br>
ensure<br>
that no two invalidations occur at the same time, ensuring that Busy <br>
clears<br>
between the two.<br>
<br>
Thanks for the heads up,<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0M.<br>
-- <br>
Jazz is not dead. It just smells funny...<br>
_______________________________________________<br>
kvmarm mailing list<br>
<a href=3D"mailto:kvmarm@lists.cs.columbia.edu" target=3D"_blank">kvmarm@li=
sts.cs.columbia.edu</a><br>
<a href=3D"https://lists.cs.columbia.edu/mailman/listinfo/kvmarm" rel=3D"no=
referrer" target=3D"_blank">https://lists.cs.columbia.edu/mailman/listinfo/=
kvmarm</a><br>
</blockquote></div>

--000000000000562895059fdfe748--

--===============4820938914917584356==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4820938914917584356==--
