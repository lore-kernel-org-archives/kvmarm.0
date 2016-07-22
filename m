From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [RFC v8 5/7] KVM: arm/arm64: Enable irqchip routing
Date: Fri, 22 Jul 2016 16:24:02 +0200
Message-ID: <20160722142401.GC9019@potion>
References: <1469195200-6498-1-git-send-email-eric.auger@redhat.com>
 <1469195200-6498-6-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469195200-6498-6-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

2016-07-22 13:46+0000, Eric Auger:
> This patch adds compilation and link against irqchip.
> 
> Main motivation behind using irqchip code is to enable MSI
> routing code. In the future irqchip routing may also be useful
> when targeting multiple irqchips.
> 
> Routing standard callbacks now are implemented in vgic-irqfd:
> - kvm_set_routing_entry
> - kvm_set_irq
> - kvm_set_msi
> 
> They only are supported with new_vgic code.
> 
> Both HAVE_KVM_IRQCHIP and HAVE_KVM_IRQ_ROUTING are defined.
> KVM_CAP_IRQ_ROUTING is advertised and KVM_SET_GSI_ROUTING is allowed.
> 
> So from now on IRQCHIP routing is enabled and a routing table entry
> must exist for irqfd injection to succeed for a given SPI. This patch
> builds a default flat irqchip routing table (gsi=irqchip.pin) covering
> all the VGIC SPI indexes. This routing table is overwritten by the
> first first user-space call to KVM_SET_GSI_ROUTING ioctl.
> 
> MSI routing setup is not yet allowed.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
> @@ -17,36 +17,101 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  #include <trace/events/kvm.h>
> +#include <kvm/arm_vgic.h>
> +#include "vgic.h"
>  
> -int kvm_irq_map_gsi(struct kvm *kvm,
> -		    struct kvm_kernel_irq_routing_entry *entries,
> -		    int gsi)
> +/**
> + * vgic_irqfd_set_irq: inject the IRQ corresponding to the
> + * irqchip routing entry
> + *
> + * This is the entry point for irqfd IRQ injection
> + */
> +static int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
> +			struct kvm *kvm, int irq_source_id,
> +			int level, bool line_status)
>  {
> -	return 0;
> +	unsigned int spi_id = e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +
> +	if (spi_id > min(dist->nr_spis, VGIC_MAX_SPI))

This is more strict that vgic_valid_spi(), because spi_id between
"dist->nr_spis" and "dist->nr_spis + VGIC_NR_PRIVATE_IRQS" is not
allowed, which probably wasn't intended.

And shouldn't nr_spis always be less that VGIC_MAX_SPI?

Thanks.

> +		return -EINVAL;
> +	return kvm_vgic_inject_irq(kvm, 0, spi_id, level);
>  }
