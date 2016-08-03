From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v1 2/4] arm/arm64: vgic-new: Add distributor and
 redistributor access
Date: Wed, 3 Aug 2016 10:42:59 +0200
Message-ID: <20160803084259.GW32244@cbox>
References: <1469019748-31005-1-git-send-email-vijay.kilari@gmail.com>
 <1469019748-31005-3-git-send-email-vijay.kilari@gmail.com>
 <20160802144349.GO32244@cbox>
 <CALicx6tXLJ=19b8gMGMdZnsmAh27mGTFDs4PSZWQGEVni-jQ3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA7364998D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2016 04:34:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M1ZpBk+E9hWT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Aug 2016 04:34:35 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2F14411BE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2016 04:34:34 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id f65so438487563wmi.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Aug 2016 01:41:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CALicx6tXLJ=19b8gMGMdZnsmAh27mGTFDs4PSZWQGEVni-jQ3Q@mail.gmail.com>
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
Cc: "prasun.kapoor" <Prasun.Kapoor@cavium.com>, Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 03, 2016 at 02:03:39PM +0530, Vijay Kilari wrote:
> On Tue, Aug 2, 2016 at 8:13 PM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Wed, Jul 20, 2016 at 06:32:26PM +0530, vijay.kilari@gmail.com wrote:
> >> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >>
> >> VGICv3 Distributor and Redistributor registers are accessed using
> >> KVM_DEV_ARM_VGIC_GRP_DIST_REGS and KVM_DEV_ARM_VGIC_GRP_DIST_REGS
> >> with KVM_SET_DEVICE_ATTR and KVM_GET_DEVICE_ATTR ioctls.
> >> These registers are accessed as 32-bit and cpu mpidr
> >> value passed along with register offset is used to identify the
> >> cpu for redistributor registers access.
> >>
> >> The draft version of VGIC v3 specification is define here
> >> https://lists.cs.columbia.edu/pipermail/kvmarm/2016-May/020355.html
> >>
> >> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >> ---
> >>  arch/arm64/include/uapi/asm/kvm.h   |    3 +
> >>  virt/kvm/arm/vgic/vgic-kvm-device.c |   72 ++++++++++++++++++++++--
> >>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |  105 +++++++++++++++++++++++++++++++++++
> >>  virt/kvm/arm/vgic/vgic-mmio.c       |    2 +-
> >>  virt/kvm/arm/vgic/vgic.h            |    8 +++
> >>  5 files changed, 183 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> >> index f209ea1..a6b996e 100644
> >> --- a/arch/arm64/include/uapi/asm/kvm.h
> >> +++ b/arch/arm64/include/uapi/asm/kvm.h
> >> @@ -199,10 +199,13 @@ struct kvm_arch_memory_slot {
> >>  #define KVM_DEV_ARM_VGIC_GRP_CPU_REGS        2
> >>  #define   KVM_DEV_ARM_VGIC_CPUID_SHIFT       32
> >>  #define   KVM_DEV_ARM_VGIC_CPUID_MASK        (0xffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
> >> +#define   KVM_DEV_ARM_VGIC_V3_CPUID_MASK \
> >> +                             (0xffffffffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
> >>  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT      0
> >>  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK       (0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
> >>  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS 3
> >>  #define KVM_DEV_ARM_VGIC_GRP_CTRL    4
> >> +#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
> >>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT 0
> >>
> >>  /* Device Control API on vcpu fd */
> >> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> >> index cace996..996a720 100644
> >> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> >> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> >> @@ -266,10 +266,17 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
> >>       int cpuid, ret, c;
> >>       struct kvm_vcpu *vcpu, *tmp_vcpu;
> >>       int vcpu_lock_idx = -1;
> >> +     struct vgic_dist *vgic = &dev->kvm->arch.vgic;
> >>
> >> -     cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
> >> -              KVM_DEV_ARM_VGIC_CPUID_SHIFT;
> >> -     vcpu = kvm_get_vcpu(dev->kvm, cpuid);
> >> +     if (vgic->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
> >> +             cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
> >> +                      KVM_DEV_ARM_VGIC_CPUID_SHIFT;
> >> +             vcpu = kvm_get_vcpu(dev->kvm, cpuid);
> >> +     } else {
> >> +             cpuid = (attr->attr & KVM_DEV_ARM_VGIC_V3_CPUID_MASK) >>
> >> +                      KVM_DEV_ARM_VGIC_CPUID_SHIFT;
> >> +             vcpu = kvm_mpidr_to_vcpu(dev->kvm, cpuid);
> >> +     }
> >>       addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
> >>
> >>       mutex_lock(&dev->kvm->lock);
> >> @@ -301,7 +308,19 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
> >>               ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, &reg->reg32);
> >>               break;
> >>       case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> >> -             ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, &reg->reg32);
> >> +             if (vgic->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
> >> +                     ret = vgic_v2_dist_uaccess(vcpu, is_write, addr,
> >> +                                                &reg->reg32);
> >> +             else
> >> +                     ret = vgic_v3_dist_uaccess(vcpu, is_write, addr,
> >> +                                                &reg->reg32);
> >> +             break;
> >> +     case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> >> +             if (vgic->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
> >> +                     ret = vgic_v3_redist_uaccess(vcpu, is_write, addr,
> >> +                                                  &reg->reg32);
> >> +             else
> >> +                     ret = -EINVAL;
> >>               break;
> >>       default:
> >>               ret = -EINVAL;
> >> @@ -411,13 +430,51 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
> >>  static int vgic_v3_set_attr(struct kvm_device *dev,
> >>                           struct kvm_device_attr *attr)
> >>  {
> >> -     return vgic_set_common_attr(dev, attr);
> >> +     int ret;
> >> +
> >> +     ret = vgic_set_common_attr(dev, attr);
> >> +     if (ret != -ENXIO)
> >> +             return ret;
> >> +
> >> +     switch (attr->group) {
> >> +     case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> >> +     case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS: {
> >> +             u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> >> +             union ureg reg;
> >> +
> >> +             if (get_user(reg.reg32, uaddr))
> >> +                     return -EFAULT;
> >> +
> >> +             return vgic_attr_regs_access(dev, attr, &reg, true);
> >> +     }
> >> +     }
> >> +     return -ENXIO;
> >>  }
> >>
> >>  static int vgic_v3_get_attr(struct kvm_device *dev,
> >>                           struct kvm_device_attr *attr)
> >>  {
> >> -     return vgic_get_common_attr(dev, attr);
> >> +     int ret;
> >> +
> >> +     ret = vgic_get_common_attr(dev, attr);
> >> +     if (ret != -ENXIO)
> >> +             return ret;
> >> +
> >> +     switch (attr->group) {
> >> +     case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> >> +     case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS: {
> >> +             u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> >> +             union ureg reg;
> >> +
> >> +             ret = vgic_attr_regs_access(dev, attr, &reg, false);
> >> +             if (ret)
> >> +                     return ret;
> >> +             ret = put_user(reg.reg32, uaddr);
> >> +             return ret;
> >> +     }
> >> +     }
> >> +
> >> +     return -ENXIO;
> >>  }
> >>
> >>  static int vgic_v3_has_attr(struct kvm_device *dev,
> >> @@ -431,6 +488,9 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
> >>                       return 0;
> >>               }
> >>               break;
> >> +     case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> >> +     case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> >> +             return vgic_v3_has_attr_regs(dev, attr);
> >>       case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
> >>               return 0;
> >>       case KVM_DEV_ARM_VGIC_GRP_CTRL:
> >> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> >> index a0c515a..f6a4e97 100644
> >> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> >> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> >> @@ -18,6 +18,8 @@
> >>  #include <kvm/arm_vgic.h>
> >>
> >>  #include <asm/kvm_emulate.h>
> >> +#include <asm/kvm_arm.h>
> >> +#include <asm/kvm_mmu.h>
> >>
> >>  #include "vgic.h"
> >>  #include "vgic-mmio.h"
> >> @@ -226,6 +228,9 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
> >>       REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
> >>               vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8,
> >>               VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
> >> +     REGISTER_DESC_WITH_LENGTH(GICR_WAKER,
> >> +             vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
> >> +             VGIC_ACCESS_32bit),
> >>       REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
> >>               vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
> >>               VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
> >> @@ -348,6 +353,52 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
> >>       return ret;
> >>  }
> >>
> >> +int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
> >> +{
> >> +     struct kvm_vcpu *vcpu;
> >> +     int nr_irqs = dev->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
> >> +     const struct vgic_register_region *regions;
> >> +     gpa_t addr;
> >> +     int nr_regions, i, len, cpuid;
> >> +
> >> +     addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
> >> +     cpuid = (attr->attr & KVM_DEV_ARM_VGIC_V3_CPUID_MASK) >>
> >> +              KVM_DEV_ARM_VGIC_CPUID_SHIFT;
> >> +     vcpu = kvm_mpidr_to_vcpu(dev->kvm, cpuid);
> >> +
> >> +     switch (attr->group) {
> >> +     case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> >> +             regions = vgic_v3_dist_registers;
> >> +             nr_regions = ARRAY_SIZE(vgic_v3_dist_registers);
> >> +             break;
> >> +     case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:{
> >> +             struct vgic_io_device *devices;
> >> +             struct vgic_io_device *rd_dev;
> >> +
> >> +             devices = dev->kvm->arch.vgic.redist_iodevs;
> >> +             rd_dev = &devices[vcpu->vcpu_id * 2];
> >> +
> >> +             regions = rd_dev->regions;
> >> +             nr_regions = rd_dev->nr_regions;
> >> +             break;
> >> +     }
> >> +     default:
> >> +             return -ENXIO;
> >> +     }
> >> +
> >> +     for (i = 0; i < nr_regions; i++) {
> >> +             if (regions[i].bits_per_irq)
> >> +                     len = (regions[i].bits_per_irq * nr_irqs) / 8;
> >> +             else
> >> +                     len = regions[i].len;
> >> +
> >> +             if (regions[i].reg_offset <= addr &&
> >> +                 regions[i].reg_offset + len > addr)
> >> +                     return 0;
> >> +     }
> >> +
> >> +     return -ENXIO;
> >> +}
> >>  /*
> >>   * Compare a given affinity (level 1-3 and a level 0 mask, from the SGI
> >>   * generation register ICC_SGI1R_EL1) with a given VCPU.
> >> @@ -453,3 +504,57 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
> >>               vgic_queue_irq_unlock(vcpu->kvm, irq);
> >>       }
> >>  }
> >> +
> >> +/*
> >> + * When userland tries to access the VGIC register handlers, we need to
> >> + * create a usable struct vgic_io_device to be passed to the handlers and we
> >> + * have to set up a buffer similar to what would have happened if a guest MMIO
> >> + * access occurred, including doing endian conversions on BE systems.
> >> + */
> >> +static int vgic_v3_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
> >> +                        bool is_write, int offset, u32 *val)
> >> +{
> >> +     unsigned int len = 4;
> >> +     u8 buf[4];
> >> +     int ret;
> >> +
> >> +     if (is_write) {
> >> +             vgic_data_host_to_mmio_bus(buf, len, *val);
> >> +             ret = kvm_io_gic_ops.write(vcpu, &dev->dev,
> >> +                                        dev->base_addr + offset, len, buf);
> >> +     } else {
> >> +             ret = kvm_io_gic_ops.read(vcpu, &dev->dev,
> >> +                                       dev->base_addr + offset, len, buf);
> >> +             if (!ret)
> >> +                     *val = vgic_data_mmio_bus_to_host(buf, len);
> >> +     }
> >> +
> >> +     return ret;
> >> +}
> >> +
> >> +int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> >> +                      int offset, u32 *val)
> >> +{
> >> +     struct vgic_io_device *dev;
> >> +
> >> +     dev = &vcpu->kvm->arch.vgic.dist_iodev;
> >
> > You're not supposed to do this.
> >
> > You're supposed to create a temporary vgic_io_device for this, just like
> > we do in vgic_v2_dist_uaccess().
> >
> > This is why we went down the road of all the init sequence problems.
> >
> > Any reason why you didn't just follow the lead from the v2
> > implementation?
> 
> I have not looked at v2 implementation.

No need to reinvent the wheel, we're allowed to be inspired by each
other.  In fact, symmetry between the v2 and v3 specific parts of the
VGIC where it makes sense is a preference.

> But you are right.
> With v2 kind of implementation for v3, the init sequence patch is no
> more required. I will drop the patch "arm/arm64: vgic-new: Create dist
> and redist iodevs earlier"
> 
Thanks, looking forward to the next version.

-Christoffer
