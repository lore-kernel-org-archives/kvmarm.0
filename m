From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 17/21] KVM: ARM64: Add helper to handle PMCR register
 bits
Date: Tue, 08 Dec 2015 17:36:23 +0000
Message-ID: <56671517.3040503@arm.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com> <1449578860-15808-18-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449578860-15808-18-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 08/12/15 12:47, Shannon Zhao wrote:
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
>  arch/arm64/kvm/sys_regs.c |  2 ++
>  include/kvm/arm_pmu.h     |  2 ++
>  virt/kvm/arm/pmu.c        | 51 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 55 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9baa654..110b288 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -620,6 +620,7 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  			val &= ~ARMV8_PMCR_MASK;
>  			val |= p->regval & ARMV8_PMCR_MASK;
>  			vcpu_sys_reg(vcpu, r->reg) = val;
> +			kvm_pmu_handle_pmcr(vcpu, val);
>  			break;
>  		}
>  		case PMCEID0_EL0:
> @@ -1218,6 +1219,7 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
>  			val &= ~ARMV8_PMCR_MASK;
>  			val |= p->regval & ARMV8_PMCR_MASK;
>  			vcpu_cp15(vcpu, r->reg) = val;
> +			kvm_pmu_handle_pmcr(vcpu, val);
>  			break;
>  		}
>  		case c9_PMCEID0:
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index d12450a..a131f76 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -46,6 +46,7 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val);
>  void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val);
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>  				    u32 select_idx);
> +void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val);
>  #else
>  u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
>  {
> @@ -58,6 +59,7 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val) {}
>  void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val) {}
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>  				    u32 select_idx) {}
> +void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val) {}
>  #endif
>  
>  #endif
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 093e211..9b9c706 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -151,6 +151,57 @@ static u32 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
>  }
>  
>  /**
> + * kvm_pmu_handle_pmcr - handle PMCR register
> + * @vcpu: The vcpu pointer
> + * @val: the value guest writes to PMCR register
> + */
> +void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc;
> +	u32 enable;
> +	int i;
> +
> +	if (val & ARMV8_PMCR_E) {
> +		if (!vcpu_mode_is_32bit(vcpu))
> +			enable = vcpu_sys_reg(vcpu, PMCNTENSET_EL0);

This returns a 64bit quantity. Please explicitly select the low 32bits.

> +		else
> +			enable = vcpu_cp15(vcpu, c9_PMCNTENSET);
> +
> +		kvm_pmu_enable_counter(vcpu, enable, true);

It really feels like there is some common stuff with the handling of
PNCTENSET,

> +	} else {
> +		kvm_pmu_disable_counter(vcpu, 0xffffffffUL);
> +	}
> +
> +	if (val & ARMV8_PMCR_C) {
> +		pmc = &pmu->pmc[ARMV8_MAX_COUNTERS - 1];

Nit: it would be nice to have a #define for the cycle counter.

> +		if (pmc->perf_event)
> +			local64_set(&pmc->perf_event->count, 0);
> +		if (!vcpu_mode_is_32bit(vcpu))
> +			vcpu_sys_reg(vcpu, PMCCNTR_EL0) = 0;
> +		else
> +			vcpu_cp15(vcpu, c9_PMCCNTR) = 0;
> +	}
> +
> +	if (val & ARMV8_PMCR_P) {
> +		for (i = 0; i < ARMV8_MAX_COUNTERS - 1; i++) {
> +			pmc = &pmu->pmc[i];
> +			if (pmc->perf_event)
> +				local64_set(&pmc->perf_event->count, 0);
> +			if (!vcpu_mode_is_32bit(vcpu))
> +				vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = 0;
> +			else
> +				vcpu_cp15(vcpu, c14_PMEVCNTR0 + i) = 0;
> +		}
> +	}
> +
> +	if (val & ARMV8_PMCR_LC) {
> +		pmc = &pmu->pmc[ARMV8_MAX_COUNTERS - 1];
> +		pmc->bitmask = 0xffffffffffffffffUL;
> +	}
> +}
> +
> +/**
>   * kvm_pmu_overflow_clear - clear PMU overflow interrupt
>   * @vcpu: The vcpu pointer
>   * @val: the value guest writes to PMOVSCLR register
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
