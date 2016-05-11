From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 18/55] KVM: arm/arm64: vgic-new: Add GICv2 world
 switch backend
Date: Wed, 11 May 2016 14:26:48 +0200
Message-ID: <20160511122648.GN27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-19-git-send-email-andre.przywara@arm.com>
 <5731EBBE.7060203@linaro.org>
 <573317DC.4060200@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <573317DC.4060200@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 11, 2016 at 12:30:36PM +0100, Andre Przywara wrote:
> Hi,
> 
> On 10/05/16 15:10, Eric Auger wrote:
> > On 05/06/2016 12:45 PM, Andre Przywara wrote:
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
> > Didn't we say we could use vcpu->arch.vgic_cpu.used_lrs here?
> 
> Why would that be useful? Don't we just want to see those LRs that had a
> maintenance interrupt received? I don't see the point if iterating over
> the used LRs, where we need to check for this condition somehow manually?
> Or what am I missing here?

if we get rid of eisr eventually we can optimize the reading of that
away, but I honestly don't think we should be pursuing this straight
away.

> 
> >> +			u32 intid = cpuif->vgic_lr[lr] & GICH_LR_VIRTUALID;
> >> +
> >> +			WARN_ON(cpuif->vgic_lr[lr] & GICH_LR_STATE);
> >> +
> >> +			kvm_notify_acked_irq(vcpu->kvm, 0,
> >> +					     intid - VGIC_NR_PRIVATE_IRQS);
> >> +
> >> +			cpuif->vgic_elrsr |= 1ULL << lr;
> 
> So are we good with removing this line (and the respective one in v3)?
> 
Yes.

-Christoffer
