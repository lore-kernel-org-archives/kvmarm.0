From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 12/18] KVM: ARM64: Add reset and access handlers for
 PMINTENSET_EL1 and PMINTENCLR_EL1 register
Date: Fri, 17 Jul 2015 16:56:24 +0200
Message-ID: <20150717145624.GV14024@cbox>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
 <1436149068-3784-13-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436149068-3784-13-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: shannon.zhao@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 06, 2015 at 10:17:42AM +0800, shannon.zhao@linaro.org wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Since the reset value of PMINTENSET_EL1 and PMINTENCLR_EL1 is UNKNOWN,
> use reset_unknown for its reset handler. Add access handler which
> emulates writing and reading PMINTENSET_EL1 or PMINTENCLR_EL1 register.
> When writing to PMINTENSET_EL1, set the interrupt flag true. While
> writing to PMINTENCLR_EL1, set the interrupt flag false. This flag will
> be useful for counter overflow interrupt.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 56 +++++++++++++++++++++++++++++++++++++++++++++--
>  include/kvm/arm_pmu.h     |  4 ++++
>  virt/kvm/arm/pmu.c        | 28 ++++++++++++++++++++++++
>  3 files changed, 86 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c14ec8d..cbc07b8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -444,6 +444,58 @@ static bool access_pmcntenclr(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +/* PMINTENSET_EL1 accessor. */
> +static bool access_pmintenset(struct kvm_vcpu *vcpu,
> +			      const struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
> +{
> +	unsigned long val;
> +
> +	if (p->is_write) {
> +		val = *vcpu_reg(vcpu, p->Rt);
> +		if (!p->is_aarch32)
> +			vcpu_sys_reg(vcpu, r->reg) |= val;
> +		else
> +			vcpu_cp15(vcpu, r->reg) |= val & 0xffffffffUL;
> +
> +		kvm_pmu_enable_interrupt(vcpu, val);
> +	} else {
> +		if (!p->is_aarch32)
> +			val = vcpu_sys_reg(vcpu, r->reg);
> +		else
> +			val = vcpu_cp15(vcpu, r->reg);
> +		*vcpu_reg(vcpu, p->Rt) = val;
> +	}
> +
> +	return true;
> +}
> +
> +/* PMINTENCLR_EL1 accessor. */
> +static bool access_pmintenclr(struct kvm_vcpu *vcpu,
> +			      const struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
> +{
> +	unsigned long val;
> +
> +	if (p->is_write) {
> +		val = *vcpu_reg(vcpu, p->Rt);
> +		if (!p->is_aarch32)
> +			vcpu_sys_reg(vcpu, r->reg) |= val;
> +		else
> +			vcpu_cp15(vcpu, r->reg) |= val & 0xffffffffUL;
> +
> +		kvm_pmu_disable_interrupt(vcpu, val);
> +	} else {
> +		if (!p->is_aarch32)
> +			val = vcpu_sys_reg(vcpu, r->reg);
> +		else
> +			val = vcpu_cp15(vcpu, r->reg);
> +		*vcpu_reg(vcpu, p->Rt) = val;
> +	}

Same comments as in the previous patch, but now I realize what you're
doing with the set/clear registers.  These are not separate pieces of
state, but a single register, which are just accessed with two
interfaces, for set/clear patterns.

> +
> +	return true;
> +}
> +
>  /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>  	/* DBGBVRn_EL1 */						\
> @@ -595,10 +647,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  
>  	/* PMINTENSET_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b1001), CRm(0b1110), Op2(0b001),
> -	  trap_raz_wi },
> +	  access_pmintenset, reset_unknown, PMINTENSET_EL1 },
>  	/* PMINTENCLR_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b1001), CRm(0b1110), Op2(0b010),
> -	  trap_raz_wi },
> +	  access_pmintenclr, reset_unknown, PMINTENCLR_EL1 },
>  
>  	/* MAIR_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b1010), CRm(0b0010), Op2(0b000),
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 2cfd9be..dee8356 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -51,6 +51,8 @@ unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
>  					unsigned long select_idx);
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, unsigned long val);
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, unsigned long val);
> +void kvm_pmu_disable_interrupt(struct kvm_vcpu *vcpu, unsigned long val);
> +void kvm_pmu_enable_interrupt(struct kvm_vcpu *vcpu, unsigned long val);
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
>  				    unsigned long select_idx);
>  void kvm_pmu_init(struct kvm_vcpu *vcpu);
> @@ -65,6 +67,8 @@ unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
>  }
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, unsigned long val) {}
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, unsigned long val) {}
> +void kvm_pmu_disable_interrupt(struct kvm_vcpu *vcpu, unsigned long val) {}
> +void kvm_pmu_enable_interrupt(struct kvm_vcpu *vcpu, unsigned long val) {}
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
>  				    unsigned long select_idx) {}
>  static inline void kvm_pmu_init(struct kvm_vcpu *vcpu) {}
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index cf59998..7023ad5 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -175,6 +175,34 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, unsigned long val)
>  }
>  
>  /**
> + * kvm_pmu_enable_interrupt - enable selected PMU counter interrupt
> + * @vcpu: The vcpu pointer
> + * @val: the value guest writes to PMINTENSET_EL0 register
> + */
> +void kvm_pmu_enable_interrupt(struct kvm_vcpu *vcpu, unsigned long val)
> +{
> +	int select_idx = find_first_bit(&val, 32);

also same as before.

> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +
> +	pmc->interrupt = true;

ah, so this was interrupts enabled, I think this is better called
interrupt_enabled on the struct.


Thanks,
-Christoffer

> +}
> +
> +/**
> + * kvm_pmu_disable_interrupt - disable selected PMU counter interrupt
> + * @vcpu: The vcpu pointer
> + * @val: the value guest writes to PMINTENCLR_EL0 register
> + */
> +void kvm_pmu_disable_interrupt(struct kvm_vcpu *vcpu, unsigned long val)
> +{
> +	int select_idx = find_first_bit(&val, 32);
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +
> +	pmc->interrupt = false;
> +}
> +
> +/**
>   * kvm_pmu_find_hw_event - find hardware event
>   * @pmu: The pmu pointer
>   * @event_select: The number of selected event type
> -- 
> 2.1.0
> 
