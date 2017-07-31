From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH v2 32/38] KVM: arm64: Trap and emulate CPTR_EL2
 accesses via CPACR_EL1 from the virtual EL2 with VHE
Date: Mon, 31 Jul 2017 14:04:01 +0200
Message-ID: <20170731120401.GS5176@cbox>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-33-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1500397144-16232-33-git-send-email-jintack.lim@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jintack Lim <jintack.lim@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, corbet@lwn.net, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, akpm@linux-foundation.org, mchehab@kernel.org, cov@codeaurora.org, daniel.lezcano@linaro.org, david.daney@cavium.com, mark.rutland@arm.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, andy.gross@linaro.org, wcohen@redhat.com, ard.biesheuvel@linaro.org, shankerd@codeaurora.org, vladimir.murzin@arm.com, james.morse@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 11:58:58AM -0500, Jintack Lim wrote:
> While the EL1 virtual memory control registers can be accessed in the
> virtual EL2 with VHE without trap to manuplate the virtual EL2 states,
> we can't do that for CPTR_EL2 for an unfortunate reason.
> 
> This is because the top bit of CPTR_EL2, which is TCPAC, will be ignored
> if it is accessed via CPACR_EL1 in the virtual EL2 without trap since
> the top bot of cpacr_el1 is RES0. Therefore we need to trap CPACR_EL1

top bit ?

> accesses from the virtual EL2 to emulate this bit correctly.
> 
> Set CPTR_EL2.TCPAC bit to trap CPACR_EL1 accesses and handle them in the
> existing handler considering that they could be meant to access CPTR_EL2
> instead in the virtual EL2 with VHE.
> 
> Note that CPTR_EL2 format depends on HCR_EL2.E2H bit. We always keep it
> in v8.0 format for the convenience. Otherwise, we need to check E2H bit
> and use different bit masks in the entry.S, and we also check E2H bit in
> all places we access virtual CPTR_EL2. The downside of using v8.0 format
> is to convert the format when copying states between CPTR_EL2 and
> CPACR_EL1 to support the virtual EL2 with VHE. The decision is subject
> to change depending on the future discussion.

I would remove the last sentence here for the actual commit message,
that is already implied by sending these patches for review.

> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  2 ++
>  arch/arm64/kvm/context.c             | 29 ++++++++++++++++++++++++++---
>  arch/arm64/kvm/hyp/switch.c          |  2 ++
>  arch/arm64/kvm/sys_regs.c            | 18 +++++++++++++++++-
>  4 files changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 68aafbd..4776bfc 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -59,6 +59,8 @@ enum exception_type {
>  void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu);
>  void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu);
>  void kvm_arm_init_cpu_context(kvm_cpu_context_t *cpu_ctxt);
> +u64 cptr_to_cpacr(u64 cptr_el2);
> +u64 cpacr_to_cptr(u64 cpacr_el1);
>  
>  static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
> index 9947bc8..a7811e1 100644
> --- a/arch/arm64/kvm/context.c
> +++ b/arch/arm64/kvm/context.c
> @@ -66,7 +66,7 @@ static inline u64 tcr_el2_ips_to_tcr_el1_ps(u64 tcr_el2)
>  		<< TCR_IPS_SHIFT;
>  }
>  
> -static inline u64 cptr_to_cpacr(u64 cptr_el2)
> +u64 cptr_to_cpacr(u64 cptr_el2)
>  {
>  	u64 cpacr_el1 = 0;
>  
> @@ -78,6 +78,21 @@ static inline u64 cptr_to_cpacr(u64 cptr_el2)
>  	return cpacr_el1;
>  }
>  
> +u64 cpacr_to_cptr(u64 cpacr_el1)
> +{
> +	u64 cptr_el2;
> +
> +	cptr_el2 = CPTR_EL2_DEFAULT;
> +	if (!(cpacr_el1 & CPACR_EL1_FPEN))
> +		cptr_el2 |= CPTR_EL2_TFP;
> +	if (cpacr_el1 & CPACR_EL1_TTA)
> +		cptr_el2 |= CPTR_EL2_TTA;
> +	if (cpacr_el1 & CPTR_EL2_TCPAC)
> +		cptr_el2 |= CPTR_EL2_TCPAC;
> +
> +	return cptr_el2;
> +}
> +
>  static void sync_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
>  {
>  	u64 *s_sys_regs = vcpu->arch.ctxt.shadow_sys_regs;
> @@ -93,8 +108,12 @@ static void sync_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
>  
>  	for (i = 0; i < ARRAY_SIZE(vhe_map); i++) {
>  		const struct el1_el2_map *map = &vhe_map[i];
> +		u64 *el2_reg = &vcpu_sys_reg(vcpu, map->el2);
>  
> -		vcpu_sys_reg(vcpu, map->el2) = s_sys_regs[map->el1];
> +		/* We do trap-and-emulate CPACR_EL1 accesses. So, don't sync */
> +		if (map->el2 == CPTR_EL2)
> +			continue;
> +		*el2_reg = s_sys_regs[map->el1];
>  	}
>  }
>  
> @@ -138,8 +157,12 @@ static void flush_shadow_el1_sysregs_vhe(struct kvm_vcpu *vcpu)
>  	 */
>  	for (i = 0; i < ARRAY_SIZE(vhe_map); i++) {
>  		const struct el1_el2_map *map = &vhe_map[i];
> +		u64 *el1_reg = &s_sys_regs[map->el1];
>  
> -		s_sys_regs[map->el1] = vcpu_sys_reg(vcpu, map->el2);
> +		if (map->el2 == CPTR_EL2)
> +			*el1_reg = cptr_to_cpacr(vcpu_sys_reg(vcpu, map->el2));
> +		else
> +			*el1_reg = vcpu_sys_reg(vcpu, map->el2);

nit: you could add a translation function to the map array and call that
if it's set, otherwise default to copying values as they are, something
like:
	if (map->translate)
		*el1_reg = map->translate(vcpu_sys_reg(vcpu, map->el2));
	else
		*el1_reg = vcpu_sys_reg(vcpu, map->el2);


>  	}
>  }
>  
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index fffd0c7..50c90f2 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -50,6 +50,8 @@ static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
>  	val = read_sysreg(cpacr_el1);
>  	val |= CPACR_EL1_TTA;
>  	val &= ~CPACR_EL1_FPEN;
> +	if (is_hyp_ctxt(vcpu))
> +		val |= CPTR_EL2_TCPAC;

also, I think we'll forget why this gets set for hyp context here, so a
short comment would be nice.

what if the guest hypervisor has set CPTR_EL2.TCPAC and runs a VM don't
we also need to set the CPTR_EL2.TCPAC in the hardware and forward the
exception to the VM in that case?

>  	write_sysreg(val, cpacr_el1);
>  
>  	write_sysreg(__kvm_hyp_vector, vbar_el1);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2aa922c..79980be 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -972,7 +972,23 @@ static bool access_cpacr(struct kvm_vcpu *vcpu,
>  		struct sys_reg_params *p,
>  		const struct sys_reg_desc *r)
>  {
> -	access_rw(p, &vcpu_sys_reg(vcpu, r->reg));
> +	u64 reg = sys_reg(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
> +
> +	/*
> +	 * When the virtual HCR_EL2.E2H == 1, an access to CPACR_EL1
> +	 * in the virtual EL2 is to access CPTR_EL2.
> +	 */
> +	if (vcpu_el2_e2h_is_set(vcpu) && (reg == SYS_CPACR_EL1)) {

you don't check here if we're in virtual el2 mode, because you rely on
only ever getting here if we had is_hyp_ctxt() when entering the VM,
right?

> +		u64 *sysreg = &vcpu_sys_reg(vcpu, CPTR_EL2);
> +
> +		/* We keep the value in ARMv8.0 CPTR_EL2 format. */
> +		if (!p->is_write)
> +			p->regval = cptr_to_cpacr(*sysreg);
> +		else
> +			*sysreg	= cpacr_to_cptr(p->regval);
> +	} else /* CPACR_EL1 access with E2H == 0 or CPACR_EL12 access */
> +		access_rw(p, &vcpu_sys_reg(vcpu, r->reg));
> +

again, I think you can improve your commenting style to make it clear
which comment belongs to which block and only put a comment above the
entire if-statement if it applies to the logic as a whole.

the coding style also prefers that you use braces in both branches if
only one of the branches is a single statement.


>  	return true;
>  }
>  
> -- 
> 1.9.1
> 

Thanks,
-Christoffer
