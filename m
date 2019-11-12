Return-Path: <SRS0=CLkw=ZE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B04C43331
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 12:49:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3DD19206A3
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 12:49:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gx7ZgN/t"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DD19206A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CE464B19A;
	Tue, 12 Nov 2019 07:49:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gWc5pbQap+oh; Tue, 12 Nov 2019 07:49:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39EE64B18D;
	Tue, 12 Nov 2019 07:49:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53B704B18E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 07:49:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PoqDQ7cVQU0b for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Nov 2019 07:49:50 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3135D4B18D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 07:49:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1573562989;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nvYcM7f3oL6WcKps2IjEC36+XCQGeg8zp1MVCMPdVfM=;
 b=Gx7ZgN/tjUOdAU+aSHeqGprEx38fI6bqVjO8cIGr3mINCadw3IxumlJhPQseCdF52zhmNd
 TPf8UMst6RouDxdLKv0wiCrP9bdyqjua8D6SJ1RIwCWRM66AYKzEwWMHF25v4xUjqFKnyt
 XWqyMnpeQ9TjMMJ27oivYEm/KXE1kug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-_AhoEWoDOA68FMcZsD6Vbw-1; Tue, 12 Nov 2019 07:49:48 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55707107ACC5;
 Tue, 12 Nov 2019 12:49:45 +0000 (UTC)
Received: from [10.36.116.54] (ovpn-116-54.ams2.redhat.com [10.36.116.54])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 61D905DDA8;
 Tue, 12 Nov 2019 12:49:43 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 01/17] arm: gic: Enable GIC MMIO tests for
 GICv3 as well
To: Andre Przywara <andre.przywara@arm.com>, Andrew Jones
 <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-2-andre.przywara@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <ee75ee48-c774-c2d8-2156-f9ed256733e6@redhat.com>
Date: Tue, 12 Nov 2019 13:49:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-2-andre.przywara@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: _AhoEWoDOA68FMcZsD6Vbw-1
X-Mimecast-Spam-Score: 0
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

Hi Andre,

On 11/8/19 3:42 PM, Andre Przywara wrote:
> So far the GIC MMIO tests were only enabled for a GICv2 guest. Modern
> machines tend to have a GICv3-only GIC, so can't run those tests.
> It turns out that most GIC distributor registers we test in the unit
> tests are actually the same in GICv3, so we can just enable those tests
> for GICv3 guests as well.
> The only exception is the CPU number in the TYPER register, which is
> only valid in the GICv2 compat mode (ARE=0), which KVM does not support.
> So we protect this test against running on a GICv3 guest.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c            | 13 +++++++++++--
>  arm/unittests.cfg    | 26 ++++++++++++++++++++++----
>  lib/arm/asm/gic-v3.h |  2 ++
>  3 files changed, 35 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index adb6aa4..04b3337 100644
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
> @@ -496,7 +497,14 @@ static void gic_test_mmio(void)
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
> @@ -505,7 +513,8 @@ static void gic_test_mmio(void)
>  	nr_irqs = GICD_TYPER_IRQS(reg);
>  	report_info("number of implemented SPIs: %d", nr_irqs - GIC_FIRST_SPI);
>  
> -	test_typer_v2(reg);
> +	if (gic_version() == 0x2)
> +		test_typer_v2(reg);

nit: reports mention ICPIDR2 independently on the version.

	report("ICPIDR2 is read-only", test_readonly_32(idreg, false));
	report_info("value of ICPIDR2: 0x%08x", reg);

>  
>  	report_info("IIDR: 0x%08x", readl(gic_dist_base + GICD_IIDR));
>  
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index daeb5a0..12ac142 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -86,28 +86,46 @@ smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
>  extra_params = -machine gic-version=2 -append 'ipi'
>  groups = gic
>  
> -[gicv2-mmio]
> +[gicv3-ipi]
> +file = gic.flat
> +smp = $MAX_SMP
> +extra_params = -machine gic-version=3 -append 'ipi'
> +groups = gic
> +
> +[gicv2-max-mmio]
>  file = gic.flat
>  smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
>  extra_params = -machine gic-version=2 -append 'mmio'
>  groups = gic
>  
> +[gicv3-max-mmio]
> +file = gic.flat
> +smp = $MAX_SMP
> +extra_params = -machine gic-version=3 -append 'mmio'
> +groups = gic
> +
>  [gicv2-mmio-up]
>  file = gic.flat
>  smp = 1
>  extra_params = -machine gic-version=2 -append 'mmio'
>  groups = gic
>  
> +[gicv3-mmio-up]
> +file = gic.flat
> +smp = 1
> +extra_params = -machine gic-version=3 -append 'mmio'
> +groups = gic
> +
>  [gicv2-mmio-3p]
>  file = gic.flat
>  smp = $((($MAX_SMP < 3)?$MAX_SMP:3))
>  extra_params = -machine gic-version=2 -append 'mmio'
>  groups = gic
>  
> -[gicv3-ipi]
> +[gicv3-mmio-3p]
>  file = gic.flat
> -smp = $MAX_SMP
> -extra_params = -machine gic-version=3 -append 'ipi'
> +smp = $((($MAX_SMP < 3)?$MAX_SMP:3))
why do we keep this smp computation?
> +extra_params = -machine gic-version=2 -append 'mmio'
gic-version=3
>  groups = gic
>  
>  [gicv2-active]
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index 347be2f..ed6a5ad 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -23,6 +23,8 @@
>  #define GICD_CTLR_ENABLE_G1A		(1U << 1)
>  #define GICD_CTLR_ENABLE_G1		(1U << 0)
>  
> +#define GICD_PIDR2			0xffe8
> +
>  /* Re-Distributor registers, offsets from RD_base */
>  #define GICR_TYPER			0x0008
>  
>

Otherwise Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
