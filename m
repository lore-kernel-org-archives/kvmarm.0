From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 4/5] arm/arm64: vgic-new: Implement VGICv3 CPU
 interface access
Date: Mon, 12 Sep 2016 10:12:54 +0100
Message-ID: <57D67196.4000500@arm.com>
References: <1473510138-4719-1-git-send-email-vijay.kilari@gmail.com>
 <1473510138-4719-5-git-send-email-vijay.kilari@gmail.com>
 <20160911085612.6bf785e1@arm.com>
 <CALicx6tG6jhNVs3DKfKKpyc8VMWjV-UWWtW1PuJSPpHC3g=wVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4D2B40F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:04:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mk3N4HqyT1za for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Sep 2016 05:04:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC5B840C9A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 05:04:17 -0400 (EDT)
In-Reply-To: <CALicx6tG6jhNVs3DKfKKpyc8VMWjV-UWWtW1PuJSPpHC3g=wVg@mail.gmail.com>
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
Cc: Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 12/09/16 10:00, Vijay Kilari wrote:
> ()
> 
> On Sun, Sep 11, 2016 at 1:26 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On Sat, 10 Sep 2016 17:52:17 +0530
>> vijay.kilari@gmail.com wrote:
>>
>>> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>>>
>>> VGICv3 CPU interface registers are accessed using
>>> KVM_DEV_ARM_VGIC_CPU_SYSREGS ioctl. These registers are accessed
>>> as 64-bit. The cpu MPIDR value is passed along with register id.
>>> is used to identify the cpu for registers access.
>>>
>>> The version of VGIC v3 specification is define here
>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
>>>
>>> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
>>> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>>> ---
>>>  arch/arm64/include/uapi/asm/kvm.h   |   3 +
>>>  arch/arm64/kvm/Makefile             |   1 +
>>>  include/linux/irqchip/arm-gic-v3.h  |  32 ++++-
>>>  virt/kvm/arm/vgic/vgic-kvm-device.c |  27 ++++
>>>  virt/kvm/arm/vgic/vgic-mmio-v2.c    |  16 ---
>>>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |  18 +++
>>>  virt/kvm/arm/vgic/vgic-mmio.c       |  16 +++
>>>  virt/kvm/arm/vgic/vgic-sys-reg-v3.c | 261 ++++++++++++++++++++++++++++++++++++
>>>  virt/kvm/arm/vgic/vgic-v3.c         |   4 +
>>>  virt/kvm/arm/vgic/vgic.h            |  15 +++
>>>  10 files changed, 376 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>>> index 56dc08d..91c7137 100644
>>> --- a/arch/arm64/include/uapi/asm/kvm.h
>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>>> @@ -206,9 +206,12 @@ struct kvm_arch_memory_slot {
>>>                       (0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
>>>  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT      0
>>>  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK       (0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
>>> +#define   KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK (0xffff)
>>>  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS 3
>>>  #define KVM_DEV_ARM_VGIC_GRP_CTRL    4
>>>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
>>> +#define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
>>> +
>>>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT 0
>>>
>>>  /* Device Control API on vcpu fd */
>>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>>> index d50a82a..1a14e29 100644
>>> --- a/arch/arm64/kvm/Makefile
>>> +++ b/arch/arm64/kvm/Makefile
>>> @@ -32,5 +32,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
>>> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-sys-reg-v3.o
>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>>>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
>>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>>> index 99ac022..22ec183 100644
>>> --- a/include/linux/irqchip/arm-gic-v3.h
>>> +++ b/include/linux/irqchip/arm-gic-v3.h
>>> @@ -354,6 +354,24 @@
>>>   */
>>>  #define ICC_CTLR_EL1_EOImode_drop_dir        (0U << 1)
>>>  #define ICC_CTLR_EL1_EOImode_drop    (1U << 1)
>>> +#define ICC_CTLR_EL1_CBPR_SHIFT              (0)
>>> +#define ICC_CTLR_EL1_CBPR_MASK               (1 << ICC_CTLR_EL1_CBPR_SHIFT)
>>> +#define ICC_CTLR_EL1_EOImode_SHIFT   (1)
>>
>> Since you're adding this, please rewrite the two existing EOImode
>> macros to use this new define.
>>
>>> +#define ICC_CTLR_EL1_EOImode_MASK    (1 << ICC_CTLR_EL1_EOImode_SHIFT)
>>> +#define ICC_CTLR_EL1_PRI_BITS_SHIFT  (8)
>>> +#define ICC_CTLR_EL1_PRI_BITS_MASK   (0x7 << ICC_CTLR_EL1_PRI_BITS_SHIFT)
>>> +#define ICC_CTLR_EL1_ID_BITS_SHIFT   (11)
>>> +#define ICC_CTLR_EL1_ID_BITS_MASK    (0x7 << ICC_CTLR_EL1_ID_BITS_SHIFT)
>>> +#define ICC_PMR_EL1_SHIFT            (0)
>>> +#define ICC_PMR_EL1_MASK             (0xff << ICC_PMR_EL1_SHIFT)
>>> +#define ICC_BPR0_EL1_SHIFT           (0)
>>> +#define ICC_BPR0_EL1_MASK            (0x7 << ICC_PMR_EL1_SHIFT)
>>> +#define ICC_BPR1_EL1_SHIFT           (0)
>>> +#define ICC_BPR1_EL1_MASK            (0x7 << ICC_PMR_EL1_SHIFT)
>>> +#define ICC_IGRPEN0_EL1_SHIFT                (0)
>>> +#define ICC_IGRPEN0_EL1_MASK         (1 << ICC_IGRPEN0_EL1_SHIFT)
>>> +#define ICC_IGRPEN1_EL1_SHIFT                (0)
>>> +#define ICC_IGRPEN1_EL1_MASK         (1 << ICC_IGRPEN1_EL1_SHIFT)
>>>  #define ICC_SRE_EL1_SRE                      (1U << 0)
>>>
>>>  /*
>>> @@ -383,7 +401,19 @@
>>>  #define ICH_HCR_UIE                  (1 << 1)
>>>
>>>  #define ICH_VMCR_CTLR_SHIFT          0
>>> -#define ICH_VMCR_CTLR_MASK           (0x21f << ICH_VMCR_CTLR_SHIFT)
>>> +#define ICH_VMCR_CTLR_MASK           (0x210 << ICH_VMCR_CTLR_SHIFT)
>>
>> Why are you dropping the four control bits? You're now only covering
>> VEOIM and VCBPR. Worse, you don't even use that modified macro in this
>> patch.
> 
> I modified this macro to hold only VEOIM and VCBPR fields.
> For the rest of the fields VENG1 and VENG0, struct vmcr is added with
> vmcr.grpen0 and vmcr.grpen1 separately.
> 
>>
>>> +#define ICH_VMCR_CBPR_SHIFT          4
>>> +#define ICH_VMCR_CBPR_MASK           (1 << ICH_VMCR_CBPR_SHIFT)
>>> +#define ICH_VMCR_EOIM_SHIFT          9
>>> +#define ICH_VMCR_EOIM_MASK           (1 << ICH_VMCR_EOIM_SHIFT)
>>> +#define ICH_VMCR_ENG0_SHIFT          0
>>> +#define ICH_VMCR_ENG0_MASK           (1 << ICH_VMCR_ENG0_SHIFT)
>>> +#define ICH_VMCR_ENG1_SHIFT          1
>>> +#define ICH_VMCR_ENG1_MASK           (1 << ICH_VMCR_ENG1_SHIFT)
>>> +#define ICH_VMCR_ENG0_SHIFT          0
>>> +#define ICH_VMCR_ENG0                        (1 << ICH_VMCR_ENG0_SHIFT)
>>> +#define ICH_VMCR_ENG1_SHIFT          1
>>> +#define ICH_VMCR_ENG1                        (1 << ICH_VMCR_ENG1_SHIFT)
>>>  #define ICH_VMCR_BPR1_SHIFT          18
>>>  #define ICH_VMCR_BPR1_MASK           (7 << ICH_VMCR_BPR1_SHIFT)
>>>  #define ICH_VMCR_BPR0_SHIFT          21
>>
>> And here you're covering for all the bits. So what is now the purpose
>> of ICH_VMCR_CTLR_MASK now?
> 
> OK. Can be replaced with CBPR and VEOIM macros.
> 
>>
>> In general, I'd like this kind of change to be split from the rest of
>> the patch so that it can be reviewed independently by the irqchip
>> maintainers (tglx, Jason and myself).
>>
> OK. I will send separate patch for changing this macro and adding
> vmcr.grpen0 and vmcr.grpen1 fields to struct vmcr
> 
> [...]
>>> --- /dev/null
>>> +++ b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
>>> @@ -0,0 +1,261 @@
>>> +#include <linux/irqchip/arm-gic-v3.h>
>>> +#include <linux/kvm.h>
>>> +#include <linux/kvm_host.h>
>>> +#include <kvm/iodev.h>
>>> +#include <kvm/arm_vgic.h>
>>> +#include <asm/kvm_emulate.h>
>>> +#include <asm/kvm_arm.h>
>>> +#include <asm/kvm_mmu.h>
>>> +
>>> +#include "vgic.h"
>>> +#include "vgic-mmio.h"
>>> +#include "sys_regs.h"
>>> +
>>> +static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>> +                         const struct sys_reg_desc *r)
>>> +{
>>> +     struct vgic_vmcr vmcr;
>>> +     u64 val;
>>> +     u32 id_bits;
>>> +
>>> +     vgic_get_vmcr(vcpu, &vmcr);
>>> +     if (p->is_write) {
>>> +             val = p->regval;
>>> +             vmcr.ctlr &= ~(ICH_VMCR_CBPR_MASK | ICH_VMCR_EOIM_MASK);
>>> +             vmcr.ctlr |= ((val & ICC_CTLR_EL1_CBPR_MASK) >>
>>> +                           ICC_CTLR_EL1_CBPR_SHIFT) << ICH_VMCR_CBPR_SHIFT;
>>> +             vmcr.ctlr |= ((val & ICC_CTLR_EL1_EOImode_MASK) >>
>>> +                          ICC_CTLR_EL1_EOImode_SHIFT) << ICH_VMCR_EOIM_SHIFT;
>>> +             vgic_set_vmcr(vcpu, &vmcr);
>>
>> What if userspace writes something that is incompatible with the
>> current configuration? Wrong number of ID bits, or number of priorities?
> 
> IDand PRI bits of ICC_CTLR_EL1 are read only. Not updated

Read again. You're migrating from a machine that implements 24 bits of
INTD to one that has 16 bits. Are you going to silently accept a bogus
value and leave most of the interrupts as undeliverable?

> 
>>
>>> +     } else {
>>> +             val = 0;
>>> +             /* ICC_CTLR_EL1.A3V and ICC_CTRL_EL1.SEIS are not set */
>>> +             val |= VGIC_PRI_BITS << ICC_CTLR_EL1_PRI_BITS_SHIFT;
>>
>> Shouldn't that come from the actual HW?
> 
> Yes, want to expose only VGIC supported value instead of HW.

What does it mean? If the HW doesn't support that range of priority,
nothing will work anyway.

> 
>>
>>> +
>>> +             if (vgic_has_its(vcpu->kvm))
>>> +                     id_bits = INTERRUPT_ID_BITS_ITS;
>>> +             else
>>> +                     id_bits = INTERRUPT_ID_BITS_SPIS;
>>> +
>>> +             if (id_bits >= 24)
>>> +                     val |= (1 << ICC_CTLR_EL1_ID_BITS_SHIFT);
>>> +             else
>>> +                     val |= (0 << ICC_CTLR_EL1_ID_BITS_SHIFT);
>>> +
>>> +             val |= ((vmcr.ctlr & ICH_VMCR_CBPR_MASK) >>
>>> +                     ICH_VMCR_CBPR_SHIFT) << ICC_CTLR_EL1_CBPR_SHIFT;
>>> +             val |= ((vmcr.ctlr & ICH_VMCR_EOIM_MASK) >>
>>> +                     ICH_VMCR_EOIM_SHIFT) << ICC_CTLR_EL1_EOImode_SHIFT;
>>> +
>>> +             p->regval = val;
>>> +     }
>>> +
>>> +     return true;
>>> +}
>>> +
>>> +static bool access_gic_pmr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>> +                        const struct sys_reg_desc *r)
>>> +{
>>> +     struct vgic_vmcr vmcr;
>>> +
>>> +     vgic_get_vmcr(vcpu, &vmcr);
>>> +     if (p->is_write) {
>>> +             vmcr.pmr = (p->regval << ICC_PMR_EL1_SHIFT) & ICC_PMR_EL1_MASK;
>>
>> I don't get this. You're trying to extract a field from a register, and
>> yet you're starting by shifting it *up* before masking it. This only
>> works because your shift is 0. In general, I believe this should read:
>>
>>                 val = (regval & MASK) >> SHIFT;
>>
>>> +             vgic_set_vmcr(vcpu, &vmcr);
>>> +     } else {
>>> +             p->regval = (vmcr.pmr & ICC_PMR_EL1_MASK) >> ICC_PMR_EL1_SHIFT;
>>
>> and this the other way around.
>>
>>> +     }
>>> +
>>> +     return true;
>>> +}
>>> +
>>> +static bool access_gic_bpr0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>> +                         const struct sys_reg_desc *r)
>>> +{
>>> +     struct vgic_vmcr vmcr;
>>> +
>>> +     vgic_get_vmcr(vcpu, &vmcr);
>>> +     if (p->is_write) {
>>> +             vmcr.bpr = (p->regval << ICC_BPR0_EL1_SHIFT) &
>>> +                         ICC_BPR0_EL1_MASK;
>>> +             vgic_set_vmcr(vcpu, &vmcr);
>>> +     } else {
>>> +             p->regval = (vmcr.bpr & ICC_BPR0_EL1_MASK) >>
>>> +                          ICC_BPR0_EL1_SHIFT;
>>> +     }
>>
>> Same problems (and I'll stop commenting on this issue).
>>
>>> +
>>> +     return true;
>>> +}
>>> +
>>> +static bool access_gic_bpr1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>> +                         const struct sys_reg_desc *r)
>>> +{
>>> +     struct vgic_vmcr vmcr;
>>> +
>>> +     vgic_get_vmcr(vcpu, &vmcr);
>>> +     if (p->is_write) {
>>> +             vmcr.abpr = (p->regval << ICC_BPR1_EL1_SHIFT) &
>>> +                          ICC_BPR1_EL1_MASK;
>>
>> nit: I'd prefer it if the binary points were called bpr0 and bpr1
>> instead of bpr and abpr.
>>
>>> +             vgic_set_vmcr(vcpu, &vmcr);
>>> +     } else {
>>> +             p->regval = (vmcr.abpr & ICC_BPR1_EL1_MASK) >>
>>> +                          ICC_BPR1_EL1_SHIFT;
>>> +     }
>>
>> Shouldn't this account for the ICC_CTLR_EL1.CBPR setting?
>>
>>> +
>>> +     return true;
>>> +}
>>> +
>>> +static bool access_gic_grpen0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>> +                           const struct sys_reg_desc *r)
>>> +{
>>> +     struct vgic_vmcr vmcr;
>>> +
>>> +     vgic_get_vmcr(vcpu, &vmcr);
>>> +     if (p->is_write) {
>>> +             vmcr.grpen0 = (p->regval << ICC_IGRPEN0_EL1_SHIFT) &
>>> +                                   ICC_IGRPEN0_EL1_MASK;
>>> +             vgic_set_vmcr(vcpu, &vmcr);
>>> +     } else {
>>> +             p->regval = (vmcr.grpen0 & ICC_IGRPEN0_EL1_MASK) >>
>>> +                          ICC_IGRPEN0_EL1_SHIFT;
>>> +     }
>>> +
>>> +     return true;
>>> +}
>>> +
>>> +static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>> +                           const struct sys_reg_desc *r)
>>> +{
>>> +     struct vgic_vmcr vmcr;
>>> +
>>> +     vgic_get_vmcr(vcpu, &vmcr);
>>> +     if (p->is_write) {
>>> +             vmcr.grpen1 = (p->regval << ICC_IGRPEN1_EL1_SHIFT) &
>>> +                                   ICC_IGRPEN1_EL1_MASK;
>>> +             vgic_set_vmcr(vcpu, &vmcr);
>>> +     } else {
>>> +             p->regval = (vmcr.grpen1 & ICC_IGRPEN1_EL1_MASK) >>
>>> +                          ICC_IGRPEN1_EL1_SHIFT;
>>> +     }
>>> +
>>> +     return true;
>>> +}
>>> +
>>> +static bool access_gic_ap0r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>> +                         const struct sys_reg_desc *r)
>>> +{
>>> +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
>>> +     u8 idx = r->Op2 & 3;
>>> +
>>> +     if (p->is_write)
>>> +             vgicv3->vgic_ap0r[idx] = p->regval;
>>
>> What if some of the priority levels are not implemented? Restoring such
>> an active priority will result in a VM that silently breaks.
> 
> You suggest to read vtr_to_nr_pri_bits() i.e ICH_VTR_EL2.PRIbits
> and save/restore only required apr registers?

I strongly suggest that if you restore active priorities that are
outside of what the HW can represent, then the only possible value is zero.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
