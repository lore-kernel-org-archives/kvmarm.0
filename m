From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [RFC PATCH 8/8] ARM: KVM: Support vGICv3 ITS
Date: Fri, 21 Oct 2016 12:02:45 +0100
Message-ID: <857fb7fd-b8eb-7a44-2a6c-be2ec41927ec@arm.com>
References: <1477042601-15227-1-git-send-email-vladimir.murzin@arm.com>
 <1477042601-15227-9-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 591D849B32
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 06:52:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vD4NoOmpgzwA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2016 06:52:10 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E13C048529
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 06:52:09 -0400 (EDT)
In-Reply-To: <1477042601-15227-9-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, kbuild-all@01.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 21/10/16 10:36, Vladimir Murzin wrote:
> This patch allows to build and use vGICv3 ITS in 32-bit mode.

Ah, what a relief to see that config option go. Thanks for that!

I quickly booted an ITS guest on a (64-bit) model and couldn't spot any
regressions.

> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
>  Documentation/virtual/kvm/api.txt   |    2 +-
>  arch/arm/include/uapi/asm/kvm.h     |    2 ++
>  arch/arm/kvm/Kconfig                |    1 +
>  arch/arm/kvm/Makefile               |    1 +
>  arch/arm/kvm/arm.c                  |    6 ++++++
>  arch/arm64/kvm/Kconfig              |    4 ----
>  arch/arm64/kvm/reset.c              |    6 ------
>  virt/kvm/arm/vgic/vgic-kvm-device.c |    2 --
>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |    2 --
>  virt/kvm/arm/vgic/vgic.h            |   26 --------------------------
>  10 files changed, 11 insertions(+), 41 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 739db9a..2feeae6 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2198,7 +2198,7 @@ after pausing the vcpu, but before it is resumed.
>  4.71 KVM_SIGNAL_MSI
>  
>  Capability: KVM_CAP_SIGNAL_MSI
> -Architectures: x86 arm64
> +Architectures: x86 arm arm64
>  Type: vm ioctl
>  Parameters: struct kvm_msi (in)
>  Returns: >0 on delivery, 0 if guest blocked the MSI, and -1 on error
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index b38c10c..af05f8e 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -87,9 +87,11 @@ struct kvm_regs {
>  /* Supported VGICv3 address types  */
>  #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
>  #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
> +#define KVM_VGIC_ITS_ADDR_TYPE		4
>  
>  #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
>  #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
> +#define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
>  
>  #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
>  #define KVM_ARM_VCPU_PSCI_0_2		1 /* CPU uses PSCI v0.2 */
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index 3e1cd04..90d0176 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -34,6 +34,7 @@ config KVM
>  	select HAVE_KVM_IRQFD
>  	select HAVE_KVM_IRQCHIP
>  	select HAVE_KVM_IRQ_ROUTING
> +	select HAVE_KVM_MSI
>  	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
>  	---help---
>  	  Support hosting virtualized guest machines.
> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
> index f19842e..d571243 100644
> --- a/arch/arm/kvm/Makefile
> +++ b/arch/arm/kvm/Makefile
> @@ -32,5 +32,6 @@ obj-y += $(KVM)/arm/vgic/vgic-mmio.o
>  obj-y += $(KVM)/arm/vgic/vgic-mmio-v2.o
>  obj-y += $(KVM)/arm/vgic/vgic-mmio-v3.o
>  obj-y += $(KVM)/arm/vgic/vgic-kvm-device.o
> +obj-y += $(KVM)/arm/vgic/vgic-its.o
>  obj-y += $(KVM)/irqchip.o
>  obj-y += $(KVM)/arm/arch_timer.o
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 03e9273..8b13448 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -209,6 +209,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_MAX_VCPUS:
>  		r = KVM_MAX_VCPUS;
>  		break;
> +	case KVM_CAP_MSI_DEVID:
> +		if (!kvm)
> +			r = -EINVAL;
> +		else
> +			r = kvm->arch.vgic.msis_require_devid;
> +		break;
>  	default:
>  		r = kvm_arch_dev_ioctl_check_extension(kvm, ext);
>  		break;
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 6eaf12c..52cb7ad 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -16,9 +16,6 @@ menuconfig VIRTUALIZATION
>  
>  if VIRTUALIZATION
>  
> -config KVM_ARM_VGIC_V3_ITS
> -	bool
> -
>  config KVM
>  	bool "Kernel-based Virtual Machine (KVM) support"
>  	depends on OF
> @@ -34,7 +31,6 @@ config KVM
>  	select KVM_VFIO
>  	select HAVE_KVM_EVENTFD
>  	select HAVE_KVM_IRQFD
> -	select KVM_ARM_VGIC_V3_ITS
>  	select KVM_ARM_PMU if HW_PERF_EVENTS
>  	select HAVE_KVM_MSI
>  	select HAVE_KVM_IRQCHIP
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 5bc4608..e95d4f6 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -86,12 +86,6 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_VCPU_ATTRIBUTES:
>  		r = 1;
>  		break;
> -	case KVM_CAP_MSI_DEVID:
> -		if (!kvm)
> -			r = -EINVAL;
> -		else
> -			r = kvm->arch.vgic.msis_require_devid;
> -		break;
>  	default:
>  		r = 0;
>  	}
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index ce1f4ed..fbe87a6 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -221,11 +221,9 @@ int kvm_register_vgic_device(unsigned long type)
>  		ret = kvm_register_device_ops(&kvm_arm_vgic_v3_ops,
>  					      KVM_DEV_TYPE_ARM_VGIC_V3);
>  
> -#ifdef CONFIG_KVM_ARM_VGIC_V3_ITS
>  		if (ret)
>  			break;
>  		ret = kvm_vgic_register_its_device();
> -#endif
>  		break;
>  	}
>  
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 0d3c76a..50f42f0 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -42,7 +42,6 @@ u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
>  	return reg | ((u64)val << lower);
>  }
>  
> -#ifdef CONFIG_KVM_ARM_VGIC_V3_ITS
>  bool vgic_has_its(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> @@ -52,7 +51,6 @@ bool vgic_has_its(struct kvm *kvm)
>  
>  	return dist->has_its;
>  }
> -#endif
>  
>  static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
>  					    gpa_t addr, unsigned int len)
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 9d9e014..859f65c 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -84,37 +84,11 @@ static inline void vgic_get_irq_kref(struct vgic_irq *irq)
>  int vgic_v3_map_resources(struct kvm *kvm);
>  int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
>  
> -#ifdef CONFIG_KVM_ARM_VGIC_V3_ITS
>  int vgic_register_its_iodevs(struct kvm *kvm);
>  bool vgic_has_its(struct kvm *kvm);
>  int kvm_vgic_register_its_device(void);
>  void vgic_enable_lpis(struct kvm_vcpu *vcpu);
>  int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
> -#else
> -static inline int vgic_register_its_iodevs(struct kvm *kvm)
> -{
> -	return -ENODEV;
> -}
> -
> -static inline bool vgic_has_its(struct kvm *kvm)
> -{
> -	return false;
> -}
> -
> -static inline int kvm_vgic_register_its_device(void)
> -{
> -	return -ENODEV;
> -}
> -
> -static inline void vgic_enable_lpis(struct kvm_vcpu *vcpu)
> -{
> -}
> -
> -static inline int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
> -{
> -	return -ENODEV;
> -}
> -#endif
>  
>  int kvm_register_vgic_device(unsigned long type);
>  int vgic_lazy_init(struct kvm *kvm);
> 
