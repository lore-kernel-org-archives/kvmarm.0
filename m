From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 12/21] KVM: ARM64: Add reset and access handlers for
 PMCNTENSET and PMCNTENCLR register
Date: Tue, 08 Dec 2015 16:42:13 +0000
Message-ID: <56670865.2050705@arm.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com> <1449578860-15808-13-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449578860-15808-13-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 08/12/15 12:47, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Since the reset value of PMCNTENSET and PMCNTENCLR is UNKNOWN, use
> reset_unknown for its reset handler. Add a new case to emulate writing
> PMCNTENSET or PMCNTENCLR register.
> 
> When writing to PMCNTENSET, call perf_event_enable to enable the perf
> event. When writing to PMCNTENCLR, call perf_event_disable to disable
> the perf event.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 39 +++++++++++++++++++++++++++++++++++----
>  include/kvm/arm_pmu.h     |  4 ++++
>  virt/kvm/arm/pmu.c        | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 86 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2304937..a780cb5 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -577,6 +577,21 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  			vcpu_sys_reg(vcpu, r->reg) = p->regval;
>  			break;
>  		}
> +		case PMCNTENSET_EL0: {
> +			val = p->regval;
> +			if (r->Op2 == 1) {
> +				/* accessing PMCNTENSET_EL0 */
> +				kvm_pmu_enable_counter(vcpu, val,
> +				   vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMCR_E);
> +				vcpu_sys_reg(vcpu, r->reg) |= val;
> +			} else {
> +
> +				/* accessing PMCNTENCLR_EL0 */
> +				kvm_pmu_disable_counter(vcpu, val);
> +				vcpu_sys_reg(vcpu, r->reg) &= ~val;
> +			}
> +			break;
> +		}
>  		case PMCR_EL0: {
>  			/* Only update writeable bits of PMCR */
>  			val = vcpu_sys_reg(vcpu, r->reg);
> @@ -817,10 +832,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmu_regs, reset_pmcr, PMCR_EL0, },
>  	/* PMCNTENSET_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
> -	  trap_raz_wi },
> +	  access_pmu_regs, reset_unknown, PMCNTENSET_EL0 },
>  	/* PMCNTENCLR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b010),
> -	  trap_raz_wi },
> +	  access_pmu_regs, reset_unknown, PMCNTENSET_EL0 },
>  	/* PMOVSCLR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b011),
>  	  trap_raz_wi },
> @@ -1137,6 +1152,20 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
>  			vcpu_cp15(vcpu, r->reg) = p->regval;
>  			break;
>  		}
> +		case c9_PMCNTENSET: {
> +			val = p->regval;
> +			if (r->Op2 == 1) {
> +				/* accessing c9_PMCNTENSET */
> +				kvm_pmu_enable_counter(vcpu, val,
> +				       vcpu_cp15(vcpu, c9_PMCR) & ARMV8_PMCR_E);
> +				vcpu_cp15(vcpu, r->reg) |= val;
> +			} else {
> +				/* accessing c9_PMCNTENCLR */
> +				kvm_pmu_disable_counter(vcpu, val);
> +				vcpu_cp15(vcpu, r->reg) &= ~val;
> +			}
> +			break;
> +		}
>  		case c9_PMCR: {
>  			/* Only update writeable bits of PMCR */
>  			val = vcpu_cp15(vcpu, r->reg);
> @@ -1220,8 +1249,10 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	/* PMU */
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmu_cp15_regs,
>  	  NULL, c9_PMCR },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), trap_raz_wi },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), access_pmu_cp15_regs,
> +	  NULL, c9_PMCNTENSET },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmu_cp15_regs,
> +	  NULL, c9_PMCNTENSET },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
>  	  NULL, c9_PMSELR },
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 36bde48..e731656 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -39,6 +39,8 @@ struct kvm_pmu {
>  
>  #ifdef CONFIG_KVM_ARM_PMU
>  u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
> +void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
> +void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable);
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>  				    u32 select_idx);
>  #else
> @@ -46,6 +48,8 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
>  {
>  	return 0;
>  }
> +void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val) {}
> +void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable) {}
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>  				    u32 select_idx) {}
>  #endif
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 15babf1..45586d2 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -90,6 +90,53 @@ static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
>  }
>  
>  /**
> + * kvm_pmu_enable_counter - enable selected PMU counter
> + * @vcpu: The vcpu pointer
> + * @val: the value guest writes to PMCNTENSET register
> + * @all_enable: the value of PMCR.E
> + *
> + * Call perf_event_enable to start counting the perf event
> + */
> +void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable)
> +{
> +	int i;
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc;
> +
> +	if (!all_enable)
> +		return;

You have the vcpu. Can you move the check for PMCR_EL0.E here instead of
having it in both of the callers?

> +
> +	for_each_set_bit(i, (const unsigned long *)&val, ARMV8_MAX_COUNTERS) {

Nonononono... If you must have to use a long, use a long. Don't cast it
to a different type (hint: big endian).

> +		pmc = &pmu->pmc[i];
> +		if (pmc->perf_event) {
> +			perf_event_enable(pmc->perf_event);
> +			if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> +				kvm_debug("fail to enable perf event\n");
> +		}
> +	}
> +}
> +
> +/**
> + * kvm_pmu_disable_counter - disable selected PMU counter
> + * @vcpu: The vcpu pointer
> + * @val: the value guest writes to PMCNTENCLR register
> + *
> + * Call perf_event_disable to stop counting the perf event
> + */
> +void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val)
> +{
> +	int i;
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc;
> +

Why are enable and disable asymmetric (handling of PMCR.E)?

> +	for_each_set_bit(i, (const unsigned long *)&val, ARMV8_MAX_COUNTERS) {
> +		pmc = &pmu->pmc[i];
> +		if (pmc->perf_event)
> +			perf_event_disable(pmc->perf_event);
> +	}
> +}
> +
> +/**
>   * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
>   * @vcpu: The vcpu pointer
>   * @data: The data guest writes to PMXEVTYPER_EL0
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
