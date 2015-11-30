From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 03/21] arm64: KVM: Implement vgic-v2 save/restore
Date: Mon, 30 Nov 2015 21:00:07 +0100
Message-ID: <20151130200007.GF11704@cbox>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
 <1448650215-15218-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448650215-15218-4-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 27, 2015 at 06:49:57PM +0000, Marc Zyngier wrote:
> Implement the vgic-v2 save restore (mostly) as a direct translation
> of the assembly code version.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/Makefile         |  1 +
>  arch/arm64/kvm/hyp/Makefile     |  5 +++
>  arch/arm64/kvm/hyp/hyp.h        |  3 ++
>  arch/arm64/kvm/hyp/vgic-v2-sr.c | 89 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 98 insertions(+)
>  create mode 100644 arch/arm64/kvm/hyp/Makefile
>  create mode 100644 arch/arm64/kvm/hyp/vgic-v2-sr.c
> 
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 1949fe5..d31e4e5 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -10,6 +10,7 @@ KVM=../../../virt/kvm
>  ARM=../../../arch/arm/kvm
>  
>  obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
> +obj-$(CONFIG_KVM_ARM_HOST) += hyp/
>  
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> new file mode 100644
> index 0000000..d8d5968
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for Kernel-based Virtual Machine module, HYP part
> +#
> +
> +obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
> index dac843e..78f25c4 100644
> --- a/arch/arm64/kvm/hyp/hyp.h
> +++ b/arch/arm64/kvm/hyp/hyp.h
> @@ -27,5 +27,8 @@
>  
>  #define kern_hyp_va(v) (typeof(v))((unsigned long)v & HYP_PAGE_OFFSET_MASK)
>  
> +void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
> +void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);

should we call these flush/sync here now ?

> +
>  #endif /* __ARM64_KVM_HYP_H__ */
>  
> diff --git a/arch/arm64/kvm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
> new file mode 100644
> index 0000000..29a5c1d
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
> @@ -0,0 +1,89 @@
> +/*
> + * Copyright (C) 2012-2015 - ARM Ltd
> + * Author: Marc Zyngier <marc.zyngier@arm.com>
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
> +#include <linux/compiler.h>
> +#include <linux/irqchip/arm-gic.h>
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_mmu.h>
> +
> +#include "hyp.h"
> +
> +/* vcpu is already in the HYP VA space */

should we annotate hyp pointers similarly to __user or will that be
confusing when VHE enters the scene ?

> +void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
> +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> +	struct vgic_dist *vgic = &kvm->arch.vgic;
> +	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
> +	u32 __iomem *lr_base;
> +	u32 eisr0, eisr1, elrsr0, elrsr1;
> +	int i = 0, nr_lr;
> +
> +	if (!base)
> +		return;
> +
> +	nr_lr = vcpu->arch.vgic_cpu.nr_lr;
> +	cpu_if->vgic_vmcr = readl_relaxed(base + GICH_VMCR);
> +	cpu_if->vgic_misr = readl_relaxed(base + GICH_MISR);
> +	eisr0  = readl_relaxed(base + GICH_EISR0);
> +	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
> +	if (unlikely(nr_lr > 32)) {
> +		eisr1  = readl_relaxed(base + GICH_EISR1);
> +		elrsr1 = readl_relaxed(base + GICH_ELRSR1);
> +	} else {
> +		eisr1 = elrsr1 = 0;
> +	}
> +#ifdef CONFIG_CPU_BIG_ENDIAN
> +	cpu_if->vgic_eisr  = ((u64)eisr0 << 32) | eisr1;
> +	cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
> +#else
> +	cpu_if->vgic_eisr  = ((u64)eisr1 << 32) | eisr0;
> +	cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
> +#endif
> +	cpu_if->vgic_apr    = readl_relaxed(base + GICH_APR);
> +
> +	writel_relaxed(0, base + GICH_HCR);
> +
> +	lr_base = base + GICH_LR0;
> +	do {
> +		cpu_if->vgic_lr[i++] = readl_relaxed(lr_base++);
> +	} while (--nr_lr);

why not a simple for-loop?

> +}
> +

copy the vcpu HYP VA comment down here.

> +void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
> +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> +	struct vgic_dist *vgic = &kvm->arch.vgic;
> +	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
> +	u32 __iomem *lr_base;
> +	unsigned int i = 0, nr_lr;
> +
> +	if (!base)
> +		return;
> +
> +	writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
> +	writel_relaxed(cpu_if->vgic_vmcr, base + GICH_VMCR);
> +	writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
> +
> +	lr_base = base + GICH_LR0;
> +	nr_lr = vcpu->arch.vgic_cpu.nr_lr;
> +	do {
> +		writel_relaxed(cpu_if->vgic_lr[i++], lr_base++);
> +	} while (--nr_lr);

same question as above.

> +}
> -- 
> 2.1.4
> 
Otherwise looks good.

-Christoffer
