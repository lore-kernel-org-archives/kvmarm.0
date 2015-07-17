From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 15/18] KVM: ARM64: Add reset and access handlers for
 PMSWINC_EL0 register
Date: Fri, 17 Jul 2015 17:13:24 +0200
Message-ID: <20150717151324.GZ14024@cbox>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
 <1436149068-3784-16-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436149068-3784-16-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: shannon.zhao@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 06, 2015 at 10:17:45AM +0800, shannon.zhao@linaro.org wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add access handler which emulates writing and reading PMSWINC_EL0
> register and add support for creating software increment event.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 15 ++++++++++++++-
>  include/kvm/arm_pmu.h     |  2 ++
>  virt/kvm/arm/pmu.c        | 20 ++++++++++++++++++++
>  3 files changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index d5984d0..70afcba 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -535,6 +535,19 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +/* PMSWINC_EL0 accessor. */
> +static bool access_pmswinc(struct kvm_vcpu *vcpu,
> +			   const struct sys_reg_params *p,
> +			   const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		kvm_pmu_software_increment(vcpu, *vcpu_reg(vcpu, p->Rt));
> +	else
> +		return read_zero(vcpu, p);
> +
> +	return true;
> +}
> +
>  /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>  	/* DBGBVRn_EL1 */						\
> @@ -738,7 +751,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmovsclr, reset_unknown, PMOVSCLR_EL0 },
>  	/* PMSWINC_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b100),
> -	  trap_raz_wi },
> +	  access_pmswinc, reset_unknown, PMSWINC_EL0 },
>  	/* PMSELR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b101),
>  	  access_pmselr, reset_unknown, PMSELR_EL0 },
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 4f3d8a6..6985809 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -54,6 +54,7 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, unsigned long val);
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, unsigned long val);
>  void kvm_pmu_disable_interrupt(struct kvm_vcpu *vcpu, unsigned long val);
>  void kvm_pmu_enable_interrupt(struct kvm_vcpu *vcpu, unsigned long val);
> +void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, unsigned long val);
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
>  				    unsigned long select_idx);
>  void kvm_pmu_init(struct kvm_vcpu *vcpu);
> @@ -70,6 +71,7 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, unsigned long val) {}
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, unsigned long val) {}
>  void kvm_pmu_disable_interrupt(struct kvm_vcpu *vcpu, unsigned long val) {}
>  void kvm_pmu_enable_interrupt(struct kvm_vcpu *vcpu, unsigned long val) {}
> +void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, unsigned long val) {}
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
>  				    unsigned long select_idx) {}
>  static inline void kvm_pmu_init(struct kvm_vcpu *vcpu) {}
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 7023ad5..e655426 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -203,6 +203,22 @@ void kvm_pmu_disable_interrupt(struct kvm_vcpu *vcpu, unsigned long val)
>  }
>  
>  /**
> + * kvm_pmu_software_increment - do software increment
> + * @vcpu: The vcpu pointer
> + * @val: the value guest writes to PMSWINC_EL0 register
> + */
> +void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, unsigned long val)
> +{
> +	int select_idx = find_first_bit(&val, 31);

can you not also increment multiple counters with a single write here?

or is it an error to configure multiple counters to the same event?  And
if it is, do we enforce that somehow?  If not, should they not reflect
the same underlying value instead of a separate pmc->counter value?


> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +
> +	if (pmu->user_enable & 0x3)

shouldn't this be:
	if (vcpu_mode_priv(vcpu) || pmu->user_enable & 0x3 == 0x3)

?


> +		if ((pmc->eventsel == 0) && (pmc->enable == true))
> +			pmc->counter++;

how do we migrate this state?  do we care?

-Christoffer

> +}
> +
> +/**
>   * kvm_pmu_find_hw_event - find hardware event
>   * @pmu: The pmu pointer
>   * @event_select: The number of selected event type
> @@ -280,6 +296,10 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
>  	kvm_pmu_stop_counter(vcpu, select_idx);
>  	pmc->eventsel = data & ARMV8_EVTYPE_EVENT;
>  
> +	/* For software increment event we don't need to create perf event */
> +	if (pmc->eventsel == 0)
> +		return;
> +
>  	config = kvm_pmu_find_hw_event(pmu, pmc->eventsel);
>  	if (config != PERF_COUNT_HW_MAX) {
>  		type = PERF_TYPE_HARDWARE;
> -- 
> 2.1.0
> 
