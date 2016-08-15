From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v2 0/4] arm/arm64: vgic-new: Implement API for vGICv3
 live migration
Date: Mon, 15 Aug 2016 23:37:27 +0200
Message-ID: <20160815213727.GA30152@cbox>
References: <1470740326-27751-1-git-send-email-vijay.kilari@gmail.com>
 <CAFEAcA-z+iM+=p0riWreJCewPPxw9wtHgg+_4MDtxV=ccwe-tg@mail.gmail.com>
 <CALicx6sdGgkf_neZ_F0OUu3cg36VBoWT581HAG=v2FecN6omJA@mail.gmail.com>
 <CAFEAcA-eAHaZio6xWtyDEDAGynXMEsAMBHMnPWx_B1DTQ+qGNQ@mail.gmail.com>
 <CALicx6sQFPSqr6AsdUE8nuFOPDz+becwGDFgmTsyOR55HFV18w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D79F49B2E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2016 17:28:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Trm+pZc4PVDl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Aug 2016 17:28:06 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2140C412DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2016 17:28:05 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id i5so128450958wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2016 14:35:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CALicx6sQFPSqr6AsdUE8nuFOPDz+becwGDFgmTsyOR55HFV18w@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vijay Kilari <vijay.kilari@gmail.com>
Cc: "prasun.kapoor" <Prasun.Kapoor@cavium.com>, Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Aug 12, 2016 at 01:08:12PM +0530, Vijay Kilari wrote:
> On Thu, Aug 11, 2016 at 1:15 PM, Peter Maydell <peter.maydell@linaro.org> wrote:
> > On 11 August 2016 at 06:29, Vijay Kilari <vijay.kilari@gmail.com> wrote:
> >> On Tue, Aug 9, 2016 at 5:22 PM, Peter Maydell <peter.maydell@linaro.org> wrote:
> >>> On 9 August 2016 at 11:58,  <vijay.kilari@gmail.com> wrote:
> >>>> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >>>>
> >>>> This patchset adds API for saving and restoring
> >>>> of VGICv3 registers to support live migration with new vgic feature.
> >>>> This API definition is as per version of VGICv3 specification
> >>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
> >>>>
> >>>> To test live migration with QEMU, use below patch series
> >>>> https://lists.gnu.org/archive/html/qemu-devel/2016-08/msg01444.html
> >>>>
> >>>> The patch 3 & 4 are picked from the Pavel's previous implementation.
> >>>> http://www.spinics.net/lists/kvm/msg122040.html
> >>>>
> >>>> v1 => v2:
> >>>>  - The init sequence change patch is no more required.
> >>>>    Fixed in patch 2 by using static vgic_io_dev regions structure instead
> >>>>    of using dynamic allocation pointer.
> >>>>  - Updated commit message of patch 4.
> >>>>  - Dropped usage of union to manage 32-bit and 64-bit access in patch 1.
> >>>>    Used local variable for 32-bit access.
> >>>>  - Updated macro __ARM64_SYS_REG and ARM64_SYS_REG in
> >>>>    arch/arm64/include/uapi/asm/kvm.h as per qemu requirements.
> >>>
> >>> I only scanned briefly through this patchset, but I didn't
> >>> see any code implementing:
> >>>  * KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO
> >>
> >> If irq->pending is updated by kernel based on irq->line_level when interrupt
> >> is asserted by device or guest. Do we still need to extract
> >> irq->line_level using
> >> this ioctl and while writing back GIC{D|R}_ISPENDR with line_level
> >> +(OR) GIC{D|R}_ISPENDR?
> >
> > The level and the pending status are different things;
> > the API docs have an explanation of this. The API access
> > to the ISPENDR registers should return only the pending
> > latch status (which is not the same as what these registers
> > return if you read them from the guest).
> >
> >>>  * the different behaviour for accesses to GICD_STATUSR, GICR_STATUSR,
> >>
> >> QEMU is saving and restoring this register, but kernel implementation
> >> is missing. Kernel is silently returning zero. So could not catch. I
> >> will fix it.
> >>
> >> However, Specification says as below for STATUSR.
> >>
> >> "    The GICD_STATUSR and GICR_STATUSR registers are architecturally
> >> defined such
> >>      that a write of a clear bit has no effect, whereas a write with a set bit
> >>      clears that value.  To allow userspace to freely set the values
> >> of these two
> >>      registers, setting the attributes with the register offsets for these two
> >>      registers simply sets the non-reserved bits to the value written."
> >>
> >> Question is during restore, the set bit will clear the value STATUSR.
> >> So it will reset the STATUSR after migrating the VM.
> >
> > The text you quote above says that setting the attribute via
> > the API "sets the non-reserved bits to the value written".
> > This is the point -- it does not have the write-1-to-clear
> > behaviour that a guest access to the register does.
> >
> >>>    GICD_ISPENDR, GICR_ISPENDR0, GICD_ICPENDR, and GICR_ICPENDR0, which
> >>>    don't act the same via this API as for a guest access to the register
> >>>
> >>> Did I miss something?
> >>
> >> In kernel (as shown in below code snippet),
> >>  GICD_ISPENDR, GICR_ISPENDR0, GICD_ICPENDR, and GICR_ICPENDR0
> >> all register access using KVM_DEV_ARM_VGIC_GRP_{RE|DIST}_REGS ioctl
> >> is accessing irq->pending state.
> >>
> >> unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
> >>                                      gpa_t addr, unsigned int len)
> >> {
> >>         u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> >>         u32 value = 0;
> >>         int i;
> >>
> >>         /* Loop over all IRQs affected by this read */
> >>         for (i = 0; i < len * 8; i++) {
> >>                 struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> >>
> >>                 if (irq->pending)
> >>                         value |= (1U << i);
> >>         }
> >>
> >>   ...
> >> }
> >
> > This is the code for handling a guest access to this register.
> > The behaviour for access from userspace via this API has
> > to be different, and therefore it must not use this code.
> > The API doc specifies how it must differ.
> 
> API doc says,
> 
> "For a level triggered interrupt the value accessed
> here is that of the latch which is set by ISPENDR and cleared by ICPENDR or
> interrupt activation"
> 
> Kernel maintains only irq->pending for all interrupts.

no, the kernel also maintains irq->soft_pending.

> By going through the code, there is no separate variable that holds purely
> ISPENDR value. With assumption that irq->pending is purely ISPENDR for
> level triggerred

it is not; irq->pending is always an OR of the line_level with the
soft_pending field for level-triggered interrupts.

You can read and understand the semantics of the soft_pending field by
taking a look at vgic_mmio_write_spending and grepping for soft_pending
in the kernel and vgic code in general.


> interrupt, userspace access to ISPENDR for level triggerred interrupts
> can be irq->pending & (~ICPENDR[irq_bit]) | irq->active?.

I don't understand what the active state has to do with userspace
reading the ISPENDR?

Hope this helps,
-Christoffer
