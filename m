From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 14/21] KVM: ARM64: Add reset and access handlers for
 PMOVSSET and PMOVSCLR register
Date: Tue, 08 Dec 2015 16:59:09 +0000
Message-ID: <56670C5D.3020407@arm.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com> <1449578860-15808-15-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449578860-15808-15-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 08/12/15 12:47, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Since the reset value of PMOVSSET and PMOVSCLR is UNKNOWN, use
> reset_unknown for its reset handler. Add a new case to emulate writing
> PMOVSSET or PMOVSCLR register.
> 
> When writing non-zero value to PMOVSSET, pend PMU interrupt. When the
> value writing to PMOVSCLR is equal to the current value, clear the PMU
> pending interrupt.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 27 ++++++++++++++++--
>  include/kvm/arm_pmu.h     |  4 +++
>  virt/kvm/arm/pmu.c        | 72 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 100 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c1dffb2..c830fde 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -601,6 +601,15 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  				vcpu_sys_reg(vcpu, r->reg) &= ~p->regval;
>  			break;
>  		}
> +		case PMOVSSET_EL0: {
> +			if (r->CRm == 14)
> +				/* accessing PMOVSSET_EL0 */
> +				kvm_pmu_overflow_set(vcpu, p->regval);
> +			else
> +				/* accessing PMOVSCLR_EL0 */
> +				kvm_pmu_overflow_clear(vcpu, p->regval);
> +			break;
> +		}
>  		case PMCR_EL0: {
>  			/* Only update writeable bits of PMCR */
>  			val = vcpu_sys_reg(vcpu, r->reg);
> @@ -847,7 +856,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmu_regs, reset_unknown, PMCNTENSET_EL0 },
>  	/* PMOVSCLR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b011),
> -	  trap_raz_wi },
> +	  access_pmu_regs, reset_unknown, PMOVSSET_EL0 },
>  	/* PMSWINC_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b100),
>  	  trap_raz_wi },
> @@ -874,7 +883,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  trap_raz_wi },
>  	/* PMOVSSET_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b011),
> -	  trap_raz_wi },
> +	  access_pmu_regs, reset_unknown, PMOVSSET_EL0 },
>  
>  	/* TPIDR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b010),
> @@ -1184,6 +1193,15 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
>  				vcpu_cp15(vcpu, r->reg) &= ~p->regval;
>  			break;
>  		}
> +		case c9_PMOVSSET: {
> +			if (r->CRm == 14)
> +				/* accessing c9_PMOVSSET */
> +				kvm_pmu_overflow_set(vcpu, p->regval);
> +			else
> +				/* accessing c9_PMOVSCLR */
> +				kvm_pmu_overflow_clear(vcpu, p->regval);
> +			break;
> +		}
>  		case c9_PMCR: {
>  			/* Only update writeable bits of PMCR */
>  			val = vcpu_cp15(vcpu, r->reg);
> @@ -1271,7 +1289,8 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	  NULL, c9_PMCNTENSET },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmu_cp15_regs,
>  	  NULL, c9_PMCNTENSET },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmu_cp15_regs,
> +	  NULL, c9_PMOVSSET },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
>  	  NULL, c9_PMSELR },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmu_cp15_regs,
> @@ -1287,6 +1306,8 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	  NULL, c9_PMINTENSET },
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pmu_cp15_regs,
>  	  NULL, c9_PMINTENSET },
> +	{ Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmu_cp15_regs,
> +	  NULL, c9_PMOVSSET },
>  
>  	{ Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, c10_PRRR },
>  	{ Op1( 0), CRn(10), CRm( 2), Op2( 1), access_vm_reg, NULL, c10_NMRR },
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index e731656..a76df52 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -41,6 +41,8 @@ struct kvm_pmu {
>  u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable);
> +void kvm_pmu_overflow_clear(struct kvm_vcpu *vcpu, u32 val);
> +void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val);
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>  				    u32 select_idx);
>  #else
> @@ -50,6 +52,8 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
>  }
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val) {}
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable) {}
> +void kvm_pmu_overflow_clear(struct kvm_vcpu *vcpu, u32 val) {}
> +void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val) {}
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>  				    u32 select_idx) {}
>  #endif
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 45586d2..ba7d11c 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -136,6 +136,78 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val)
>  	}
>  }
>  
> +static u32 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
> +{
> +	u32 val;
> +
> +	if (!vcpu_mode_is_32bit(vcpu))
> +	val = (vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMCR_N_SHIFT)
> +	      & ARMV8_PMCR_N_MASK;
> +	else
> +	val = (vcpu_cp15(vcpu, c9_PMCR) >> ARMV8_PMCR_N_SHIFT)
> +	      & ARMV8_PMCR_N_MASK;

Indentation? Again, no need to distinguish 32 and 64bit here.

> +
> +	return GENMASK(val - 1, 0) | BIT(ARMV8_COUNTER_MASK);
> +}
> +
> +/**
> + * kvm_pmu_overflow_clear - clear PMU overflow interrupt
> + * @vcpu: The vcpu pointer
> + * @val: the value guest writes to PMOVSCLR register
> + * @reg: the current value of PMOVSCLR register
> + */
> +void kvm_pmu_overflow_clear(struct kvm_vcpu *vcpu, u32 val)
> +{
> +	u32 mask = kvm_pmu_valid_counter_mask(vcpu);
> +
> +	if (!vcpu_mode_is_32bit(vcpu)) {
> +		vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= mask;
> +		vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~val;
> +		val = vcpu_sys_reg(vcpu, PMOVSSET_EL0);

I'm not fond of messing with the sysreg like this. Consider using a
temporary variable.

> +	} else {
> +		vcpu_cp15(vcpu, c9_PMOVSSET) &= mask;
> +		vcpu_cp15(vcpu, c9_PMOVSSET) &= ~val;
> +		val = vcpu_cp15(vcpu, c9_PMOVSSET);

Same here.

> +	}
> +
> +	/* If all overflow bits are cleared, kick the vcpu to clear interrupt
> +	 * pending status.
> +	 */
> +	if (val == 0)
> +		kvm_vcpu_kick(vcpu);

Do we really need to do so? This will be dropped on the next entry
anyway, so i don't see the need to kick the vcpu again. Or am I missing
something?

> +}
> +
> +/**
> + * kvm_pmu_overflow_set - set PMU overflow interrupt
> + * @vcpu: The vcpu pointer
> + * @val: the value guest writes to PMOVSSET register
> + */
> +void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val)
> +{
> +	u32 mask = kvm_pmu_valid_counter_mask(vcpu);
> +
> +	val &= mask;
> +	if (val == 0)
> +		return;
> +
> +	if (!vcpu_mode_is_32bit(vcpu)) {
> +		vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= mask;
> +		vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= val;
> +		val = vcpu_sys_reg(vcpu, PMCNTENSET_EL0)
> +		      & vcpu_sys_reg(vcpu, PMINTENSET_EL1)
> +		      & vcpu_sys_reg(vcpu, PMOVSSET_EL0);

Same here.

> +	} else {
> +		vcpu_cp15(vcpu, c9_PMOVSSET) &= mask;
> +		vcpu_cp15(vcpu, c9_PMOVSSET) |= val;
> +		val = vcpu_cp15(vcpu, c9_PMCNTENSET)
> +		      & vcpu_cp15(vcpu, c9_PMINTENSET)
> +		      & vcpu_cp15(vcpu, c9_PMOVSSET);

and here.

> +	}
> +
> +	if (val != 0)
> +		kvm_vcpu_kick(vcpu);
> +}
> +
>  /**
>   * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
>   * @vcpu: The vcpu pointer
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
