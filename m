Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF490C5519F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 19:20:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2572A24655
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 19:20:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qM2lhbVf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2572A24655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A7AE4B6AC;
	Tue, 17 Nov 2020 14:20:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wjGsrUuZwtwY; Tue, 17 Nov 2020 14:20:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB5DA4B624;
	Tue, 17 Nov 2020 14:20:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA4504B61B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 14:20:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eD9W8Mw+sqob for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 14:20:38 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3FAE04B617
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 14:20:38 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0309C24631;
 Tue, 17 Nov 2020 19:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605640837;
 bh=ohOh5WPXiqeSu0K35QMhfsgvCplCZR23KeDba4m8iGI=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=qM2lhbVfp8tuRszbBkvzfLyHV88MlpBMhPmcEo+APzoMMPQUG3LZmem8/HJsZ+3vX
 V+J7ajFzNUGxfUMq7hh9awyECnFBpACJZ1RElQ4VzdJRAvn6mAO5f+RktOx1jA8Mg3
 vPd6NfjYIexuIUTewlstCwGmgpZxJfqhYltGD3C0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kf6Wo-00BSt5-Ja; Tue, 17 Nov 2020 19:20:34 +0000
MIME-Version: 1.0
Date: Tue, 17 Nov 2020 19:20:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v4 1/2] arm64: kvm: Save/restore MTE registers
In-Reply-To: <20201026155727.36685-2-steven.price@arm.com>
References: <20201026155727.36685-1-steven.price@arm.com>
 <20201026155727.36685-2-steven.price@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <b8f2fe15e0cab5c24094915b8c000930@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: steven.price@arm.com, catalin.marinas@arm.com,
 will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Dave.Martin@arm.com, mark.rutland@arm.com, tglx@linutronix.de,
 qemu-devel@nongnu.org, quintela@redhat.com, dgilbert@redhat.com,
 richard.henderson@linaro.org, peter.maydell@linaro.org, Haibo.Xu@arm.com,
 drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
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

Hi Steven,

These patches unfortunately don't apply to -rc4 anymore, as we repainted
quite a bit while working on fixes. I'd be grateful if you could rebase 
them.

A few other things though:

