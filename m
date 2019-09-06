Return-Path: <SRS0=tFZo=XB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82980C43331
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 16:33:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17287207FC
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 16:33:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17287207FC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 638834A5A5;
	Fri,  6 Sep 2019 12:33:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JqFLAFMCgLva; Fri,  6 Sep 2019 12:33:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AA074A584;
	Fri,  6 Sep 2019 12:33:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 244E94A584
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 12:33:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8e5l99wFwRI7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Sep 2019 12:33:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BB3D4A53D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 12:33:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F00031570;
 Fri,  6 Sep 2019 09:33:43 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48DAB3F59C;
 Fri,  6 Sep 2019 09:33:43 -0700 (PDT)
Date: Fri, 6 Sep 2019 17:32:51 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] arm: gic: enable GIC MMIO tests for
 GICv3 as well
Message-ID: <20190906173251.66795717@donnerap.cambridge.arm.com>
In-Reply-To: <20190906064837.6afynobk3p6a64hv@kamzik.brq.redhat.com>
References: <20190905172114.215380-1-andre.przywara@arm.com>
 <20190906064837.6afynobk3p6a64hv@kamzik.brq.redhat.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Fri, 6 Sep 2019 08:48:37 +0200
Andrew Jones <drjones@redhat.com> wrote:

Hi,

> On Thu, Sep 05, 2019 at 06:21:14PM +0100, Andre Przywara wrote:
> > So far the GIC MMIO tests were only enabled for a GICv2 guest. Modern
> > machines tend to have a GICv3-only GIC, so can't run those guests.
> > It turns out that most GIC distributor registers we test in the unit
> > tests are actually the same in GICv3, so we can just enable those tests
> > for GICv3 guests as well.
> > The only exception is the CPU number in the TYPER register, which we
> > just protect against running on a GICv3 guest.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  arm/gic.c         | 13 +++++++++++--
> >  arm/unittests.cfg | 16 +++++++++++-----
> >  lib/arm/asm/gic.h |  2 ++
> >  3 files changed, 24 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arm/gic.c b/arm/gic.c
> > index ed5642e..bd3c027 100644
> > --- a/arm/gic.c
> > +++ b/arm/gic.c
> > @@ -6,6 +6,7 @@
> >   *   + MMIO access tests
> >   * GICv3
> >   *   + test sending/receiving IPIs
> > + *   + MMIO access tests
> >   *
> >   * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> >   *
> > @@ -483,7 +484,14 @@ static void gic_test_mmio(void)
> >  		idreg = gic_dist_base + GICD_ICPIDR2;
> >  		break;
> >  	case 0x3:
> > -		report_abort("GICv3 MMIO tests NYI");
> > +		/*
> > +		 * We only test generic registers or those affecting
> > +		 * SPIs, so don't need to consider the SGI base in
> > +		 * the redistributor here.
> > +		 */
> > +		gic_dist_base = gicv3_dist_base();
> > +		idreg = gic_dist_base + GICD_PIDR2;
> > +		break;
> >  	default:
> >  		report_abort("GIC version %d not supported", gic_version());
> >  	}
> > @@ -492,7 +500,8 @@ static void gic_test_mmio(void)
> >  	nr_irqs = GICD_TYPER_IRQS(reg);
> >  	report_info("number of implemented SPIs: %d", nr_irqs - GIC_FIRST_SPI);
> >  
> > -	test_typer_v2(reg);
> > +	if (gic_version() == 0x2)
> > +		test_typer_v2(reg);
> >  
> >  	report_info("IIDR: 0x%08x", readl(gic_dist_base + GICD_IIDR));
> >  
> > diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> > index 6d3df92..3fd5b04 100644
> > --- a/arm/unittests.cfg
> > +++ b/arm/unittests.cfg
> > @@ -86,22 +86,28 @@ smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
> >  extra_params = -machine gic-version=2 -append 'ipi'
> >  groups = gic
> >  
> > -[gicv2-mmio]
> > +[gicv2-max-mmio]
> >  file = gic.flat
> >  smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
> >  extra_params = -machine gic-version=2 -append 'mmio'
> >  groups = gic
> >  
> > -[gicv2-mmio-up]
> > +[gicv3-max-mmio]
> > +file = gic.flat
> > +smp = $MAX_SMP
> > +extra_params = -machine gic-version=3 -append 'mmio'
> > +groups = gic
> > +
> > +[gic-mmio-up]
> >  file = gic.flat
> >  smp = 1
> > -extra_params = -machine gic-version=2 -append 'mmio'
> > +extra_params = -append 'mmio'
> >  groups = gic
> >  
> > -[gicv2-mmio-3p]
> > +[gic-mmio-3p]
> >  file = gic.flat
> >  smp = $((($MAX_SMP < 3)?$MAX_SMP:3))
> > -extra_params = -machine gic-version=2 -append 'mmio'
> > +extra_params = -append 'mmio'
> >  groups = gic
> >  
> >  [gicv3-ipi]
> > diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> > index f6dfb90..ffed025 100644
> > --- a/lib/arm/asm/gic.h
> > +++ b/lib/arm/asm/gic.h
> > @@ -23,6 +23,8 @@
> >  #define GICD_ITARGETSR			0x0800
> >  #define GICD_SGIR			0x0f00
> >  #define GICD_ICPIDR2			0x0fe8
> > +/* only in GICv3 */
> > +#define GICD_PIDR2			0xffe8  
> 
> If this is gicv3-only, then shouldn't it go to lib/arm/asm/gic-v3.h ?

Ah, true, I missed that file.

Added it there, I will send a reworked version as part of now some bigger series to test GICD_IROUTER and SPIs as well.

> 
> >  
> >  #define GICD_TYPER_IRQS(typer)		((((typer) & 0x1f) + 1) * 32)
> >  #define GICD_INT_EN_SET_SGI		0x0000ffff
> > -- 
> > 2.17.1
> >   
> 
> Otherwise
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks!

Cheers,
Andre.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
