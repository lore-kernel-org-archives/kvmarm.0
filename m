From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 18/55] KVM: arm/arm64: vgic-new: Add GICv2 world
 switch backend
Date: Tue, 10 May 2016 16:11:19 +0200
Message-ID: <20160510141119.GB20499@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-19-git-send-email-andre.przywara@arm.com>
 <20160510133043.GF27623@cbox>
 <5731E52A.9000402@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5731E52A.9000402@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 10, 2016 at 02:42:02PM +0100, Marc Zyngier wrote:
> On 10/05/16 14:30, Christoffer Dall wrote:
> > On Fri, May 06, 2016 at 11:45:31AM +0100, Andre Przywara wrote:
> >> From: Marc Zyngier <marc.zyngier@arm.com>
> >>
> >> Processing maintenance interrupts and accessing the list registers
> >> are dependent on the host's GIC version.
> >> Introduce vgic-v2.c to contain GICv2 specific functions.
> >> Implement the GICv2 specific code for syncing the emulation state
> >> into the VGIC registers.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >> Changelog RFC..v1:
> >> - remove explicit LR_STATE clearing on maintenance interrupt handling
> >> - improve documentation for vgic_v2_populate_lr()
> >> - remove WARN_ON on non-edge IRQs in maintenance interrupts
> >> - simplify multi-CPU source SGI handling
> >>
> >> Changelog v1 .. v2:
> >> - inject the IRQ priority into the list register
> >>
> >> Changelog v2 .. v3:
> >> - cleanup diff containing rebase artifacts
> >>
> >>  include/linux/irqchip/arm-gic.h |   1 +
> >>  virt/kvm/arm/vgic/vgic-v2.c     | 178 ++++++++++++++++++++++++++++++++++++++++
> >>  virt/kvm/arm/vgic/vgic.c        |   6 ++
> >>  virt/kvm/arm/vgic/vgic.h        |   6 ++
> >>  4 files changed, 191 insertions(+)
> >>  create mode 100644 virt/kvm/arm/vgic/vgic-v2.c
> >>
> >> diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
> >> index 9c94026..be0d26f 100644
> >> --- a/include/linux/irqchip/arm-gic.h
> >> +++ b/include/linux/irqchip/arm-gic.h
> >> @@ -76,6 +76,7 @@
> >>  #define GICH_LR_VIRTUALID		(0x3ff << 0)
> >>  #define GICH_LR_PHYSID_CPUID_SHIFT	(10)
> >>  #define GICH_LR_PHYSID_CPUID		(0x3ff << GICH_LR_PHYSID_CPUID_SHIFT)
> >> +#define GICH_LR_PRIORITY_SHIFT		23
> >>  #define GICH_LR_STATE			(3 << 28)
> >>  #define GICH_LR_PENDING_BIT		(1 << 28)
> >>  #define GICH_LR_ACTIVE_BIT		(1 << 29)
> >> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> >> new file mode 100644
> >> index 0000000..4cee616
> >> --- /dev/null
> >> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> >> @@ -0,0 +1,178 @@
> >> +/*
> >> + * Copyright (C) 2015, 2016 ARM Ltd.
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + * You should have received a copy of the GNU General Public License
> >> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> >> + */
> >> +
> >> +#include <linux/irqchip/arm-gic.h>
> >> +#include <linux/kvm.h>
> >> +#include <linux/kvm_host.h>
> >> +
> >> +#include "vgic.h"
> >> +
> >> +/*
> >> + * Call this function to convert a u64 value to an unsigned long * bitmask
> >> + * in a way that works on both 32-bit and 64-bit LE and BE platforms.
> >> + *
> >> + * Warning: Calling this function may modify *val.
> >> + */
> >> +static unsigned long *u64_to_bitmask(u64 *val)
> >> +{
> >> +#if defined(CONFIG_CPU_BIG_ENDIAN) && BITS_PER_LONG == 32
> >> +	*val = (*val >> 32) | (*val << 32);
> >> +#endif
> >> +	return (unsigned long *)val;
> >> +}
> >> +
> >> +void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu)
> >> +{
> >> +	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
> >> +
> >> +	if (cpuif->vgic_misr & GICH_MISR_EOI) {
> >> +		u64 eisr = cpuif->vgic_eisr;
> >> +		unsigned long *eisr_bmap = u64_to_bitmask(&eisr);
> >> +		int lr;
> >> +
> >> +		for_each_set_bit(lr, eisr_bmap, kvm_vgic_global_state.nr_lr) {
> >> +			u32 intid = cpuif->vgic_lr[lr] & GICH_LR_VIRTUALID;
> >> +
> >> +			WARN_ON(cpuif->vgic_lr[lr] & GICH_LR_STATE);
> >> +
> >> +			kvm_notify_acked_irq(vcpu->kvm, 0,
> >> +					     intid - VGIC_NR_PRIVATE_IRQS);
> >> +
> > 
> > why do we need to do this?  I cannot find any consumers of this info
> > after we've left the hyp code.
> 
> I believe that's for vhost and irqfd. Or am I misreading your question?
> 

I meant the setting of the bits in vgic_elrsr (sorry, badly placed
comment)...

> > Also, I think I offered a comment about why we would potentially need
> > this in the first place.  This is the famous race where hardware doesn't
> > guarantee consistency between the MISR and ELRSR right?
> 
> That's the one (except it is between EISR and ELRSR). I don't have your
> initial comment at hand, but would something like the following do?
> 
> 			/*
> 			 * The maintenance interrupt may not have had a
> 			 * chance to update ELRSR, so let's mark the LRs
> 			 * presents in EISR as empty.
> 			 */
> > 
> >> +			cpuif->vgic_elrsr |= 1ULL << lr;

so, why are we doing this?

> >> +		}
> >> +	}
> 
> Thanks,
> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...
