From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v1 15/16] kvm: arm64: Allow configuring physical address
 space size
Date: Thu, 8 Feb 2018 12:14:14 +0100
Message-ID: <20180208111414.GM29286@cbox>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-16-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180109190414.4017-16-suzuki.poulose@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 09, 2018 at 07:04:10PM +0000, Suzuki K Poulose wrote:
> Allow the guests to choose a larger physical address space size.
> The default and minimum size is 40bits. A guest can change this
> right after the VM creation, but before the stage2 entry page
> tables are allocated (i.e, before it registers a memory range
> or maps a device address). The size is restricted to the maximum
> supported by the host. Also, the guest can only increase the PA size,
> from the existing value, as reducing it could break the devices which
> may have verified their physical address for validity and may do a
> lazy mapping(e.g, VGIC).
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@linaro.org>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  Documentation/virtual/kvm/api.txt | 27 ++++++++++++++++++++++++++
>  arch/arm/include/asm/kvm_host.h   |  7 +++++++
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/include/asm/kvm_mmu.h  | 41 ++++++++++++++++++++++++++++++---------
>  arch/arm64/kvm/reset.c            | 28 ++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h          |  4 ++++
>  virt/kvm/arm/arm.c                |  2 +-
>  7 files changed, 100 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 57d3ee9e4bde..a203faf768c4 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -3403,6 +3403,33 @@ invalid, if invalid pages are written to (e.g. after the end of memory)
>  or if no page table is present for the addresses (e.g. when using
>  hugepages).
>  
> +4.109 KVM_ARM_GET_PHYS_SHIFT
> +
> +Capability: KVM_CAP_ARM_CONFIG_PHYS_SHIFT
> +Architectures: arm64
> +Type: vm ioctl
> +Parameters: __u32 (out)
> +Returns: 0 on success, a negative value on error
> +
> +This ioctl is used to get the current maximum physical address size for
> +the VM. The value is Log2(Maximum_Physical_Address). This is neither the
> + amount of physical memory assigned to the VM nor the maximum physical address
> +that a real CPU on the host can handle. Rather, this is the upper limit of the
> +guest physical address that can be used by the VM.

What is the point of this?  Presumably if userspace has set the size, it
already knows the size?

> +
> +4.109 KVM_ARM_SET_PHYS_SHIFT
> +
> +Capability: KVM_CAP_ARM_CONFIG_PHYS_SHIFT
> +Architectures: arm64
> +Type: vm ioctl
> +Parameters: __u32 (in)
> +Returns: 0 on success, a negative value on error
> +
> +This ioctl is used to set the maximum physical address size for
> +the VM. The value is Log2(Maximum_Physical_Address). The value can only
> +be increased from the existing setting. The value cannot be changed
> +after the stage-2 page tables are allocated and will return an error.
> +

Is there a way for userspace to discover what the underlying hardware
can actually support, beyond trial-and-error on this ioctl?

