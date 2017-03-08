From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 5/5] KVM: arm/arm64: allow userspace to set MPIDR
Date: Wed, 8 Mar 2017 05:19:07 -0800
Message-ID: <20170308131907.GA109908@lvm>
References: <20170227175504.15751-1-drjones@redhat.com>
 <20170227175504.15751-6-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B922440064
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Mar 2017 08:17:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rhTRX2gF7Cv9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Mar 2017 08:17:47 -0500 (EST)
Received: from mail-wr0-f180.google.com (mail-wr0-f180.google.com
 [209.85.128.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60E4540019
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Mar 2017 08:17:47 -0500 (EST)
Received: by mail-wr0-f180.google.com with SMTP id g10so23122187wrg.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Mar 2017 05:19:10 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170227175504.15751-6-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, ashoks@broadcom.com, imammedo@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 27, 2017 at 06:55:04PM +0100, Andrew Jones wrote:
> QEMU would already prefer having control over the vcpu MPIDRs
> in order to correctly map vcpus to virtual numa nodes without
> having to first instantiate the vcpus. Also, when virtual cpu
> topologies are eventually describable, QEMU may need to adjust
> the MPIDR to reflect that topology. Finally, we need to cache
> the MPIDR in the vcpu structure to fix potential races that can
> arise between vcpu reset and the extraction of the MPIDR from
> the sys-reg array. So, while we're tinkering with MPIDR to
> provide it a cache, then we might as well extend its capabilities
> to allowing user setting too.
> 
> Cc: Ashok Kumar <ashoks@broadcom.com>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm/include/asm/kvm_emulate.h   |  2 +-
>  arch/arm/include/asm/kvm_host.h      |  3 ++
>  arch/arm/kvm/arm.c                   |  1 +
>  arch/arm/kvm/coproc.c                | 61 +++++++++++++++++++++++++++++-----
>  arch/arm/kvm/coproc.h                |  6 ++++
>  arch/arm64/include/asm/kvm_emulate.h |  2 +-
>  arch/arm64/include/asm/kvm_host.h    |  3 ++
>  arch/arm64/kvm/sys_regs.c            | 64 ++++++++++++++++++++++++++++--------
>  include/uapi/linux/kvm.h             |  1 +
>  9 files changed, 119 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
> index 9a8a45aaf19a..1b922de46785 100644
> --- a/arch/arm/include/asm/kvm_emulate.h
> +++ b/arch/arm/include/asm/kvm_emulate.h
> @@ -213,7 +213,7 @@ static inline u32 kvm_vcpu_hvc_get_imm(struct kvm_vcpu *vcpu)
>  
>  static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
>  {
> -	return vcpu_cp15(vcpu, c0_MPIDR) & MPIDR_HWID_BITMASK;
> +	return vcpu->arch.vmpidr & MPIDR_HWID_BITMASK;
>  }
>  
>  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 73f61773e9c2..6427cac77204 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -151,6 +151,9 @@ struct kvm_vcpu_arch {
>  	/* The CPU type we expose to the VM */
>  	u32 midr;
>  
> +	/* vcpu MPIDR */
> +	u32 vmpidr;
> +
>  	/* HYP trapping configuration */
>  	u32 hcr;
>  
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index aa68354a0bf8..899528b884d9 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -207,6 +207,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_READONLY_MEM:
>  	case KVM_CAP_MP_STATE:
>  	case KVM_CAP_IMMEDIATE_EXIT:
> +	case KVM_CAP_ARM_USER_MPIDR:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index 3e5e4194ef86..30d35dd407a6 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -99,16 +99,55 @@ int kvm_handle_cp14_access(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	return 1;
>  }
>  
> -static void reset_mpidr(struct kvm_vcpu *vcpu, const struct coproc_reg *r)
> +static int set_mpidr(struct kvm_vcpu *vcpu, const struct coproc_reg *rd,
> +		     const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> +	struct kvm_vcpu *v;
> +	__u32 mpidr;
> +	int i;
> +
> +	if (copy_from_user(&mpidr, uaddr, KVM_REG_SIZE(reg->id)))
> +		return -EFAULT;
> +
>  	/*
> -	 * Compute guest MPIDR. We build a virtual cluster out of the
> -	 * vcpu_id, but we read the 'U' bit from the underlying
> -	 * hardware directly.
> +	 * All ARMv7 processors that support KVM include the
> +	 * Multiprocessing Extensions. Furthermore, without at
> +	 * least one bit set in the MPIDR we won't be able to
> +	 * distinguish a user set MPIDR from an unset MPIDR in
> +	 * reset_mpidr. Thus we force bit 31 on.
>  	 */
> -	vcpu_cp15(vcpu, c0_MPIDR) = ((read_cpuid_mpidr() & MPIDR_SMP_BITMASK) |
> -				     ((vcpu->vcpu_id >> 2) << MPIDR_LEVEL_BITS) |
> -				     (vcpu->vcpu_id & 3));
> +	mpidr |= (1UL << 31);
> +
> +	/* Ensure flag consistency and ID uniqueness */
> +	kvm_for_each_vcpu(i, v, vcpu->kvm) {
> +		if (v == vcpu)
> +			continue;
> +		if (((v->arch.vmpidr | mpidr) & MPIDR_SMP_BITMASK) != MPIDR_SMP_VALUE
> +		    || ((mpidr & MPIDR_MT_BITMASK) && !(v->arch.vmpidr & MPIDR_MT_BITMASK))
> +		    || v->arch.vmpidr == mpidr)
> +			return -EINVAL;
> +	}
> +
> +	vcpu->arch.vmpidr = mpidr;
> +	vcpu_cp15(vcpu, c0_MPIDR) = mpidr;

Isn't this all super racy?  What prevents two VCPUs from getting the
same MPIDR at the same time?

How do you support initializing the MPIDRs with a default value
(existing ABI that we must maintain), but then making vcpu 1 have the
mpidr of vcpu 0 and vice versa?

I think you also need to make sure that you can only modify the MPIDR
before actually running the VCPU.

You can take a look at kvm_vgic_create at how we check has_run_once for
inspiration.

Thanks,
-Christoffer

> +
> +	return 0;
> +}
> +
> +static void reset_mpidr(struct kvm_vcpu *vcpu, const struct coproc_reg *r)
> +{
> +	if (!vcpu->arch.vmpidr) {
> +		/*
> +		 * Compute guest MPIDR. We build a virtual cluster out of the
> +		 * vcpu_id, but we read the 'U' bit from the underlying
> +		 * hardware directly.
> +		 */
> +		u32 mpidr = ((read_cpuid_mpidr() & MPIDR_SMP_BITMASK) |
> +			     ((vcpu->vcpu_id >> 2) << MPIDR_LEVEL_BITS) |
> +			     (vcpu->vcpu_id & 3));
> +		vcpu->arch.vmpidr = mpidr;
> +	}
> +	vcpu_cp15(vcpu, c0_MPIDR) = vcpu->arch.vmpidr;
>  }
>  
>  /* TRM entries A7:4.3.31 A15:4.3.28 - RO WI */
> @@ -300,7 +339,7 @@ static bool pm_fake(struct kvm_vcpu *vcpu,
>  static const struct coproc_reg cp15_regs[] = {
>  	/* MPIDR: we use VMPIDR for guest access. */
>  	{ CRn( 0), CRm( 0), Op1( 0), Op2( 5), is32,
> -			NULL, reset_mpidr, c0_MPIDR },
> +			NULL, reset_mpidr, c0_MPIDR, 0, NULL, set_mpidr },
>  
>  	/* CSSELR: swapped by interrupt.S. */
>  	{ CRn( 0), CRm( 0), Op1( 2), Op2( 0), is32,
> @@ -1072,6 +1111,9 @@ int kvm_arm_coproc_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	if (!r)
>  		return get_invariant_cp15(reg->id, uaddr);
>  
> +	if (r->get_user)
> +		return (r->get_user)(vcpu, r, reg, uaddr);
> +
>  	ret = -ENOENT;
>  	if (KVM_REG_SIZE(reg->id) == 8) {
>  		u64 val;
> @@ -1101,6 +1143,9 @@ int kvm_arm_coproc_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	if (!r)
>  		return set_invariant_cp15(reg->id, uaddr);
>  
> +	if (r->set_user)
> +		return (r->set_user)(vcpu, r, reg, uaddr);
> +
>  	ret = -ENOENT;
>  	if (KVM_REG_SIZE(reg->id) == 8) {
>  		u64 val;
> diff --git a/arch/arm/kvm/coproc.h b/arch/arm/kvm/coproc.h
> index eef1759c2b65..7107f19cac5e 100644
> --- a/arch/arm/kvm/coproc.h
> +++ b/arch/arm/kvm/coproc.h
> @@ -52,6 +52,12 @@ struct coproc_reg {
>  
>  	/* Value (usually reset value) */
>  	u64 val;
> +
> +	/* Custom get/set_user functions, fallback to generic if NULL */
> +	int (*get_user)(struct kvm_vcpu *vcpu, const struct coproc_reg *rd,
> +			const struct kvm_one_reg *reg, void __user *uaddr);
> +	int (*set_user)(struct kvm_vcpu *vcpu, const struct coproc_reg *rd,
> +			const struct kvm_one_reg *reg, void __user *uaddr);
>  };
>  
>  static inline void print_cp_instr(const struct coproc_params *p)
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index f5ea0ba70f07..c138bb15b507 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -242,7 +242,7 @@ static inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vcpu)
>  
>  static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
>  {
> -	return vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
> +	return vcpu->arch.vmpidr_el2 & MPIDR_HWID_BITMASK;
>  }
>  
>  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d1e4b5d962eb..31aed40a3724 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -198,6 +198,9 @@ typedef struct kvm_cpu_context kvm_cpu_context_t;
>  struct kvm_vcpu_arch {
>  	struct kvm_cpu_context ctxt;
>  
> +	/* vcpu MPIDR */
> +	u64 vmpidr_el2;
> +
>  	/* HYP configuration */
>  	u64 hcr_el2;
>  	u32 mdcr_el2;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0e26f8c2b56f..2b558ac034ce 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -429,21 +429,57 @@ static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	vcpu_sys_reg(vcpu, AMAIR_EL1) = read_sysreg(amair_el1);
>  }
>  
> -static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +static int set_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		     const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -	u64 mpidr;
> +	struct kvm_vcpu *v;
> +	__u64 mpidr;
> +	int i;
>  
> -	/*
> -	 * Map the vcpu_id into the first three affinity level fields of
> -	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
> -	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
> -	 * of the GICv3 to be able to address each CPU directly when
> -	 * sending IPIs.
> -	 */
> -	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
> -	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
> -	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
> -	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
> +	if (copy_from_user(&mpidr, uaddr, KVM_REG_SIZE(reg->id)))
> +		return -EFAULT;
> +
> +	/* Ensure RES1 bits are set */
> +	mpidr |= (1ULL << 31);
> +
> +	/* Ensure no RES0 bits are set */
> +	if ((mpidr & (GENMASK_ULL(63, 40) | GENMASK(29, 25))) ||
> +	    (vcpu_mode_is_32bit(vcpu) && (mpidr & GENMASK_ULL(39, 32))))
> +		return -EINVAL;
> +
> +	/* Ensure flag consistency and ID uniqueness */
> +	kvm_for_each_vcpu(i, v, vcpu->kvm) {
> +		if (v == vcpu)
> +			continue;
> +		if (((v->arch.vmpidr_el2 | mpidr) & MPIDR_UP_BITMASK)
> +		    || ((mpidr & MPIDR_MT_BITMASK) && !(v->arch.vmpidr_el2 & MPIDR_MT_BITMASK))
> +		    || v->arch.vmpidr_el2 == mpidr)
> +			return -EINVAL;
> +	}
> +
> +	vcpu->arch.vmpidr_el2 = mpidr;
> +	vcpu_sys_reg(vcpu, MPIDR_EL1) = mpidr;
> +
> +	return 0;
> +}
> +
> +static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	if (!vcpu->arch.vmpidr_el2) {
> +		/*
> +		 * Userspace didn't provide us an MPIDR, so we construct one
> +		 * from the vcpu_id by mapping it into the first three affinity
> +		 * levels. We limit the number of VCPUs in level 0 due to a
> +		 * limitation of 16 CPUs in that level in the ICC_SGIxR
> +		 * registers of the GICv3, which are used to address each CPU
> +		 * directly when sending IPIs.
> +		 */
> +		u64 mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
> +		mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
> +		mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
> +		vcpu->arch.vmpidr_el2 = (1ULL << 31) | mpidr;
> +	}
> +	vcpu_sys_reg(vcpu, MPIDR_EL1) = vcpu->arch.vmpidr_el2;
>  }
>  
>  static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> @@ -961,7 +997,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  
>  	/* MPIDR_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b101),
> -	  NULL, reset_mpidr, MPIDR_EL1 },
> +	  NULL, reset_mpidr, MPIDR_EL1, 0, NULL, set_mpidr },
>  	/* SCTLR_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b000),
>  	  access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f51d5082a377..c20b58fe84cd 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -883,6 +883,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_MMU_RADIX 134
>  #define KVM_CAP_PPC_MMU_HASH_V3 135
>  #define KVM_CAP_IMMEDIATE_EXIT 136
> +#define KVM_CAP_ARM_USER_MPIDR 137
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.9.3
> 
