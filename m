Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5259C433DF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 14:42:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6CF90206E2
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 14:42:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="gj/ZRJwC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CF90206E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAF1A4B0B7;
	Thu,  2 Jul 2020 10:42:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J8F4f2hobWq1; Thu,  2 Jul 2020 10:42:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F5044B192;
	Thu,  2 Jul 2020 10:42:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A0214B171
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 10:42:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8-Ee18SO90x8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 10:42:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF5C64B0B7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 10:42:13 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9004020772;
 Thu,  2 Jul 2020 14:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593700933;
 bh=BNTUXODvFdVFTe7bBzNUMKyoZ8+YAkcVdFCsple2mvg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=gj/ZRJwC5Kl1VNMJ8DVtjsP60JNfSv+xzmn8d5Zm3CTbKpExOEUdADTACEGZ5d3PL
 eSEsPGosjinwUi2aRsGT1Azl65YZmfJHFAeZhQryMx2WV7ejk/E08SgFtwMjVfwAel
 jX+4FGegpq0G9TRENDEVN/hl9F51aJsrREEOiwII=
Date: Thu, 2 Jul 2020 15:42:08 +0100
From: Will Deacon <will@kernel.org>
To: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Print warning when cpu erratum can
 cause guests to deadlock
Message-ID: <20200702144208.GA16999@willie-the-truck>
References: <20200701215308.3715856-1-robh@kernel.org>
 <20200701215308.3715856-2-robh@kernel.org>
 <20200702114527.GB16499@willie-the-truck>
 <CAL_JsqLnZHXjnYf3s6FJnVKf4kN1fhRgJov=Sb3H6J=Yro+cQg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL_JsqLnZHXjnYf3s6FJnVKf4kN1fhRgJov=Sb3H6J=Yro+cQg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Jul 02, 2020 at 08:04:43AM -0600, Rob Herring wrote:
> On Thu, Jul 2, 2020 at 5:45 AM Will Deacon <will@kernel.org> wrote:
> >
> > On Wed, Jul 01, 2020 at 03:53:06PM -0600, Rob Herring wrote:
> > > If guests don't have certain CPU erratum work-arounds implemented, then
> > > there is a possibility a guest can deadlock the system. IOW, only trusted
> > > guests should be used on systems with the erratum.
> > >
> > > This is the case for Cortex-A57 erratum 832075.
> > >
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Cc: James Morse <james.morse@arm.com>
> > > Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> > > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Will Deacon <will@kernel.org>
> > > Cc: kvmarm@lists.cs.columbia.edu
> > > Signed-off-by: Rob Herring <robh@kernel.org>
> > > ---
> > >  arch/arm64/kvm/arm.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 90cb90561446..e2f50fa4d825 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -1653,6 +1653,10 @@ int kvm_arch_init(void *opaque)
> > >               return -ENODEV;
> > >       }
> > >
> > > +     if (cpus_have_const_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE))
> > > +             kvm_info("Guests without required CPU erratum work-arounds can deadlock system!\n" \
> >
> > work-arounds => workarounds
> >
> > (mainly for consistency, I have no clue if this is a real word or not!).
> >
> > I'd also probably do erratum => errata given that you're about to add a
> > second one.
> 
> Humm, the plural is on workarounds. If I use a more standard singular
> vs. plural form like "CPU feature workarounds" vs "CPU features
> workarounds", the former seems more correct to me. (working around
> features may be a bit nonsensical, but big.LITTLE ;) )

Ok, "erratum" it is then!

One other thing on the actual workaround... Case B in the document says:

  | In Program Order,
  | 1. The core executes any load with device memory attributes.
  | 2. The core executes a store-exclusive or register read of PAR_EL1.

and the patch register sequence says:

  | Use the following write sequence to several IMPLEMENTATION DEFINED
  | registers to have the hardware insert a DMB SY after all load-exclusive and
  | store-exclusive instructions.

but that would mean that the sequence is effectively:

	LDR	Xa, [device address]
	STXR	Wb, Xc, [Xd]
	DMB	SY

Does that really prevent the deadlock?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
