Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6594EC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  2 Feb 2022 12:10:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB5764B0BD;
	Wed,  2 Feb 2022 07:09:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qG8k6s1KGKal; Wed,  2 Feb 2022 07:09:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAC8F4B0BE;
	Wed,  2 Feb 2022 07:09:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9943E4B0B9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Feb 2022 07:09:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lz4TEX4aJQjQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Feb 2022 07:09:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 441A24B0B6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Feb 2022 07:09:54 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 751E71FB;
 Wed,  2 Feb 2022 04:09:53 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A66663F718;
 Wed,  2 Feb 2022 04:09:50 -0800 (PST)
Date: Wed, 2 Feb 2022 12:10:00 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 06/64] KVM: arm64: nv: Add nested virt VCPU primitives
 for vEL2 VCPU state
Message-ID: <Yfp0fTypgtqYzNdD@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-7-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-7-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org
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

On Fri, Jan 28, 2022 at 12:18:14PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> When running a nested hypervisor we commonly have to figure out if
> the VCPU mode is running in the context of a guest hypervisor or guest
> guest, or just a normal guest.
> 
> Add convenient primitives for this.
> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 53 ++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index d62405ce3e6d..ea9a130c4b6a 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -178,6 +178,59 @@ static __always_inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
>  		vcpu_gp_regs(vcpu)->regs[reg_num] = val;
>  }
>  
> +static inline bool vcpu_is_el2_ctxt(const struct kvm_cpu_context *ctxt)
> +{
> +	switch (ctxt->regs.pstate & (PSR_MODE32_BIT | PSR_MODE_MASK)) {
> +	case PSR_MODE_EL2h:
> +	case PSR_MODE_EL2t:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static inline bool vcpu_is_el2(const struct kvm_vcpu *vcpu)
> +{
> +	return vcpu_is_el2_ctxt(&vcpu->arch.ctxt);
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
> +	 */
> +	return vcpu_is_el2_ctxt(ctxt) ||
> +		(__vcpu_el2_e2h_is_set(ctxt) && __vcpu_el2_tge_is_set(ctxt)) ||
> +		WARN_ON(__vcpu_el2_tge_is_set(ctxt));

Why the WARN_ON? Wouldn't it be easy for a guest to flood the host's dmesg with
warnings by setting HCR_EL2.{E2H,TGE} = {0, 1} and then repeatedly accessing EL2
registers (for example)?

> +}
> +
> +static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)

When KVM boots at EL2 and FEAT_VHE is not implemented it prints to dmesg:

[    1.352302] kvm [1]: Hyp mode initialized successfully

I take it in that context "Hyp" means "EL2 NVHE", because when E2H,TGE are
set the message changes to:

[    0.037683] kvm [1]: VHE mode initialized successfully

In this file, in the function is_kernel_in_hyp_mode(), "hyp" actually means
that the exception level is EL2. In kvm/arm.c, "hyp" also means EL2 (or
maybe EL2 NVHE?).

Wouldn't it be nice to avoid having "hyp" mean yet another thing and
replace it with "hypervisor" in these two functions?

Thanks,
Alex

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