On 2020-10-26 15:57, Steven Price wrote:
> Define the new system registers that MTE introduces and context switch
> them. The MTE feature is still hidden from the ID register as it isn't
> supported in a VM yet.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_host.h          |  4 ++++
>  arch/arm64/include/asm/sysreg.h            |  3 ++-
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 14 ++++++++++++++
>  arch/arm64/kvm/sys_regs.c                  | 14 ++++++++++----
>  4 files changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index 0aecbab6a7fb..95ab7345dcc8 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -134,6 +134,8 @@ enum vcpu_sysreg {
>  	SCTLR_EL1,	/* System Control Register */
>  	ACTLR_EL1,	/* Auxiliary Control Register */
>  	CPACR_EL1,	/* Coprocessor Access Control */
> +	RGSR_EL1,	/* Random Allocation Tag Seed Register */
> +	GCR_EL1,	/* Tag Control Register */
>  	ZCR_EL1,	/* SVE Control */
>  	TTBR0_EL1,	/* Translation Table Base Register 0 */
>  	TTBR1_EL1,	/* Translation Table Base Register 1 */
> @@ -150,6 +152,8 @@ enum vcpu_sysreg {
>  	TPIDR_EL1,	/* Thread ID, Privileged */
>  	AMAIR_EL1,	/* Aux Memory Attribute Indirection Register */
>  	CNTKCTL_EL1,	/* Timer Control Register (EL1) */
> +	TFSRE0_EL1,	/* Tag Fault Status Register (EL0) */
> +	TFSR_EL1,	/* Tag Fault Stauts Register (EL1) */
>  	PAR_EL1,	/* Physical Address Register */
>  	MDSCR_EL1,	/* Monitor Debug System Control Register */
>  	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
> diff --git a/arch/arm64/include/asm/sysreg.h 
> b/arch/arm64/include/asm/sysreg.h
> index d52c1b3ce589..7727df0bc09d 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -565,7 +565,8 @@
>  #define SCTLR_ELx_M	(BIT(0))
> 
>  #define SCTLR_ELx_FLAGS	(SCTLR_ELx_M  | SCTLR_ELx_A | SCTLR_ELx_C | \
> -			 SCTLR_ELx_SA | SCTLR_ELx_I | SCTLR_ELx_IESB)
> +			 SCTLR_ELx_SA | SCTLR_ELx_I | SCTLR_ELx_IESB | \
> +			 SCTLR_ELx_ITFSB)
> 
>  /* SCTLR_EL2 specific flags. */
>  #define SCTLR_EL2_RES1	((BIT(4))  | (BIT(5))  | (BIT(11)) | (BIT(16)) 
> | \
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index 7a986030145f..a124ffa49ba3 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -18,6 +18,11 @@
>  static inline void __sysreg_save_common_state(struct kvm_cpu_context 
> *ctxt)
>  {
>  	ctxt_sys_reg(ctxt, MDSCR_EL1)	= read_sysreg(mdscr_el1);
> +	if (system_supports_mte()) {
> +		ctxt_sys_reg(ctxt, RGSR_EL1)	= read_sysreg_s(SYS_RGSR_EL1);
> +		ctxt_sys_reg(ctxt, GCR_EL1)	= read_sysreg_s(SYS_GCR_EL1);
> +		ctxt_sys_reg(ctxt, TFSRE0_EL1)	= read_sysreg_s(SYS_TFSRE0_EL1);

As far as I can tell, HCR_EL2.ATA is still clear when running a guest.
So why, do we save/restore this state yet?

Also, I wonder whether we should keep these in the C code. If one day
we enable MTE in the kernel, we will have to move them to the assembly
part, much like we do for PAuth. And I fear that "one day" is pretty
soon:

https://lore.kernel.org/linux-arm-kernel/cover.1605046192.git.andreyknvl@google.com/


> +	}
>  }
> 
>  static inline void __sysreg_save_user_state(struct kvm_cpu_context 
> *ctxt)
> @@ -45,6 +50,8 @@ static inline void __sysreg_save_el1_state(struct
> kvm_cpu_context *ctxt)
>  	ctxt_sys_reg(ctxt, CNTKCTL_EL1)	= read_sysreg_el1(SYS_CNTKCTL);
>  	ctxt_sys_reg(ctxt, PAR_EL1)	= read_sysreg(par_el1);
>  	ctxt_sys_reg(ctxt, TPIDR_EL1)	= read_sysreg(tpidr_el1);
> +	if (system_supports_mte())
> +		ctxt_sys_reg(ctxt, TFSR_EL1) = read_sysreg_el1(SYS_TFSR);
> 
>  	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
>  	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
> @@ -63,6 +70,11 @@ static inline void
> __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
>  static inline void __sysreg_restore_common_state(struct 
> kvm_cpu_context *ctxt)
>  {
>  	write_sysreg(ctxt_sys_reg(ctxt, MDSCR_EL1),  mdscr_el1);
> +	if (system_supports_mte()) {
> +		write_sysreg_s(ctxt_sys_reg(ctxt, RGSR_EL1), SYS_RGSR_EL1);
> +		write_sysreg_s(ctxt_sys_reg(ctxt, GCR_EL1), SYS_GCR_EL1);
> +		write_sysreg_s(ctxt_sys_reg(ctxt, TFSRE0_EL1), SYS_TFSRE0_EL1);
> +	}
>  }
> 
>  static inline void __sysreg_restore_user_state(struct kvm_cpu_context 
> *ctxt)
> @@ -106,6 +118,8 @@ static inline void
> __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg_el1(ctxt_sys_reg(ctxt, CNTKCTL_EL1), SYS_CNTKCTL);
>  	write_sysreg(ctxt_sys_reg(ctxt, PAR_EL1),	par_el1);
>  	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL1),	tpidr_el1);
> +	if (system_supports_mte())
> +		write_sysreg_el1(ctxt_sys_reg(ctxt, TFSR_EL1), SYS_TFSR);
> 
>  	if (!has_vhe() &&
>  	    cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT) &&
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index d9117bc56237..430e36e1a13d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1391,6 +1391,12 @@ static bool access_mte_regs(struct kvm_vcpu
> *vcpu, struct sys_reg_params *p,
>  	return false;
>  }
> 
> +static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
> +				   const struct sys_reg_desc *rd)
> +{
> +	return REG_HIDDEN_USER | REG_HIDDEN_GUEST;

The handling of visibility has changed somehow since 01fe5ace92dd.

> +}
> +
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
>  #define ID_SANITISED(name) {			\
>  	SYS_DESC(SYS_##name),			\
> @@ -1557,8 +1563,8 @@ static const struct sys_reg_desc sys_reg_descs[] 
> = {
>  	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
>  	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
> 
> -	{ SYS_DESC(SYS_RGSR_EL1), access_mte_regs },
> -	{ SYS_DESC(SYS_GCR_EL1), access_mte_regs },
> +	{ SYS_DESC(SYS_RGSR_EL1), access_mte_regs, reset_unknown, RGSR_EL1,
> .visibility = mte_visibility },
> +	{ SYS_DESC(SYS_GCR_EL1), access_mte_regs, reset_unknown, GCR_EL1,
> .visibility = mte_visibility },
> 
>  	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility =
> sve_visibility },
>  	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
> @@ -1584,8 +1590,8 @@ static const struct sys_reg_desc sys_reg_descs[] 
> = {
>  	{ SYS_DESC(SYS_ERXMISC0_EL1), trap_raz_wi },
>  	{ SYS_DESC(SYS_ERXMISC1_EL1), trap_raz_wi },
> 
> -	{ SYS_DESC(SYS_TFSR_EL1), access_mte_regs },
> -	{ SYS_DESC(SYS_TFSRE0_EL1), access_mte_regs },
> +	{ SYS_DESC(SYS_TFSR_EL1), access_mte_regs, reset_unknown, TFSR_EL1,
> .visibility = mte_visibility },
> +	{ SYS_DESC(SYS_TFSRE0_EL1), access_mte_regs, reset_unknown,
> TFSRE0_EL1, .visibility = mte_visibility },
> 
>  	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
>  	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
