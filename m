From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v7 17/17] KVM: arm64: enable ITS emulation as a virtual
 MSI controller
Date: Wed, 29 Jun 2016 18:34:59 +0200
Message-ID: <477014eb-cb07-9339-ef34-5b358d358b77@redhat.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
 <20160628123230.26255-18-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160628123230.26255-18-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 28/06/2016 14:32, Andre Przywara wrote:
> Now that all ITS emulation functionality is in place, we advertise
> MSI functionality to userland and also the ITS device to the guest - if
> userland has configured that.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  Documentation/virtual/kvm/api.txt |  2 +-
>  arch/arm64/kvm/Kconfig            |  1 +
>  arch/arm64/kvm/reset.c            | 10 ++++++++++
>  include/kvm/vgic/vgic.h           |  5 +++++
>  virt/kvm/arm/vgic.c               |  5 +++++
>  virt/kvm/arm/vgic/vgic-init.c     |  3 +++
>  virt/kvm/arm/vgic/vgic-mmio-v3.c  | 14 ++++++++++----
>  virt/kvm/arm/vgic/vgic.c          |  8 ++++++++
>  8 files changed, 43 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index bf76639..f60b137 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2156,7 +2156,7 @@ after pausing the vcpu, but before it is resumed.
>  4.71 KVM_SIGNAL_MSI
>  
>  Capability: KVM_CAP_SIGNAL_MSI
> -Architectures: x86
> +Architectures: x86 arm64
>  Type: vm ioctl
>  Parameters: struct kvm_msi (in)
>  Returns: >0 on delivery, 0 if guest blocked the MSI, and -1 on error
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index c4f26ef..446686a 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -36,6 +36,7 @@ config KVM
>  	select HAVE_KVM_IRQFD
>  	select KVM_ARM_VGIC_V3-ENODEV
>  	select KVM_ARM_PMU if HW_PERF_EVENTS
> +	select HAVE_KVM_MSI
don't you want to enable the modality only with new VGIC? If I am not
wrong an attempt to inject an msi from userspace with old vgic will
return  -ENODEV.

Thanks

Eric
>  	---help---
>  	  Support hosting virtualized guest machines.
>  	  We don't support KVM with 16K page tables yet, due to the multiple
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 6ec9dfe..409d188 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -86,6 +86,16 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_VCPU_ATTRIBUTES:
>  		r = 1;
>  		break;
> +	case KVM_CAP_MSI_DEVID:
> +#ifdef CONFIG_KVM_NEW_VGIC
> +		if (!kvm)
> +			r = -EINVAL;
> +		else
> +			r = kvm->arch.vgic.msis_require_devid;
> +#else
> +		r = -EINVAL;
> +#endif
> +		break;
>  	default:
>  		r = 0;
>  	}
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 2b00fb3..d7a6da3 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -154,6 +154,9 @@ struct vgic_dist {
>  	/* vGIC model the kernel emulates for the guest (GICv2 or GICv3) */
>  	u32			vgic_model;
>  
> +	/* Do injected MSIs require an additional device ID? */
> +	bool			msis_require_devid;
> +
>  	int			nr_spis;
>  
>  	/* TODO: Consider moving to global state */
> @@ -298,4 +301,6 @@ static inline int kvm_vgic_get_max_vcpus(void)
>  	return kvm_vgic_global_state.max_gic_vcpus;
>  }
>  
> +int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
> +
>  #endif /* __ASM_ARM_KVM_VGIC_VGIC_H */
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index c3bfbb9..26db30a 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -2438,3 +2438,8 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>  {
>  	return 0;
>  }
> +
> +int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
> +{
> +	return -ENODEV;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 535e713..01a60dc 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -258,6 +258,9 @@ int vgic_init(struct kvm *kvm)
>  	if (ret)
>  		goto out;
>  
> +	if (vgic_has_its(kvm))
> +		dist->msis_require_devid = true;
> +
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		kvm_vgic_vcpu_init(vcpu);
>  
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index dfa79c7..26f4779 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -66,7 +66,12 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
>  	case GICD_TYPER:
>  		value = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
>  		value = (value >> 5) - 1;
> -		value |= (INTERRUPT_ID_BITS_SPIS - 1) << 19;
> +		if (vgic_has_its(vcpu->kvm)) {
> +			value |= (INTERRUPT_ID_BITS_ITS - 1) << 19;
> +			value |= GICD_TYPER_LPIS;
> +		} else {
> +			value |= (INTERRUPT_ID_BITS_SPIS - 1) << 19;
> +		}
>  		break;
>  	case GICD_IIDR:
>  		value = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
> @@ -161,9 +166,8 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
>  
>  	vgic_cpu->lpis_enabled = val & GICR_CTLR_ENABLE_LPIS;
>  
> -	if (!was_enabled && vgic_cpu->lpis_enabled) {
> -		/* Eventually do something */
> -	}
> +	if (!was_enabled && vgic_cpu->lpis_enabled)
> +		vgic_enable_lpis(vcpu);
>  }
>  
>  static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
> @@ -177,6 +181,8 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
>  	value |= ((target_vcpu_id & 0xffff) << 8);
>  	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
>  		value |= GICR_TYPER_LAST;
> +	if (vgic_has_its(vcpu->kvm))
> +		value |= GICR_TYPER_PLPIS;
>  
>  	return extract_bytes(value, addr & 7, len);
>  }
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 8111d49..f93f8dd 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -682,3 +682,11 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
>  
>  	return map_is_active;
>  }
> +
> +int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
> +{
> +	if (vgic_has_its(kvm))
> +		return vits_inject_msi(kvm, msi);
> +	else
> +		return -ENODEV;
> +}
> 
