Return-Path: <SRS0=VgM6=WY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A616AC3A5A1
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 14:19:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 335162189D
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 14:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 335162189D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 794CA4A4FA;
	Wed, 28 Aug 2019 10:19:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BKuoCWr85gqG; Wed, 28 Aug 2019 10:19:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E82F4A562;
	Wed, 28 Aug 2019 10:19:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34C604A526
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 10:19:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rQg+PDtVhLbb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Aug 2019 10:19:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E5C84A4FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 10:19:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F30FF28;
 Wed, 28 Aug 2019 07:19:30 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 173B63F246;
 Wed, 28 Aug 2019 07:19:29 -0700 (PDT)
Date: Wed, 28 Aug 2019 15:19:28 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 14/16] lib: arm64: Add support for
 disabling and re-enabling VHE
Message-ID: <20190828141927.GD41023@lakrids.cambridge.arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-15-git-send-email-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1566999511-24916-15-git-send-email-alexandru.elisei@arm.com>
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

On Wed, Aug 28, 2019 at 02:38:29PM +0100, Alexandru Elisei wrote:
> Add a function to disable VHE and another one to re-enable VHE. Both
> functions work under the assumption that the CPU had VHE mode enabled at
> boot.
> 
> Minimal support to run with VHE has been added to the TLB invalidate
> functions and to the exception handling code.
> 
> Since we're touch the assembly enable/disable MMU code, let's take this
> opportunity to replace a magic number with the proper define.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/asm/processor.h       |   8 ++
>  lib/arm64/asm/mmu.h           |  11 ++-
>  lib/arm64/asm/pgtable-hwdef.h |  53 +++++++++---
>  lib/arm64/asm/processor.h     |  44 +++++++++-
>  lib/arm/processor.c           |  11 +++
>  lib/arm/setup.c               |   2 +
>  lib/arm64/processor.c         |  67 ++++++++++++++-
>  arm/cstart64.S                | 186 +++++++++++++++++++++++++++++++++++++++++-
>  8 files changed, 364 insertions(+), 18 deletions(-)

> +extern void asm_disable_vhe(void);
> +void disable_vhe(void)
> +{
> +	u64 sp, sp_phys, sp_base, sp_base_phys;
> +
> +	assert(current_level() == CurrentEL_EL2 && vhe_enabled());
> +
> +	sp = current_stack_pointer;
> +	sp_phys = __virt_to_phys(sp);
> +	sp_base = sp & THREAD_MASK;
> +	sp_base_phys = sp_phys & THREAD_MASK;
> +
> +	/*
> +	 * We will disable, then enable the MMU, make sure the exception
> +	 * handling code works during the small window of time when the MMU is
> +	 * off.
> +	 */
> +	dcache_clean_inval_range(sp_base, sp_base + THREAD_SIZE);
> +	dcache_inval_range(sp_base_phys, sp_base_phys + THREAD_SIZE);
> +	asm volatile(	"mov	sp, %0\n" : :"r" (sp_phys));
> +
> +	asm_disable_vhe();
> +
> +	dcache_clean_inval_range(sp_base_phys, sp_base_phys + THREAD_SIZE);
> +	dcache_inval_range(sp_base, sp_base + THREAD_SIZE);
> +	asm volatile(	"mov	sp, %0\n" : :"r" (sp));
> +}

This sequence is not safe. The compiler can spill/reload at any point,
and the CPU can allocate (clean) lines into the cache while the MMU is
enabled.

I think you need to move the entire sequence to assembly, and should
perform any cache maintenance while the MMU is off.

> +extern void asm_enable_vhe(void);
> +void enable_vhe(void)
> +{
> +	u64 sp, sp_phys, sp_base, sp_base_phys;
> +
> +	assert(current_level() == CurrentEL_EL2 && !vhe_enabled());
> +
> +	sp = current_stack_pointer;
> +	sp_phys = __virt_to_phys(sp);
> +	sp_base = sp & THREAD_MASK;
> +	sp_base_phys = sp_phys & THREAD_MASK;
> +
> +	dcache_clean_inval_range(sp_base, sp_base + THREAD_SIZE);
> +	dcache_inval_range(sp_base_phys, sp_base_phys + THREAD_SIZE);
> +	asm volatile(	"mov	sp, %0\n" : :"r" (sp_phys));
> +
> +	asm_enable_vhe();
> +
> +	dcache_clean_inval_range(sp_base_phys, sp_base_phys + THREAD_SIZE);
> +	dcache_inval_range(sp_base, sp_base + THREAD_SIZE);
> +	asm volatile(	"mov	sp, %0\n" : :"r" (sp));
> +}

Likewise.

> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index d4b20267a7a6..dc9e634e2307 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -104,6 +104,13 @@ exceptions_init:
>  
>  .text
>  
> +exceptions_init_nvhe:
> +	adrp	x0, vector_table_nvhe
> +	add	x0, x0, :lo12:vector_table_nvhe
> +	msr	vbar_el2, x0
> +	isb
> +	ret
> +
>  .globl get_mmu_off
>  get_mmu_off:
>  	adrp	x0, auxinfo
> @@ -204,7 +211,7 @@ asm_mmu_enable:
>  		     TCR_IRGN_WBWA | TCR_ORGN_WBWA |	\
>  		     TCR_SHARED
>  	mrs	x2, id_aa64mmfr0_el1
> -	bfi	x1, x2, #32, #3
> +	bfi	x1, x2, #TCR_EL1_IPS_SHIFT, #3
>  	msr	tcr_el1, x1
>  
>  	/* MAIR */
> @@ -229,6 +236,33 @@ asm_mmu_enable:
>  
>  	ret
>  
> +asm_mmu_enable_nvhe:
> +	ic      iallu
> +	tlbi    alle2is
> +	dsb     ish

why is the IC local, but the TLBI broadcast?

If this only needs ot be local, a DSB NSH will be sufficient.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
