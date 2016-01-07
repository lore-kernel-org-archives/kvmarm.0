From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 16/20] KVM: ARM64: Add access handler for PMUSERENR
 register
Date: Thu, 07 Jan 2016 10:14:04 +0000
Message-ID: <568E3A6C.2010404@arm.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <1450771695-11948-17-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3E254970D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2016 05:10:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QXyaDnH+OfjE for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2016 05:10:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F51749680
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2016 05:10:24 -0500 (EST)
In-Reply-To: <1450771695-11948-17-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 22/12/15 08:08, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> This register resets as unknown in 64bit mode while it resets as zero
> in 32bit mode. Here we choose to reset it as zero for consistency.
> 
> PMUSERENR_EL0 holds some bits which decide whether PMU registers can be
> accessed from EL0. Add some check helpers to handle the access from EL0.
> 
> When these bits are zero, only reading PMUSERENR will trap to EL2 and
> writing PMUSERENR or reading/writing other PMU registers will trap to
> EL1 other than EL2 when HCR.TGE==0. To current KVM configuration
> (HCR.TGE==0) there is no way to get these traps. Here we write 0xf to
> physical PMUSERENR register on VM entry, so that it will trap PMU access
> from EL0 to EL2. Within the register access handler we check the real
> value of guest PMUSERENR register to decide whether this access is
> allowed. If not allowed, forward this trap to EL1.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/include/asm/pmu.h |   9 ++++
>  arch/arm64/kvm/hyp/switch.c  |   3 ++
>  arch/arm64/kvm/sys_regs.c    | 122 +++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 129 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
> index 2588f9c..1238ade 100644
> --- a/arch/arm64/include/asm/pmu.h
> +++ b/arch/arm64/include/asm/pmu.h
> @@ -67,4 +67,13 @@
>  #define	ARMV8_EXCLUDE_EL0	(1 << 30)
>  #define	ARMV8_INCLUDE_EL2	(1 << 27)
>  
> +/*
> + * PMUSERENR: user enable reg
> + */
> +#define ARMV8_USERENR_MASK	0xf		/* Mask for writable bits */
> +#define ARMV8_USERENR_EN	(1 << 0) /* PMU regs can be accessed at EL0 */
> +#define ARMV8_USERENR_SW	(1 << 1) /* PMSWINC can be written at EL0 */
> +#define ARMV8_USERENR_CR	(1 << 2) /* Cycle counter can be read at EL0 */
> +#define ARMV8_USERENR_ER	(1 << 3) /* Event counter can be read at EL0 */
> +
>  #endif /* __ASM_PMU_H */
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index ca8f5a5..a85375f 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -37,6 +37,8 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
>  	write_sysreg(1 << 15, hstr_el2);
>  	write_sysreg(CPTR_EL2_TTA | CPTR_EL2_TFP, cptr_el2);
> +	/* Make sure we trap PMU access from EL0 to EL2 */
> +	write_sysreg(15, pmuserenr_el0);

Please use the ARMV8_USERENR_* constants here instead of a magic number
(since you went through the hassle of defining them!).

>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>  }
>  
> @@ -45,6 +47,7 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
>  	write_sysreg(HCR_RW, hcr_el2);
>  	write_sysreg(0, hstr_el2);
>  	write_sysreg(read_sysreg(mdcr_el2) & MDCR_EL2_HPMN_MASK, mdcr_el2);
> +	write_sysreg(0, pmuserenr_el0);
>  	write_sysreg(0, cptr_el2);
>  }
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 04281f1..ac0cbf8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -453,11 +453,47 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	vcpu_sys_reg(vcpu, r->reg) = val;
>  }
>  
> +static inline bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)

Please drop all the inline attributes. The compiler knows its stuff well
enough to do it automagically, and this is hardly a fast path...

> +{
> +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> +
> +	return !((reg & ARMV8_USERENR_EN) || vcpu_mode_priv(vcpu));
> +}
> +
> +static inline bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
> +{
> +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> +
> +	return !((reg & (ARMV8_USERENR_SW | ARMV8_USERENR_EN))
> +		 || vcpu_mode_priv(vcpu));
> +}
> +
> +static inline bool pmu_access_cycle_counter_el0_disabled(struct kvm_vcpu *vcpu)
> +{
> +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> +
> +	return !((reg & (ARMV8_USERENR_CR | ARMV8_USERENR_EN))
> +		 || vcpu_mode_priv(vcpu));
> +}
> +
> +static inline bool pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
> +{
> +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> +
> +	return !((reg & (ARMV8_USERENR_ER | ARMV8_USERENR_EN))
> +		 || vcpu_mode_priv(vcpu));
> +}
> +
>  static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			const struct sys_reg_desc *r)
>  {
>  	u64 val;
>  
> +	if (pmu_access_el0_disabled(vcpu)) {
> +		kvm_forward_trap_to_el1(vcpu);
> +		return true;
> +	}

So with the patch I posted earlier
(http://www.spinics.net/lists/arm-kernel/msg472693.html), all the
instances similar to that code can be rewritten as

+       if (pmu_access_el0_disabled(vcpu))
+               return false;

You can then completely drop both patch 15 and my original patch to fix
the PC stuff (which is far from being perfect, as noted by Peter).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
