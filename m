From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v9 07/11] arm/arm64: vgic: Implement
 KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
Date: Tue, 29 Nov 2016 22:09:01 +0100
Message-ID: <20161129210901.GC15346@cbox>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
 <1479906118-15832-8-git-send-email-vijay.kilari@gmail.com>
 <20161128195028.GH18170@cbox>
 <CALicx6uW5RmjsPPBKB5wLW4TzNmcdc9ZADqp=M2ZJe9Cd+keZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7EC7405E6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 16:08:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eO+dPyLwoYNB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Nov 2016 16:08:16 -0500 (EST)
Received: from mail-lf0-f41.google.com (mail-lf0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02216405C4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 16:08:15 -0500 (EST)
Received: by mail-lf0-f41.google.com with SMTP id b14so131577636lfg.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 13:09:05 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CALicx6uW5RmjsPPBKB5wLW4TzNmcdc9ZADqp=M2ZJe9Cd+keZg@mail.gmail.com>
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

On Tue, Nov 29, 2016 at 10:06:27PM +0530, Vijay Kilari wrote:
> On Tue, Nov 29, 2016 at 1:20 AM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Wed, Nov 23, 2016 at 06:31:54PM +0530, vijay.kilari@gmail.com wrote:
> >> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >>
> >> Userspace requires to store and restore of line_level for
> >> level triggered interrupts using ioctl KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO.
> >>
> >> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >> ---
> >>  arch/arm/include/uapi/asm/kvm.h     |  7 ++++++
> >>  arch/arm64/include/uapi/asm/kvm.h   |  6 +++++
> >>  virt/kvm/arm/vgic/vgic-kvm-device.c | 49 ++++++++++++++++++++++++++++++++++++-
> >>  virt/kvm/arm/vgic/vgic-mmio-v3.c    | 11 +++++++++
> >>  virt/kvm/arm/vgic/vgic-mmio.c       | 38 ++++++++++++++++++++++++++++
> >>  virt/kvm/arm/vgic/vgic-mmio.h       |  5 ++++
> >>  virt/kvm/arm/vgic/vgic.h            |  2 ++
> >>  7 files changed, 117 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> >> index 98658d9d..f347779 100644
> >> --- a/arch/arm/include/uapi/asm/kvm.h
> >> +++ b/arch/arm/include/uapi/asm/kvm.h
> >> @@ -191,6 +191,13 @@ struct kvm_arch_memory_slot {
> >>  #define KVM_DEV_ARM_VGIC_GRP_CTRL       4
> >>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
> >>  #define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
> >> +#define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO 7
> >> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT       10
> >> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
> >> +                     (0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
> >> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK       0x3ff
> >> +#define VGIC_LEVEL_INFO_LINE_LEVEL   0
> >> +
> >>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
> >>
> >>  /* KVM_IRQ_LINE irq field index values */
> >> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> >> index 91c7137..4100f8c 100644
> >> --- a/arch/arm64/include/uapi/asm/kvm.h
> >> +++ b/arch/arm64/include/uapi/asm/kvm.h
> >> @@ -211,6 +211,12 @@ struct kvm_arch_memory_slot {
> >>  #define KVM_DEV_ARM_VGIC_GRP_CTRL    4
> >>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
> >>  #define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
> >> +#define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO 7
> >> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT       10
> >> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
> >> +                     (0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
> >> +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK       0x3ff
> >> +#define VGIC_LEVEL_INFO_LINE_LEVEL   0
> >>
> >>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT 0
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> >> index b6266fe..52ed00b 100644
> >> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> >> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> >> @@ -510,6 +510,25 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
> >>                                                 regid, reg);
> >>               break;
> >>       }
> >> +     case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
> >> +             unsigned int info, intid;
> >> +
> >> +             info = (attr->attr & KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK) >>
> >> +                     KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT;
> >> +             if (info == VGIC_LEVEL_INFO_LINE_LEVEL) {
> >> +                     if (is_write)
> >> +                             tmp32 = *reg;
> >> +                     intid = attr->attr &
> >> +                             KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK;
> >> +                     ret = vgic_v3_line_level_info_uaccess(vcpu, is_write,
> >> +                                                           intid, &tmp32);
> >> +                     if (!is_write)
> >> +                             *reg = tmp32;
> >
> > I had a comment here about not having to use the tmp32 by modifying the
> > line_level_info function, that you seem to have missed.
> >
> > Hint: The level info is not called from an MMIO path so you should be
> > able to just write it in a natural way.
> 
> Ok. Changed the prototype of vgic_v3_line_level_info_uaccess() to take
> u64 reg instead of tmp32
> 
> >
> >> +             } else {
> >> +                     ret = -EINVAL;
> >> +             }
> >> +             break;
> >> +     }
> >>       default:
> >>               ret = -EINVAL;
> >>               break;
> >> @@ -552,6 +571,17 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
> >>
> >>               return vgic_v3_attr_regs_access(dev, attr, &reg, true);
> >>       }
> >> +     case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
> >> +             u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> >> +             u64 reg;
> >> +             u32 tmp32;
> >> +
> >> +             if (get_user(tmp32, uaddr))
> >> +                     return -EFAULT;
> >> +
> >> +             reg = tmp32;
> >> +             return vgic_v3_attr_regs_access(dev, attr, &reg, true);
> >> +     }
> >>       }
> >>       return -ENXIO;
> >>  }
> >> @@ -587,8 +617,18 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
> >>                       return ret;
> >>               return put_user(reg, uaddr);
> >>       }
> >> -     }
> >> +     case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
> >> +             u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> >> +             u64 reg;
> >> +             u32 tmp32;
> >>
> >> +             ret = vgic_v3_attr_regs_access(dev, attr, &reg, false);
> >> +             if (ret)
> >> +                     return ret;
> >> +             tmp32 = reg;
> >> +             return put_user(tmp32, uaddr);
> >> +     }
> >> +     }
> >>       return -ENXIO;
> >>  }
> >>
> >> @@ -609,6 +649,13 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
> >>               return vgic_v3_has_attr_regs(dev, attr);
> >>       case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
> >>               return 0;
> >> +     case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
> >> +             if (((attr->attr & KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK) >>
> >> +                   KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT) ==
> >> +                   VGIC_LEVEL_INFO_LINE_LEVEL)
> >> +                     return 0;
> >> +             break;
> >> +     }
> >>       case KVM_DEV_ARM_VGIC_GRP_CTRL:
> >>               switch (attr->attr) {
> >>               case KVM_DEV_ARM_VGIC_CTRL_INIT:
> >> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> >> index 2f7b4ed..4d7d93d 100644
> >> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> >> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> >> @@ -808,3 +808,14 @@ int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> >>               return vgic_uaccess(vcpu, &rd_dev, is_write,
> >>                                   offset, val);
> >>  }
> >> +
> >> +int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> >> +                                 u32 intid, u32 *val)
> >> +{
> >> +     if (is_write)
> >> +             vgic_write_irq_line_level_info(vcpu, intid, *val);
> >> +     else
> >> +             *val = vgic_read_irq_line_level_info(vcpu, intid);
> >> +
> >> +     return 0;
> >> +}
> >> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> >> index f81e0e5..d602081 100644
> >> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> >> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> >> @@ -371,6 +371,44 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
> >>       }
> >>  }
> >>
> >> +unsigned long vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid)
> >> +{
> >> +     int i;
> >> +     unsigned long val = 0;
> >> +
> >> +     for (i = 0; i < 32; i++) {
> >> +             struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> >> +
> >> +             if (irq->line_level)
> >> +                     val |= (1U << i);
> >> +
> >> +             vgic_put_irq(vcpu->kvm, irq);
> >> +     }
> >> +
> >> +     return val;
> >> +}
> >> +
> >> +void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
> >> +                                 const unsigned long val)
> >> +{
> >> +     int i;
> >> +
> >> +     for (i = 0; i < 32; i++) {
> >> +             struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> >> +
> >> +             spin_lock(&irq->irq_lock);
> >> +             if (val & (1U << i)) {
> >> +                     irq->line_level = true;
> >> +                     vgic_queue_irq_unlock(vcpu->kvm, irq);
> >> +             } else {
> >> +                     irq->line_level = false;
> >> +                     spin_unlock(&irq->irq_lock);
> >> +             }
> >
> > I think you also missed my comment about having to keep the pending
> > state in sync with the level state.
> >
> > Which means you have to set the pending state when the line_level goes
> > up, and lower it when it goes down unless soft_pending is also set,
> > assuming it's configured as a level triggered interrupt.
> >
> > If it's an edge-triggered interrupt, I think you only need to set the
> > pending state on a line being asserted and the rest should be adjusted
> > in case the user restores the configuration state to level triggered
> > later.
> 
> Is this ok?
> 
> void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
>                                     const u64 val)
> {
>         int i;
> 
>         for (i = 0; i < 32; i++) {
>                 struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> 
>                 spin_lock(&irq->irq_lock);
>                 if (val & (1U << i)) {
>                         irq->line_level = true;
>                         irq->pending = true;
>                         vgic_queue_irq_unlock(vcpu->kvm, irq);

Actually, I'm not sure what the semantics of the line level ioctl should
be for edge-triggered interrupts?  My inclination is that it shouldn't
have any effect at this point, but that would mean that at this point we
should only set the pending variable and try to queue the interrupt if
the config is level.  But that also means that when we set the config
later, we need to try to queue the interrupt, which we don't do
currently, because we rely on the guest not fiddling with the config of
an enabled interrupt.

Could it be considered an error if user space tries to set the level for
an edge-triggered interrupt and therefore something we can just ignore
and assume that the corresponing interrupt will be configured as a
level-triggered one later?

Marc/Peter, thoughts on this one?

In any case we probably need to clarify the ABI in terms of this
particular KVM_DEV_AR_VGIC_GRP_LEVEL_INFO group and how it relates to
the config of edge vs. level of interrupts and ordering on restore...


Thanks,
-Christoffer

>                 } else {
>                         if (irq->config == VGIC_CONFIG_EDGE ||
>                             (irq->config == VGIC_CONFIG_LEVEL &&
>                             !irq->soft_pending))
>                                 irq->line_level = false;
>                         spin_unlock(&irq->irq_lock);
>                 }
> 
>                 vgic_put_irq(vcpu->kvm, irq);
>         }
> }
