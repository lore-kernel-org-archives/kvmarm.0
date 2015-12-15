From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 13/19] KVM: ARM64: Add access handler for PMSWINC
 register
Date: Tue, 15 Dec 2015 14:36:11 +0000
Message-ID: <5670255B.9030900@arm.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
 <1450169379-12336-14-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA24E411F6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 09:34:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WMgneZ7mdLzQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Dec 2015 09:33:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D944849680
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 09:33:58 -0500 (EST)
In-Reply-To: <1450169379-12336-14-git-send-email-zhaoshenglong@huawei.com>
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
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/12/15 08:49, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add access handler which emulates writing and reading PMSWINC
> register and add support for creating software increment event.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 14 +++++++++++++-
>  include/kvm/arm_pmu.h     |  2 ++
>  virt/kvm/arm/pmu.c        | 32 ++++++++++++++++++++++++++++++++
>  3 files changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index d1926c4..f09e500 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -690,6 +690,17 @@ static bool access_pmovsset(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	return true;
>  }
>  
> +static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			   const struct sys_reg_desc *r)
> +{
> +	if (p->is_write) {
> +		kvm_pmu_software_increment(vcpu, p->regval);

Shouldn't you filter this with valid counter mask?

> +		return true;
> +	} else {
> +		return read_zero(vcpu, p);

Mark just mentioned to me that reading from this register is UNDEFINED.
Which means you should generate an exception into the guest by calling
kvm_inject_undefined() for that vcpu.

> +	}
> +}
> +
>  /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>  	/* DBGBVRn_EL1 */						\
> @@ -900,7 +911,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmovsset, NULL, PMOVSSET_EL0 },
>  	/* PMSWINC_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b100),
> -	  trap_raz_wi },
> +	  access_pmswinc, reset_unknown, PMSWINC_EL0 },
>  	/* PMSELR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b101),
>  	  access_pmselr, reset_unknown, PMSELR_EL0 },
> @@ -1239,6 +1250,7 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), access_pmcntenset },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmcntenset },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmovsset },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 4), access_pmswinc },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 93aea6a..f5888eb 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -39,6 +39,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
> +void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  				    u64 select_idx);
>  #else
> @@ -52,6 +53,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>  void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
> +void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  				    u64 select_idx) {}
>  #endif
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 861471d..01af727 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -150,6 +150,34 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val)
>  }
>  
>  /**
> + * kvm_pmu_software_increment - do software increment
> + * @vcpu: The vcpu pointer
> + * @val: the value guest writes to PMSWINC register
> + */
> +void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	int i;
> +	u64 type, enable, reg;
> +
> +	if (val == 0)
> +		return;
> +
> +	for (i = 0; i < ARMV8_CYCLE_IDX; i++) {
> +		if (!((val >> i) & 0x1))

Same comment as for the other patches.

> +			continue;
> +		type = vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i)
> +		       & ARMV8_EVTYPE_EVENT;
> +		enable = vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
> +		if ((type == 0) && ((enable >> i) & 0x1)) {
> +			vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i)++;
> +			reg = vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
> +			if ((reg & 0xFFFFFFFF) == 0)
> +				kvm_pmu_overflow_set(vcpu, BIT(i));

The increment handling is not very nice, as you end-up with stuff in the
upper 32bit... How about:

	reg = vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
	reg = lower_32bit(reg);
	vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
	if (!reg)
		kvm_pmu_overflow_set(vcpu, BIT(i));

> +		}
> +	}
> +}
> +
> +/**
>   * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
>   * @vcpu: The vcpu pointer
>   * @data: The data guest writes to PMXEVTYPER_EL0
> @@ -171,6 +199,10 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  	kvm_pmu_stop_counter(vcpu, pmc);
>  	eventsel = data & ARMV8_EVTYPE_EVENT;
>  
> +	/* For software increment event it does't need to create perf event */
> +	if (eventsel == 0)
> +		return;
> +
>  	memset(&attr, 0, sizeof(struct perf_event_attr));
>  	attr.type = PERF_TYPE_RAW;
>  	attr.size = sizeof(attr);
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
