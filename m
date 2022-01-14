Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C714C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 14 Jan 2022 17:42:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB10749E44;
	Fri, 14 Jan 2022 12:42:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AfvBQuqDMWtD; Fri, 14 Jan 2022 12:42:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65DEF49E49;
	Fri, 14 Jan 2022 12:42:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F44649E44
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Jan 2022 12:41:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WFaxd1w74FPt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Jan 2022 12:41:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FD4B49E36
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Jan 2022 12:41:58 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 235BF6D;
 Fri, 14 Jan 2022 09:41:57 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 782743F766;
 Fri, 14 Jan 2022 09:41:54 -0800 (PST)
Date: Fri, 14 Jan 2022 17:42:04 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 11/69] KVM: arm64: nv: Add nested virt VCPU primitives
 for vEL2 VCPU state
Message-ID: <YeG17OWrvFPQjgjS@monolith.localdoman>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-12-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-12-maz@kernel.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

Hi Marc,

Bunch of bikeshedding regarding names below, which can be safely ignored.

On Mon, Nov 29, 2021 at 08:00:52PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> When running a nested hypervisor we commonly have to figure out if
> the VCPU mode is running in the context of a guest hypervisor or guest
> guest, or just a normal guest.
> 
> Add convenient primitives for this.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 55 ++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index f4871e47b2d0..f4b079945d0f 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -176,6 +176,61 @@ static __always_inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
>  		vcpu_gp_regs(vcpu)->regs[reg_num] = val;
>  }
>  
> +static inline bool vcpu_mode_el2_ctxt(const struct kvm_cpu_context *ctxt)

"The Armv8-A architecture defines a set of Exception levels, EL0 to EL3" (ARM
DDI 0487G.a, page G1-5941).

"AArch64 state does not support modes. Modes are a concept that is specific to
AArch32 state." (ARM DDI 0487G.a, page G1-5944).

Wouldn't it be better to use the same terminology as the architecture?

> +{
> +	unsigned long cpsr = ctxt->regs.pstate;

CPSR is an AArch32 register. Why not name the variable pstate?

> +
> +	switch (cpsr & (PSR_MODE32_BIT | PSR_MODE_MASK)) {
> +	case PSR_MODE_EL2h:
> +	case PSR_MODE_EL2t:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static inline bool vcpu_mode_el2(const struct kvm_vcpu *vcpu)
> +{
> +	return vcpu_mode_el2_ctxt(&vcpu->arch.ctxt);
> +}
> +
> +static inline bool __vcpu_el2_e2h_is_set(const struct kvm_cpu_context *ctxt)
> +{
> +	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_E2H;
> +}
> +
> +static inline bool vcpu_el2_e2h_is_set(const struct kvm_vcpu *vcpu)
> +{
> +	return __vcpu_el2_e2h_is_set(&vcpu->arch.ctxt);
> +}
> +
> +static inline bool __vcpu_el2_tge_is_set(const struct kvm_cpu_context *ctxt)
> +{
> +	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_TGE;
> +}
> +
> +static inline bool vcpu_el2_tge_is_set(const struct kvm_vcpu *vcpu)

This is confusing. What does the exception level have to do with the HCR_EL2.TGE
bit being set? Wouldn't vcpu_hcr_tge_is_set() be better?

> +{
> +	return __vcpu_el2_tge_is_set(&vcpu->arch.ctxt);
> +}
> +
> +static inline bool __is_hyp_ctxt(const struct kvm_cpu_context *ctxt)
> +{
> +	/*
> +	 * We are in a hypervisor context if the vcpu mode is EL2 or
> +	 * E2H and TGE bits are set. The latter means we are in the user space
> +	 * of the VHE kernel. ARMv8.1 ARM describes this as 'InHost'

So why not call the function vcpu_is_inhost() or something along those lines to
match the architecture?

Thanks,
Alex

> +	 */
> +	return vcpu_mode_el2_ctxt(ctxt) ||
> +		(__vcpu_el2_e2h_is_set(ctxt) && __vcpu_el2_tge_is_set(ctxt)) ||
> +		WARN_ON(__vcpu_el2_tge_is_set(ctxt));
> +}
> +
> +static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
> +{
> +	return __is_hyp_ctxt(&vcpu->arch.ctxt);
> +}
> +
>  /*
>   * The layout of SPSR for an AArch32 state is different when observed from an
>   * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
