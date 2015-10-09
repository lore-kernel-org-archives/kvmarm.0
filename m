From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 6/6] arm/arm64: KVM: only allow 64bit hosts to build
 VGICv3
Date: Fri, 9 Oct 2015 14:10:06 +0100
Message-ID: <20151009141006.213e252d@arm.com>
References: <1443703639-3730-1-git-send-email-jean-philippe.brucker@arm.com>
	<1443703639-3730-7-git-send-email-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443703639-3730-7-git-send-email-jean-philippe.brucker@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu,  1 Oct 2015 13:47:19 +0100
Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:

> Hardware virtualisation of GICv3 is only supported by 64bit hosts for
> the moment. Some VGICv3 bits are missing from the 32bit side, and this
> patch allows to still be able to build 32bit hosts when CONFIG_ARM_GIC_V3
> is selected.
> 
> To this end, we introduce a new option, CONFIG_KVM_ARM_VGIC_V3, that is
> only enabled on the 64bit side. The selection is done unconditionally
> because CONFIG_ARM_GIC_V3 is always enabled on arm64.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> ---
>  arch/arm64/kvm/Kconfig |    4 ++++
>  include/kvm/arm_vgic.h |    4 ++--
>  virt/kvm/arm/vgic.c    |    4 ++--
>  3 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 5c7e920..ff5292c 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -16,6 +16,9 @@ menuconfig VIRTUALIZATION
>  
>  if VIRTUALIZATION
>  
> +config KVM_ARM_VGIC_V3
> +	bool
> +
>  config KVM
>  	bool "Kernel-based Virtual Machine (KVM) support"
>  	depends on OF
> @@ -31,6 +34,7 @@ config KVM
>  	select KVM_VFIO
>  	select HAVE_KVM_EVENTFD
>  	select HAVE_KVM_IRQFD
> +	select KVM_ARM_VGIC_V3
>  	---help---
>  	  Support hosting virtualized guest machines.
>  
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 4e14dac..6a3538e 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -282,7 +282,7 @@ struct vgic_v2_cpu_if {
>  };
>  
>  struct vgic_v3_cpu_if {
> -#ifdef CONFIG_ARM_GIC_V3
> +#ifdef CONFIG_KVM_ARM_VGIC_V3
>  	u32		vgic_hcr;
>  	u32		vgic_vmcr;
>  	u32		vgic_sre;	/* Restored only, change ignored */
> @@ -364,7 +364,7 @@ void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
>  int vgic_v2_probe(struct device_node *vgic_node,
>  		  const struct vgic_ops **ops,
>  		  const struct vgic_params **params);
> -#ifdef CONFIG_ARM_GIC_V3
> +#ifdef CONFIG_KVM_ARM_VGIC_V3
>  int vgic_v3_probe(struct device_node *vgic_node,
>  		  const struct vgic_ops **ops,
>  		  const struct vgic_params **params);
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 6bd1c9b..77b0176 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -2122,7 +2122,7 @@ static int init_vgic_model(struct kvm *kvm, int type)
>  	case KVM_DEV_TYPE_ARM_VGIC_V2:
>  		vgic_v2_init_emulation(kvm);
>  		break;
> -#ifdef CONFIG_ARM_GIC_V3
> +#ifdef CONFIG_KVM_ARM_VGIC_V3
>  	case KVM_DEV_TYPE_ARM_VGIC_V3:
>  		vgic_v3_init_emulation(kvm);
>  		break;
> @@ -2284,7 +2284,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  		block_size = KVM_VGIC_V2_CPU_SIZE;
>  		alignment = SZ_4K;
>  		break;
> -#ifdef CONFIG_ARM_GIC_V3
> +#ifdef CONFIG_KVM_ARM_VGIC_V3
>  	case KVM_VGIC_V3_ADDR_TYPE_DIST:
>  		type_needed = KVM_DEV_TYPE_ARM_VGIC_V3;
>  		addr_ptr = &vgic->vgic_dist_base;


Christoffer, do you have any objection to that patch, and to have it
merged though the irqchip tree?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
