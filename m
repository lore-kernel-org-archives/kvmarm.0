Return-Path: <SRS0=tFZo=XB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A2B2C43331
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 06:48:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 050C8206BB
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 06:48:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 050C8206BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67E5A4A5AF;
	Fri,  6 Sep 2019 02:48:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JkSmOI33K9aH; Fri,  6 Sep 2019 02:48:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29D3A4A56C;
	Fri,  6 Sep 2019 02:48:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B4EE4A551
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 02:48:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FvMeBSXqoOOZ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Sep 2019 02:48:42 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 014604A540
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 02:48:41 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 22894190C032;
 Fri,  6 Sep 2019 06:48:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 102BA60A97;
 Fri,  6 Sep 2019 06:48:39 +0000 (UTC)
Date: Fri, 6 Sep 2019 08:48:37 +0200
From: Andrew Jones <drjones@redhat.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvm-unit-tests] arm: gic: enable GIC MMIO tests for GICv3
 as well
Message-ID: <20190906064837.6afynobk3p6a64hv@kamzik.brq.redhat.com>
References: <20190905172114.215380-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190905172114.215380-1-andre.przywara@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2
 (mx1.redhat.com [10.5.110.70]); Fri, 06 Sep 2019 06:48:41 +0000 (UTC)
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

On Thu, Sep 05, 2019 at 06:21:14PM +0100, Andre Przywara wrote:
> So far the GIC MMIO tests were only enabled for a GICv2 guest. Modern
> machines tend to have a GICv3-only GIC, so can't run those guests.
> It turns out that most GIC distributor registers we test in the unit
> tests are actually the same in GICv3, so we can just enable those tests
> for GICv3 guests as well.
> The only exception is the CPU number in the TYPER register, which we
> just protect against running on a GICv3 guest.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c         | 13 +++++++++++--
>  arm/unittests.cfg | 16 +++++++++++-----
>  lib/arm/asm/gic.h |  2 ++
>  3 files changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index ed5642e..bd3c027 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -6,6 +6,7 @@
>   *   + MMIO access tests
>   * GICv3
>   *   + test sending/receiving IPIs
> + *   + MMIO access tests
>   *
>   * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
>   *
> @@ -483,7 +484,14 @@ static void gic_test_mmio(void)
>  		idreg = gic_dist_base + GICD_ICPIDR2;
>  		break;
>  	case 0x3:
> -		report_abort("GICv3 MMIO tests NYI");
> +		/*
> +		 * We only test generic registers or those affecting
> +		 * SPIs, so don't need to consider the SGI base in
> +		 * the redistributor here.
> +		 */
> +		gic_dist_base = gicv3_dist_base();
> +		idreg = gic_dist_base + GICD_PIDR2;
> +		break;
>  	default:
>  		report_abort("GIC version %d not supported", gic_version());
>  	}
> @@ -492,7 +500,8 @@ static void gic_test_mmio(void)
>  	nr_irqs = GICD_TYPER_IRQS(reg);
>  	report_info("number of implemented SPIs: %d", nr_irqs - GIC_FIRST_SPI);
>  
> -	test_typer_v2(reg);
> +	if (gic_version() == 0x2)
> +		test_typer_v2(reg);
>  
>  	report_info("IIDR: 0x%08x", readl(gic_dist_base + GICD_IIDR));
>  
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 6d3df92..3fd5b04 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -86,22 +86,28 @@ smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
>  extra_params = -machine gic-version=2 -append 'ipi'
>  groups = gic
>  
> -[gicv2-mmio]
> +[gicv2-max-mmio]
>  file = gic.flat
>  smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
>  extra_params = -machine gic-version=2 -append 'mmio'
>  groups = gic
>  
> -[gicv2-mmio-up]
> +[gicv3-max-mmio]
> +file = gic.flat
> +smp = $MAX_SMP
> +extra_params = -machine gic-version=3 -append 'mmio'
> +groups = gic
> +
> +[gic-mmio-up]
>  file = gic.flat
>  smp = 1
> -extra_params = -machine gic-version=2 -append 'mmio'
> +extra_params = -append 'mmio'
>  groups = gic
>  
> -[gicv2-mmio-3p]
> +[gic-mmio-3p]
>  file = gic.flat
>  smp = $((($MAX_SMP < 3)?$MAX_SMP:3))
> -extra_params = -machine gic-version=2 -append 'mmio'
> +extra_params = -append 'mmio'
>  groups = gic
>  
>  [gicv3-ipi]
> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> index f6dfb90..ffed025 100644
> --- a/lib/arm/asm/gic.h
> +++ b/lib/arm/asm/gic.h
> @@ -23,6 +23,8 @@
>  #define GICD_ITARGETSR			0x0800
>  #define GICD_SGIR			0x0f00
>  #define GICD_ICPIDR2			0x0fe8
> +/* only in GICv3 */
> +#define GICD_PIDR2			0xffe8

If this is gicv3-only, then shouldn't it go to lib/arm/asm/gic-v3.h ?

>  
>  #define GICD_TYPER_IRQS(typer)		((((typer) & 0x1f) + 1) * 32)
>  #define GICD_INT_EN_SET_SGI		0x0000ffff
> -- 
> 2.17.1
> 

Otherwise

Reviewed-by: Andrew Jones <drjones@redhat.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
