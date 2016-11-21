From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [PATCH v8 6/7] arm/arm64: vgic: Implement VGICv3 CPU interface
 access
Date: Mon, 21 Nov 2016 18:56:08 +0530
Message-ID: <CALicx6snqsSbaKYcj9kt0nt8y2wdTbrY1PKOq-SrGTepCfSZSg@mail.gmail.com>
References: <1478258013-6669-1-git-send-email-vijay.kilari@gmail.com>
 <1478258013-6669-7-git-send-email-vijay.kilari@gmail.com>
 <20161116185232.GF3811@cbox>
 <CALicx6t5D5n3dDQzeKZNUWdS-q5LNiSq-UrP4HdmbdUCj1tF1g@mail.gmail.com>
 <20161117160951.GB23588@cbox>
 <CALicx6uia5_H5Zg_x6GP0nKgZi_513w97igCuDdezySOUNQtBw@mail.gmail.com>
 <20161121101930.GD23588@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E54B040284
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 08:25:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JmRvUWO0Z02b for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Nov 2016 08:25:33 -0500 (EST)
Received: from mail-oi0-f68.google.com (mail-oi0-f68.google.com
 [209.85.218.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E85E4027C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 08:25:32 -0500 (EST)
Received: by mail-oi0-f68.google.com with SMTP id f201so18384445oib.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 05:26:11 -0800 (PST)
In-Reply-To: <20161121101930.GD23588@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 21, 2016 at 3:49 PM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Fri, Nov 18, 2016 at 10:28:34PM +0530, Vijay Kilari wrote:
>> On Thu, Nov 17, 2016 at 9:39 PM, Christoffer Dall
>> <christoffer.dall@linaro.org> wrote:
>> > On Thu, Nov 17, 2016 at 09:25:59PM +0530, Vijay Kilari wrote:
>> >> On Thu, Nov 17, 2016 at 12:22 AM, Christoffer Dall
>> >> <christoffer.dall@linaro.org> wrote:
>> >> > On Fri, Nov 04, 2016 at 04:43:32PM +0530, vijay.kilari@gmail.com wrote:
>> >> >> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>> >> >>
>> >> >> VGICv3 CPU interface registers are accessed using
>> >> >> KVM_DEV_ARM_VGIC_CPU_SYSREGS ioctl. These registers are accessed
>> >> >> as 64-bit. The cpu MPIDR value is passed along with register id.
>> >> >> is used to identify the cpu for registers access.
>> >> >>
>> >> >> The version of VGIC v3 specification is define here
>> >> >> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
>> >> >>
>> >> >> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
>> >> >> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>> >> >> ---
>> >> >>  arch/arm64/include/uapi/asm/kvm.h   |   3 +
>> >> >>  arch/arm64/kvm/Makefile             |   1 +
>> >> >>  include/kvm/arm_vgic.h              |   9 +
>> >> >>  virt/kvm/arm/vgic/vgic-kvm-device.c |  27 +++
>> >> >>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |  19 +++
>> >> >>  virt/kvm/arm/vgic/vgic-sys-reg-v3.c | 324 ++++++++++++++++++++++++++++++++++++
>> >> >>  virt/kvm/arm/vgic/vgic-v3.c         |   8 +
>> >> >>  virt/kvm/arm/vgic/vgic.h            |   4 +
>> >> >>  8 files changed, 395 insertions(+)
>> >> >>
>> >> >> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>> >> >> index 56dc08d..91c7137 100644
>> >> >> --- a/arch/arm64/include/uapi/asm/kvm.h
>> >> >> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> >> >> @@ -206,9 +206,12 @@ struct kvm_arch_memory_slot {
>> >> >>                       (0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
>> >> >>  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT      0
>> >> >>  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK       (0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
>> >> >> +#define   KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK (0xffff)
>> >> >>  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS 3
>> >> >>  #define KVM_DEV_ARM_VGIC_GRP_CTRL    4
>> >> >>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
>> >> >> +#define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
>> >> >> +
>> >> >>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT 0
>> >> >>
>> >> >>  /* Device Control API on vcpu fd */
>> >> >> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> >> >> index d50a82a..1a14e29 100644
>> >> >> --- a/arch/arm64/kvm/Makefile
>> >> >> +++ b/arch/arm64/kvm/Makefile
>> >> >> @@ -32,5 +32,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
>> >> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
>> >> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
>> >> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
>> >> >> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-sys-reg-v3.o
>> >> >
>> >> > Thi is making me wonder:  Are we properly handling GICv3 save/restore
>> >> > for AArch32 now that we have GICv3 support for AArch32?  By properly I
>> >> > mean that either it is clearly only supported on AArch64 systems or it's
>> >> > supported on both AArch64 and AArch32, but it shouldn't break randomly
>> >> > on AArch32.
>> >>
>> >> It supports both AArch64 and AArch64 in handling of system registers
>> >> save/restore.
>> >> All system registers that we save/restore are 32-bit for both aarch64
>> >> and aarch32.
>> >> Though opcode op0 should be zero for aarch32, the remaining Op and CRn codes
>> >> are same. However the codes sent by qemu is matched and register
>> >> are handled properly irrespective of AArch32 or AArch64.
>> >>
>> >> I don't have platform which support AArch32 guests to verify.
>> >
>> > Actually this is not about the guest, it's about an ARMv8 AArch32 host
>> > that has a GICv3.
>> >
>> > I just tried to do a v7 compile with your patches, and it results in an
>> > epic failure, so there's something for you to look at.
>> >
>> >> >
>> >> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>> >> >>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
>> >> >> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> >> >> index 002f092..730a18a 100644
>> >> >> --- a/include/kvm/arm_vgic.h
>> >> >> +++ b/include/kvm/arm_vgic.h
>> >> >> @@ -71,6 +71,9 @@ struct vgic_global {
>> >> >>
>> >> >>       /* GIC system register CPU interface */
>> >> >>       struct static_key_false gicv3_cpuif;
>> >> >> +
>> >> >> +     /* Cache ICH_VTR_EL2 reg value */
>> >> >> +     u32                     ich_vtr_el2;
>> >> >>  };
>> >> >>
>> >> >>  extern struct vgic_global kvm_vgic_global_state;
>> >> >> @@ -269,6 +272,12 @@ struct vgic_cpu {
>> >> >>       u64 pendbaser;
>> >> >>
>> >> >>       bool lpis_enabled;
>> >> >> +
>> >> >> +     /* Cache guest priority bits */
>> >> >> +     u32 num_pri_bits;
>> >> >> +
>> >> >> +     /* Cache guest interrupt ID bits */
>> >> >> +     u32 num_id_bits;
>> >> >>  };
>> >> >>
>> >> >>  extern struct static_key_false vgic_v2_cpuif_trap;
>> >> >> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> >> >> index 6c7d30c..da532d1 100644
>> >> >> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
>> >> >> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> >> >> @@ -504,6 +504,14 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>> >> >>               if (!is_write)
>> >> >>                       *reg = tmp32;
>> >> >>               break;
>> >> >> +     case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
>> >> >> +             u64 regid;
>> >> >> +
>> >> >> +             regid = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
>> >> >> +             ret = vgic_v3_cpu_sysregs_uaccess(vcpu, is_write,
>> >> >> +                                               regid, reg);
>> >> >> +             break;
>> >> >> +     }
>> >> >>       default:
>> >> >>               ret = -EINVAL;
>> >> >>               break;
>> >> >> @@ -537,6 +545,15 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>> >> >>               reg = tmp32;
>> >> >>               return vgic_v3_attr_regs_access(dev, attr, &reg, true);
>> >> >>       }
>> >> >> +     case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
>> >> >> +             u64 __user *uaddr = (u64 __user *)(long)attr->addr;
>> >> >> +             u64 reg;
>> >> >> +
>> >> >> +             if (get_user(reg, uaddr))
>> >> >> +                     return -EFAULT;
>> >> >> +
>> >> >> +             return vgic_v3_attr_regs_access(dev, attr, &reg, true);
>> >> >> +     }
>> >> >>       }
>> >> >>       return -ENXIO;
>> >> >>  }
>> >> >> @@ -563,6 +580,15 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
>> >> >>               tmp32 = reg;
>> >> >>               return put_user(tmp32, uaddr);
>> >> >>       }
>> >> >> +     case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
>> >> >> +             u64 __user *uaddr = (u64 __user *)(long)attr->addr;
>> >> >> +             u64 reg;
>> >> >> +
>> >> >> +             ret = vgic_v3_attr_regs_access(dev, attr, &reg, false);
>> >> >> +             if (ret)
>> >> >> +                     return ret;
>> >> >> +             return put_user(reg, uaddr);
>> >> >> +     }
>> >> >>       }
>> >> >>
>> >> >>       return -ENXIO;
>> >> >> @@ -581,6 +607,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>> >> >>               break;
>> >> >>       case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>> >> >>       case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
>> >> >> +     case KVM_DEV_ARM_VGIC_CPU_SYSREGS:
>> >> >>               return vgic_v3_has_attr_regs(dev, attr);
>> >> >>       case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>> >> >>               return 0;
>> >> >> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> >> >> index b35fb83..519b919 100644
>> >> >> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> >> >> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> >> >> @@ -23,6 +23,7 @@
>> >> >>
>> >> >>  #include "vgic.h"
>> >> >>  #include "vgic-mmio.h"
>> >> >> +#include "sys_regs.h"
>> >> >>
>> >> >>  /* extract @num bytes at @offset bytes offset in data */
>> >> >>  unsigned long extract_bytes(u64 data, unsigned int offset,
>> >> >> @@ -639,6 +640,24 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>> >> >>               nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
>> >> >>               break;
>> >> >>       }
>> >> >> +     case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
>> >> >> +             u64 reg, id;
>> >> >> +             unsigned long vgic_mpidr, mpidr_reg;
>> >> >> +             struct kvm_vcpu *vcpu;
>> >> >> +
>> >> >> +             vgic_mpidr = (attr->attr & KVM_DEV_ARM_VGIC_V3_MPIDR_MASK) >>
>> >> >> +                           KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT;
>> >> >> +
>> >> >> +             /* Convert plain mpidr value to MPIDR reg format */
>> >> >> +             mpidr_reg = VGIC_TO_MPIDR(vgic_mpidr);
>> >> >> +
>> >> >> +             vcpu = kvm_mpidr_to_vcpu(dev->kvm, mpidr_reg);
>> >> >> +             if (!vcpu)
>> >> >> +                     return -EINVAL;
>> >> >> +
>> >> >> +             id = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
>> >> >> +             return vgic_v3_has_cpu_sysregs_attr(vcpu, 0, id, &reg);
>> >> >> +     }
>> >> >>       default:
>> >> >>               return -ENXIO;
>> >> >>       }
>> >> >> diff --git a/virt/kvm/arm/vgic/vgic-sys-reg-v3.c b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
>> >> >> new file mode 100644
>> >> >> index 0000000..69d8597
>> >> >> --- /dev/null
>> >> >> +++ b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
>> >> >
>> >> > Shouldn't we have a GPL header here?
>> >> >
>> >> >> @@ -0,0 +1,324 @@
>> >> >> +#include <linux/irqchip/arm-gic-v3.h>
>> >> >> +#include <linux/kvm.h>
>> >> >> +#include <linux/kvm_host.h>
>> >> >> +#include <kvm/iodev.h>
>> >> >> +#include <kvm/arm_vgic.h>
>> >> >> +#include <asm/kvm_emulate.h>
>> >> >> +#include <asm/kvm_arm.h>
>> >> >> +#include <asm/kvm_mmu.h>
>> >> >> +
>> >> >> +#include "vgic.h"
>> >> >> +#include "vgic-mmio.h"
>> >> >> +#include "sys_regs.h"
>> >> >> +
>> >> >> +static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> >> >> +                         const struct sys_reg_desc *r)
>> >> >> +{
>> >> >> +     struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
>> >> >> +     struct vgic_vmcr vmcr;
>> >> >> +     u64 val;
>> >> >> +     u32 num_pri_bits, num_id_bits;
>> >> >> +
>> >> >> +     vgic_get_vmcr(vcpu, &vmcr);
>> >> >> +     if (p->is_write) {
>> >> >> +             val = p->regval;
>> >> >> +
>> >> >> +             /*
>> >> >> +              * Does not allow update of ICC_CTLR_EL1 if HW does not support
>> >> >> +              * guest programmed ID and PRI bits
>> >> >> +              */
>> >> >
>> >> > I would suggest rewording this comment:
>> >> > Disallow restoring VM state not supported by this hardware.
>> >> >
>> >> >> +             num_pri_bits = ((val & ICC_CTLR_EL1_PRI_BITS_MASK) >>
>> >> >> +                             ICC_CTLR_EL1_PRI_BITS_SHIFT) + 1;
>> >> >> +             if (num_pri_bits > vgic_v3_cpu->num_pri_bits)
>> >> >> +                     return false;
>> >> >> +
>> >> >> +             vgic_v3_cpu->num_pri_bits = num_pri_bits;
>> >> >
>> >> > hmmm, this looks weird to me, because vgic_v3_cpu->num_pri_bits I don't
>> >> > understand which effect this is intended to have?
>> >> >
>> >> > Sure, it may limit what you do with other registers later, but since
>> >> > there's no ordering requirement that the ctlr be restored first, I'm not
>> >> > sure it makes sense.
>> >> >
>> >> > Also, since this field is RO in the ICH_VTR, we'll have a strange
>> >> > situation during runtime after a GICv3 restore where the
>> >> > vgic_v3_cpu->num_pri_its differs from the hardware's ICH_VTR_EL2 field,
>> >> > which is never the case if you didn't do a save/restore.
>> >>
>> >> Yes, but in any case, vgic_v3_cpu->num_pri_bits will be always less
>> >> than HW supported
>> >> value.
>> >>
>> >
>> > So answer my question:  What is the intended effect of writing this
>> > value?  Is it just so that if you migrate this platform back again, then
>> > you're checking compatibility with what the guest would potentially do,
>>
>> Yes
>
> Then add a comment explaining that
>
>> and also to limit the valid aprn registers access as you said above.
>> But that has ordering restriction. Which I think we should follow.
>>
>
> I'm sorry, now I'm confused.  Is there an ordering requirement in the
> API, or how should we follow this?

There is  no ordering requirement mentioned in the API doc.
However the APRn registers depends on num_pri_bits. Hence first
ICC_CTLR_EL1 should be restored  before APRn restore.

If ordering is not followed then APRn registers restore is allowed
as per hw supported num_pri_bits.

This should be mentioned in doc.
