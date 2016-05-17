From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v4 49/56] KVM: arm/arm64: vgic-new: vgic_init: implement
 kvm_vgic_hyp_init
Date: Tue, 17 May 2016 16:50:11 +0100
Message-ID: <573B3DB3.80707@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-107-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463392481-26583-107-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 16/05/16 10:54, Andre Przywara wrote:
> +
> +/**
> + * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
> + * @node:	pointer to the DT node

This needs to be updated to match the parameters of vgic_v2_probe.

> + *
> + * Returns 0 if a GICv2 has been found, returns an error code otherwise
> + */
> +int vgic_v2_probe(const struct gic_kvm_info *info)

[...]

> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 8548297..de0e8e0 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -15,6 +15,9 @@
>   #include <linux/irqchip/arm-gic-v3.h>
>   #include <linux/kvm.h>
>   #include <linux/kvm_host.h>
> +#include <kvm/arm_vgic.h>
> +#include <asm/kvm_mmu.h>
> +#include <asm/kvm_asm.h>
>
>   #include "vgic.h"
>
> @@ -182,3 +185,49 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
>   	vmcrp->bpr  = (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
>   	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
>   }
> +
> +/**
> + * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
> + * @node:	pointer to the DT node

This needs to be updated to match the parameters of vgic_v3_probe.

> + *
> + * Returns 0 if a GICv3 has been found, returns an error code otherwise
> + */
> +int vgic_v3_probe(const struct gic_kvm_info *info)

Regards,

-- 
Julien Grall
