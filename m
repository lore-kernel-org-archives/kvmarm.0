From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 14/20] KVM: ARM64: Add helper to handle PMCR register
 bits
Date: Thu, 07 Jan 2016 11:59:43 +0000
Message-ID: <568E532F.70604@arm.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com> <1450771695-11948-15-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450771695-11948-15-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 22/12/15 08:08, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> According to ARMv8 spec, when writing 1 to PMCR.E, all counters are
> enabled by PMCNTENSET, while writing 0 to PMCR.E, all counters are
> disabled. When writing 1 to PMCR.P, reset all event counters, not
> including PMCCNTR, to zero. When writing 1 to PMCR.C, reset PMCCNTR to
> zero.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c |  1 +
>  include/kvm/arm_pmu.h     |  2 ++
>  virt/kvm/arm/pmu.c        | 42 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 45 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 92021dc..04281f1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -464,6 +464,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  		val &= ~ARMV8_PMCR_MASK;
>  		val |= p->regval & ARMV8_PMCR_MASK;
>  		vcpu_sys_reg(vcpu, r->reg) = val;
> +		kvm_pmu_handle_pmcr(vcpu, val);
>  	} else {
>  		/* PMCR.P & PMCR.C are RAZ */
>  		val = vcpu_sys_reg(vcpu, r->reg)
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 67d168c..7ec7706 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -41,6 +41,7 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
> +void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  				    u64 select_idx);
>  #else
> @@ -59,6 +60,7 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>  void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
>  void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
> +void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  				    u64 select_idx) {}
>  #endif
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 409f3c4..fda32cb 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -189,6 +189,48 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
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

As much as I'm scared by the idea of directly messing with the perf
internals, I can't find another way of doing this, and perf itself
doesn't seen to do any locking when resetting the counter.

> +			vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = 0;
> +		}
> +	}
> +
> +	if (val & ARMV8_PMCR_LC) {
> +		pmc = &pmu->pmc[ARMV8_CYCLE_IDX];
> +		pmc->bitmask = 0xffffffffffffffffUL;
> +	}
> +}
> +
>  static inline bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu,
>  					      u64 select_idx)
>  {
> 

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
