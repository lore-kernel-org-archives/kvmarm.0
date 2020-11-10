Return-Path: <SRS0=+U1N=EQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0377DC388F7
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 15:56:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 301572068D
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 15:56:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hm7VSa4y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 301572068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 826B54B710;
	Tue, 10 Nov 2020 10:56:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T9KyS0XN1F9k; Tue, 10 Nov 2020 10:56:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 395234B7E5;
	Tue, 10 Nov 2020 10:56:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88E0C4B726
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 10:56:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qHNL5aa1DyG4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2020 10:56:04 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 271CD4B710
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 10:56:04 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B077B20678;
 Tue, 10 Nov 2020 15:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605023762;
 bh=Eo0MWPPGvXTFnYkuWfDnVUHwKz8AEJ3ivHYMYusnut0=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=hm7VSa4yMcZIFtuMT+B3gPOylF14tJBlCmKDdyjnEGz14C1i9nNMqZcMRdncsP+av
 kIlIpdAinU+hi2pS1WhuseW/xN8qTBySD9YVJigLo9H6J0et2fo8pLEIKryy/41epx
 IF+pp87icY6zd1XFSYbTm/XrzuxR4bDaRoBWqo1Q=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcW00-009UrU-Ha; Tue, 10 Nov 2020 15:56:00 +0000
MIME-Version: 1.0
Date: Tue, 10 Nov 2020 15:56:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v1 10/24] kvm: arm64: Extract parts of el2_setup into a
 macro
In-Reply-To: <20201109113233.9012-11-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-11-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <a6f5d318eb7e7adde2106df068121b48@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, dennis@kernel.org, tj@kernel.org,
 cl@linux.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com,
 qperret@google.com, ascull@google.com, qwandor@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-11-09 11:32, David Brazdil wrote:
> When the a CPU is booted in EL2, the kernel checks for VHE support and
> initializes the CPU core accordingly. For nVHE it also installs the 
> stub
> vectors and drops down to EL1.
> 
> Once KVM gains the ability to boot cores without going through the
> kernel entry point, it will need to initialize the CPU the same way.
> Extract the relevant bits of el2_setup into init_el2_state macro
> with an argument specifying whether to initialize for VHE or nVHE.
> 
> No functional change. Size of el2_setup increased by 148 bytes due
> to duplication.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h | 128 ++++++++++++++++++++++++++++
>  arch/arm64/kernel/head.S         | 140 +++----------------------------
>  2 files changed, 141 insertions(+), 127 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h 
> b/arch/arm64/include/asm/kvm_asm.h
> index a49a87a186c3..893327d1e449 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -331,6 +331,134 @@ extern char
> __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
>  	msr	sp_el0, \tmp
>  .endm
> 
> +.macro init_el2_state mode
> +
> +.ifnes "\mode", "vhe"
> +.ifnes "\mode", "nvhe"
> +.error "Invalid 'mode' argument"
> +.endif
> +.endif
> +
> +	mov_q	x0, (SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
> +	msr	sctlr_el2, x0
> +	isb
> +
> +	/*
> +	 * Allow Non-secure EL1 and EL0 to access physical timer and counter.
> +	 * This is not necessary for VHE, since the host kernel runs in EL2,
> +	 * and EL0 accesses are configured in the later stage of boot 
> process.
> +	 * Note that when HCR_EL2.E2H == 1, CNTHCTL_EL2 has the same bit 
> layout
> +	 * as CNTKCTL_EL1, and CNTKCTL_EL1 accessing instructions are 
> redefined
> +	 * to access CNTHCTL_EL2. This allows the kernel designed to run at 
> EL1
> +	 * to transparently mess with the EL0 bits via CNTKCTL_EL1 access in
> +	 * EL2.
> +	 */
> +.ifeqs "\mode", "nvhe"
> +	mrs	x0, cnthctl_el2
> +	orr	x0, x0, #3			// Enable EL1 physical timers
> +	msr	cnthctl_el2, x0
> +.endif
> +	msr	cntvoff_el2, xzr		// Clear virtual offset
> +
> +#ifdef CONFIG_ARM_GIC_V3
> +	/* GICv3 system register access */
> +	mrs	x0, id_aa64pfr0_el1
> +	ubfx	x0, x0, #ID_AA64PFR0_GIC_SHIFT, #4
> +	cbz	x0, 3f
> +
> +	mrs_s	x0, SYS_ICC_SRE_EL2
> +	orr	x0, x0, #ICC_SRE_EL2_SRE	// Set ICC_SRE_EL2.SRE==1
> +	orr	x0, x0, #ICC_SRE_EL2_ENABLE	// Set ICC_SRE_EL2.Enable==1
> +	msr_s	SYS_ICC_SRE_EL2, x0
> +	isb					// Make sure SRE is now set
> +	mrs_s	x0, SYS_ICC_SRE_EL2		// Read SRE back,
> +	tbz	x0, #0, 3f			// and check that it sticks
> +	msr_s	SYS_ICH_HCR_EL2, xzr		// Reset ICC_HCR_EL2 to defaults
> +3:
> +#endif
> +
> +	/* Populate ID registers. */
> +	mrs	x0, midr_el1
> +	mrs	x1, mpidr_el1
> +	msr	vpidr_el2, x0
> +	msr	vmpidr_el2, x1

I don't think this has any effect on VHE, and could be lumped
together with the nVHE code.

> +
> +#ifdef CONFIG_COMPAT
> +	msr	hstr_el2, xzr			// Disable CP15 traps to EL2
> +#endif
> +
> +	/* EL2 debug */
> +	mrs	x1, id_aa64dfr0_el1
> +	sbfx	x0, x1, #ID_AA64DFR0_PMUVER_SHIFT, #4
> +	cmp	x0, #1
> +	b.lt	4f				// Skip if no PMU present
> +	mrs	x0, pmcr_el0			// Disable debug access traps
> +	ubfx	x0, x0, #11, #5			// to EL2 and allow access to
> +4:
> +	csel	x3, xzr, x0, lt			// all PMU counters from EL1
> +
> +	/* Statistical profiling */
> +	ubfx	x0, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
> +	cbz	x0, 7f				// Skip if SPE not present
> +.ifeqs "\mode", "nvhe"
> +	mrs_s	x4, SYS_PMBIDR_EL1		// If SPE available at EL2,
> +	and	x4, x4, #(1 << SYS_PMBIDR_EL1_P_SHIFT)
> +	cbnz	x4, 5f				// then permit sampling of physical
> +	mov	x4, #(1 << SYS_PMSCR_EL2_PCT_SHIFT | \
> +		      1 << SYS_PMSCR_EL2_PA_SHIFT)
> +	msr_s	SYS_PMSCR_EL2, x4		// addresses and physical counter
> +5:
> +	mov	x1, #(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)
> +	orr	x3, x3, x1			// If we don't have VHE, then
> +	b	7f				// use EL1&0 translation.
> +.endif
> +	orr	x3, x3, #MDCR_EL2_TPMS		// and disable access from EL1

