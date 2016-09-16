From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 5/6] arm/arm64: vgic-new: Implement VGICv3 CPU interface
 access
Date: Fri, 16 Sep 2016 18:07:17 +0100
Message-ID: <57DC26C5.2060800@arm.com>
References: <1474028453-29132-1-git-send-email-vijay.kilari@gmail.com>
 <1474028453-29132-6-git-send-email-vijay.kilari@gmail.com>
 <57DC0366.8060304@arm.com>
 <CALicx6u-uYLY3DtDGMh3n6NbNH3kD9fn9aYHHJC=LVUQfFjTsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5DD2412A6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 12:58:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c138hUUR7YX6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2016 12:58:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC834410B5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 12:58:27 -0400 (EDT)
In-Reply-To: <CALicx6u-uYLY3DtDGMh3n6NbNH3kD9fn9aYHHJC=LVUQfFjTsQ@mail.gmail.com>
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

On 16/09/16 17:57, Vijay Kilari wrote:
> On Fri, Sep 16, 2016 at 8:06 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 16/09/16 13:20, vijay.kilari@gmail.com wrote:
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
>>>  include/linux/irqchip/arm-gic-v3.h  |  30 ++++
>>>  virt/kvm/arm/vgic/vgic-kvm-device.c |  27 ++++
>>>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |  18 +++
>>>  virt/kvm/arm/vgic/vgic-sys-reg-v3.c | 296 ++++++++++++++++++++++++++++++++++++
>>>  virt/kvm/arm/vgic/vgic.h            |  10 ++
>>>  7 files changed, 385 insertions(+)

[...]

>>> diff --git a/virt/kvm/arm/vgic/vgic-sys-reg-v3.c b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
>>> new file mode 100644
>>> index 0000000..8e4f403
>>> --- /dev/null
>>> +++ b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
>>> @@ -0,0 +1,296 @@
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
>>> +     u32 ich_vtr;
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
>> You've ignored my comments again: "What if userspace writes something
>> that is incompatible with the current configuration? Wrong number of ID
>> bits, or number of priorities?"
> 
> IMO, In case of incompatibility,
> If ID bits and PRI bits are less than HW supported, it is ok.

Yes. But you also need to track of what the guest has programmed in
order to be able to migrate it back to its original configuration.

> If ID bits and PRI bits are greater than HW supported, then warn would be good
> enough. Please suggest the behaviour that you think it should be.

No, it is an error, plain and simple. You cannot run in this condition.

> 
>>
>>> +     } else {
>>> +             ich_vtr = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
>>> +
>>> +             val = 0;
>>> +             val |= ((ich_vtr & ICH_VTR_PRI_BITS_MASK) >>
>>> +                     ICH_VTR_PRI_BITS_SHIFT) << ICC_CTLR_EL1_PRI_BITS_SHIFT;
>>> +             val |= ((ich_vtr & ICH_VTR_ID_BITS_MASK) >>
>>> +                     ICH_VTR_ID_BITS_SHIFT) << ICC_CTLR_EL1_ID_BITS_SHIFT;
>>> +             val |= ((ich_vtr & ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT)
>>> +                     << ICC_CTLR_EL1_SEIS_SHIFT;
>>> +             val |= ((ich_vtr & ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT)
>>> +                     << ICC_CTLR_EL1_A3V_SHIFT;
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
>>> +             vmcr.pmr = (p->regval & ICC_PMR_EL1_MASK) >> ICC_PMR_EL1_SHIFT;
>>> +             vgic_set_vmcr(vcpu, &vmcr);
>>> +     } else {
>>> +             p->regval = (vmcr.pmr << ICC_PMR_EL1_SHIFT) & ICC_PMR_EL1_MASK;
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
>>> +             vmcr.bpr = (p->regval & ICC_BPR0_EL1_MASK) >>
>>> +                         ICC_BPR0_EL1_SHIFT;
>>> +             vgic_set_vmcr(vcpu, &vmcr);
>>> +     } else {
>>> +             p->regval = (vmcr.bpr << ICC_BPR0_EL1_SHIFT) &
>>> +                          ICC_BPR0_EL1_MASK;
>>> +     }
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
>>> +             vmcr.abpr = (p->regval & ICC_BPR1_EL1_MASK) >>
>>> +                          ICC_BPR1_EL1_SHIFT;
>>> +             vgic_set_vmcr(vcpu, &vmcr);
>>> +     } else {
>>> +             p->regval = (vmcr.abpr << ICC_BPR1_EL1_SHIFT) &
>>> +                          ICC_BPR1_EL1_MASK;
>>> +     }
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
>>> +             vmcr.grpen0 = (p->regval & ICC_IGRPEN0_EL1_MASK) >>
>>> +                                   ICC_IGRPEN0_EL1_SHIFT;
>>> +             vgic_set_vmcr(vcpu, &vmcr);
>>> +     } else {
>>> +             p->regval = (vmcr.grpen0 << ICC_IGRPEN0_EL1_SHIFT) &
>>> +                          ICC_IGRPEN0_EL1_MASK;
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
>>> +             vmcr.grpen1 = (p->regval & ICC_IGRPEN1_EL1_MASK) >>
>>> +                                   ICC_IGRPEN1_EL1_SHIFT;
>>> +             vgic_set_vmcr(vcpu, &vmcr);
>>> +     } else {
>>> +             p->regval = (vmcr.grpen1 << ICC_IGRPEN1_EL1_SHIFT) &
>>> +                          ICC_IGRPEN1_EL1_MASK;
>>
>> From the previous review comments: "Shouldn't this account for the
>> ICC_CTLR_EL1.CBPR setting?"
> 
>  Ok. I think this comment is for ICC_BPR1_EL1 access.

Yes, sorry about the misplaced comment.

> I will make a check on ICC_CTLR.EL1.CBPR for accessing ICC_BPR1_EL1.

The reverse is also true: you also need to account the value of
ICC_BPR1_EL1 when accessing ICC_CTLR_EL1.

>>
>>> +     }
>>> +
>>> +     return true;
>>> +}
>>> +
>>> +static void vgic_v3_access_apr_reg(struct kvm_vcpu *vcpu,
>>> +                                struct sys_reg_params *p, u8 apr, u8 idx)
>>> +{
>>> +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
>>> +     uint32_t *ap_reg;
>>> +
>>> +     if (apr)
>>> +             ap_reg = &vgicv3->vgic_ap1r[idx];
>>> +     else
>>> +             ap_reg = &vgicv3->vgic_ap0r[idx];
>>> +
>>> +     if (p->is_write)
>>> +             *ap_reg = p->regval;
>>> +     else
>>> +             p->regval = *ap_reg;
>>> +}
>>> +
>>> +static void access_gic_aprn(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>> +                         const struct sys_reg_desc *r, u8 apr)
>>> +{
>>> +     u8 num_pri_bits, idx;
>>> +     u32 ich_vtr = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
>>
>> Maybe you should cache this once and for all? It is fairly unlikely to
>> change over time...
> 
> Is it ok to cache in vgic_global struct?

I can't see why not.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
