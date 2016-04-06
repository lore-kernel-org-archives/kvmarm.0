From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 04/45] KVM: arm/arm64: vgic-new: Add data structure
 definitions
Date: Wed, 6 Apr 2016 16:46:29 +0200
Message-ID: <20160406144629.GA8961@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-5-git-send-email-andre.przywara@arm.com>
 <20160329130922.GE4126@cbox> <5703BEF2.7090507@arm.com>
 <20160405201009.GA10522@cbox> <20160406135753.GE16355@cbox>
 <570518AE.7010107@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20575407A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 10:45:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4fKBxk9FddYu for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2016 10:44:58 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9336940402
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 10:44:58 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id n3so66536043wmn.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2016 07:46:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <570518AE.7010107@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 06, 2016 at 03:09:50PM +0100, Andre Przywara wrote:
> 
> 
> On 06/04/16 14:57, Christoffer Dall wrote:
> > On Tue, Apr 05, 2016 at 10:10:09PM +0200, Christoffer Dall wrote:
> >> On Tue, Apr 05, 2016 at 02:34:42PM +0100, Andre Przywara wrote:
> >>> Hi,
> >>>
> >>> On 29/03/16 14:09, Christoffer Dall wrote:
> >>>> On Fri, Mar 25, 2016 at 02:04:27AM +0000, Andre Przywara wrote:
> >>>>> From: Christoffer Dall <christoffer.dall@linaro.org>
> >>>>>
> >>>>> Add a new header file for the new and improved GIC implementation.
> >>>>> The big change is that we now have a struct vgic_irq per IRQ instead
> >>>>> of spreading all the information over various bitmaps.
> >>>>>
> >>>>> We include this new header conditionally from within the old header
> >>>>> file for the time being to avoid touching all the users.
> >>>>>
> >>>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >>>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >>>>> ---
> >>>>>  include/kvm/arm_vgic.h  |   5 ++
> >>>>>  include/kvm/vgic/vgic.h | 198 ++++++++++++++++++++++++++++++++++++++++++++++++
> >>>>>  2 files changed, 203 insertions(+)
> >>>>>  create mode 100644 include/kvm/vgic/vgic.h
> >>>>>
> >>>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >>>>> index 7656a46..db289a2 100644
> >>>>> --- a/include/kvm/arm_vgic.h
> >>>>> +++ b/include/kvm/arm_vgic.h
> >>>>> @@ -19,6 +19,10 @@
> >>>>>  #ifndef __ASM_ARM_KVM_VGIC_H
> >>>>>  #define __ASM_ARM_KVM_VGIC_H
> >>>>>
> >>>>> +#ifdef CONFIG_KVM_NEW_VGIC
> >>>>> +#include <kvm/vgic/vgic.h>
> >>>>> +#else
> >>>>> +
> >>>>>  #include <linux/kernel.h>
> >>>>>  #include <linux/kvm.h>
> >>>>>  #include <linux/irqreturn.h>
> >>>>> @@ -376,4 +380,5 @@ static inline int vgic_v3_probe(struct device_node *vgic_node,
> >>>>>  }
> >>>>>  #endif
> >>>>>
> >>>>> +#endif   /* old VGIC include */
> >>>>>  #endif
> >>>>> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> >>>>> new file mode 100644
> >>>>> index 0000000..659f8b1
> >>>>> --- /dev/null
> >>>>> +++ b/include/kvm/vgic/vgic.h
> >>>>> @@ -0,0 +1,198 @@
> >>>>> +/*
> >>>>> + * Copyright (C) 2015, 2016 ARM Ltd.
> >>>>> + *
> >>>>> + * This program is free software; you can redistribute it and/or modify
> >>>>> + * it under the terms of the GNU General Public License version 2 as
> >>>>> + * published by the Free Software Foundation.
> >>>>> + *
> >>>>> + * This program is distributed in the hope that it will be useful,
> >>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>>>> + * GNU General Public License for more details.
> >>>>> + *
> >>>>> + * You should have received a copy of the GNU General Public License
> >>>>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> >>>>> + */
> >>>>> +#ifndef __ASM_ARM_KVM_VGIC_VGIC_H
> >>>>> +#define __ASM_ARM_KVM_VGIC_VGIC_H
> >>>>> +
> >>>>> +#include <linux/kernel.h>
> >>>>> +#include <linux/kvm.h>
> >>>>> +#include <linux/irqreturn.h>
> >>>>> +#include <linux/spinlock.h>
> >>>>> +#include <linux/types.h>
> >>>>> +#include <kvm/iodev.h>
> >>>>> +
> >>>>> +#define VGIC_V3_MAX_CPUS 255
> >>>>> +#define VGIC_V2_MAX_CPUS 8
> >>>>> +#define VGIC_NR_IRQS_LEGACY     256
> >>>>> +#define VGIC_NR_SGIS             16
> >>>>> +#define VGIC_NR_PPIS             16
> >>>>> +#define VGIC_NR_PRIVATE_IRQS     (VGIC_NR_SGIS + VGIC_NR_PPIS)
> >>>>> +#define VGIC_MAX_PRIVATE (VGIC_NR_PRIVATE_IRQS - 1)
> >>>>> +#define VGIC_MAX_SPI             1019
> >>>>> +#define VGIC_MAX_RESERVED        1023
> >>>>> +#define VGIC_MIN_LPI             8192
> >>>>> +
> >>>>> +enum vgic_type {
> >>>>> + VGIC_V2,                /* Good ol' GICv2 */
> >>>>> + VGIC_V3,                /* New fancy GICv3 */
> >>>>> +};
> >>>>> +
> >>>>> +/* same for all guests, as depending only on the _host's_ GIC model */
> >>>>> +struct vgic_global {
> >>>>> + /* type of the host GIC */
> >>>>> + enum vgic_type          type;
> >>>>> +
> >>>>> + /* Physical address of vgic virtual cpu interface */
> >>>>> + phys_addr_t             vcpu_base;
> >>>>> +
> >>>>> + /* virtual control interface mapping */
> >>>>> + void __iomem            *vctrl_base;
> >>>>> +
> >>>>> + /* Number of implemented list registers */
> >>>>> + int                     nr_lr;
> >>>>> +
> >>>>> + /* Maintenance IRQ number */
> >>>>> + unsigned int            maint_irq;
> >>>>> +
> >>>>> + /* maximum number of VCPUs allowed (GICv2 limits us to 8) */
> >>>>> + int                     max_gic_vcpus;
> >>>>> +
> >>>>> + /* Only needed for the legacy KVM_CREATE_IRQCHIP */
> >>>>> + bool                    can_emulate_gicv2;
> >>>>> +};
> >>>>> +
> >>>>> +extern struct vgic_global kvm_vgic_global_state;
> >>>>> +
> >>>>> +#define VGIC_V2_MAX_LRS          (1 << 6)
> >>>>> +#define VGIC_V3_MAX_LRS          16
> >>>>> +#define VGIC_V3_LR_INDEX(lr)     (VGIC_V3_MAX_LRS - 1 - lr)
> >>>>> +
> >>>>> +enum vgic_irq_config {
> >>>>> + VGIC_CONFIG_EDGE = 0,
> >>>>> + VGIC_CONFIG_LEVEL
> >>>>> +};
> >>>>> +
> >>>>> +struct vgic_irq {
> >>>>> + spinlock_t irq_lock;            /* Protects the content of the struct */
> >>>>> + struct list_head ap_list;
> >>>>> +
> >>>>> + struct kvm_vcpu *vcpu;          /* SGIs and PPIs: The VCPU
> >>>>> +                                  * SPIs and LPIs: The VCPU whose ap_list
> >>>>> +                                  * on which this is queued.
> >>>>> +                                  */
> >>>>> +
> >>>>> + struct kvm_vcpu *target_vcpu;   /* The VCPU that this interrupt should
> >>>>> +                                  * be send to, as a result of the
> >>>>> +                                  * targets reg (v2) or the
> >>>>> +                                  * affinity reg (v3).
> >>>>> +                                  */
> >>>>> +
> >>>>> + u32 intid;                      /* Guest visible INTID */
> >>>>> + bool pending;
> >>>>> + bool line_level;                /* Level only */
> >>>>> + bool soft_pending;              /* Level only */
> >>>>> + bool active;                    /* not used for LPIs */
> >>>>> + bool enabled;
> >>>>> + bool hw;                        /* Tied to HW IRQ */
> >>>>> + u32 hwintid;                    /* HW INTID number */
> >>>>> + union {
> >>>>> +         u8 targets;                     /* GICv2 target VCPUs mask */
> >>>>> +         u32 mpidr;                      /* GICv3 target VCPU */
> >>>>> + };
> >>>>> + u8 source;                      /* GICv2 SGIs only */
> >>>>> + u8 priority;
> >>>>> + enum vgic_irq_config config;    /* Level or edge */
> >>>>> +};
> >>>>> +
> >>>>> +struct vgic_dist {
> >>>>> + bool                    in_kernel;
> >>>>> + bool                    ready;
> >>>>> +
> >>>>> + /* vGIC model the kernel emulates for the guest (GICv2 or GICv3) */
> >>>>> + u32                     vgic_model;
> >>>>> +
> >>>>> + int                     nr_spis;
> >>>>> +
> >>>>> + /* TODO: Consider moving to global state */
> >>>>> + /* Virtual control interface mapping */
> >>>>> + void __iomem            *vctrl_base;
> >>>>> +
> >>>>> + /* base addresses in guest physical address space: */
> >>>>> + gpa_t                   vgic_dist_base;         /* distributor */
> >>>>> + union {
> >>>>> +         /* either a GICv2 CPU interface */
> >>>>> +         gpa_t                   vgic_cpu_base;
> >>>>> +         /* or a number of GICv3 redistributor regions */
> >>>>> +         gpa_t                   vgic_redist_base;
> >>>>> + };
> >>>>> +
> >>>>> + /* distributor enabled */
> >>>>> + u32                     enabled;
> >>>>> +
> >>>>> + struct vgic_irq         *spis;
> >>>>> +};
> >>>>> +
> >>>>> +struct vgic_v2_cpu_if {
> >>>>> + u32             vgic_hcr;
> >>>>> + u32             vgic_vmcr;
> >>>>> + u32             vgic_misr;      /* Saved only */
> >>>>> + u64             vgic_eisr;      /* Saved only */
> >>>>> + u64             vgic_elrsr;     /* Saved only */
> >>>>> + u32             vgic_apr;
> >>>>> + u32             vgic_lr[VGIC_V2_MAX_LRS];
> >>>>> +};
> >>>>> +
> >>>>> +struct vgic_v3_cpu_if {
> >>>>> +#ifdef CONFIG_KVM_ARM_VGIC_V3
> >>>>> + u32             vgic_hcr;
> >>>>> + u32             vgic_vmcr;
> >>>>> + u32             vgic_sre;       /* Restored only, change ignored */
> >>>>> + u32             vgic_misr;      /* Saved only */
> >>>>> + u32             vgic_eisr;      /* Saved only */
> >>>>> + u32             vgic_elrsr;     /* Saved only */
> >>>>> + u32             vgic_ap0r[4];
> >>>>> + u32             vgic_ap1r[4];
> >>>>> + u64             vgic_lr[VGIC_V3_MAX_LRS];
> >>>>> +#endif
> >>>>> +};
> >>>>> +
> >>>>> +struct vgic_cpu {
> >>>>> + /* CPU vif control registers for world switch */
> >>>>> + union {
> >>>>> +         struct vgic_v2_cpu_if   vgic_v2;
> >>>>> +         struct vgic_v3_cpu_if   vgic_v3;
> >>>>> + };
> >>>>> +
> >>>>> + /* TODO: Move nr_lr to a global state */
> >>>>
> >>>> what is our current plan and status about this TODO?
> >>>
> >>> The point is that the current HYP code is accessing this field. We do
> >>> have this field in the current "global" struct vgic_params there as
> >>> well, but this struct is (more or less) private to vgic-v2.c, so not
> >>> easily accessible from virt/kvm/arm/hyp/*.c.
> >>> So I suggest we keep this in here for the time being and eventually
> >>> remove it (and rework the save/restore code) once we get rid of the old
> >>> VGIC code.
> >>>
> >> Hmmm, I haven't tried it, but I don't understand why moving it now is
> >> difficult.  I'd really like to avoid having a bunch of todo's lingering
> >> around and having duplicated state in the new code.
> >>
> >> I think I noticed a number of places in this patch series which refers
> >> tot he vgic_cpu->nr_lr instead of the global place already...
> >>
> > So I wrote a patch for this and it doesn't really look that bad.  I'll
> > send it as part of a little prerequisite series later.
> 
> I just fixed it as well - the private new VGIC part is trivial indeed.
> But how did you solve the reference to the vgic_cpu.nr_lr in
> virt/kvm/arm/hyp/vgic-v2-sr.c? With #ifdef .. #else? Or passing in the
> number as in vgic-v3-sr.c?
> 

I sent you a couple of patches as I said I would.

I just used an extern with the kern_hyp_va() macro trickery applied.
Not the prettiest thing in the world, but hey.  It should serve just
fine for moving on with this, and then we can worry about the finesses
as the vgic series progresses.

-Christoffer
