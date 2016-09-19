From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [PATCH 5/6] arm/arm64: vgic-new: Implement VGICv3 CPU interface
 access
Date: Mon, 19 Sep 2016 13:06:53 +0530
Message-ID: <CALicx6s=FOVv8t-6s4VJYwqUGaCfqMxrjXuop=JX6UYrYVj7Fg@mail.gmail.com>
References: <1474028453-29132-1-git-send-email-vijay.kilari@gmail.com>
 <1474028453-29132-6-git-send-email-vijay.kilari@gmail.com>
 <57DC0366.8060304@arm.com>
 <CALicx6u-uYLY3DtDGMh3n6NbNH3kD9fn9aYHHJC=LVUQfFjTsQ@mail.gmail.com>
 <57DC26C5.2060800@arm.com>
 <CALicx6ucEH3w58Rhb8Urk0V5kRcqtUdwDYDtSLXrkas-Jatv=A@mail.gmail.com>
 <20160917123756.0a05a904@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA48F410EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2016 03:27:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6hs9aAXNXhNY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2016 03:27:54 -0400 (EDT)
Received: from mail-yw0-f196.google.com (mail-yw0-f196.google.com
 [209.85.161.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E053B410B5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2016 03:27:54 -0400 (EDT)
Received: by mail-yw0-f196.google.com with SMTP id u82so7337397ywc.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2016 00:36:54 -0700 (PDT)
In-Reply-To: <20160917123756.0a05a904@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc , Peter

On Sat, Sep 17, 2016 at 5:07 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On Sat, 17 Sep 2016 11:58:48 +0530
> Vijay Kilari <vijay.kilari@gmail.com> wrote:
>
>> On Fri, Sep 16, 2016 at 10:37 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> > On 16/09/16 17:57, Vijay Kilari wrote:
>> >> On Fri, Sep 16, 2016 at 8:06 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> >>> On 16/09/16 13:20, vijay.kilari@gmail.com wrote:
>> >>>> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>> >>>>
>> >>>> VGICv3 CPU interface registers are accessed using
>> >>>> KVM_DEV_ARM_VGIC_CPU_SYSREGS ioctl. These registers are accessed
>> >>>> as 64-bit. The cpu MPIDR value is passed along with register id.
>> >>>> is used to identify the cpu for registers access.
>> >>>>
>> >>>> The version of VGIC v3 specification is define here
>> >>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
>> >>>>
>> >>>> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
>> >>>> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>> >>>> ---
>> >>>>  arch/arm64/include/uapi/asm/kvm.h   |   3 +
>> >>>>  arch/arm64/kvm/Makefile             |   1 +
>> >>>>  include/linux/irqchip/arm-gic-v3.h  |  30 ++++
>> >>>>  virt/kvm/arm/vgic/vgic-kvm-device.c |  27 ++++
>> >>>>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |  18 +++
>> >>>>  virt/kvm/arm/vgic/vgic-sys-reg-v3.c | 296 ++++++++++++++++++++++++++++++++++++
>> >>>>  virt/kvm/arm/vgic/vgic.h            |  10 ++
>> >>>>  7 files changed, 385 insertions(+)
>> >
>> > [...]
>> >
>> >>>> diff --git a/virt/kvm/arm/vgic/vgic-sys-reg-v3.c b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
>> >>>> new file mode 100644
>> >>>> index 0000000..8e4f403
>> >>>> --- /dev/null
>> >>>> +++ b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
>> >>>> @@ -0,0 +1,296 @@
>> >>>> +#include <linux/irqchip/arm-gic-v3.h>
>> >>>> +#include <linux/kvm.h>
>> >>>> +#include <linux/kvm_host.h>
>> >>>> +#include <kvm/iodev.h>
>> >>>> +#include <kvm/arm_vgic.h>
>> >>>> +#include <asm/kvm_emulate.h>
>> >>>> +#include <asm/kvm_arm.h>
>> >>>> +#include <asm/kvm_mmu.h>
>> >>>> +
>> >>>> +#include "vgic.h"
>> >>>> +#include "vgic-mmio.h"
>> >>>> +#include "sys_regs.h"
>> >>>> +
>> >>>> +static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> >>>> +                         const struct sys_reg_desc *r)
>> >>>> +{
>> >>>> +     struct vgic_vmcr vmcr;
>> >>>> +     u64 val;
>> >>>> +     u32 ich_vtr;
>> >>>> +
>> >>>> +     vgic_get_vmcr(vcpu, &vmcr);
>> >>>> +     if (p->is_write) {
>> >>>> +             val = p->regval;
>> >>>> +             vmcr.ctlr &= ~(ICH_VMCR_CBPR_MASK | ICH_VMCR_EOIM_MASK);
>> >>>> +             vmcr.ctlr |= ((val & ICC_CTLR_EL1_CBPR_MASK) >>
>> >>>> +                           ICC_CTLR_EL1_CBPR_SHIFT) << ICH_VMCR_CBPR_SHIFT;
>> >>>> +             vmcr.ctlr |= ((val & ICC_CTLR_EL1_EOImode_MASK) >>
>> >>>> +                          ICC_CTLR_EL1_EOImode_SHIFT) << ICH_VMCR_EOIM_SHIFT;
>> >>>> +             vgic_set_vmcr(vcpu, &vmcr);
>> >>>
>> >>> You've ignored my comments again: "What if userspace writes something
>> >>> that is incompatible with the current configuration? Wrong number of ID
>> >>> bits, or number of priorities?"
>> >>
>> >> IMO, In case of incompatibility,
>> >> If ID bits and PRI bits are less than HW supported, it is ok.
>> >
>> > Yes. But you also need to track of what the guest has programmed in
>> > order to be able to migrate it back to its original configuration.
>>
>> You mean the vgic has to track/store the ID and PRI bits that guest
>> has programmed
>> and return the same when guest reads back instead of
>> returning HW supported value for ICC_CTLR_EL1 reg access?.
>
> If you have two hosts (A and B), A having 5 bits of priority and B
> having 7 bits, you should be able to migrate from A to B, and then from
> B to A. Which means you have to preserve what the guest knows to be its
> configuration, even if you run on a more capable system. Otherwise,
> you're a bit stuck.
>
> You probably won't be able to hide the discrepancy from inside the
> guest though (the guest will be able to observe the change), but this
> is better than nothing.

In order to track the PRI and ID bits written by guest,
VGIC needs to store these values when ICC_CTRL_EL1 is updated.
However,  QEMU is reseting VGIC by writing 0's to all the
registers after VGIC initialization and hence the back up values are
always reset to 0 and hence when guest read back, VGIC returns wrong value.

One option is to drop VGIC reset from QEMU which is not doing much.