>  5. The kvm_run structure
>  ------------------------
>  
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index a9f7d3f47134..fa8e68a4f692 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -268,6 +268,13 @@ static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>  	return 0;
>  }
>  
> +static inline long kvm_arch_dev_vm_ioctl(struct kvm *kvm,
> +					 unsigned int ioctl,
> +					 unsigned long arg)
> +{
> +	return -EINVAL;
> +}
> +
>  int kvm_perf_init(void);
>  int kvm_perf_teardown(void);
>  
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1e66e5ab3dde..2895c2cda8fc 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -50,6 +50,7 @@
>  int __attribute_const__ kvm_target_cpu(void);
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>  int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext);
> +long kvm_arch_dev_vm_ioctl(struct kvm *kvm, unsigned int ioctl, unsigned long arg);
>  void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
>  
>  struct kvm_arch {
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index ab6a8b905065..ab7f50f20bcd 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -347,21 +347,44 @@ static inline u64 kvm_vttbr_baddr_mask(struct kvm *kvm)
>  	return GENMASK_ULL(PHYS_MASK_SHIFT - 1, x);
>  }
>  
> +static inline int kvm_reconfig_stage2(struct kvm *kvm, u32 phys_shift)
> +{
> +	int rc = 0;
> +	unsigned int pa_max, parange;
> +
> +	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 7;
> +	pa_max = id_aa64mmfr0_parange_to_phys_shift(parange);
> +	/* Raise it to 40bits for backward compatibility */
> +	pa_max = (pa_max < 40) ? 40 : pa_max;
> +	/* Make sure the size is supported/available */
> +	if (phys_shift > PHYS_MASK_SHIFT || phys_shift > pa_max)
> +		return -EINVAL;
> +	/*
> +	 * The stage2 PGD is dependent on the settings we initialise here
> +	 * and should be allocated only after this step. We cannot allow
> +	 * down sizing the IPA size as there could be devices or memory
> +	 * regions, that depend on the previous size.
> +	 */
> +	mutex_lock(&kvm->slots_lock);
> +	if (kvm->arch.pgd || phys_shift < kvm->arch.phys_shift) {
> +		rc = -EPERM;
> +	} else if (phys_shift > kvm->arch.phys_shift) {
> +		kvm->arch.phys_shift = phys_shift;
> +		kvm->arch.s2_levels = stage2_pt_levels(kvm->arch.phys_shift);
> +		kvm->arch.vtcr_private = VTCR_EL2_SL0(kvm->arch.s2_levels) |
> +					 TCR_T0SZ(kvm->arch.phys_shift);
> +	}

I think you can rework the above to make it more obvious what's going on
in this way:

	rc = -EPERM;
	if (kvm->arch.pgd || phys_shift < kvm->arch.phys_shift)
		goto out_unlock;

	rc = 0;
	if (phys_shift == kvm->arch.phys_shift)
		goto out_unlock;

	kvm->arch.phys_shift = phys_shift;
	kvm->arch.s2_levels = stage2_pt_levels(kvm->arch.phys_shift);
	kvm->arch.vtcr_private = VTCR_EL2_SL0(kvm->arch.s2_levels) |
				 TCR_T0SZ(kvm->arch.phys_shift);

out_unlock:

> +	mutex_unlock(&kvm->slots_lock);
> +	return rc;
> +}
> +
>  /*
>   * kvm_init_stage2_config: Initialise the VM specific stage2 page table
>   * details to default IPA size.
>   */
>  static inline void kvm_init_stage2_config(struct kvm *kvm)
>  {
> -	/*
> -	 * The stage2 PGD is dependent on the settings we initialise here
> -	 * and should be allocated only after this step.
> -	 */
> -	VM_BUG_ON(kvm->arch.pgd != NULL);
> -	kvm->arch.phys_shift = KVM_PHYS_SHIFT_DEFAULT;
> -	kvm->arch.s2_levels = stage2_pt_levels(kvm->arch.phys_shift);
> -	kvm->arch.vtcr_private = VTCR_EL2_SL0(kvm->arch.s2_levels) |
> -				 TCR_T0SZ(kvm->arch.phys_shift);
> +	kvm_reconfig_stage2(kvm, KVM_PHYS_SHIFT_DEFAULT);
>  }
>  
>  #endif /* __ASSEMBLY__ */
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 3256b9228e75..90ceca823aca 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -23,6 +23,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/kvm.h>
>  #include <linux/hw_breakpoint.h>
> +#include <linux/uaccess.h>
>  
>  #include <kvm/arm_arch_timer.h>
>  
> @@ -81,6 +82,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_VCPU_ATTRIBUTES:
>  		r = 1;
>  		break;
> +	case KVM_CAP_ARM_CONFIG_PHYS_SHIFT:
> +		r = 1;
> +		break;
>  	default:
>  		r = 0;
>  	}
> @@ -88,6 +92,30 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>  	return r;
>  }
>  
> +long kvm_arch_dev_vm_ioctl(struct kvm *kvm,
> +			  unsigned int ioctl, unsigned long arg)
> +{
> +	void __user *argp = (void __user *)arg;
> +	u32 phys_shift;
> +	long r = -EFAULT;
> +
> +	switch (ioctl) {
> +	case KVM_ARM_GET_PHYS_SHIFT:
> +		phys_shift = kvm_phys_shift(kvm);
> +		if (!put_user(phys_shift, (u32 __user *)argp))
> +			r = 0;
> +		break;
> +        case KVM_ARM_SET_PHYS_SHIFT:
> +		if (!get_user(phys_shift, (u32 __user*)argp))
> +			r = kvm_reconfig_stage2(kvm, phys_shift);
> +		break;
> +	default:
> +		r = -EINVAL;
> +	}
> +	return r;
> +}
> +
> +
>  /**
>   * kvm_reset_vcpu - sets core registers and sys_regs to reset value
>   * @vcpu: The VCPU pointer
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 496e59a2738b..66bfbe19b434 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -932,6 +932,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_HYPERV_SYNIC2 148
>  #define KVM_CAP_HYPERV_VP_INDEX 149
>  #define KVM_CAP_S390_AIS_MIGRATION 150
> +#define KVM_CAP_ARM_CONFIG_PHYS_SHIFT 151
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -1261,6 +1262,9 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_PPC_CONFIGURE_V3_MMU  _IOW(KVMIO,  0xaf, struct kvm_ppc_mmuv3_cfg)
>  /* Available with KVM_CAP_PPC_RADIX_MMU */
>  #define KVM_PPC_GET_RMMU_INFO	  _IOW(KVMIO,  0xb0, struct kvm_ppc_rmmu_info)
> +/* Available with KVM_CAP_ARM_CONFIG_PHYS_SHIFT */
> +#define KVM_ARM_GET_PHYS_SHIFT	  _IOR(KVMIO, 0xb1, __u32)
> +#define KVM_ARM_SET_PHYS_SHIFT	  _IOW(KVMIO, 0xb2, __u32)
>  
>  /* ioctl for vm fd */
>  #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index e0bf8d19fcfe..05fc49304722 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1136,7 +1136,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		return 0;
>  	}
>  	default:
> -		return -EINVAL;
> +		return kvm_arch_dev_vm_ioctl(kvm, ioctl, arg);
>  	}
>  }
>  
> -- 
> 2.13.6
> 

Have you considered making this capability a generic capability and
encoding this in the 'type' argument to KVM_CREATE_VM?  This would
significantly simplify all the above and would allow you to drop patch 8
and 9 I think.

Thanks,
-Christoffer
