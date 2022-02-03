Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D54C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  3 Feb 2022 17:11:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE5254B090;
	Thu,  3 Feb 2022 12:11:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eAjpbzV2gekx; Thu,  3 Feb 2022 12:11:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC39E4B092;
	Thu,  3 Feb 2022 12:11:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 890554B092
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:11:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ByR2bMTtEpH2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Feb 2022 12:11:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF4354B090
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:11:10 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46358147A;
 Thu,  3 Feb 2022 09:11:10 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7AD043F40C;
 Thu,  3 Feb 2022 09:11:07 -0800 (PST)
Date: Thu, 3 Feb 2022 17:11:16 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 18/64] KVM: arm64: nv: Trap EL1 VM register accesses
 in virtual EL2
Message-ID: <YfwMtP/McwEJApy2@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-19-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-19-maz@kernel.org>
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

On Fri, Jan 28, 2022 at 12:18:26PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> When running in virtual EL2 mode, we actually run the hardware in EL1
> and therefore have to use the EL1 registers to ensure correct operation.
> 
> By setting the HCR.TVM and HCR.TVRM we ensure that the virtual EL2 mode
> doesn't shoot itself in the foot when setting up what it believes to be
> a different mode's system register state (for example when preparing to
> switch to a VM).
> 
> We can leverage the existing sysregs infrastructure to support trapped
> accesses to these registers.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  4 +---
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
>  arch/arm64/kvm/hyp/vhe/switch.c         |  7 ++++++-
>  arch/arm64/kvm/sys_regs.c               | 19 ++++++++++++++++---
>  4 files changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 58e14f8ead23..49c3b9eb09d7 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -110,10 +110,8 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
>  		write_sysreg(0, pmuserenr_el0);
>  }
>  
> -static inline void ___activate_traps(struct kvm_vcpu *vcpu)
> +static inline void ___activate_traps(struct kvm_vcpu *vcpu, u64 hcr)
>  {
> -	u64 hcr = vcpu->arch.hcr_el2;
> -
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
>  		hcr |= HCR_TVM;
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 6410d21d8695..61a5627fd456 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -38,7 +38,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  {
>  	u64 val;
>  
> -	___activate_traps(vcpu);
> +	___activate_traps(vcpu, vcpu->arch.hcr_el2);
>  	__activate_traps_common(vcpu);
>  
>  	val = vcpu->arch.cptr_el2;
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 82ddaebe66de..6ed9e4893a02 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -32,9 +32,14 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
>  
>  static void __activate_traps(struct kvm_vcpu *vcpu)
>  {
> +	u64 hcr = vcpu->arch.hcr_el2;
>  	u64 val;
>  
> -	___activate_traps(vcpu);
> +	/* Trap VM sysreg accesses if an EL2 guest is not using VHE. */
> +	if (vcpu_is_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
> +		hcr |= HCR_TVM | HCR_TRVM;
> +
> +	___activate_traps(vcpu, hcr);
>  
>  	val = read_sysreg(cpacr_el1);
>  	val |= CPACR_EL1_TTA;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 102bc4906723..9d3520f1d17a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -322,8 +322,15 @@ static void get_access_mask(const struct sys_reg_desc *r, u64 *mask, u64 *shift)
>  
>  /*
>   * Generic accessor for VM registers. Only called as long as HCR_TVM
> - * is set. If the guest enables the MMU, we stop trapping the VM
> - * sys_regs and leave it in complete control of the caches.
> + * is set.
> + *
> + * This is set in two cases: either (1) we're running at vEL2, or (2)
> + * we're running at EL1 and the guest has its MMU off.
> + *
> + * (1) TVM/TRVM is set, as we need to virtualise some of the VM
> + * registers for the guest hypervisor
> + * (2) Once the guest enables the MMU, we stop trapping the VM sys_regs
> + * and leave it in complete control of the caches.
>   */
>  static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  			  struct sys_reg_params *p,
> @@ -332,7 +339,13 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  	bool was_enabled = vcpu_has_cache_enabled(vcpu);
>  	u64 val, mask, shift;
>  
> -	BUG_ON(!p->is_write);
> +	/* We don't expect TRVM on the host */

I don't get what that means. Isn't KVM setting HCR_EL2.TRVM to trap reads?

Other than that, the patch looks good:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> +	BUG_ON(!vcpu_is_el2(vcpu) && !p->is_write);
> +
> +	if (!p->is_write) {
> +		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
> +		return true;
> +	}
>  
>  	get_access_mask(r, &mask, &shift);
>  
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
