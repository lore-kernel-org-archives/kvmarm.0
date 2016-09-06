From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [RFC PATCH v3 2/5] arm/arm64: vgic-new: Add distributor and
 redistributor access
Date: Tue, 6 Sep 2016 19:44:15 +0530
Message-ID: <CALicx6uv67B_S4Gd0zDS7Tag-cpZaqt-nNPQ8MchucnmD+BPUg@mail.gmail.com>
References: <1472037609-4164-1-git-send-email-vijay.kilari@gmail.com>
 <1472037609-4164-3-git-send-email-vijay.kilari@gmail.com>
 <20160830123126.GH10162@cbox>
 <CALicx6tbUDCUe6SBr=HA1MnNdZa6L1+U67C3V_pT-Nw2RGjR6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6AD249B60
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 10:05:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ISen3Ccafd5O for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 10:05:52 -0400 (EDT)
Received: from mail-oi0-f65.google.com (mail-oi0-f65.google.com
 [209.85.218.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3653240FA2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 10:05:52 -0400 (EDT)
Received: by mail-oi0-f65.google.com with SMTP id 2so14721662oif.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2016 07:14:16 -0700 (PDT)
In-Reply-To: <CALicx6tbUDCUe6SBr=HA1MnNdZa6L1+U67C3V_pT-Nw2RGjR6g@mail.gmail.com>
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

Resending in plain text mode

On Tue, Sep 6, 2016 at 7:17 PM, Vijay Kilari <vijay.kilari@gmail.com> wrote:
>
>
> On Tue, Aug 30, 2016 at 6:01 PM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
>>
>> On Wed, Aug 24, 2016 at 04:50:06PM +0530, vijay.kilari@gmail.com wrote:
>> > From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>> >
>> > VGICv3 Distributor and Redistributor registers are accessed using
>> > KVM_DEV_ARM_VGIC_GRP_DIST_REGS and KVM_DEV_ARM_VGIC_GRP_DIST_REGS
>> > with KVM_SET_DEVICE_ATTR and KVM_GET_DEVICE_ATTR ioctls.
>> > These registers are accessed as 32-bit and cpu mpidr
>> > value passed along with register offset is used to identify the
>> > cpu for redistributor registers access.
>> >
>> > The version of VGIC v3 specification is define here
>> >
>> > http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
>> >
>> > Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>> > ---
>> >  arch/arm64/include/uapi/asm/kvm.h   |   3 +
>> >  virt/kvm/arm/vgic/vgic-kvm-device.c | 127
>> > +++++++++++++++++++++++++++++++++++-
>> >  virt/kvm/arm/vgic/vgic-mmio-v3.c    | 113
>> > ++++++++++++++++++++++++++++++++
>> >  virt/kvm/arm/vgic/vgic-mmio.c       |   2 +-
>> >  virt/kvm/arm/vgic/vgic.h            |   8 +++
>> >  5 files changed, 250 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/arch/arm64/include/uapi/asm/kvm.h
>> > b/arch/arm64/include/uapi/asm/kvm.h
>> > index 3051f86..94ea676 100644
>> > --- a/arch/arm64/include/uapi/asm/kvm.h
>> > +++ b/arch/arm64/include/uapi/asm/kvm.h
>> > @@ -201,10 +201,13 @@ struct kvm_arch_memory_slot {
>> >  #define KVM_DEV_ARM_VGIC_GRP_CPU_REGS        2
>> >  #define   KVM_DEV_ARM_VGIC_CPUID_SHIFT       32
>> >  #define   KVM_DEV_ARM_VGIC_CPUID_MASK        (0xffULL <<
>> > KVM_DEV_ARM_VGIC_CPUID_SHIFT)
>> > +#define   KVM_DEV_ARM_VGIC_V3_CPUID_MASK \
>> > +                             (0xffffffffULL <<
>> > KVM_DEV_ARM_VGIC_CPUID_SHIFT)
>>
>> I think this should be KVM_DEV_ARM_VGIC_V3_MPIDR_MASK, and I would
>> probably define a V3 of the shift as well, since we're really talking
>> about two distinct APIs here.
>>
>> >  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT      0
>> >  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK       (0xffffffffULL <<
>> > KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
>> >  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS 3
>> >  #define KVM_DEV_ARM_VGIC_GRP_CTRL    4
>> > +#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
>> >  #define   KVM_DEV_ARM_VGIC_CTRL_INIT 0
>> >
>> >  /* Device Control API on vcpu fd */
>> > diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c
>> > b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> > index 163b057..06f0158 100644
>> > --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
>> > +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> > @@ -433,16 +433,136 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
>> >
>> >  #ifdef CONFIG_KVM_ARM_VGIC_V3
>> >
>> > +static int parse_vgic_v3_attr(struct kvm_device *dev,
>> > +                           struct kvm_device_attr *attr,
>> > +                           struct vgic_reg_attr *reg_attr)
>> > +{
>> > +     int cpuid;
>> > +
>> > +     cpuid = (attr->attr & KVM_DEV_ARM_VGIC_V3_CPUID_MASK) >>
>> > +              KVM_DEV_ARM_VGIC_CPUID_SHIFT;
>> > +
>> > +     if (cpuid >= atomic_read(&dev->kvm->online_vcpus))
>> > +             return -EINVAL;
>>
>> huh?  it's an MPIDR, not a cpu id.
>>
>> just resolve it with kvm_mpidr_to_vcpu and check its return value.
>>
>>
>> > +
>> > +     reg_attr->vcpu = kvm_mpidr_to_vcpu(dev->kvm, cpuid);
>>
>> please check the return value of this function in any case...
>>
>> > +     reg_attr->addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
>> > +
>> > +     return 0;
>> > +}
>> > +
>> > +/**
>> > + * vgic_attr_regs_access_v3 - allows user space to access VGIC v3 state
>> > + *
>> > + * @dev:      kvm device handle
>> > + * @attr:     kvm device attribute
>> > + * @reg:      address the value is read or written
>> > + * @is_write: true if userspace is writing a register
>> > + */
>> > +static int vgic_attr_regs_access_v3(struct kvm_device *dev,
>> > +                                 struct kvm_device_attr *attr,
>> > +                                 u64 *reg, bool is_write)
>> > +{
>> > +     struct vgic_reg_attr reg_attr;
>> > +     gpa_t addr;
>> > +     struct kvm_vcpu *vcpu;
>> > +     int ret;
>> > +     u32 tmp32;
>> > +
>> > +     ret = parse_vgic_v3_attr(dev, attr, &reg_attr);
>> > +     if (ret)
>> > +             return ret;
>> > +
>> > +     vcpu = reg_attr.vcpu;
>> > +     addr = reg_attr.addr;
>> > +
>> > +     mutex_lock(&dev->kvm->lock);
>> > +
>> > +     ret = vgic_init(dev->kvm);
>> > +     if (ret)
>> > +             goto out;
>>
>> no, no, please no more auto-init at userspace access time.  This code
>> should instead check vgic_initialized() and return an error to userspace
>> if not initialized.
>>
>> Ok. I wil fix it. It is coming from v2 code.
>
>
>>
>> > +
>> > +     if (!lock_all_vcpus(dev->kvm)) {
>> > +             ret = -EBUSY;
>> > +             goto out;
>> > +     }
>> > +
>> > +     switch (attr->group) {
>> > +     case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>> > +             tmp32 = *reg;
>>
>> why is this assignment not predicated on if (is_write) ?
>>
>> also, all this type conversion nonsense is probably unnecessary, see my
>> comment below.
>>
>> > +             ret = vgic_v3_dist_uaccess(vcpu, is_write, addr, &tmp32);
>> > +             if (!is_write)
>> > +                     *reg = tmp32;
>> > +             break;
>> > +     case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
>> > +             tmp32 = *reg;
>> > +             ret = vgic_v3_redist_uaccess(vcpu, is_write, addr,
>> > &tmp32);
>> > +             if (!is_write)
>> > +                     *reg = tmp32;
>> > +             break;
>> > +     default:
>> > +             ret = -EINVAL;
>> > +             break;
>> > +     }
>> > +
>> > +     unlock_all_vcpus(dev->kvm);
>> > +out:
>> > +     mutex_unlock(&dev->kvm->lock);
>> > +     return ret;
>> > +}
>> > +
>> >  static int vgic_v3_set_attr(struct kvm_device *dev,
>> >                           struct kvm_device_attr *attr)
>> >  {
>> > -     return vgic_set_common_attr(dev, attr);
>> > +     int ret;
>> > +
>> > +     ret = vgic_set_common_attr(dev, attr);
>> > +     if (ret != -ENXIO)
>> > +             return ret;
>> > +
>> > +     switch (attr->group) {
>> > +     case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>> > +     case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS: {
>> > +             u32 __user *uaddr = (u32 __user *)(long)attr->addr;
>> > +             u32 tmp32;
>> > +             u64 reg;
>> > +
>> > +             if (get_user(tmp32, uaddr))
>> > +                     return -EFAULT;
>> > +
>> > +             reg = tmp32;
>> > +             return vgic_attr_regs_access_v3(dev, attr, &reg, true);
>>
>> oh, but wait, you already had a 32-bit value, which you convert into a
>> 64-bit value, just to convert it back again, to do some extra data
>> copies?
>>
>> I'm really confused as to why this has to be so complicated.
>>
>> Why not simply use u32 all the way?
>
>
>     vgic_attr_regs_access_v3() is used for handling both GICD/GICR and
> SYSREGS. For this reason we convert u32 to 64 and vice versa.
> To avoid these conversions, I can create separate vgic_attr_regs_access_v3()
> functions for GICD and SYSREGS.
>
>
