From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [RFC PATCH v2 0/4] arm/arm64: vgic-new: Implement API for vGICv3
 live migration
Date: Thu, 11 Aug 2016 10:59:52 +0530
Message-ID: <CALicx6sdGgkf_neZ_F0OUu3cg36VBoWT581HAG=v2FecN6omJA@mail.gmail.com>
References: <1470740326-27751-1-git-send-email-vijay.kilari@gmail.com>
 <CAFEAcA-z+iM+=p0riWreJCewPPxw9wtHgg+_4MDtxV=ccwe-tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57F4849B3C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2016 01:22:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id erMvJApaXLpb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Aug 2016 01:22:42 -0400 (EDT)
Received: from mail-oi0-f68.google.com (mail-oi0-f68.google.com
 [209.85.218.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1530D412D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2016 01:22:42 -0400 (EDT)
Received: by mail-oi0-f68.google.com with SMTP id e80so2121964oig.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 22:29:53 -0700 (PDT)
In-Reply-To: <CAFEAcA-z+iM+=p0riWreJCewPPxw9wtHgg+_4MDtxV=ccwe-tg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: "prasun.kapoor" <Prasun.Kapoor@cavium.com>, Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 9, 2016 at 5:22 PM, Peter Maydell <peter.maydell@linaro.org> wrote:
> On 9 August 2016 at 11:58,  <vijay.kilari@gmail.com> wrote:
>> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>>
>> This patchset adds API for saving and restoring
>> of VGICv3 registers to support live migration with new vgic feature.
>> This API definition is as per version of VGICv3 specification
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
>>
>> To test live migration with QEMU, use below patch series
>> https://lists.gnu.org/archive/html/qemu-devel/2016-08/msg01444.html
>>
>> The patch 3 & 4 are picked from the Pavel's previous implementation.
>> http://www.spinics.net/lists/kvm/msg122040.html
>>
>> v1 => v2:
>>  - The init sequence change patch is no more required.
>>    Fixed in patch 2 by using static vgic_io_dev regions structure instead
>>    of using dynamic allocation pointer.
>>  - Updated commit message of patch 4.
>>  - Dropped usage of union to manage 32-bit and 64-bit access in patch 1.
>>    Used local variable for 32-bit access.
>>  - Updated macro __ARM64_SYS_REG and ARM64_SYS_REG in
>>    arch/arm64/include/uapi/asm/kvm.h as per qemu requirements.
>
> I only scanned briefly through this patchset, but I didn't
> see any code implementing:
>  * KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO

If irq->pending is updated by kernel based on irq->line_level when interrupt
is asserted by device or guest. Do we still need to extract
irq->line_level using
this ioctl and while writing back GIC{D|R}_ISPENDR with line_level
+(OR) GIC{D|R}_ISPENDR?

>  * the different behaviour for accesses to GICD_STATUSR, GICR_STATUSR,

QEMU is saving and restoring this register, but kernel implementation
is missing. Kernel is silently returning zero. So could not catch. I
will fix it.

However, Specification says as below for STATUSR.

"    The GICD_STATUSR and GICR_STATUSR registers are architecturally
defined such
     that a write of a clear bit has no effect, whereas a write with a set bit
     clears that value.  To allow userspace to freely set the values
of these two
     registers, setting the attributes with the register offsets for these two
     registers simply sets the non-reserved bits to the value written."

Question is during restore, the set bit will clear the value STATUSR.
So it will reset the STATUSR after migrating the VM.

>    GICD_ISPENDR, GICR_ISPENDR0, GICD_ICPENDR, and GICR_ICPENDR0, which
>    don't act the same via this API as for a guest access to the register
>
> Did I miss something?

In kernel (as shown in below code snippet),
 GICD_ISPENDR, GICR_ISPENDR0, GICD_ICPENDR, and GICR_ICPENDR0
all register access using KVM_DEV_ARM_VGIC_GRP_{RE|DIST}_REGS ioctl
is accessing irq->pending state.

unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
                                     gpa_t addr, unsigned int len)
{
        u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
        u32 value = 0;
        int i;

        /* Loop over all IRQs affected by this read */
        for (i = 0; i < len * 8; i++) {
                struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);

                if (irq->pending)
                        value |= (1U << i);
        }

  ...
}
>
> thanks
> -- PMM
