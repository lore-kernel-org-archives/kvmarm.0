From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 6/7] arm/arm64: vgic: Implement VGICv3 CPU interface
 access
Date: Mon, 21 Nov 2016 11:19:30 +0100
Message-ID: <20161121101930.GD23588@cbox>
References: <1478258013-6669-1-git-send-email-vijay.kilari@gmail.com>
 <1478258013-6669-7-git-send-email-vijay.kilari@gmail.com>
 <20161116185232.GF3811@cbox>
 <CALicx6t5D5n3dDQzeKZNUWdS-q5LNiSq-UrP4HdmbdUCj1tF1g@mail.gmail.com>
 <20161117160951.GB23588@cbox>
 <CALicx6uia5_H5Zg_x6GP0nKgZi_513w97igCuDdezySOUNQtBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF22A404E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 05:19:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xn8cvnqef7PZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Nov 2016 05:19:01 -0500 (EST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DA4140293
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 05:19:00 -0500 (EST)
Received: by mail-wm0-f44.google.com with SMTP id g23so137852417wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 02:19:39 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CALicx6uia5_H5Zg_x6GP0nKgZi_513w97igCuDdezySOUNQtBw@mail.gmail.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 18, 2016 at 10:28:34PM +0530, Vijay Kilari wrote:
> On Thu, Nov 17, 2016 at 9:39 PM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Thu, Nov 17, 2016 at 09:25:59PM +0530, Vijay Kilari wrote:
> >> On Thu, Nov 17, 2016 at 12:22 AM, Christoffer Dall
> >> <christoffer.dall@linaro.org> wrote:
> >> > On Fri, Nov 04, 2016 at 04:43:32PM +0530, vijay.kilari@gmail.com wrote:
> >> >> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >> >>
> >> >> VGICv3 CPU interface registers are accessed using
> >> >> KVM_DEV_ARM_VGIC_CPU_SYSREGS ioctl. These registers are accessed
> >> >> as 64-bit. The cpu MPIDR value is passed along with register id.
> >> >> is used to identify the cpu for registers access.
> >> >>
> >> >> The version of VGIC v3 specification is define here
> >> >> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
> >> >>
> >> >> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> >> >> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >> >> ---
> >> >>  arch/arm64/include/uapi/asm/kvm.h   |   3 +
> >> >>  arch/arm64/kvm/Makefile             |   1 +
> >> >>  include/kvm/arm_vgic.h              |   9 +
> >> >>  virt/kvm/arm/vgic/vgic-kvm-device.c |  27 +++
> >> >>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |  19 +++
> >> >>  virt/kvm/arm/vgic/vgic-sys-reg-v3.c | 324 ++++++++++++++++++++++++++++++++++++
> >> >>  virt/kvm/arm/vgic/vgic-v3.c         |   8 +
> >> >>  virt/kvm/arm/vgic/vgic.h            |   4 +
> >> >>  8 files changed, 395 insertions(+)
> >> >>
> >> >> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> >> >> index 56dc08d..91c7137 100644
> >> >> --- a/arch/arm64/include/uapi/asm/kvm.h
> >> >> +++ b/arch/arm64/include/uapi/asm/kvm.h
> >> >> @@ -206,9 +206,12 @@ struct kvm_arch_memory_slot {
> >> >>                       (0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
> >> >>  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT      0
> >> >>  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK       (0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
> >> >> +#define   KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK (0xffff)
> >> >>  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS 3
> >> >>  #define KVM_DEV_ARM_VGIC_GRP_CTRL    4
> >> >>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
> >> >> +#define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
> >> >> +
> >> >>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT 0
> >> >>
> >> >>  /* Device Control API on vcpu fd */
> >> >> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> >> >> index d50a82a..1a14e29 100644
> >> >> --- a/arch/arm64/kvm/Makefile
> >> >> +++ b/arch/arm64/kvm/Makefile
> >> >> @@ -32,5 +32,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
> >> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
> >> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
> >> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
> >> >> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-sys-reg-v3.o
> >> >
> >> > Thi is making me wonder:  Are we properly handling GICv3 save/restore
> >> > for AArch32 now that we have GICv3 support for AArch32?  By properly I
> >> > mean that either it is clearly only supported on AArch64 systems or it's
> >> > supported on both AArch64 and AArch32, but it shouldn't break randomly
> >> > on AArch32.
> >>
> >> It supports both AArch64 and AArch64 in handling of system registers
> >> save/restore.
> >> All system registers that we save/restore are 32-bit for both aarch64
> >> and aarch32.
> >> Though opcode op0 should be zero for aarch32, the remaining Op and CRn codes
> >> are same. However the codes sent by qemu is matched and register
> >> are handled properly irrespective of AArch32 or AArch64.
> >>
> >> I don't have platform which support AArch32 guests to verify.
> >
> > Actually this is not about the guest, it's about an ARMv8 AArch32 host
> > that has a GICv3.
> >
> > I just tried to do a v7 compile with your patches, and it results in an
> > epic failure, so there's something for you to look at.
> >
> >> >
> >> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
> >> >>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
> >> >> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >> >> index 002f092..730a18a 100644
> >> >> --- a/include/kvm/arm_vgic.h
> >> >> +++ b/include/kvm/arm_vgic.h
> >> >> @@ -71,6 +71,9 @@ struct vgic_global {
> >> >>
> >> >>       /* GIC system register CPU interface */
> >> >>       struct static_key_false gicv3_cpuif;
> >> >> +
> >> >> +     /* Cache ICH_VTR_EL2 reg value */
> >> >> +     u32                     ich_vtr_el2;
> >> >>  };
> >> >>
> >> >>  extern struct vgic_global kvm_vgic_global_state;
> >> >> @@ -269,6 +272,12 @@ struct vgic_cpu {
> >> >>       u64 pendbaser;
> >> >>
> >> >>       bool lpis_enabled;
> >> >> +
> >> >> +     /* Cache guest priority bits */
> >> >> +     u32 num_pri_bits;
> >> >> +
> >> >> +     /* Cache guest interrupt ID bits */
> >> >> +     u32 num_id_bits;
> >> >>  };
> >> >>
> >> >>  extern struct static_key_false vgic_v2_cpuif_trap;
> >> >> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> >> >> index 6c7d30c..da532d1 100644
> >> >> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> >> >> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> >> >> @@ -504,6 +504,14 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
> >> >>               if (!is_write)
> >> >>                       *reg = tmp32;
> >> >>               break;
> >> >> +     case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> >> >> +             u64 regid;
> >> >> +
> >> >> +             regid = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
> >> >> +             ret = vgic_v3_cpu_sysregs_uaccess(vcpu, is_write,
> >> >> +                                               regid, reg);
> >> >> +             break;
> >> >> +     }
> >> >>       default:
> >> >>               ret = -EINVAL;
> >> >>               break;
> >> >> @@ -537,6 +545,15 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
> >> >>               reg = tmp32;
> >> >>               return vgic_v3_attr_regs_access(dev, attr, &reg, true);
> >> >>       }
> >> >> +     case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> >> >> +             u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> >> >> +             u64 reg;
> >> >> +
> >> >> +             if (get_user(reg, uaddr))
> >> >> +                     return -EFAULT;
> >> >> +
> >> >> +             return vgic_v3_attr_regs_access(dev, attr, &reg, true);
> >> >> +     }
> >> >>       }
> >> >>       return -ENXIO;
> >> >>  }
> >> >> @@ -563,6 +580,15 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
> >> >>               tmp32 = reg;
> >> >>               return put_user(tmp32, uaddr);
> >> >>       }
> >> >> +     case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> >> >> +             u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> >> >> +             u64 reg;
> >> >> +
> >> >> +             ret = vgic_v3_attr_regs_access(dev, attr, &reg, false);
> >> >> +             if (ret)
> >> >> +                     return ret;
> >> >> +             return put_user(reg, uaddr);
> >> >> +     }
> >> >>       }
> >> >>
> >> >>       return -ENXIO;
> >> >> @@ -581,6 +607,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
> >> >>               break;
> >> >>       case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> >> >>       case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> >> >> +     case KVM_DEV_ARM_VGIC_CPU_SYSREGS:
> >> >>               return vgic_v3_has_attr_regs(dev, attr);
> >> >>       case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
> >> >>               return 0;
> >> >> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> >> >> index b35fb83..519b919 100644
> >> >> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> >> >> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> >> >> @@ -23,6 +23,7 @@
> >> >>
> >> >>  #include "vgic.h"
> >> >>  #include "vgic-mmio.h"
> >> >> +#include "sys_regs.h"
> >> >>
> >> >>  /* extract @num bytes at @offset bytes offset in data */
> >> >>  unsigned long extract_bytes(u64 data, unsigned int offset,
> >> >> @@ -639,6 +640,24 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
> >> >>               nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
> >> >>               break;
> >> >>       }
> >> >> +     case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> >> >> +             u64 reg, id;
> >> >> +             unsigned long vgic_mpidr, mpidr_reg;
> >> >> +             struct kvm_vcpu *vcpu;
> >> >> +
> >> >> +             vgic_mpidr = (attr->attr & KVM_DEV_ARM_VGIC_V3_MPIDR_MASK) >>
> >> >> +                           KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT;
> >> >> +
> >> >> +             /* Convert plain mpidr value to MPIDR reg format */
> >> >> +             mpidr_reg = VGIC_TO_MPIDR(vgic_mpidr);
> >> >> +
> >> >> +             vcpu = kvm_mpidr_to_vcpu(dev->kvm, mpidr_reg);
> >> >> +             if (!vcpu)
> >> >> +                     return -EINVAL;
> >> >> +
> >> >> +             id = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
> >> >> +             return vgic_v3_has_cpu_sysregs_attr(vcpu, 0, id, &reg);
> >> >> +     }
> >> >>       default:
> >> >>               return -ENXIO;
> >> >>       }
> >> >> diff --git a/virt/kvm/arm/vgic/vgic-sys-reg-v3.c b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> >> >> new file mode 100644
> >> >> index 0000000..69d8597
> >> >> --- /dev/null
> >> >> +++ b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> >> >
> >> > Shouldn't we have a GPL header here?
> >> >
> >> >> @@ -0,0 +1,324 @@
> >> >> +#include <linux/irqchip/arm-gic-v3.h>
> >> >> +#include <linux/kvm.h>
> >> >> +#include <linux/kvm_host.h>
> >> >> +#include <kvm/iodev.h>
> >> >> +#include <kvm/arm_vgic.h>
> >> >> +#include <asm/kvm_emulate.h>
> >> >> +#include <asm/kvm_arm.h>
> >> >> +#include <asm/kvm_mmu.h>
> >> >> +
> >> >> +#include "vgic.h"
> >> >> +#include "vgic-mmio.h"
> >> >> +#include "sys_regs.h"
> >> >> +
> >> >> +static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >> +                         const struct sys_reg_desc *r)
> >> >> +{
> >> >> +     struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
> >> >> +     struct vgic_vmcr vmcr;
> >> >> +     u64 val;
> >> >> +     u32 num_pri_bits, num_id_bits;
> >> >> +
> >> >> +     vgic_get_vmcr(vcpu, &vmcr);
> >> >> +     if (p->is_write) {
> >> >> +             val = p->regval;
> >> >> +
> >> >> +             /*
> >> >> +              * Does not allow update of ICC_CTLR_EL1 if HW does not support
> >> >> +              * guest programmed ID and PRI bits
> >> >> +              */
> >> >
> >> > I would suggest rewording this comment:
> >> > Disallow restoring VM state not supported by this hardware.
> >> >
> >> >> +             num_pri_bits = ((val & ICC_CTLR_EL1_PRI_BITS_MASK) >>
> >> >> +                             ICC_CTLR_EL1_PRI_BITS_SHIFT) + 1;
> >> >> +             if (num_pri_bits > vgic_v3_cpu->num_pri_bits)
> >> >> +                     return false;
> >> >> +
> >> >> +             vgic_v3_cpu->num_pri_bits = num_pri_bits;
> >> >
> >> > hmmm, this looks weird to me, because vgic_v3_cpu->num_pri_bits I don't
> >> > understand which effect this is intended to have?
> >> >
> >> > Sure, it may limit what you do with other registers later, but since
> >> > there's no ordering requirement that the ctlr be restored first, I'm not
> >> > sure it makes sense.
> >> >
> >> > Also, since this field is RO in the ICH_VTR, we'll have a strange
> >> > situation during runtime after a GICv3 restore where the
> >> > vgic_v3_cpu->num_pri_its differs from the hardware's ICH_VTR_EL2 field,
> >> > which is never the case if you didn't do a save/restore.
> >>
> >> Yes, but in any case, vgic_v3_cpu->num_pri_bits will be always less
> >> than HW supported
> >> value.
> >>
> >
> > So answer my question:  What is the intended effect of writing this
> > value?  Is it just so that if you migrate this platform back again, then
> > you're checking compatibility with what the guest would potentially do,
> 
> Yes 

Then add a comment explaining that

> and also to limit the valid aprn registers access as you said above.
> But that has ordering restriction. Which I think we should follow.
> 

I'm sorry, now I'm confused.  Is there an ordering requirement in the
API, or how should we follow this?

> > or should you maintain the num_pri_bits limitation during runtime
> > somehow?
> Once after checking compatibility, at runtime it is not updated
> and this value is not used at all in VGIC further
> >
> >> >
> >> > Finally, should we somehow ensure that this field is set to the same
> >> > value across VCPUs or is that not an architectural requirement?
> >> >
> >>    Yes it is nice to have it same across VCPUs. But should be ok as
> >> we are ensuring value is not greater than HW supported value.
> >
> > Does the architecture allow having a different number of priority bits
> > supported across CPUs?  If not, you shouldn't allow a VM programming
> > things that way either.
> 
> AFAIK, architecturally it is not mentioned any where in the spec that priority
> bits should be same across CPUs.

ok

> >
> >> There is no single point of place where we can make such a check
> >>
> >> >> +
> >> >> +             num_id_bits = (val & ICC_CTLR_EL1_ID_BITS_MASK) >>
> >> >> +                            ICC_CTLR_EL1_ID_BITS_SHIFT;
> >> >> +             if (num_id_bits > vgic_v3_cpu->num_id_bits)
> >> >> +                     return false;
> >> >> +
> >> >> +             vgic_v3_cpu->num_id_bits = num_id_bits;
> >> >
> >> > same questions
> >> >
> >> >> +
> >> >> +             vmcr.ctlr &= ~(ICH_VMCR_CBPR_MASK | ICH_VMCR_EOIM_MASK);
> >> >> +             vmcr.ctlr |= ((val & ICC_CTLR_EL1_CBPR_MASK) >>
> >> >> +                           ICC_CTLR_EL1_CBPR_SHIFT) << ICH_VMCR_CBPR_SHIFT;
> >> >> +             vmcr.ctlr |= ((val & ICC_CTLR_EL1_EOImode_MASK) >>
> >> >> +                           ICC_CTLR_EL1_EOImode_SHIFT) <<
> >> >> +                           ICH_VMCR_EOIM_SHIFT;
> >> >
> >> > I'm really confused here.  Is the vmcr.ctlr field in the ICC_CTLR_EL1
> >> > format or in the VMCR format?  I would assume the former, since
> >> > otherwise I don't get the point with this indirection, and for GICv2
> >> > vmcr.ctlr captures the GICC_CTLR value and git_set_vmcr transforms this
> >> > into VMCR values.
> >> >
> >> > Having a line that says "ctlr &= ~ICH_VMCR" should make some alarm bells
> >> > ring.
> >>
> >> I will check and fix it.
> >> >
> >> >> +             vgic_set_vmcr(vcpu, &vmcr);
> >> >
> >> > Should we check compatibility between the source and destination for the
> >> > SEIS and A3V support here?
> >>
> >> Can be checked. But I feel A3V check makes more sense than checking for
> >> SEIS.
> >>
> >
> > Please argue the *why* for whatever you end up doing with respect to
> > both bits in the commit message of your next patch revision.
> >
> >> >
> >> >> +     } else {
> >> >> +             val = 0;
> >> >> +             val |= (vgic_v3_cpu->num_pri_bits - 1) <<
> >> >> +                     ICC_CTLR_EL1_PRI_BITS_SHIFT;
> >> >> +             val |= vgic_v3_cpu->num_id_bits <<
> >> >> +                     ICC_CTLR_EL1_ID_BITS_SHIFT;
> >> >> +             val |= ((kvm_vgic_global_state.ich_vtr_el2 &
> >> >> +                     ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT) <<
> >> >> +                     ICC_CTLR_EL1_SEIS_SHIFT;
> >> >> +             val |= ((kvm_vgic_global_state.ich_vtr_el2 &
> >> >> +                     ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT) <<
> >> >> +                     ICC_CTLR_EL1_A3V_SHIFT;
> >> >> +             val |= ((vmcr.ctlr & ICH_VMCR_CBPR_MASK) >>
> >> >> +                     ICH_VMCR_CBPR_SHIFT) << ICC_CTLR_EL1_CBPR_SHIFT;
> >> >> +             val |= ((vmcr.ctlr & ICH_VMCR_EOIM_MASK) >>
> >> >> +                     ICH_VMCR_EOIM_SHIFT) << ICC_CTLR_EL1_EOImode_SHIFT;
> >> >
> >> > again, these last two look weird to me.
> >> >
> >> >> +
> >> >> +             p->regval = val;
> >> >> +     }
> >> >> +
> >> >> +     return true;
> >> >> +}
> >> >> +
> >> >> +static bool access_gic_pmr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >> +                        const struct sys_reg_desc *r)
> >> >> +{
> >> >> +     struct vgic_vmcr vmcr;
> >> >> +
> >> >> +     vgic_get_vmcr(vcpu, &vmcr);
> >> >> +     if (p->is_write) {
> >> >> +             vmcr.pmr = (p->regval & ICC_PMR_EL1_MASK) >> ICC_PMR_EL1_SHIFT;
> >> >> +             vgic_set_vmcr(vcpu, &vmcr);
> >> >> +     } else {
> >> >> +             p->regval = (vmcr.pmr << ICC_PMR_EL1_SHIFT) & ICC_PMR_EL1_MASK;
> >> >> +     }
> >> >> +
> >> >> +     return true;
> >> >> +}
> >> >> +
> >> >> +static bool access_gic_bpr0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >> +                         const struct sys_reg_desc *r)
> >> >> +{
> >> >> +     struct vgic_vmcr vmcr;
> >> >> +
> >> >> +     vgic_get_vmcr(vcpu, &vmcr);
> >> >> +     if (p->is_write) {
> >> >> +             vmcr.bpr = (p->regval & ICC_BPR0_EL1_MASK) >>
> >> >> +                         ICC_BPR0_EL1_SHIFT;
> >> >> +             vgic_set_vmcr(vcpu, &vmcr);
> >> >> +     } else {
> >> >> +             p->regval = (vmcr.bpr << ICC_BPR0_EL1_SHIFT) &
> >> >> +                          ICC_BPR0_EL1_MASK;
> >> >> +     }
> >> >> +
> >> >> +     return true;
> >> >> +}
> >> >> +
> >> >> +static bool access_gic_bpr1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >> +                         const struct sys_reg_desc *r)
> >> >> +{
> >> >> +     struct vgic_vmcr vmcr;
> >> >> +
> >> >> +     if (!p->is_write)
> >> >> +             p->regval = 0;
> >> >> +
> >> >> +     vgic_get_vmcr(vcpu, &vmcr);
> >> >> +     if (!((vmcr.ctlr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT)) {
> >> >> +             if (p->is_write) {
> >> >> +                     vmcr.abpr = (p->regval & ICC_BPR1_EL1_MASK) >>
> >> >> +                                  ICC_BPR1_EL1_SHIFT;
> >> >> +                     vgic_set_vmcr(vcpu, &vmcr);
> >> >> +             } else {
> >> >> +                     p->regval = (vmcr.abpr << ICC_BPR1_EL1_SHIFT) &
> >> >> +                                  ICC_BPR1_EL1_MASK;
> >> >> +             }
> >> >> +     } else {
> >> >> +             if (!p->is_write)
> >> >> +                     p->regval = min((vmcr.bpr + 1), 7U);
> >> >> +     }
> >> >> +
> >> >> +     return true;
> >> >> +}
> >> >> +
> >> >> +static bool access_gic_grpen0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >> +                           const struct sys_reg_desc *r)
> >> >> +{
> >> >> +     struct vgic_vmcr vmcr;
> >> >> +
> >> >> +     vgic_get_vmcr(vcpu, &vmcr);
> >> >> +     if (p->is_write) {
> >> >> +             vmcr.grpen0 = (p->regval & ICC_IGRPEN0_EL1_MASK) >>
> >> >> +                                   ICC_IGRPEN0_EL1_SHIFT;
> >> >> +             vgic_set_vmcr(vcpu, &vmcr);
> >> >> +     } else {
> >> >> +             p->regval = (vmcr.grpen0 << ICC_IGRPEN0_EL1_SHIFT) &
> >> >> +                          ICC_IGRPEN0_EL1_MASK;
> >> >> +     }
> >> >> +
> >> >> +     return true;
> >> >> +}
> >> >> +
> >> >> +static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >> +                           const struct sys_reg_desc *r)
> >> >> +{
> >> >> +     struct vgic_vmcr vmcr;
> >> >> +
> >> >> +     vgic_get_vmcr(vcpu, &vmcr);
> >> >> +     if (p->is_write) {
> >> >> +             vmcr.grpen1 = (p->regval & ICC_IGRPEN1_EL1_MASK) >>
> >> >> +                                   ICC_IGRPEN1_EL1_SHIFT;
> >> >> +             vgic_set_vmcr(vcpu, &vmcr);
> >> >> +     } else {
> >> >> +             p->regval = (vmcr.grpen1 << ICC_IGRPEN1_EL1_SHIFT) &
> >> >> +                          ICC_IGRPEN1_EL1_MASK;
> >> >> +     }
> >> >> +
> >> >> +     return true;
> >> >> +}
> >> >> +
> >> >> +static void vgic_v3_access_apr_reg(struct kvm_vcpu *vcpu,
> >> >> +                                struct sys_reg_params *p, u8 apr, u8 idx)
> >> >> +{
> >> >> +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> >> >> +     uint32_t *ap_reg;
> >> >> +
> >> >> +     if (apr)
> >> >> +             ap_reg = &vgicv3->vgic_ap1r[idx];
> >> >> +     else
> >> >> +             ap_reg = &vgicv3->vgic_ap0r[idx];
> >> >> +
> >> >> +     if (p->is_write)
> >> >> +             *ap_reg = p->regval;
> >> >> +     else
> >> >> +             p->regval = *ap_reg;
> >> >> +}
> >> >> +
> >> >> +static void access_gic_aprn(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >> +                         const struct sys_reg_desc *r, u8 apr)
> >> >> +{
> >> >> +     struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
> >> >> +     u8 idx = r->Op2 & 3;
> >> >> +
> >> >> +     switch (vgic_v3_cpu->num_pri_bits) {
> >> >> +     case 7:
> >> >> +             if (idx > 3)
> >> >> +                     goto err;
> >> >
> >> > idx cannot be higher than three given the mask above, right?
> >> >
> >> >> +             vgic_v3_access_apr_reg(vcpu, p, apr, idx);
> >> >> +             break;
> >> >> +     case 6:
> >> >> +             if (idx > 1)
> >> >> +                     goto err;
> >> >> +             vgic_v3_access_apr_reg(vcpu, p, apr, idx);
> >> >> +             break;
> >> >> +     default:
> >> >> +             if (idx > 0)
> >> >> +                     goto err;
> >> >> +             vgic_v3_access_apr_reg(vcpu, p, apr, idx);
> >> >> +     }
> >> >
> >> > what's the rationale behind ignoring the case where userspace is using
> >> > unsupported priorities?  Is it that this will be checked during
> >> > save/restore of the ctlr?
> >> >
> >> > This sort of thing just looks like the case that's impossible to debug,
> >> > because userspace could be scratching its head trying to understand why
> >> > the value it wrote isn't recorded anywhere...
> >> >
> >> > If there's a good rationale for doing it this way, then could we have a
> >> > comment to that effect?
> >>
> >> Accessing umplemented priority registers raised UNDEF exception.
> >> So userspace accesing should be ignored instead of recording unsupported
> >> values.
> >>
> >
> > That's not what I asked.
> >
> > I asked why it's silently ignored as opposed to raising an error visible
> > to user space?
> >
> >> >
> >> >> +
> >> >> +     return;
> >> >> +err:
> >> >> +     if (!p->is_write)
> >> >> +             p->regval = 0;
> >> >> +}
> >> >> +
> >> >> +static bool access_gic_ap0r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >> +                         const struct sys_reg_desc *r)
> >> >> +{
> >> >> +     access_gic_aprn(vcpu, p, r, 0);
> >> >> +
> >> >> +     return true;
> >> >> +}
> >> >> +
> >> >> +static bool access_gic_ap1r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >> +                         const struct sys_reg_desc *r)
> >> >> +{
> >> >> +     access_gic_aprn(vcpu, p, r, 1);
> >> >> +
> >> >> +     return true;
> >> >> +}
> >> >> +
> >> >> +static bool access_gic_sre(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >> +                        const struct sys_reg_desc *r)
> >> >> +{
> >> >> +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> >> >> +
> >> >> +     /* Validate SRE bit */
> >> >> +     if (p->is_write) {
> >> >> +             if (!(p->regval & ICC_SRE_EL1_SRE))
> >> >> +                     return false;
> >> >> +     } else {
> >> >> +             p->regval = vgicv3->vgic_sre;
> >> >> +     }
> >> >> +
> >> >> +     return true;
> >> >> +}
> >> >> +
> >> >> +static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
> >> >> +     /* ICC_PMR_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(4), CRm(6), Op2(0), access_gic_pmr },
> >> >> +     /* ICC_BPR0_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(3), access_gic_bpr0 },
> >> >> +     /* ICC_AP0R0_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(4), access_gic_ap0r },
> >> >> +     /* ICC_AP0R1_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(5), access_gic_ap0r },
> >> >> +     /* ICC_AP0R2_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(6), access_gic_ap0r },
> >> >> +     /* ICC_AP0R3_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(7), access_gic_ap0r },
> >> >> +     /* ICC_AP1R0_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(0), access_gic_ap1r },
> >> >> +     /* ICC_AP1R1_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(1), access_gic_ap1r },
> >> >> +     /* ICC_AP1R2_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(2), access_gic_ap1r },
> >> >> +     /* ICC_AP1R3_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(3), access_gic_ap1r },
> >> >> +     /* ICC_BPR1_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(3), access_gic_bpr1 },
> >> >> +     /* ICC_CTLR_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(4), access_gic_ctlr },
> >> >> +     /* ICC_SRE_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(5), access_gic_sre },
> >> >> +     /* ICC_IGRPEN0_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(6), access_gic_grpen0 },
> >> >> +     /* ICC_GRPEN1_EL1 */
> >> >> +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(7), access_gic_grpen1 },
> >> >> +};
> >> >> +
> >> >> +int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> >> >> +                             u64 *reg)
> >> >> +{
> >> >> +     struct sys_reg_params params;
> >> >> +     u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
> >> >> +
> >> >> +     params.regval = *reg;
> >> >> +     params.is_write = is_write;
> >> >> +     params.is_aarch32 = false;
> >> >> +     params.is_32bit = false;
> >> >> +
> >> >> +     if (find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
> >> >> +                           ARRAY_SIZE(gic_v3_icc_reg_descs)))
> >> >> +             return 0;
> >> >> +
> >> >> +     return -ENXIO;
> >> >> +}
> >> >> +
> >> >> +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> >> >> +                             u64 *reg)
> >> >> +{
> >> >> +     struct sys_reg_params params;
> >> >> +     const struct sys_reg_desc *r;
> >> >> +     u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
> >> >> +
> >> >> +     if (is_write)
> >> >> +             params.regval = *reg;
> >> >> +     params.is_write = is_write;
> >> >> +     params.is_aarch32 = false;
> >> >> +     params.is_32bit = false;
> >> >> +
> >> >> +     r = find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
> >> >> +                        ARRAY_SIZE(gic_v3_icc_reg_descs));
> >> >> +     if (!r)
> >> >> +             return -ENXIO;
> >> >> +
> >> >> +     if (!r->access(vcpu, &params, r))
> >> >> +             return -EINVAL;
> >> >
> >> > According to the API, EINVAL meansinvalid mpidr.  Should we expand on
> >> > how it can be used or allocate a new error code?
> >> How abt EACCES error code?
> >>
> >
> > That would mean permission denied, which is a bit weird.
> Yes I agree, but you can suggest.

You could expand the meaning in the API doc for gicv3 and use EINVAL, or
you could expand on what ENXIO means.


Thanks,
-Christoffer
