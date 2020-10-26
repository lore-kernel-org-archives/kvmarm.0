Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63C4C55178
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 14:26:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54D1A239D2
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 14:26:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54D1A239D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79D5E4B478;
	Mon, 26 Oct 2020 10:26:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cJV16d0ef2xs; Mon, 26 Oct 2020 10:26:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C62714B47B;
	Mon, 26 Oct 2020 10:26:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38FCC4B478
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 10:26:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kBc9uoQrDWtr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 10:26:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48AB64B110
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 10:26:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB94C30E;
 Mon, 26 Oct 2020 07:26:40 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.56.187])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2DCC33F68F;
 Mon, 26 Oct 2020 07:26:38 -0700 (PDT)
Date: Mon, 26 Oct 2020 14:26:36 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 08/11] KVM: arm64: Inject AArch32 exceptions from HYP
Message-ID: <20201026142636.GJ12454@C02TD0UTHF1T.local>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-9-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201026133450.73304-9-maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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

On Mon, Oct 26, 2020 at 01:34:47PM +0000, Marc Zyngier wrote:
> Similarily to what has been done for AArch64, move the AArch32 exception
> inhjection to HYP.
> 
> In order to not use the regmap selection code at EL2, simplify the code
> populating the target mode's LR register by harcoding the two possible
> LR registers (LR_abt in X20, LR_und in X22).
> 
> We also introduce new accessors for SPSR and CP15 registers.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Modulo comments on the prior patch for the AArch64 exception bits that
get carried along:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/kvm/aarch32.c       | 149 +---------------------
>  arch/arm64/kvm/hyp/exception.c | 221 ++++++++++++++++++++++++++++++---
>  2 files changed, 212 insertions(+), 158 deletions(-)
> 
> diff --git a/arch/arm64/kvm/aarch32.c b/arch/arm64/kvm/aarch32.c
> index 40a62a99fbf8..ad453b47c517 100644
> --- a/arch/arm64/kvm/aarch32.c
> +++ b/arch/arm64/kvm/aarch32.c
> @@ -19,20 +19,6 @@
>  #define DFSR_FSC_EXTABT_nLPAE	0x08
>  #define DFSR_LPAE		BIT(9)
>  
> -/*
> - * Table taken from ARMv8 ARM DDI0487B-B, table G1-10.
> - */
> -static const u8 return_offsets[8][2] = {
> -	[0] = { 0, 0 },		/* Reset, unused */
> -	[1] = { 4, 2 },		/* Undefined */
> -	[2] = { 0, 0 },		/* SVC, unused */
> -	[3] = { 4, 4 },		/* Prefetch abort */
> -	[4] = { 8, 8 },		/* Data abort */
> -	[5] = { 0, 0 },		/* HVC, unused */
> -	[6] = { 4, 4 },		/* IRQ, unused */
> -	[7] = { 4, 4 },		/* FIQ, unused */
> -};
> -
>  static bool pre_fault_synchronize(struct kvm_vcpu *vcpu)
>  {
>  	preempt_disable();
> @@ -53,132 +39,10 @@ static void post_fault_synchronize(struct kvm_vcpu *vcpu, bool loaded)
>  	}
>  }
>  
> -/*
> - * When an exception is taken, most CPSR fields are left unchanged in the
> - * handler. However, some are explicitly overridden (e.g. M[4:0]).
> - *
> - * The SPSR/SPSR_ELx layouts differ, and the below is intended to work with
> - * either format. Note: SPSR.J bit doesn't exist in SPSR_ELx, but this bit was
> - * obsoleted by the ARMv7 virtualization extensions and is RES0.
> - *
> - * For the SPSR layout seen from AArch32, see:
> - * - ARM DDI 0406C.d, page B1-1148
> - * - ARM DDI 0487E.a, page G8-6264
> - *
> - * For the SPSR_ELx layout for AArch32 seen from AArch64, see:
> - * - ARM DDI 0487E.a, page C5-426
> - *
> - * Here we manipulate the fields in order of the AArch32 SPSR_ELx layout, from
> - * MSB to LSB.
> - */
> -static unsigned long get_except32_cpsr(struct kvm_vcpu *vcpu, u32 mode)
> -{
> -	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
> -	unsigned long old, new;
> -
> -	old = *vcpu_cpsr(vcpu);
> -	new = 0;
> -
> -	new |= (old & PSR_AA32_N_BIT);
> -	new |= (old & PSR_AA32_Z_BIT);
> -	new |= (old & PSR_AA32_C_BIT);
> -	new |= (old & PSR_AA32_V_BIT);
> -	new |= (old & PSR_AA32_Q_BIT);
> -
> -	// CPSR.IT[7:0] are set to zero upon any exception
> -	// See ARM DDI 0487E.a, section G1.12.3
> -	// See ARM DDI 0406C.d, section B1.8.3
> -
> -	new |= (old & PSR_AA32_DIT_BIT);
> -
> -	// CPSR.SSBS is set to SCTLR.DSSBS upon any exception
> -	// See ARM DDI 0487E.a, page G8-6244
> -	if (sctlr & BIT(31))
> -		new |= PSR_AA32_SSBS_BIT;
> -
> -	// CPSR.PAN is unchanged unless SCTLR.SPAN == 0b0
> -	// SCTLR.SPAN is RES1 when ARMv8.1-PAN is not implemented
> -	// See ARM DDI 0487E.a, page G8-6246
> -	new |= (old & PSR_AA32_PAN_BIT);
> -	if (!(sctlr & BIT(23)))
> -		new |= PSR_AA32_PAN_BIT;
> -
> -	// SS does not exist in AArch32, so ignore
> -
> -	// CPSR.IL is set to zero upon any exception
> -	// See ARM DDI 0487E.a, page G1-5527
> -
> -	new |= (old & PSR_AA32_GE_MASK);
> -
> -	// CPSR.IT[7:0] are set to zero upon any exception
> -	// See prior comment above
> -
> -	// CPSR.E is set to SCTLR.EE upon any exception
> -	// See ARM DDI 0487E.a, page G8-6245
> -	// See ARM DDI 0406C.d, page B4-1701
> -	if (sctlr & BIT(25))
> -		new |= PSR_AA32_E_BIT;
> -
> -	// CPSR.A is unchanged upon an exception to Undefined, Supervisor
> -	// CPSR.A is set upon an exception to other modes
> -	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
> -	// See ARM DDI 0406C.d, page B1-1182
> -	new |= (old & PSR_AA32_A_BIT);
> -	if (mode != PSR_AA32_MODE_UND && mode != PSR_AA32_MODE_SVC)
> -		new |= PSR_AA32_A_BIT;
> -
> -	// CPSR.I is set upon any exception
> -	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
> -	// See ARM DDI 0406C.d, page B1-1182
> -	new |= PSR_AA32_I_BIT;
> -
> -	// CPSR.F is set upon an exception to FIQ
> -	// CPSR.F is unchanged upon an exception to other modes
> -	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
> -	// See ARM DDI 0406C.d, page B1-1182
> -	new |= (old & PSR_AA32_F_BIT);
> -	if (mode == PSR_AA32_MODE_FIQ)
> -		new |= PSR_AA32_F_BIT;
> -
> -	// CPSR.T is set to SCTLR.TE upon any exception
> -	// See ARM DDI 0487E.a, page G8-5514
> -	// See ARM DDI 0406C.d, page B1-1181
> -	if (sctlr & BIT(30))
> -		new |= PSR_AA32_T_BIT;
> -
> -	new |= mode;
> -
> -	return new;
> -}
> -
> -static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
> -{
> -	unsigned long spsr = *vcpu_cpsr(vcpu);
> -	bool is_thumb = (spsr & PSR_AA32_T_BIT);
> -	u32 return_offset = return_offsets[vect_offset >> 2][is_thumb];
> -	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
> -
> -	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
> -
> -	/* Note: These now point to the banked copies */
> -	vcpu_write_spsr(vcpu, host_spsr_to_spsr32(spsr));
> -	*vcpu_reg32(vcpu, 14) = *vcpu_pc(vcpu) + return_offset;
> -
> -	/* Branch to exception vector */
> -	if (sctlr & (1 << 13))
> -		vect_offset += 0xffff0000;
> -	else /* always have security exceptions */
> -		vect_offset += vcpu_cp15(vcpu, c12_VBAR);
> -
> -	*vcpu_pc(vcpu) = vect_offset;
> -}
> -
>  void kvm_inject_undef32(struct kvm_vcpu *vcpu)
>  {
> -	bool loaded = pre_fault_synchronize(vcpu);
> -
> -	prepare_fault32(vcpu, PSR_AA32_MODE_UND, 4);
> -	post_fault_synchronize(vcpu, loaded);
> +	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_UND |
> +			     KVM_ARM64_PENDING_EXCEPTION);
>  }
>  
>  /*
> @@ -188,7 +52,6 @@ void kvm_inject_undef32(struct kvm_vcpu *vcpu)
>  static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
>  			 unsigned long addr)
>  {
> -	u32 vect_offset;
>  	u32 *far, *fsr;
>  	bool is_lpae;
>  	bool loaded;
> @@ -196,17 +59,17 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
>  	loaded = pre_fault_synchronize(vcpu);
>  
>  	if (is_pabt) {
> -		vect_offset = 12;
> +		vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_IABT |
> +				     KVM_ARM64_PENDING_EXCEPTION);
>  		far = &vcpu_cp15(vcpu, c6_IFAR);
>  		fsr = &vcpu_cp15(vcpu, c5_IFSR);
>  	} else { /* !iabt */
> -		vect_offset = 16;
> +		vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_DABT |
> +				     KVM_ARM64_PENDING_EXCEPTION);
>  		far = &vcpu_cp15(vcpu, c6_DFAR);
>  		fsr = &vcpu_cp15(vcpu, c5_DFSR);
>  	}
>  
> -	prepare_fault32(vcpu, PSR_AA32_MODE_ABT, vect_offset);
> -
>  	*far = addr;
>  
>  	/* Give the guest an IMPLEMENTATION DEFINED exception */
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index cd6e643639e8..8d1d1bcd9e69 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -33,6 +33,16 @@ static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
>  {
>  	write_sysreg_el1(val, SYS_SPSR);
>  }
> +
> +static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	vcpu->arch.ctxt.spsr_abt = val;
> +}
> +
> +static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	vcpu->arch.ctxt.spsr_und = val;
> +}
>  #elif defined (__KVM_VHE_HYPERVISOR__)
>  /* On VHE, all the registers are already loaded on the CPU */
>  static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> @@ -57,10 +67,25 @@ static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
>  {
>  	write_sysreg_el1(val, SYS_SPSR);
>  }
> +
> +static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	write_sysreg(val, spsr_abt);
> +}
> +
> +static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	write_sysreg(val, spsr_und);
> +}
>  #else
>  #error Hypervisor code only!
>  #endif
>  
> +static inline u32 __vcpu_read_cp15(const struct kvm_vcpu *vcpu, int reg)
> +{
> +	return __vcpu_read_sys_reg(vcpu, reg / 2);
> +}
> +
>  /*
>   * This performs the exception entry at a given EL (@target_mode), stashing PC
>   * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
> @@ -155,23 +180,189 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>  	__vcpu_write_spsr(vcpu, old);
>  }
>  
> -void kvm_inject_exception(struct kvm_vcpu *vcpu)
> +/*
> + * When an exception is taken, most CPSR fields are left unchanged in the
> + * handler. However, some are explicitly overridden (e.g. M[4:0]).
> + *
> + * The SPSR/SPSR_ELx layouts differ, and the below is intended to work with
> + * either format. Note: SPSR.J bit doesn't exist in SPSR_ELx, but this bit was
> + * obsoleted by the ARMv7 virtualization extensions and is RES0.
> + *
> + * For the SPSR layout seen from AArch32, see:
> + * - ARM DDI 0406C.d, page B1-1148
> + * - ARM DDI 0487E.a, page G8-6264
> + *
> + * For the SPSR_ELx layout for AArch32 seen from AArch64, see:
> + * - ARM DDI 0487E.a, page C5-426
> + *
> + * Here we manipulate the fields in order of the AArch32 SPSR_ELx layout, from
> + * MSB to LSB.
> + */
> +static unsigned long get_except32_cpsr(struct kvm_vcpu *vcpu, u32 mode)
>  {
> -	switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
> -	case KVM_ARM64_EXCEPT_AA64_EL1_SYNC:
> -		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
> -		break;
> -	case KVM_ARM64_EXCEPT_AA64_EL1_IRQ:
> -		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_irq);
> -		break;
> -	case KVM_ARM64_EXCEPT_AA64_EL1_FIQ:
> -		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_fiq);
> -		break;
> -	case KVM_ARM64_EXCEPT_AA64_EL1_SERR:
> -		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_serror);
> +	u32 sctlr = __vcpu_read_cp15(vcpu, c1_SCTLR);
> +	unsigned long old, new;
> +
> +	old = *vcpu_cpsr(vcpu);
> +	new = 0;
> +
> +	new |= (old & PSR_AA32_N_BIT);
> +	new |= (old & PSR_AA32_Z_BIT);
> +	new |= (old & PSR_AA32_C_BIT);
> +	new |= (old & PSR_AA32_V_BIT);
> +	new |= (old & PSR_AA32_Q_BIT);
> +
> +	// CPSR.IT[7:0] are set to zero upon any exception
> +	// See ARM DDI 0487E.a, section G1.12.3
> +	// See ARM DDI 0406C.d, section B1.8.3
> +
> +	new |= (old & PSR_AA32_DIT_BIT);
> +
> +	// CPSR.SSBS is set to SCTLR.DSSBS upon any exception
> +	// See ARM DDI 0487E.a, page G8-6244
> +	if (sctlr & BIT(31))
> +		new |= PSR_AA32_SSBS_BIT;
> +
> +	// CPSR.PAN is unchanged unless SCTLR.SPAN == 0b0
> +	// SCTLR.SPAN is RES1 when ARMv8.1-PAN is not implemented
> +	// See ARM DDI 0487E.a, page G8-6246
> +	new |= (old & PSR_AA32_PAN_BIT);
> +	if (!(sctlr & BIT(23)))
> +		new |= PSR_AA32_PAN_BIT;
> +
> +	// SS does not exist in AArch32, so ignore
> +
> +	// CPSR.IL is set to zero upon any exception
> +	// See ARM DDI 0487E.a, page G1-5527
> +
> +	new |= (old & PSR_AA32_GE_MASK);
> +
> +	// CPSR.IT[7:0] are set to zero upon any exception
> +	// See prior comment above
> +
> +	// CPSR.E is set to SCTLR.EE upon any exception
> +	// See ARM DDI 0487E.a, page G8-6245
> +	// See ARM DDI 0406C.d, page B4-1701
> +	if (sctlr & BIT(25))
> +		new |= PSR_AA32_E_BIT;
> +
> +	// CPSR.A is unchanged upon an exception to Undefined, Supervisor
> +	// CPSR.A is set upon an exception to other modes
> +	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
> +	// See ARM DDI 0406C.d, page B1-1182
> +	new |= (old & PSR_AA32_A_BIT);
> +	if (mode != PSR_AA32_MODE_UND && mode != PSR_AA32_MODE_SVC)
> +		new |= PSR_AA32_A_BIT;
> +
> +	// CPSR.I is set upon any exception
> +	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
> +	// See ARM DDI 0406C.d, page B1-1182
> +	new |= PSR_AA32_I_BIT;
> +
> +	// CPSR.F is set upon an exception to FIQ
> +	// CPSR.F is unchanged upon an exception to other modes
> +	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
> +	// See ARM DDI 0406C.d, page B1-1182
> +	new |= (old & PSR_AA32_F_BIT);
> +	if (mode == PSR_AA32_MODE_FIQ)
> +		new |= PSR_AA32_F_BIT;
> +
> +	// CPSR.T is set to SCTLR.TE upon any exception
> +	// See ARM DDI 0487E.a, page G8-5514
> +	// See ARM DDI 0406C.d, page B1-1181
> +	if (sctlr & BIT(30))
> +		new |= PSR_AA32_T_BIT;
> +
> +	new |= mode;
> +
> +	return new;
> +}
> +
> +/*
> + * Table taken from ARMv8 ARM DDI0487B-B, table G1-10.
> + */
> +static const u8 return_offsets[8][2] = {
> +	[0] = { 0, 0 },		/* Reset, unused */
> +	[1] = { 4, 2 },		/* Undefined */
> +	[2] = { 0, 0 },		/* SVC, unused */
> +	[3] = { 4, 4 },		/* Prefetch abort */
> +	[4] = { 8, 8 },		/* Data abort */
> +	[5] = { 0, 0 },		/* HVC, unused */
> +	[6] = { 4, 4 },		/* IRQ, unused */
> +	[7] = { 4, 4 },		/* FIQ, unused */
> +};
> +
> +static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
> +{
> +	unsigned long spsr = *vcpu_cpsr(vcpu);
> +	bool is_thumb = (spsr & PSR_AA32_T_BIT);
> +	u32 return_offset = return_offsets[vect_offset >> 2][is_thumb];
> +	u32 sctlr = __vcpu_read_cp15(vcpu, c1_SCTLR);
> +	int lr;
> +
> +	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
> +
> +	/*
> +	 * Table D1-27 of DDI 0487F.c shows the GPR mapping between
> +	 * AArch32 and AArch64. We only deal with ABT/UND.
> +	 */
> +	switch(mode) {
> +	case PSR_AA32_MODE_ABT:
> +		__vcpu_write_spsr_abt(vcpu, host_spsr_to_spsr32(spsr));
> +		lr = 20;
>  		break;
> -	default:
> -		/* EL2 are unimplemented until we get NV. One day. */
> +		
> +	case PSR_AA32_MODE_UND:
> +		__vcpu_write_spsr_und(vcpu, host_spsr_to_spsr32(spsr));
> +		lr = 22;
>  		break;
>  	}
> +
> +	vcpu_set_reg(vcpu, lr, *vcpu_pc(vcpu) + return_offset);
> +
> +	/* Branch to exception vector */
> +	if (sctlr & (1 << 13))
> +		vect_offset += 0xffff0000;
> +	else /* always have security exceptions */
> +		vect_offset += __vcpu_read_cp15(vcpu, c12_VBAR);
> +
> +	*vcpu_pc(vcpu) = vect_offset;
> +}
> +
> +void kvm_inject_exception(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu_el1_is_32bit(vcpu)) {
> +		switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
> +		case KVM_ARM64_EXCEPT_AA32_UND:
> +			enter_exception32(vcpu, PSR_AA32_MODE_UND, 4);
> +			break;
> +		case KVM_ARM64_EXCEPT_AA32_IABT:
> +			enter_exception32(vcpu, PSR_AA32_MODE_ABT, 12);
> +			break;
> +		case KVM_ARM64_EXCEPT_AA32_DABT:
> +			enter_exception32(vcpu, PSR_AA32_MODE_ABT, 16);
> +			break;
> +		default:
> +			/* Err... */
> +			break;
> +		}
> +	} else {
> +		switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
> +		case KVM_ARM64_EXCEPT_AA64_EL1_SYNC:
> +			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
> +			break;
> +		case KVM_ARM64_EXCEPT_AA64_EL1_IRQ:
> +			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_irq);
> +			break;
> +		case KVM_ARM64_EXCEPT_AA64_EL1_FIQ:
> +			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_fiq);
> +			break;
> +		case KVM_ARM64_EXCEPT_AA64_EL1_SERR:
> +			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_serror);
> +			break;
> +		default:
> +			/* EL2 are unimplemented until we get NV. One day. */
> +			break;
> +		}
> +	}
>  }
> -- 
> 2.28.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
