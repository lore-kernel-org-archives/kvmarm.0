From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 14/55] KVM: arm/arm64: vgic-new: Add acccessor to new
 struct vgic_irq instance
Date: Tue, 10 May 2016 10:22:44 +0100
Message-ID: <5731A864.5000109@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-15-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462531568-9799-15-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/05/16 11:45, Andre Przywara wrote:
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

nit: this structure isn't referenced anywhere yet.

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
> 

Otherwise:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
