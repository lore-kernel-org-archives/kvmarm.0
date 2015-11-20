From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 03/21] arm64: KVM: Implement vgic-v2 save/restore
Date: Fri, 20 Nov 2015 15:54:38 +0000
Message-ID: <564F423E.9050007@arm.com>
References: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com> <1447679519-17888-4-git-send-email-marc.zyngier@arm.com> <20151120152215.GA24960@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151120152215.GA24960@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Steve Capper <steve.capper@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <marc.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Steve,

On 20/11/15 15:22, Steve Capper wrote:
> On Mon, Nov 16, 2015 at 01:11:41PM +0000, Marc Zyngier wrote:
>> > Implement the vgic-v2 save restore as a direct translation of
>> > the assembly code version.
> Hi Marc,
> I have one comment below:
> 
> Cheers,
> -- Steve
>> > 
>> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> > ---
>> >  arch/arm64/kvm/Makefile         |  1 +
>> >  arch/arm64/kvm/hyp/Makefile     |  5 +++
>> >  arch/arm64/kvm/hyp/hyp.h        |  3 ++
>> >  arch/arm64/kvm/hyp/vgic-v2-sr.c | 85 +++++++++++++++++++++++++++++++++++++++++
>> >  4 files changed, 94 insertions(+)
>> >  create mode 100644 arch/arm64/kvm/hyp/Makefile
>> >  create mode 100644 arch/arm64/kvm/hyp/vgic-v2-sr.c
>> > 
>> > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> > index 1949fe5..d31e4e5 100644
>> > --- a/arch/arm64/kvm/Makefile
>> > +++ b/arch/arm64/kvm/Makefile
>> > @@ -10,6 +10,7 @@ KVM=../../../virt/kvm
>> >  ARM=../../../arch/arm/kvm
>> >  
>> >  obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
>> > +obj-$(CONFIG_KVM_ARM_HOST) += hyp/
>> >  
>> >  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
>> >  kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
>> > diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
>> > new file mode 100644
>> > index 0000000..d8d5968
>> > --- /dev/null
>> > +++ b/arch/arm64/kvm/hyp/Makefile
>> > @@ -0,0 +1,5 @@
>> > +#
>> > +# Makefile for Kernel-based Virtual Machine module, HYP part
>> > +#
>> > +
>> > +obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
>> > diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
>> > index dac843e..78f25c4 100644
>> > --- a/arch/arm64/kvm/hyp/hyp.h
>> > +++ b/arch/arm64/kvm/hyp/hyp.h
>> > @@ -27,5 +27,8 @@
>> >  
>> >  #define kern_hyp_va(v) (typeof(v))((unsigned long)v & HYP_PAGE_OFFSET_MASK)
>> >  
>> > +void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
>> > +void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
>> > +
>> >  #endif /* __ARM64_KVM_HYP_H__ */
>> >  
>> > diff --git a/arch/arm64/kvm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
>> > new file mode 100644
>> > index 0000000..1382d2e
>> > --- /dev/null
>> > +++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
>> > @@ -0,0 +1,85 @@
>> > +/*
>> > + * Copyright (C) 2012-2015 - ARM Ltd
>> > + * Author: Marc Zyngier <marc.zyngier@arm.com>
>> > + *
>> > + * This program is free software; you can redistribute it and/or modify
>> > + * it under the terms of the GNU General Public License version 2 as
>> > + * published by the Free Software Foundation.
>> > + *
>> > + * This program is distributed in the hope that it will be useful,
>> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> > + * GNU General Public License for more details.
>> > + *
>> > + * You should have received a copy of the GNU General Public License
>> > + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> > + */
>> > +
>> > +#include <linux/compiler.h>
>> > +#include <linux/irqchip/arm-gic.h>
>> > +#include <linux/kvm_host.h>
>> > +
>> > +#include <asm/kvm_mmu.h>
>> > +
>> > +#include "hyp.h"
>> > +
>> > +/* vcpu is already in the HYP VA space */
>> > +void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
>> > +{
>> > +	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
>> > +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
>> > +	struct vgic_dist *vgic = &kvm->arch.vgic;
>> > +	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
>> > +	u32 __iomem *lr_base;
>> > +	u32 eisr0, eisr1, elrsr0, elrsr1;
>> > +	int i = 0, nr_lr;
>> > +
>> > +	if (!base)
>> > +		return;
>> > +
>> > +	cpu_if->vgic_vmcr = readl_relaxed(base + GICH_VMCR);
>> > +	cpu_if->vgic_misr = readl_relaxed(base + GICH_MISR);
>> > +	eisr0  = readl_relaxed(base + GICH_EISR0);
>> > +	eisr1  = readl_relaxed(base + GICH_EISR0);
> Not sure what this would affect, but should the RHS be:
> "base + GICH_EISR1"?

-ECOPYPASTE. We're just lucky that we only have 4 list registers, and
thus never look past the first word.

Thanks a lot for noticing this!

	M.
-- 
Jazz is not dead. It just smells funny...
