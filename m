From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 1/2] KVM: arm/arm64: Add save/restore support for
 firmware workaround state
Date: Fri, 22 Feb 2019 17:22:37 +0000
Message-ID: <20190222172236.GC3567@e103592.cambridge.arm.com>
References: <20190222121818.30164-1-andre.przywara@arm.com>
 <20190222121818.30164-2-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7277A4A2E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 12:22:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rP9FR1LP+Wjm for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 12:22:42 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40A6F4A200
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 12:22:42 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190222121818.30164-2-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 22, 2019 at 12:18:17PM +0000, Andre Przywara wrote:
> KVM implements the firmware interface for mitigating cache speculation
> vulnerabilities. Guests may use this interface to ensure mitigation is
> active.
> If we want to migrate such a guest to a host with a different support
> level for those workarounds, migration might need to fail, to ensure that
> critical guests don't loose their protection.
> 
> Introduce a way for userland to save and restore the workarounds state.
> On restoring we do checks that make sure we don't downgrade our
> mitigation level.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arch/arm/include/asm/kvm_emulate.h   |  10 +++
>  arch/arm/include/uapi/asm/kvm.h      |  10 +++
>  arch/arm64/include/asm/kvm_emulate.h |  14 ++++
>  arch/arm64/include/uapi/asm/kvm.h    |   9 ++
>  virt/kvm/arm/psci.c                  | 119 +++++++++++++++++++++++----
>  5 files changed, 146 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
> index 8927cae7c966..663a02d7e6f4 100644
> --- a/arch/arm/include/asm/kvm_emulate.h
> +++ b/arch/arm/include/asm/kvm_emulate.h
> @@ -283,6 +283,16 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
>  	return vcpu_cp15(vcpu, c0_MPIDR) & MPIDR_HWID_BITMASK;
>  }
>  
> +static inline bool kvm_arm_get_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
> +
> +static inline void kvm_arm_set_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu,
> +						      bool flag)
> +{
> +}
> +
>  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
>  {
>  	*vcpu_cpsr(vcpu) |= PSR_E_BIT;
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 4602464ebdfb..ba4d2afe65e3 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -214,6 +214,16 @@ struct kvm_vcpu_events {
>  #define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM | KVM_REG_SIZE_U64 | \
>  					 KVM_REG_ARM_FW | ((r) & 0xffff))
>  #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1	KVM_REG_ARM_FW_REG(1)
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL	0
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL	1
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_UNAFFECTED	2
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL	0
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN	1
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL	2
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED	3
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED	(1U << 4)

Why 4?  How could the system be less affected than "UNAFFECTED"?  (And
if not, why do we need space to insert extra values?)  Mixing read-only
system-description info with mutable guest state in this register feels
a bit odd, but we probably don't win much by making it a separate
register either.

Possibly we could drop the _REG from the #defines that are not reg IDs,
since KVM_REG_* are all reg IDs today.

But it works either way.


Without a clear definition of what these values mean, I worry about ABI
drift.  But if we don't expect these to evolve it's probably low-risk.

>  /* Device Control API: ARM VGIC */
>  #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index d3842791e1c4..c00c17c9adb6 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -348,6 +348,20 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
>  	return vcpu_read_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
>  }
>  
> +static inline bool kvm_arm_get_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.workaround_flags & VCPU_WORKAROUND_2_FLAG;
> +}
> +
> +static inline void kvm_arm_set_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu,
> +						      bool flag)
> +{
> +	if (flag)
> +		vcpu->arch.workaround_flags |= VCPU_WORKAROUND_2_FLAG;
> +	else
> +		vcpu->arch.workaround_flags &= ~VCPU_WORKAROUND_2_FLAG;
> +}
> +
>  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu_mode_is_32bit(vcpu)) {
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 97c3478ee6e7..367e96fe654e 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -225,6 +225,15 @@ struct kvm_vcpu_events {
>  #define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
>  					 KVM_REG_ARM_FW | ((r) & 0xffff))
>  #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1	KVM_REG_ARM_FW_REG(1)
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL	0
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL	1
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL	0
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN	1
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL	2
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED	3
> +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED     (1U << 4)
>  
>  /* Device Control API: ARM VGIC */
>  #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index 9b73d3ad918a..97d2d13756f6 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -445,42 +445,97 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  
>  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
>  {
> -	return 1;		/* PSCI version */
> +	return 3;		/* PSCI version and two workaround registers */

Meh.  But this is no worse than the way we do it elsewhere.

>  }
>  
>  int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  {
> -	if (put_user(KVM_REG_ARM_PSCI_VERSION, uindices))
> +	if (put_user(KVM_REG_ARM_PSCI_VERSION, uindices++))
>  		return -EFAULT;
>  
> +	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1, uindices++))
> +		return -EFAULT;
> +
> +	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2, uindices++))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +#define KVM_REG_FEATURE_LEVEL_WIDTH	4
> +#define KVM_REG_FEATURE_LEVEL_MASK	(BIT(KVM_REG_FEATURE_LEVEL_WIDTH) - 1)

Nit: Maybe use GENMASK?

