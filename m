From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC PATCH 16/16] KVM: arm64/sve: Report and enable SVE API
 extensions for userspace
Date: Thu, 19 Jul 2018 16:59:21 +0200
Message-ID: <20180719145921.oasa3a57at5nnwya@kamzik.brq.redhat.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-17-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89F7C40196
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 10:46:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LIVDdN8HtXYy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 10:46:18 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F91F40192
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 10:46:18 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1529593060-542-17-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 21, 2018 at 03:57:40PM +0100, Dave Martin wrote:
> This patch reports the availability of KVM SVE support to userspace
> via a new vcpu feature flag KVM_ARM_VCPU_SVE.  This flag is
> reported via the KVM_ARM_PREFERRED_TARGET ioctl.
> 
> Userspace can enable the feature by setting the flag for
> KVM_ARM_VCPU_INIT.  Without this flag set, SVE-related ioctls and
> register access extensions are hidden, and SVE remains disabled
> unconditionally for the guest.  This ensures that non-SVE-aware KVM
> userspace does not receive a vcpu that it does not understand how
> to snapshot or restore correctly.
> 
> Storage is allocated for the SVE register state at vcpu init time,
> sufficient for the maximum vector length to be exposed to the vcpu.
> No attempt is made to allocate the storage lazily for now.  Also,
> no attempt is made to resize the storage dynamically, since the
> effective vector length of the vcpu can change at each EL0/EL1
> transition.  The storage is freed at the vcpu uninit hook.
> 
> No particular attempt is made to prevent userspace from creating a
> mix of vcpus some of which have SVE enabled and some of which have
> it disabled.  This may or may not be useful, but it reflects the
> underlying architectural behaviour.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  6 +++---
>  arch/arm64/include/uapi/asm/kvm.h |  1 +
>  arch/arm64/kvm/guest.c            | 19 +++++++++++++------
>  arch/arm64/kvm/reset.c            | 14 ++++++++++++++
>  4 files changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d2084ae..d956cf2 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -44,7 +44,7 @@
>  
>  #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>  
> -#define KVM_VCPU_MAX_FEATURES 4
> +#define KVM_VCPU_MAX_FEATURES 5
>  
>  #define KVM_REQ_SLEEP \
>  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> @@ -439,8 +439,8 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>  
> -static inline int kvm_arm_arch_vcpu_init(struct kvm_vcpu *vcpu) { return 0; }
> -static inline void kvm_arm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
> +int kvm_arm_arch_vcpu_init(struct kvm_vcpu *vcpu);
> +void kvm_arm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
>  
>  void kvm_arm_init_debug(void);
>  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index f54a9b0..6acf276 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -101,6 +101,7 @@ struct kvm_regs {
>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
>  #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
>  #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
> +#define KVM_ARM_VCPU_SVE		4 /* Allow SVE for guest */
>  
>  struct kvm_vcpu_init {
>  	__u32 target;
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 5152362..fb7f6aa 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -58,6 +58,16 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +int kvm_arm_arch_vcpu_init(struct kvm_vcpu *vcpu)
> +{
> +	return 0;
> +}

Unused, so could have just left the inline version.

> +
> +void kvm_arm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
> +{
> +	kfree(vcpu->arch.sve_state);
> +}
> +
>  static u64 core_reg_offset_from_id(u64 id)
>  {
>  	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
> @@ -600,12 +610,9 @@ int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
>  
>  	memset(init, 0, sizeof(*init));
>  
> -	/*
> -	 * For now, we don't return any features.
> -	 * In future, we might use features to return target
> -	 * specific features available for the preferred
> -	 * target type.
> -	 */
> +	/* KVM_ARM_VCPU_SVE understood by KVM_VCPU_INIT */
> +	init->features[0] = 1 << KVM_ARM_VCPU_SVE;
> +

We shouldn't need to do this. The "preferred" target type isn't defined
well (that I know of), but IMO it should probably be the target that
best matches the host, minus optional features. The best base target. We
may use these features to convey that the preferred target should enable
some optional feature if that feature is necessary to workaround a bug,
i.e. using the "feature" bit as an erratum bit someday, but that'd be
quite a debatable use, so maybe not even that. Most likely we'll never
need to add features here.

That said, I think defining the feature bit makes sense. ATM, I'm feeling
like we'll want to model the user interface for SVE like PMU (using VCPU
device ioctls).


>  	init->target = (__u32)target;
>  
>  	return 0;
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index a74311b..f63a791 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -110,6 +110,20 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  			cpu_reset = &default_regs_reset;
>  		}
>  
> +		if (system_supports_sve() &&
> +		    test_bit(KVM_ARM_VCPU_SVE, vcpu->arch.features)) {
> +			vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_SVE;
> +
> +			vcpu->arch.sve_max_vl = sve_max_virtualisable_vl;
> +
> +			vcpu->arch.sve_state = kzalloc(
> +				SVE_SIG_REGS_SIZE(
> +					sve_vq_from_vl(vcpu->arch.sve_max_vl)),

I guess sve_state can be pretty large. Should we allocate it like we
do the VM with kvm_arch_alloc_vm()? I.e. using vzalloc() on VHE machines?

> +				GFP_KERNEL);
> +			if (!vcpu->arch.sve_state)
> +				return -ENOMEM;
> +		}
> +
>  		break;
>  	}
>  
> -- 
> 2.1.4

Thanks,
drew
