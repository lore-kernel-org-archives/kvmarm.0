From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: PMU: fix overflow interrupt injection
Date: Tue, 4 Jul 2017 13:10:57 +0200
Message-ID: <20170704111057.GP4066@cbox>
References: <20170701162654.3430-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170701162654.3430-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

On Sat, Jul 01, 2017 at 06:26:54PM +0200, Andrew Jones wrote:
> kvm_pmu_overflow_set() is called from perf's interrupt handler,
> making the call of kvm_vgic_inject_irq() from it introduced with
> "KVM: arm/arm64: PMU: remove request-less vcpu kick" a really bad
> idea, as it's quite easy to try and retake a lock that the
> interrupted context is already holding. The fix is to use a vcpu
> kick, leaving the interrupt injection to kvm_pmu_sync_hwstate(),
> like it was doing before the refactoring. We don't just revert,
> though, because before the kick was request-less, leaving the vcpu
> exposed to the request-less vcpu kick race, and also because the
> kick was used unnecessarily from register access handlers.

I have some patches that makes it possible to inject virtual IRQs to the
vgic from interrupt context (my timer improvement series), but it's
probably better to merge this as a fix even though.

> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> ---
>  arch/arm64/kvm/sys_regs.c |  2 +-
>  include/kvm/arm_pmu.h     |  2 --
>  virt/kvm/arm/pmu.c        | 43 +++++++++++++++----------------------------
>  3 files changed, 16 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 77862881ae86..2e070d3baf9f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -764,7 +764,7 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	if (p->is_write) {
>  		if (r->CRm & 0x2)
>  			/* accessing PMOVSSET_EL0 */
> -			kvm_pmu_overflow_set(vcpu, p->regval & mask);
> +			vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= (p->regval & mask);
>  		else
>  			/* accessing PMOVSCLR_EL0 */
>  			vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~(p->regval & mask);
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index f6e030617467..f87fe20fcb05 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -48,7 +48,6 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
>  void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
> -void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
>  void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
>  bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu);
> @@ -86,7 +85,6 @@ static inline void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
> -static inline void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu) {}
>  static inline bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index fc8a723ff387..8a9c42366db7 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -203,11 +203,15 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
>  	return reg;
>  }
>  
> -static void kvm_pmu_check_overflow(struct kvm_vcpu *vcpu)
> +static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -	bool overflow = !!kvm_pmu_overflow_status(vcpu);
> +	bool overflow;
> +
> +	if (!kvm_arm_pmu_v3_ready(vcpu))
> +		return;
>  
> +	overflow = !!kvm_pmu_overflow_status(vcpu);
>  	if (pmu->irq_level == overflow)
>  		return;
>  
> @@ -215,33 +219,11 @@ static void kvm_pmu_check_overflow(struct kvm_vcpu *vcpu)
>  
>  	if (likely(irqchip_in_kernel(vcpu->kvm))) {
>  		int ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
> -					      pmu->irq_num, overflow,
> -					      &vcpu->arch.pmu);
> +					      pmu->irq_num, overflow, pmu);
>  		WARN_ON(ret);
>  	}
>  }
>  
> -/**
> - * kvm_pmu_overflow_set - set PMU overflow interrupt
> - * @vcpu: The vcpu pointer
> - * @val: the value guest writes to PMOVSSET register
> - */
> -void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val)
> -{
> -	if (val == 0)
> -		return;
> -
> -	vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= val;
> -	kvm_pmu_check_overflow(vcpu);
> -}
> -
> -static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
> -{
> -	if (!kvm_arm_pmu_v3_ready(vcpu))
> -		return;
> -	kvm_pmu_check_overflow(vcpu);
> -}
> -
>  bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> @@ -303,7 +285,7 @@ static inline struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
>  }
>  
>  /**
> - * When perf event overflows, call kvm_pmu_overflow_set to set overflow status.
> + * When the perf event overflows, set the overflow status and inform the vcpu.
>   */
>  static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
>  				  struct perf_sample_data *data,
> @@ -313,7 +295,12 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
>  	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
>  	int idx = pmc->idx;
>  
> -	kvm_pmu_overflow_set(vcpu, BIT(idx));
> +	vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
> +
> +	if (kvm_pmu_overflow_status(vcpu)) {
> +		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> +		kvm_vcpu_kick(vcpu);
> +	}
>  }
>  
>  /**
> @@ -341,7 +328,7 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
>  			reg = lower_32_bits(reg);
>  			vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
>  			if (!reg)
> -				kvm_pmu_overflow_set(vcpu, BIT(i));
> +				vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
>  		}
>  	}
>  }
> -- 
> 2.9.4
> 
