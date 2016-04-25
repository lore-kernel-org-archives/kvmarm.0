From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 05/45] KVM: arm/arm64: vgic-new: Add acccessor to new
 struct vgic_irq instance
Date: Mon, 25 Apr 2016 18:15:25 +0200
Message-ID: <20160425161525.b4hqjrrharfdsdgo@hawk.localdomain>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
 <1460740316-8755-6-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460740316-8755-6-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

I'm just randomly jumping in here because I spotted a typo in $SUBJECT.
'accessor' has too many c's. Also, just curious, but if the author is
from Linaro (hi Christoffer), then why do the new files this patch adds
have ARM copyrights?

Thanks,
drew
 

On Fri, Apr 15, 2016 at 06:11:16PM +0100, Andre Przywara wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> The new VGIC implementation centers around a struct vgic_irq instance
> per virtual IRQ.
> Provide a function to retrieve the right instance for a given IRQ
> number and (in case of private interrupts) the right VCPU.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h | 22 ++++++++++++++++++++++
>  2 files changed, 63 insertions(+)
>  create mode 100644 virt/kvm/arm/vgic/vgic.c
>  create mode 100644 virt/kvm/arm/vgic/vgic.h
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> new file mode 100644
> index 0000000..fb45537
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -0,0 +1,41 @@
> +/*
> + * Copyright (C) 2015, 2016 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +
> +#include "vgic.h"
> +
> +struct vgic_global __section(.hyp.text) kvm_vgic_global_state;
> +
> +struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
> +			      u32 intid)
> +{
> +	/* SGIs and PPIs */
> +	if (intid <= VGIC_MAX_PRIVATE)
> +		return &vcpu->arch.vgic_cpu.private_irqs[intid];
> +
> +	/* SPIs */
> +	if (intid <= VGIC_MAX_SPI)
> +		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
> +
> +	/* LPIs are not yet covered */
> +	if (intid >= VGIC_MIN_LPI)
> +		return NULL;
> +
> +	WARN(1, "Looking up struct vgic_irq for reserved INTID");
> +	return NULL;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> new file mode 100644
> index 0000000..61b8d22
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -0,0 +1,22 @@
> +/*
> + * Copyright (C) 2015, 2016 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __KVM_ARM_VGIC_NEW_H__
> +#define __KVM_ARM_VGIC_NEW_H__
> +
> +struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
> +			      u32 intid);
> +
> +#endif
> -- 
> 2.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