> +
> +/*
> + * Convert the workaround level into an easy-to-compare number, where higher
> + * values mean better protection.
> + */
> +static int get_kernel_wa_level(u64 regid)
> +{
> +	switch (regid) {
> +	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> +		if (kvm_arm_harden_branch_predictor())
> +			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL;
> +		else
> +			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
> +	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> +		switch (kvm_arm_have_ssbd()) {
> +		case KVM_SSBD_FORCE_DISABLE:
> +			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> +		case KVM_SSBD_KERNEL:
> +			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL;
> +		case KVM_SSBD_FORCE_ENABLE:
> +		case KVM_SSBD_MITIGATED:
> +			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED;
> +		case KVM_SSBD_UNKNOWN:
> +		default:
> +			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
>  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
> -	if (reg->id == KVM_REG_ARM_PSCI_VERSION) {
> -		void __user *uaddr = (void __user *)(long)reg->addr;
> -		u64 val;
> +	void __user *uaddr = (void __user *)(long)reg->addr;

(Why (long), I wonder?  Anyway, no bother.)

> +	u64 val;
>  
> +	switch (reg->id) {
> +	case KVM_REG_ARM_PSCI_VERSION:
>  		val = kvm_psci_version(vcpu, vcpu->kvm);
> -		if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
> -			return -EFAULT;
> -
> -		return 0;
> +		break;
> +	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> +		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
> +		break;
> +	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> +		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
> +		if (kvm_arm_have_ssbd() == KVM_SSBD_KERNEL &&
> +		    kvm_arm_get_vcpu_workaround_2_flag(vcpu))
> +			val |= KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED;
> +		break;
> +	default:
> +		return -EINVAL;

Hmmm, it could be more reasonable to return -ENOENT.  But this precedent
may be established now.

Anyway, userspace is unlikely to make any useful distinction between
these two errors.

>  	}
>  
> -	return -EINVAL;

You could try a BUILD_BUG_ON(KVM_REG_SIZE(reg->id) == sizeof(val)).

I suspect gcc may not be quite bright enough to spot that condition is
compiletime-constant, but if it does then so much the better.

Not sure it's worth a runtime check though.

> +	if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
> +		return -EFAULT;
> +
> +	return 0;
>  }
>  
>  int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
> -	if (reg->id == KVM_REG_ARM_PSCI_VERSION) {
> -		void __user *uaddr = (void __user *)(long)reg->addr;
> -		bool wants_02;
> -		u64 val;
> +	void __user *uaddr = (void __user *)(long)reg->addr;
> +	u64 val;
> +	int wa_level;
> +
> +	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
> +		return -EFAULT;
>  
> -		if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
> -			return -EFAULT;
> +	switch (reg->id) {
> +	case KVM_REG_ARM_PSCI_VERSION:
> +	{
> +		bool wants_02;
>  
>  		wants_02 = test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features);
>  
> @@ -497,6 +552,38 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  			vcpu->kvm->arch.psci_version = val;
>  			return 0;
>  		}
> +		break;
> +	}
> +
> +	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> +		wa_level = val & KVM_REG_FEATURE_LEVEL_MASK;

Should we require the other bits to be zero?

Providing we never add anything else to this register we will get away
with it, but it would be cleaner to police the extra bits here and in
similar places.

> +
> +		/* For now we only accept the very same workaround level. */
> +		if (get_kernel_wa_level(reg->id) != wa_level)
> +			return -EINVAL;
> +
> +		return 0;
> +
> +	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> +		wa_level = val & KVM_REG_FEATURE_LEVEL_MASK;

Ditto...

> +
> +		if (get_kernel_wa_level(reg->id) < wa_level)
> +			return -EINVAL;

Is the SMCCC_ARCH_WORKAROUND_2 interface definitely always available to
the guest even when in the get_kernel_wa_level() == _UNAFFECTED case?

With wa_level == _AVAIL, the guest assumes that the interface is there.

(This may be fine; I'm just not so aware of the history.)

> +
> +		if (kvm_arm_have_ssbd() != KVM_SSBD_KERNEL)
> +			return 0;

(val & KVM_REG_FEATURE_LEVEL_MASK) could still be _NOT_AVAIL or _UNKNOWN
here, yet we still attempt to call kvm_arm_set_vcpu_workaround_2_flag()
based on the user's KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED bit.

Should we?  I'm not clear on what the sematics should be for this case.

> +
> +		switch (wa_level) {
> +		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL:
> +			kvm_arm_set_vcpu_workaround_2_flag(vcpu,
> +			    val & KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED);
> +			break;
> +		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED:
> +			kvm_arm_set_vcpu_workaround_2_flag(vcpu, true);
> +			break;
> +		}

This has the odd effect that userspace can bypass PSCI/SMCCC and twiddle
this bit directly via KVM_SET_ONE_REG.  I'm not sure this matters, and
it may even be useful.  A bit unexpected though.  Are there any pitfalls
here I've not thought of?

> +
> +		return 0;

The logic overall feels a bit fragile and arbitrary, though given what
it is describing, we may not be able to do a whole lot better.

Do we trust the user-supplied val more than we should?

[...]

Overall, the code looks reasonable; my comments are pretty much nits.

Cheers
---Dave
