Return-Path: <SRS0=w40L=FW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF16FC4361B
	for <kvmarm@archiver.kernel.org>; Fri, 18 Dec 2020 12:04:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4A49623443
	for <kvmarm@archiver.kernel.org>; Fri, 18 Dec 2020 12:04:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A49623443
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2CAF4B0EE;
	Fri, 18 Dec 2020 07:04:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4Dkq6jqUjGzO; Fri, 18 Dec 2020 07:04:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 611704B0EF;
	Fri, 18 Dec 2020 07:04:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A730B4B0E8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2020 07:04:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BedlRJ7sQjhf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Dec 2020 07:04:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D51E4B0DD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2020 07:04:03 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DADA71FB;
 Fri, 18 Dec 2020 04:04:01 -0800 (PST)
Received: from [192.168.2.22] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D65823F66E;
 Fri, 18 Dec 2020 04:04:00 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 01/12] lib: arm/arm64: gicv3: Add
 missing barrier when sending IPIs
To: Alexandru Elisei <alexandru.elisei@arm.com>, drjones@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
 <20201217141400.106137-2-alexandru.elisei@arm.com>
From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
Message-ID: <911a9bfb-061c-69b7-1915-1877f1898e55@arm.com>
Date: Fri, 18 Dec 2020 12:03:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201217141400.106137-2-alexandru.elisei@arm.com>
Content-Language: en-GB
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

On 17/12/2020 14:13, Alexandru Elisei wrote:
> One common usage for IPIs is for one CPU to write to a shared memory
> location, send the IPI to kick another CPU, and the receiver to read from
> the same location. Proper synchronization is needed to make sure that the
> IPI receiver reads the most recent value and not stale data (for example,
> the write from the sender CPU might still be in a store buffer).
> 
> For GICv3, IPIs are generated with a write to the ICC_SGI1R_EL1 register.
> To make sure the memory stores are observable by other CPUs, we need a
> wmb() barrier (DSB ST), which waits for stores to complete.
> 
> From the definition of DSB from ARM DDI 0487F.b, page B2-139:
> 
> "In addition, no instruction that appears in program order after the DSB
> instruction can alter any state of the system or perform any part of its
> functionality until the DSB completes other than:
> 
> - Being fetched from memory and decoded.
> - Reading the general-purpose, SIMD and floating-point, Special-purpose, or
> System registers that are directly or indirectly read without causing
> side-effects."
> 
> Similar definition for armv7 (ARM DDI 0406C.d, page A3-150).
> 
> The DSB instruction is enough to prevent reordering of the GIC register
> write which comes in program order after the memory access.
> 
> This also matches what the Linux GICv3 irqchip driver does (commit
> 21ec30c0ef52 ("irqchip/gic-v3: Use wmb() instead of smb_wmb() in
> gic_raise_softirq()")).
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Yes, makes sense. Also verified the references in both the ARM ARM and
the Linux code.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  lib/arm/gic-v3.c | 6 ++++++
>  arm/gic.c        | 5 +++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
> index a7e2cb819746..2c067e4e9ba2 100644
> --- a/lib/arm/gic-v3.c
> +++ b/lib/arm/gic-v3.c
> @@ -77,6 +77,12 @@ void gicv3_ipi_send_mask(int irq, const cpumask_t *dest)
>  
>  	assert(irq < 16);
>  
> +	/*
> +	 * Ensure stores to Normal memory are visible to other CPUs before
> +	 * sending the IPI.
> +	 */
> +	wmb();
> +
>  	/*
>  	 * For each cpu in the mask collect its peers, which are also in
>  	 * the mask, in order to form target lists.
> diff --git a/arm/gic.c b/arm/gic.c
> index acb060585fae..fee48f9b4ccb 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -275,6 +275,11 @@ static void gicv3_ipi_send_self(void)
>  
>  static void gicv3_ipi_send_broadcast(void)
>  {
> +	/*
> +	 * Ensure stores to Normal memory are visible to other CPUs before
> +	 * sending the IPI
> +	 */
> +	wmb();
>  	gicv3_write_sgi1r(1ULL << 40 | IPI_IRQ << 24);
>  	isb();
>  }
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
