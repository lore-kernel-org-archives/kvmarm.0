From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 12/15] KVM: arm: keep track of host use of the debug
 registers
Date: Wed, 2 Sep 2015 17:44:53 +0200
Message-ID: <20150902154453.GO10991@cbox>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
 <1439213167-8988-13-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1439213167-8988-13-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 10, 2015 at 09:26:04PM +0800, Zhichao Huang wrote:
> Every guest entry, we need to keep track of host use of the debug
> registers.
> 
> We only call the function upon guest entry, after preempt_disable()
> and local_irq_disable(), so there is no race for it.

what about on SMP?  It may be true because you're only accessing per cpu
data structures which are never accessed by any other CPUs than
yourself, but then this commit message should explain this :)

> 
> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> ---
>  arch/arm/include/asm/kvm_asm.h    | 3 +++
>  arch/arm/include/asm/kvm_host.h   | 4 ++++
>  arch/arm/kernel/asm-offsets.c     | 1 +
>  arch/arm/kvm/arm.c                | 2 ++
>  arch/arm/kvm/coproc.c             | 8 ++++++++
>  arch/arm64/include/asm/kvm_host.h | 1 +
>  6 files changed, 19 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
> index 7443a3a..5b1c3eb 100644
> --- a/arch/arm/include/asm/kvm_asm.h
> +++ b/arch/arm/include/asm/kvm_asm.h
> @@ -64,6 +64,9 @@
>  #define cp14_DBGDSCRext	65	/* Debug Status and Control external */
>  #define NR_CP14_REGS	66	/* Number of regs (incl. invalid) */
>  
> +#define KVM_ARM_DEBUG_HOST_INUSE_SHIFT	0
> +#define KVM_ARM_DEBUG_HOST_INUSE	(1 << KVM_ARM_DEBUG_HOST_INUSE_SHIFT)
> +
>  #define ARM_EXCEPTION_RESET	  0
>  #define ARM_EXCEPTION_UNDEFINED   1
>  #define ARM_EXCEPTION_SOFTWARE    2
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index fc461ac..7338f34 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -131,6 +131,9 @@ struct kvm_vcpu_arch {
>  	/* System control coprocessor (cp14) */
>  	u32 cp14[NR_CP14_REGS];
>  
> +	/* Debug State */
> +	u32 debug_flags;
> +
>  	/*
>  	 * Anything that is not used directly from assembly code goes
>  	 * here.
> @@ -237,5 +240,6 @@ static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> +void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>  
>  #endif /* __ARM_KVM_HOST_H__ */
> diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
> index cee4254..7750597 100644
> --- a/arch/arm/kernel/asm-offsets.c
> +++ b/arch/arm/kernel/asm-offsets.c
> @@ -178,6 +178,7 @@ int main(void)
>    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
>    DEFINE(VCPU_VFP_HOST,		offsetof(struct kvm_cpu_context, vfp));
>    DEFINE(VCPU_CP14_HOST,	offsetof(struct kvm_cpu_context, cp14));
> +  DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_flags));
>    DEFINE(VCPU_REGS,		offsetof(struct kvm_vcpu, arch.regs));
>    DEFINE(VCPU_USR_REGS,		offsetof(struct kvm_vcpu, arch.regs.usr_regs));
>    DEFINE(VCPU_SVC_REGS,		offsetof(struct kvm_vcpu, arch.regs.svc_regs));
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index bc738d2..0129346 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -550,6 +550,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  			continue;
>  		}
>  
> +		kvm_arm_setup_debug(vcpu);
> +

you need to rebase this series on kvmarm/next or mainline once the
KVM/ARM pull request with the v8 debug stuff is merged.

>  		/**************************************************************
>  		 * Enter the guest
>  		 */
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index d15b250..b37afd6 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -1516,3 +1516,11 @@ void kvm_reset_coprocs(struct kvm_vcpu *vcpu)
>  		if (vcpu->arch.cp15[num] == 0x42424242)
>  			panic("Didn't reset vcpu->arch.cp15[%zi]", num);
>  }
> +
> +void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> +{
> +	if (hw_breakpoint_enabled())
> +		vcpu->arch.debug_flags |= KVM_ARM_DEBUG_HOST_INUSE;
> +	else
> +		vcpu->arch.debug_flags &= ~KVM_ARM_DEBUG_HOST_INUSE;
> +}

This otherwise looks reasonable enough.


Thanks,
-Christoffer
