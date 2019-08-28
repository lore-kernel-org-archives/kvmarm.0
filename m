Return-Path: <SRS0=VgM6=WY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AA2C3A5A1
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 14:09:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DAE452189D
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 14:09:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAE452189D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 548214A562;
	Wed, 28 Aug 2019 10:09:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dsYJ+x2j19+T; Wed, 28 Aug 2019 10:09:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17D1B4A563;
	Wed, 28 Aug 2019 10:09:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4E7D4A580
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 10:09:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9sPVlKMwTyRy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Aug 2019 10:09:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40CFD40A52
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 10:09:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7B1B28;
 Wed, 28 Aug 2019 07:09:28 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF91F3F246;
 Wed, 28 Aug 2019 07:09:27 -0700 (PDT)
Date: Wed, 28 Aug 2019 15:09:25 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 04/16] arm/arm64: selftest: Add
 prefetch abort test
Message-ID: <20190828140925.GC41023@lakrids.cambridge.arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-5-git-send-email-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1566999511-24916-5-git-send-email-alexandru.elisei@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: maz@kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, andre.przywara@arm.com
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

On Wed, Aug 28, 2019 at 02:38:19PM +0100, Alexandru Elisei wrote:
> When a guest tries to execute code from MMIO memory, KVM injects an
> external abort into that guest. We have now fixed the psci test to not
> fetch instructions from the I/O region, and it's not that often that a
> guest misbehaves in such a way. Let's expand our coverage by adding a
> proper test targetting this corner case.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> The fault injection path is broken for nested guests [1]. You can use the
> last patch from the thread [2] to successfully run the test at EL2.
> 
> [1] https://www.spinics.net/lists/arm-kernel/msg745391.html
> [2] https://www.spinics.net/lists/arm-kernel/msg750310.html
> 
>  lib/arm64/asm/esr.h |  3 ++
>  arm/selftest.c      | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 96 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
> index 8e5af4d90767..8c351631b0a0 100644
> --- a/lib/arm64/asm/esr.h
> +++ b/lib/arm64/asm/esr.h
> @@ -44,4 +44,7 @@
>  #define ESR_EL1_EC_BKPT32	(0x38)
>  #define ESR_EL1_EC_BRK64	(0x3C)
>  
> +#define ESR_EL1_FSC_MASK	(0x3F)
> +#define ESR_EL1_FSC_EXTABT	(0x10)
> +
>  #endif /* _ASMARM64_ESR_H_ */
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 176231f32ee1..18cc0ad8f729 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -16,6 +16,8 @@
>  #include <asm/psci.h>
>  #include <asm/smp.h>
>  #include <asm/barrier.h>
> +#include <asm/mmu.h>
> +#include <asm/pgtable.h>
>  
>  static void __user_psci_system_off(void)
>  {
> @@ -60,9 +62,38 @@ static void check_setup(int argc, char **argv)
>  		report_abort("missing input");
>  }
>  
> +extern pgd_t *mmu_idmap;
> +static void prep_io_exec(void)
> +{
> +	pgd_t *pgd = pgd_offset(mmu_idmap, 0);
> +	unsigned long sctlr;
> +
> +	/*
> +	 * AArch64 treats all regions writable at EL0 as PXN.

I didn't think that was the case, and I can't find wording to that
effect in the ARM ARM (looking at ARM DDI 0487E.a). Where is that
stated?

> Clear the user bit
> +	 * so we can execute code from the bottom I/O space (0G-1G) to simulate
> +	 * a misbehaved guest.
> +	 */
> +	pgd_val(*pgd) &= ~PMD_SECT_USER;
> +	flush_dcache_addr((unsigned long)pgd);

The virtualization extensions imply coherent page table walks, so I
don't think the cache maintenance is necessary (provided
TCR_EL1.{SH*,ORGN*,IRGN*} are configured appropriately.

> +	flush_tlb_page(0);
> +
> +	/* Make sure we can actually execute from a writable region */
> +#ifdef __arm__
> +	asm volatile("mrc p15, 0, %0, c1, c0, 0": "=r" (sctlr));
> +	sctlr &= ~CR_ST;
> +	asm volatile("mcr p15, 0, %0, c1, c0, 0" :: "r" (sctlr));
> +#else
> +	sctlr = read_sysreg(sctlr_el1);
> +	sctlr &= ~SCTLR_EL1_WXN;
> +	write_sysreg(sctlr, sctlr_el1);
> +#endif
> +	isb();
> +}

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