This orr would probably be better placed in an "else" close to the
previous macro. And since you are making things "modular", why not
go the extra mile, and define macros for each functionality that
defer between modes? It would certainly make this change more digest,
and the result more readable.

> +7:
> +	msr	mdcr_el2, x3			// Configure debug traps
> +
> +	/* LORegions */
> +	mrs	x1, id_aa64mmfr1_el1
> +	ubfx	x0, x1, #ID_AA64MMFR1_LOR_SHIFT, 4
> +	cbz	x0, 1f
> +	msr_s	SYS_LORC_EL1, xzr
> +1:
> +
> +	/* Stage-2 translation */
> +	msr	vttbr_el2, xzr
> +
> +.ifeqs "\mode", "nvhe"
> +	/*
> +	 * When VHE is not in use, early init of EL2 and EL1 needs to be
> +	 * done here.
> +	 * When VHE _is_ in use, EL1 will not be used in the host and
> +	 * requires no configuration, and all non-hyp-specific EL2 setup
> +	 * will be done via the _EL1 system register aliases in __cpu_setup.
> +	 */
> +	mov_q	x0, (SCTLR_EL1_RES1 | ENDIAN_SET_EL1)
> +	msr	sctlr_el1, x0
> +
> +	/* Coprocessor traps. */
> +	mov	x0, #0x33ff
> +	msr	cptr_el2, x0			// Disable copro. traps to EL2
> +
> +	/* SVE register access */
> +	mrs	x1, id_aa64pfr0_el1
> +	ubfx	x1, x1, #ID_AA64PFR0_SVE_SHIFT, #4
> +	cbz	x1, 7f
> +
> +	bic	x0, x0, #CPTR_EL2_TZ		// Also disable SVE traps
> +	msr	cptr_el2, x0			// Disable copro. traps to EL2
> +	isb
> +	mov	x1, #ZCR_ELx_LEN_MASK		// SVE: Enable full vector
> +	msr_s	SYS_ZCR_EL2, x1			// length for EL1.
> +
> +	/* spsr */
> +7:	mov	x0, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
> +		      PSR_MODE_EL1h)
> +	msr	spsr_el2, x0
> +.endif
> +.endm
> +
>  #endif
> 
>  #endif /* __ARM_KVM_ASM_H__ */
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index d8d9caf02834..e7270b63abed 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -25,6 +25,7 @@
>  #include <asm/image.h>
>  #include <asm/kernel-pgtable.h>
>  #include <asm/kvm_arm.h>
> +#include <asm/kvm_asm.h>
>  #include <asm/memory.h>
>  #include <asm/pgtable-hwdef.h>
>  #include <asm/page.h>
> @@ -499,153 +500,38 @@ SYM_FUNC_START(el2_setup)
>  	isb
>  	ret
> 
> -1:	mov_q	x0, (SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
> -	msr	sctlr_el2, x0
> -
> +1:
>  #ifdef CONFIG_ARM64_VHE
>  	/*
> -	 * Check for VHE being present. For the rest of the EL2 setup,
> -	 * x2 being non-zero indicates that we do have VHE, and that the
> -	 * kernel is intended to run at EL2.
> +	 * Check for VHE being present. x2 being non-zero indicates that we
> +	 * do have VHE, and that the kernel is intended to run at EL2.
>  	 */
>  	mrs	x2, id_aa64mmfr1_el1
>  	ubfx	x2, x2, #ID_AA64MMFR1_VHE_SHIFT, #4
> -#else
> -	mov	x2, xzr
> -#endif
> +	cbz	x2, el2_setup_nvhe

What initialises x2 to zero when CONFIG_VHE is disabled?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
