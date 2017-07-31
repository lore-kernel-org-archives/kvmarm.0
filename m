From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH v2 31/38] KVM: arm64: Manage the shadow states when
 virtual E2H bit enabled
Date: Mon, 31 Jul 2017 11:57:21 +0200
Message-ID: <20170731095721.GR5176@cbox>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-32-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1500397144-16232-32-git-send-email-jintack.lim@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jintack Lim <jintack.lim@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, corbet@lwn.net, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, akpm@linux-foundation.org, mchehab@kernel.org, cov@codeaurora.org, daniel.lezcano@linaro.org, david.daney@cavium.com, mark.rutland@arm.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, andy.gross@linaro.org, wcohen@redhat.com, ard.biesheuvel@linaro.org, shankerd@codeaurora.org, vladimir.murzin@arm.com, james.morse@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 11:58:57AM -0500, Jintack Lim wrote:

In the subject: s/virtual E2H bit enabled/virtual E2H bit is set/

> When creating the shadow context for the virtual EL2 execution, we can
> directly copy the EL2 register states to the shadow EL1 register states
> if the virtual HCR_EL2.E2H bit is set. This is because EL1 and EL2
> system register formats compatible with E2H=1.

are compatible when HCR_EL2.E2H==1.

> 
> Now that we allow the virtual EL2 modify its EL2 registers without trap

to modify

without trapping, via...

> via the physical EL1 system register accesses, we need to reflect the
> changes made to the EL1 system registers to the virtual EL2 register
> states. This is not required to the virtual EL2 without VHE, since the

for virtual EL2 without...

> virtual EL2 should always use _EL2 accessors, which traps to EL2.

s/should always use/always uses/

> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> ---
>  arch/arm64/kvm/context.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
> index 39bd92d..9947bc8 100644
> --- a/arch/arm64/kvm/context.c
> +++ b/arch/arm64/kvm/context.c
> @@ -39,6 +39,27 @@ struct el1_el2_map {
>  	{ VBAR_EL1, VBAR_EL2 },
>  };
>  
> +/*
> + * List of pair of EL1/EL2 registers which are used to access real EL2
> + * registers in EL2 with E2H bit set.

in EL1?

Maybe you can just say:
   /*
    * List of system registers that can be directly mapped between VHE
    * EL2 system registers and EL1 system registers.
    */

> + */
> +static const struct el1_el2_map vhe_map[] = {
> +	{ SCTLR_EL1, SCTLR_EL2 },
> +	{ CPACR_EL1, CPTR_EL2 },
> +	{ TTBR0_EL1, TTBR0_EL2 },
> +	{ TTBR1_EL1, TTBR1_EL2 },
> +	{ TCR_EL1, TCR_EL2},
> +	{ AFSR0_EL1, AFSR0_EL2 },
> +	{ AFSR1_EL1, AFSR1_EL2 },
> +	{ ESR_EL1, ESR_EL2},
> +	{ FAR_EL1, FAR_EL2},
> +	{ MAIR_EL1, MAIR_EL2 },
> +	{ AMAIR_EL1, AMAIR_EL2 },
> +	{ VBAR_EL1, VBAR_EL2 },
> +	{ CONTEXTIDR_EL1, CONTEXTIDR_EL2 },
> +	{ CNTKCTL_EL1, CNTHCTL_EL2 },
> +};
> +
>  static inline u64 tcr_el2_ips_to_tcr_el1_ps(u64 tcr_el2)
>  {
>  	return ((tcr_el2 & TCR_EL2_PS_MASK) >> TCR_EL2_PS_SHIFT)
> @@ -57,7 +78,27 @@ static inline u64 cptr_to_cpacr(u64 cptr_el2)
>  	return cpacr_el1;
>  }
>  
> -static void flush_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
> +static void sync_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
> +{
> +	u64 *s_sys_regs = vcpu->arch.ctxt.shadow_sys_regs;
> +	int i;
> +
> +	/*
> +	 * In the virtual EL2 without VHE no EL1 system registers can't be

no other EL1 system register then el1_non_trap_regs[] can be changed
without trapping to the host hypervisor

> +	 * changed without trap except el1_non_trap_regs[]. So we have nothing
> +	 * to sync on exit from a guest.
> +	 */
> +	if (!vcpu_el2_e2h_is_set(vcpu))
> +		return;
> +
> +	for (i = 0; i < ARRAY_SIZE(vhe_map); i++) {
> +		const struct el1_el2_map *map = &vhe_map[i];
> +
> +		vcpu_sys_reg(vcpu, map->el2) = s_sys_regs[map->el1];
> +	}
> +}
> +
> +static void flush_shadow_el1_sysregs_nvhe(struct kvm_vcpu *vcpu)
>  {
>  	u64 *s_sys_regs = vcpu->arch.ctxt.shadow_sys_regs;
>  	u64 tcr_el2;
> @@ -86,6 +127,29 @@ static void flush_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
>  	s_sys_regs[CPACR_EL1] = cptr_to_cpacr(vcpu_sys_reg(vcpu, CPTR_EL2));
>  }
>  
> +static void flush_shadow_el1_sysregs_vhe(struct kvm_vcpu *vcpu)
> +{
> +	u64 *s_sys_regs = vcpu->arch.ctxt.shadow_sys_regs;
> +	int i;
> +
> +	/*
> +	 * When e2h bit is set, EL2 registers becomes compatible
> +	 * with corrensponding EL1 registers. So, no conversion required.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(vhe_map); i++) {
> +		const struct el1_el2_map *map = &vhe_map[i];
> +
> +		s_sys_regs[map->el1] = vcpu_sys_reg(vcpu, map->el2);
> +	}
> +}
> +
> +static void flush_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu_el2_e2h_is_set(vcpu))
> +		flush_shadow_el1_sysregs_vhe(vcpu);
> +	else
> +		flush_shadow_el1_sysregs_nvhe(vcpu);
> +}
>  
>  /*
>   * List of EL0 and EL1 registers which we allow the virtual EL2 mode to access
> @@ -247,6 +311,7 @@ void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu)
>  	if (unlikely(is_hyp_ctxt(vcpu))) {
>  		sync_shadow_special_regs(vcpu);
>  		sync_shadow_non_trap_el1_state(vcpu);
> +		sync_shadow_el1_sysregs(vcpu);
>  	} else
>  		sync_special_regs(vcpu);
>  }
> -- 
> 1.9.1
> 

Thanks,
-Christoffer
