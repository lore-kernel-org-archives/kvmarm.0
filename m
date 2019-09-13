Return-Path: <SRS0=dbzw=XI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197EBC49ED7
	for <kvmarm@archiver.kernel.org>; Fri, 13 Sep 2019 07:13:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8BA1620830
	for <kvmarm@archiver.kernel.org>; Fri, 13 Sep 2019 07:13:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="u15oBIN8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BA1620830
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AB824A67A;
	Fri, 13 Sep 2019 03:13:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JPYXyzadV9fL; Fri, 13 Sep 2019 03:13:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DAE54A66B;
	Fri, 13 Sep 2019 03:13:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7CDA4A669
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Sep 2019 03:13:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1Ke1gt5iUoFo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Sep 2019 03:13:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50D314A5A9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Sep 2019 03:13:26 -0400 (EDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com
 [209.85.128.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 02E51214DA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Sep 2019 07:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1568358805;
 bh=Y9/DSawRiw7HkV7LtyD5C99WKwn1uJtmvAOU+zwccO4=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=u15oBIN8ZtiTSNSv6Z/kEOoMpILX5r0aDdSzkaZp9hK4h1fxdbN3mv8qlxmupDjc5
 QVAacKw2pRuUh6MDbjcdYE0w1YBaj6L8X1u7VJ+BR1Z42Y9xEvk5FKr5NaO+Zq/utB
 yQEOs7bTKcHIsr3UELybtnbdEjzi3jRvybLMNLrQ=
Received: by mail-wm1-f54.google.com with SMTP id 7so1522704wme.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Sep 2019 00:13:24 -0700 (PDT)
X-Gm-Message-State: APjAAAXkMbI8JQ4tKOdd48KOlG/N1fxFkfaOHTFL55ir96rHl2hgDads
 4WLqjEKuJMH2u/GdyfjNPGtAGf8H6G8vvN1ET5w=
X-Google-Smtp-Source: APXvYqxi0Jghii/qEM7O0Qi1P6dXAzbAe3ZmdcsQpaqA78muEW6iWtmDNae/AhMUGSjE0UlZ/D7znbTkhEE5NdpUEf4=
X-Received: by 2002:a05:600c:2256:: with SMTP id
 a22mr2082602wmm.79.1568358803393; 
 Fri, 13 Sep 2019 00:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190321163623.20219-12-julien.grall@arm.com>
 <0dfe120b-066a-2ac8-13bc-3f5a29e2caa3@arm.com>
 <CAJF2gTTXHHgDboaexdHA284y6kNZVSjLis5-Q2rDnXCxr4RSmA@mail.gmail.com>
 <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
 <20190619091219.GB7767@fuggles.cambridge.arm.com>
 <CAJF2gTTmFq3yYa9UrdZRAFwJgC=KmKTe2_NFy_UZBUQovqQJPg@mail.gmail.com>
 <20190619123939.GF7767@fuggles.cambridge.arm.com>
 <CAJF2gTSiiiewTLwVAXvPLO7rTSUw1rg8VtFLzANdP2S2EEbTjg@mail.gmail.com>
 <20190624104006.lvm32nahemaqklxc@willie-the-truck>
 <CAJF2gTSC1sGgmiTCgzKUTdPyUZ3LG4H7N8YbMyWr-E+eifGuYg@mail.gmail.com>
 <20190912140256.fwbutgmadpjbjnab@willie-the-truck>
 <CAJF2gTT2c45HRfATF+=zs-HNToFAKgq1inKRmJMV3uPYBo4iVg@mail.gmail.com>
In-Reply-To: <CAJF2gTT2c45HRfATF+=zs-HNToFAKgq1inKRmJMV3uPYBo4iVg@mail.gmail.com>
From: Guo Ren <guoren@kernel.org>
Date: Fri, 13 Sep 2019 15:13:10 +0800
X-Gmail-Original-Message-ID: <CAJF2gTTsHCsSpf1ncVb=ZJS2d=r+AdDi2=5z-REVS=uUg9138A@mail.gmail.com>
Message-ID: <CAJF2gTTsHCsSpf1ncVb=ZJS2d=r+AdDi2=5z-REVS=uUg9138A@mail.gmail.com>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Palmer Dabbelt <palmer@sifive.com>, Will Deacon <will.deacon@arm.com>,
 Atish Patra <Atish.Patra@wdc.com>, Julien Grall <julien.grall@arm.com>,
 gary@garyguo.net, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Mike Rapoport <rppt@linux.ibm.com>,
 Christoph Hellwig <hch@infradead.org>, aou@eecs.berkeley.edu,
 Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-arm-kernel@lists.infradead.org,
 Anup Patel <anup.Patel@wdc.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 iommu@lists.linux-foundation.org
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
Content-Type: multipart/mixed; boundary="===============1110305693905173118=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============1110305693905173118==
Content-Type: multipart/alternative; boundary="0000000000005b52a7059269fda0"

--0000000000005b52a7059269fda0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Another idea is seperate remote TLB invalidate into two instructions:

 - sfence.vma.b.asyc
 - sfence.vma.b.barrier // wait all async TLB invalidate operations
finished for all harts.

(I remember who mentioned me separate them into two instructions after
session. Anup? Is the idea right ?)

Actually, I never consider asyc TLB invalidate before, because current our
light iommu did not need it.

Thx all people attend the session :) Let's continue the talk.


Guo Ren <guoren@kernel.org> =E4=BA=8E 2019=E5=B9=B49=E6=9C=8812=E6=97=A5=E5=
=91=A8=E5=9B=9B 22:59=E5=86=99=E9=81=93=EF=BC=9A

> Thx Will for reply.
>
> On Thu, Sep 12, 2019 at 3:03 PM Will Deacon <will@kernel.org> wrote:
> >
> > On Sun, Sep 08, 2019 at 07:52:55AM +0800, Guo Ren wrote:
> > > On Mon, Jun 24, 2019 at 6:40 PM Will Deacon <will@kernel.org> wrote:
> > > > > I'll keep my system use the same ASID for SMP + IOMMU :P
> > > >
> > > > You will want a separate allocator for that:
> > > >
> > > >
> https://lkml.kernel.org/r/20190610184714.6786-2-jean-philippe.brucker@arm=
.com
> > >
> > > Yes, it is hard to maintain ASID between IOMMU and CPUMMU or differen=
t
> > > system, because it's difficult to synchronize the IO_ASID when the CP=
U
> > > ASID is rollover.
> > > But we could still use hardware broadcast TLB invalidation instructio=
n
> > > to uniformly manage the ASID and IO_ASID, or OTHER_ASID in our IOMMU.
> >
> > That's probably a bad idea, because you'll likely stall execution on th=
e
> > CPU until the IOTLB has completed invalidation. In the case of ATS, I
> think
> > an endpoint ATC is permitted to take over a minute to respond. In
> reality, I
> > suspect the worst you'll ever see would be in the msec range, but that'=
s
> > still an unacceptable period of time to hold a CPU.
> Just as I've said in the session that IOTLB invalidate delay is
> another topic, My main proposal is to introduce stage1.pgd and
> stage2.pgd as address space identifiers between different TLB systems
> based on vmid, asid. My last part of sildes will show you how to
> translate stage1/2.pgd to as/vmid in PCI ATS system and the method
> could work with SMMU-v3 and intel Vt-d. (It's regret for me there is
> no time to show you the whole slides.)
>
> In our light IOMMU implementation, there's no IOTLB invalidate delay
> problem. Becasue IOMMU is very close to CPU MMU and interconnect's
> delay is the same with SMP CPUs MMU (no PCI, VM supported).
>
> To solve the problem, we could define a async mode in sfence.vma.b to
> slove the problem and finished with per_cpu_irq/exception.
>
> --
> Best Regards
>  Guo Ren
>
> ML: https://lore.kernel.org/linux-csky/
>

--0000000000005b52a7059269fda0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div>Another idea is seperate remote TLB invalidate into =
two instructions:<div dir=3D"auto"><br></div><div dir=3D"auto">=C2=A0- sfen=
ce.vma.b.asyc</div><div dir=3D"auto">=C2=A0- sfence.vma.b.barrier  // wait =
all async TLB invalidate operations finished for all harts.</div><div dir=
=3D"auto"><br></div><div dir=3D"auto">(I remember who mentioned me separate=
 them into two instructions after session. Anup? Is the idea right ?)=C2=A0=
</div><div dir=3D"auto"><br></div><div dir=3D"auto">Actually,  I never cons=
ider asyc TLB invalidate before,  because current our light iommu did not n=
eed it.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Thx all people a=
ttend the session :)  Let&#39;s continue the talk.=C2=A0</div><br><br><div =
class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">Guo Ren &lt;<a =
href=3D"mailto:guoren@kernel.org">guoren@kernel.org</a>&gt; =E4=BA=8E 2019=
=E5=B9=B49=E6=9C=8812=E6=97=A5=E5=91=A8=E5=9B=9B 22:59=E5=86=99=E9=81=93=EF=
=BC=9A<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8e=
x;border-left:1px #ccc solid;padding-left:1ex">Thx Will for reply.<br>
<br>
On Thu, Sep 12, 2019 at 3:03 PM Will Deacon &lt;<a href=3D"mailto:will@kern=
el.org" target=3D"_blank" rel=3D"noreferrer">will@kernel.org</a>&gt; wrote:=
<br>
&gt;<br>
&gt; On Sun, Sep 08, 2019 at 07:52:55AM +0800, Guo Ren wrote:<br>
&gt; &gt; On Mon, Jun 24, 2019 at 6:40 PM Will Deacon &lt;<a href=3D"mailto=
:will@kernel.org" target=3D"_blank" rel=3D"noreferrer">will@kernel.org</a>&=
gt; wrote:<br>
&gt; &gt; &gt; &gt; I&#39;ll keep my system use the same ASID for SMP + IOM=
MU :P<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; You will want a separate allocator for that:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; <a href=3D"https://lkml.kernel.org/r/20190610184714.6786-2-j=
ean-philippe.brucker@arm.com" rel=3D"noreferrer noreferrer" target=3D"_blan=
k">https://lkml.kernel.org/r/20190610184714.6786-2-jean-philippe.brucker@ar=
m.com</a><br>
&gt; &gt;<br>
&gt; &gt; Yes, it is hard to maintain ASID between IOMMU and CPUMMU or diff=
erent<br>
&gt; &gt; system, because it&#39;s difficult to synchronize the IO_ASID whe=
n the CPU<br>
&gt; &gt; ASID is rollover.<br>
&gt; &gt; But we could still use hardware broadcast TLB invalidation instru=
ction<br>
&gt; &gt; to uniformly manage the ASID and IO_ASID, or OTHER_ASID in our IO=
MMU.<br>
&gt;<br>
&gt; That&#39;s probably a bad idea, because you&#39;ll likely stall execut=
ion on the<br>
&gt; CPU until the IOTLB has completed invalidation. In the case of ATS, I =
think<br>
&gt; an endpoint ATC is permitted to take over a minute to respond. In real=
ity, I<br>
&gt; suspect the worst you&#39;ll ever see would be in the msec range, but =
that&#39;s<br>
&gt; still an unacceptable period of time to hold a CPU.<br>
Just as I&#39;ve said in the session that IOTLB invalidate delay is<br>
another topic, My main proposal is to introduce stage1.pgd and<br>
stage2.pgd as address space identifiers between different TLB systems<br>
based on vmid, asid. My last part of sildes will show you how to<br>
translate stage1/2.pgd to as/vmid in PCI ATS system and the method<br>
could work with SMMU-v3 and intel Vt-d. (It&#39;s regret for me there is<br=
>
no time to show you the whole slides.)<br>
<br>
In our light IOMMU implementation, there&#39;s no IOTLB invalidate delay<br=
>
problem. Becasue IOMMU is very close to CPU MMU and interconnect&#39;s<br>
delay is the same with SMP CPUs MMU (no PCI, VM supported).<br>
<br>
To solve the problem, we could define a async mode in sfence.vma.b to<br>
slove the problem and finished with per_cpu_irq/exception.<br>
<br>
-- <br>
Best Regards<br>
=C2=A0Guo Ren<br>
<br>
ML: <a href=3D"https://lore.kernel.org/linux-csky/" rel=3D"noreferrer noref=
errer" target=3D"_blank">https://lore.kernel.org/linux-csky/</a><br>
</blockquote></div></div></div>

--0000000000005b52a7059269fda0--

--===============1110305693905173118==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1110305693905173118==--
