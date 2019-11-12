Return-Path: <SRS0=CLkw=ZE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE42C43331
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 16:58:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C597F214E0
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 16:58:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C597F214E0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3734F4B18B;
	Tue, 12 Nov 2019 11:58:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XuRSWLmeltFo; Tue, 12 Nov 2019 11:58:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15DFE4B18D;
	Tue, 12 Nov 2019 11:58:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 208514B18B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 11:58:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b8TxpnWgL-UM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Nov 2019 11:58:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED7314B18A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 11:58:07 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FD9A30E;
 Tue, 12 Nov 2019 08:58:07 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 96C733F534;
 Tue, 12 Nov 2019 08:58:06 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 11/17] arm: gic: Check for validity of both
 group enable bits
To: Andre Przywara <andre.przywara@arm.com>, Andrew Jones
 <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-12-andre.przywara@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <5f667bf5-7404-4a33-590e-cdf0a432cb8d@arm.com>
Date: Tue, 12 Nov 2019 16:58:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-12-andre.przywara@arm.com>
Content-Language: en-US
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

Hi,

On 11/8/19 2:42 PM, Andre Przywara wrote:
> The GIC distributor actually supports *two* enable bits, one per
> interrupt group. Linux itself won't care and will only ever use one bit.
> In a VM however we have two groups available, so we should be able to
> flip the two separate enable bits.
>
> Provide tests that try to flip the two available bits and check whether
> they stick.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c            | 21 +++++++++++++++++++++
>  lib/arm/asm/gic-v3.h |  4 ++--
>  lib/arm/gic-v3.c     |  2 +-
>  3 files changed, 24 insertions(+), 3 deletions(-)
>
> diff --git a/arm/gic.c b/arm/gic.c
> index 485ca4f..a0511e5 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -640,6 +640,8 @@ static void spi_test_smp(void)
>  	report("SPI delievered on all cores", cores == nr_cpus);
>  }
>  
> +#define GICD_CTLR_ENABLE_BOTH (GICD_CTLR_ENABLE_G0 | GICD_CTLR_ENABLE_G1)
> +
>  /*
>   * Check the security state configuration of the GIC.
>   * Test whether we can switch to a single security state, to test both
> @@ -694,6 +696,25 @@ static void test_irq_group(void *gicd_base)
>  			return;
>  	}
>  
> +	/* Check whether the group enable bits stick. */
> +	reg = readl(gicd_base + GICD_CTLR);
> +	writel(reg & ~GICD_CTLR_ENABLE_BOTH, gicd_base + GICD_CTLR);
> +	reg = readl(gicd_base + GICD_CTLR);
> +	report("both groups disabled sticks",
> +	       (reg & GICD_CTLR_ENABLE_BOTH) == 0);
> +
> +	reg &= ~GICD_CTLR_ENABLE_BOTH;
> +	writel(reg | GICD_CTLR_ENABLE_G1, gicd_base + GICD_CTLR);
> +	reg = readl(gicd_base + GICD_CTLR);
> +	report("group 1 enabled sticks",
> +	       (reg & GICD_CTLR_ENABLE_BOTH) == GICD_CTLR_ENABLE_G1);
> +
> +	reg &= ~GICD_CTLR_ENABLE_BOTH;
> +	writel(reg | GICD_CTLR_ENABLE_G0, gicd_base + GICD_CTLR);
> +	reg = readl(gicd_base + GICD_CTLR);
> +	report("group 0 enabled sticks",
> +	       (reg & GICD_CTLR_ENABLE_BOTH) == GICD_CTLR_ENABLE_G0);

How about adding a check that enabling both groups at the same time works?

> +
>  	/*
>  	 * On a security aware GIC in non-secure world the IGROUPR registers
>  	 * are RAZ/WI. KVM emulates a single-security-state GIC, so both
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index 2eaf944..0a29610 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -21,8 +21,8 @@
>  #define GICD_CTLR_RWP			(1U << 31)
>  #define GICD_CTLR_DS			(1U << 6)
>  #define GICD_CTLR_ARE_NS		(1U << 4)
> -#define GICD_CTLR_ENABLE_G1A		(1U << 1)
> -#define GICD_CTLR_ENABLE_G1		(1U << 0)
> +#define GICD_CTLR_ENABLE_G1		(1U << 1)
> +#define GICD_CTLR_ENABLE_G0		(1U << 0)

Nice cleanup.

>  
>  #define GICD_IROUTER			0x6000
>  #define GICD_PIDR2			0xffe8
> diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
> index feecb5e..d6a5186 100644
> --- a/lib/arm/gic-v3.c
> +++ b/lib/arm/gic-v3.c
> @@ -42,7 +42,7 @@ void gicv3_enable_defaults(void)
>  	writel(0, dist + GICD_CTLR);
>  	gicv3_dist_wait_for_rwp();
>  
> -	writel(GICD_CTLR_ARE_NS | GICD_CTLR_ENABLE_G1A | GICD_CTLR_ENABLE_G1,
> +	writel(GICD_CTLR_ARE_NS | GICD_CTLR_ENABLE_G0 | GICD_CTLR_ENABLE_G1,
>  	       dist + GICD_CTLR);
>  	gicv3_dist_wait_for_rwp();
>  
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
