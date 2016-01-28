From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v10 14/21] KVM: ARM64: Add helper to handle PMCR register
 bits
Date: Thu, 28 Jan 2016 20:15:40 +0100
Message-ID: <20160128191540.GE16453@hawk.localdomain>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
 <1453866709-20324-15-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453866709-20324-15-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 27, 2016 at 11:51:42AM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> According to ARMv8 spec, when writing 1 to PMCR.E, all counters are
> enabled by PMCNTENSET, while writing 0 to PMCR.E, all counters are
> disabled. When writing 1 to PMCR.P, reset all event counters, not
> including PMCCNTR, to zero. When writing 1 to PMCR.C, reset PMCCNTR to
> zero.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c |  1 +
>  include/kvm/arm_pmu.h     |  2 ++
>  virt/kvm/arm/pmu.c        | 42 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 45 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f45c227..eefc60a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -467,6 +467,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  		val &= ~ARMV8_PMCR_MASK;
>  		val |= p->regval & ARMV8_PMCR_MASK;
>  		vcpu_sys_reg(vcpu, PMCR_EL0) = val;
> +		kvm_pmu_handle_pmcr(vcpu, val);
>  	} else {
>  		/* PMCR.P & PMCR.C are RAZ */
>  		val = vcpu_sys_reg(vcpu, PMCR_EL0)
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index caa706e..5bed00c 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -42,6 +42,7 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
> +void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  				    u64 select_idx);
>  #else
> @@ -62,6 +63,7 @@ static inline void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
> +static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
>  						  u64 data, u64 select_idx) {}
>  #endif
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 706c935..d411f3f 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -190,6 +190,48 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
>  	}
>  }
>  
> +/**
> + * kvm_pmu_handle_pmcr - handle PMCR register
> + * @vcpu: The vcpu pointer
> + * @val: the value guest writes to PMCR register
> + */
> +void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc;
> +	u64 mask;
> +	int i;
> +
> +	mask = kvm_pmu_valid_counter_mask(vcpu);
> +	if (val & ARMV8_PMCR_E) {
> +		kvm_pmu_enable_counter(vcpu,
> +				     vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);

nit: sort of an ugly indentation. I don't think the vcpu_sys_reg needs
to line up with the vcpu.

> +	} else {
> +		kvm_pmu_disable_counter(vcpu, mask);
> +	}
> +
> +	if (val & ARMV8_PMCR_C) {
> +		pmc = &pmu->pmc[ARMV8_CYCLE_IDX];
> +		if (pmc->perf_event)
> +			local64_set(&pmc->perf_event->count, 0);
> +		vcpu_sys_reg(vcpu, PMCCNTR_EL0) = 0;
> +	}
> +
> +	if (val & ARMV8_PMCR_P) {
> +		for (i = 0; i < ARMV8_CYCLE_IDX; i++) {
> +			pmc = &pmu->pmc[i];
> +			if (pmc->perf_event)
> +				local64_set(&pmc->perf_event->count, 0);
> +			vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = 0;
> +		}
> +	}

The local64_set's surprise me. Patch 9/21 seems to go out of its way to
allow the perf_event count to be whatever it happens to be, but then
calculate the appropriate base to modify it with when the register is
written by the guest. Here we're just simply setting both the perf_event
counter and the register to zero. Shouldn't we be going through some perf
API for the zeroing of its counter, and then do the same thing as patch
9/21 does to set the register?

> +
> +	if (val & ARMV8_PMCR_LC) {
> +		pmc = &pmu->pmc[ARMV8_CYCLE_IDX];
> +		pmc->bitmask = 0xffffffffffffffffUL;
> +	}
> +}
> +
>  static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
>  	return (vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMCR_E) &&
> -- 
> 2.0.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
