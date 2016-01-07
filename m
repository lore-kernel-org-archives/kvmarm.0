From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 12/20] KVM: ARM64: Add access handler for PMOVSSET
 and PMOVSCLR register
Date: Thu, 07 Jan 2016 11:14:33 +0000
Message-ID: <568E4899.6060607@arm.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com> <1450771695-11948-13-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450771695-11948-13-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 22/12/15 08:08, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Since the reset value of PMOVSSET and PMOVSCLR is UNKNOWN, use
> reset_unknown for its reset handler. Add a handler to emulate writing
> PMOVSSET or PMOVSCLR register.
> 
> When writing non-zero value to PMOVSSET, the counter and its interrupt
> is enabled, kick this vcpu to sync PMU interrupt.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 26 +++++++++++++++++++++++---
>  include/kvm/arm_pmu.h     |  2 ++
>  virt/kvm/arm/pmu.c        | 30 ++++++++++++++++++++++++++++++
>  3 files changed, 55 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 24ce4fe..d61f271dd 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -663,6 +663,25 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	return true;
>  }
>  
> +static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			 const struct sys_reg_desc *r)
> +{
> +	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
> +
> +	if (p->is_write) {
> +		if (r->CRm & 0x2)
> +			/* accessing PMOVSSET_EL0 */
> +			kvm_pmu_overflow_set(vcpu, p->regval & mask);
> +		else
> +			/* accessing PMOVSCLR_EL0 */
> +			vcpu_sys_reg(vcpu, r->reg) &= ~(p->regval & mask);
> +	} else {
> +		p->regval = vcpu_sys_reg(vcpu, r->reg) & mask;
> +	}
> +
> +	return true;
> +}

Same 32bit bug.

> +
>  /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>  	/* DBGBVRn_EL1 */						\
> @@ -870,7 +889,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmcnten, NULL, PMCNTENSET_EL0 },
>  	/* PMOVSCLR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b011),
> -	  trap_raz_wi },
> +	  access_pmovs, NULL, PMOVSSET_EL0 },
>  	/* PMSWINC_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b100),
>  	  trap_raz_wi },
> @@ -897,7 +916,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  trap_raz_wi },
>  	/* PMOVSSET_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b011),
> -	  trap_raz_wi },
> +	  access_pmovs, reset_unknown, PMOVSSET_EL0 },
>  
>  	/* TPIDR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b010),
> @@ -1211,7 +1230,7 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmcr },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), access_pmcnten },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmcnten },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmovs },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
> @@ -1221,6 +1240,7 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pminten },
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pminten },
> +	{ Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmovs },
>  
>  	{ Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, c10_PRRR },
>  	{ Op1( 0), CRn(10), CRm( 2), Op2( 1), access_vm_reg, NULL, c10_NMRR },
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 9d2d0c0..244970b 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -39,6 +39,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
>  u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
> +void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  				    u64 select_idx);
>  #else
> @@ -55,6 +56,7 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
>  }
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
> +void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  				    u64 select_idx) {}
>  #endif
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index bc64043..c23d57e 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -130,6 +130,36 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val)
>  	}
>  }
>  
> +static inline u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)

Please drop the inline attribute.

> +{
> +	u64 reg;
> +
> +	reg = vcpu_sys_reg(vcpu, PMOVSSET_EL0);
> +	reg &= vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
> +	reg &= vcpu_sys_reg(vcpu, PMINTENSET_EL1);
> +	reg &= kvm_pmu_valid_counter_mask(vcpu);
> +
> +	return reg;
> +}
> +
> +/**
> + * kvm_pmu_overflow_set - set PMU overflow interrupt
> + * @vcpu: The vcpu pointer
> + * @val: the value guest writes to PMOVSSET register
> + */
> +void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	u64 reg;
> +
> +	if (val == 0)
> +		return;
> +
> +	vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= val;
> +	reg = kvm_pmu_overflow_status(vcpu);
> +	if (reg != 0)
> +		kvm_vcpu_kick(vcpu);
> +}
> +
>  static inline bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu,
>  					      u64 select_idx)
>  {
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
