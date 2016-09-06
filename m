From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [RFC PATCH v3 2/5] arm/arm64: vgic-new: Add distributor and
 redistributor access
Date: Tue, 6 Sep 2016 19:17:03 +0530
Message-ID: <CALicx6tbUDCUe6SBr=HA1MnNdZa6L1+U67C3V_pT-Nw2RGjR6g@mail.gmail.com>
References: <1472037609-4164-1-git-send-email-vijay.kilari@gmail.com>
 <1472037609-4164-3-git-send-email-vijay.kilari@gmail.com>
 <20160830123126.GH10162@cbox>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2099161562832472340=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED8FD49B53
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 09:38:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HZy-EjB0DDri for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 09:38:40 -0400 (EDT)
Received: from mail-oi0-f67.google.com (mail-oi0-f67.google.com
 [209.85.218.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F70C49B47
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 09:38:40 -0400 (EDT)
Received: by mail-oi0-f67.google.com with SMTP id u131so5674938oif.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2016 06:47:04 -0700 (PDT)
In-Reply-To: <20160830123126.GH10162@cbox>
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

--===============2099161562832472340==
Content-Type: multipart/alternative; boundary=001a113d47f2259bfe053bd708e0

--001a113d47f2259bfe053bd708e0
Content-Type: text/plain; charset=UTF-8

On Tue, Aug 30, 2016 at 6:01 PM, Christoffer Dall <
christoffer.dall@linaro.org> wrote:

> On Wed, Aug 24, 2016 at 04:50:06PM +0530, vijay.kilari@gmail.com wrote:
> > From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >
> > VGICv3 Distributor and Redistributor registers are accessed using
> > KVM_DEV_ARM_VGIC_GRP_DIST_REGS and KVM_DEV_ARM_VGIC_GRP_DIST_REGS
> > with KVM_SET_DEVICE_ATTR and KVM_GET_DEVICE_ATTR ioctls.
> > These registers are accessed as 32-bit and cpu mpidr
> > value passed along with register offset is used to identify the
> > cpu for redistributor registers access.
> >
> > The version of VGIC v3 specification is define here
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2016-
> July/445611.html
> >
> > Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> > ---
> >  arch/arm64/include/uapi/asm/kvm.h   |   3 +
> >  virt/kvm/arm/vgic/vgic-kvm-device.c | 127
> +++++++++++++++++++++++++++++++++++-
> >  virt/kvm/arm/vgic/vgic-mmio-v3.c    | 113
> ++++++++++++++++++++++++++++++++
> >  virt/kvm/arm/vgic/vgic-mmio.c       |   2 +-
> >  virt/kvm/arm/vgic/vgic.h            |   8 +++
> >  5 files changed, 250 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h
> b/arch/arm64/include/uapi/asm/kvm.h
> > index 3051f86..94ea676 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -201,10 +201,13 @@ struct kvm_arch_memory_slot {
> >  #define KVM_DEV_ARM_VGIC_GRP_CPU_REGS        2
> >  #define   KVM_DEV_ARM_VGIC_CPUID_SHIFT       32
> >  #define   KVM_DEV_ARM_VGIC_CPUID_MASK        (0xffULL <<
> KVM_DEV_ARM_VGIC_CPUID_SHIFT)
> > +#define   KVM_DEV_ARM_VGIC_V3_CPUID_MASK \
> > +                             (0xffffffffULL <<
> KVM_DEV_ARM_VGIC_CPUID_SHIFT)
>
> I think this should be KVM_DEV_ARM_VGIC_V3_MPIDR_MASK, and I would
> probably define a V3 of the shift as well, since we're really talking
> about two distinct APIs here.
>
> >  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT      0
> >  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK       (0xffffffffULL <<
> KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
> >  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS 3
> >  #define KVM_DEV_ARM_VGIC_GRP_CTRL    4
> > +#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
> >  #define   KVM_DEV_ARM_VGIC_CTRL_INIT 0
> >
> >  /* Device Control API on vcpu fd */
> > diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c
> b/virt/kvm/arm/vgic/vgic-kvm-device.c
> > index 163b057..06f0158 100644
> > --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> > +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> > @@ -433,16 +433,136 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
> >
> >  #ifdef CONFIG_KVM_ARM_VGIC_V3
> >
> > +static int parse_vgic_v3_attr(struct kvm_device *dev,
> > +                           struct kvm_device_attr *attr,
> > +                           struct vgic_reg_attr *reg_attr)
> > +{
> > +     int cpuid;
> > +
> > +     cpuid = (attr->attr & KVM_DEV_ARM_VGIC_V3_CPUID_MASK) >>
> > +              KVM_DEV_ARM_VGIC_CPUID_SHIFT;
> > +
> > +     if (cpuid >= atomic_read(&dev->kvm->online_vcpus))
> > +             return -EINVAL;
>
> huh?  it's an MPIDR, not a cpu id.
>
> just resolve it with kvm_mpidr_to_vcpu and check its return value.
>
>
> > +
> > +     reg_attr->vcpu = kvm_mpidr_to_vcpu(dev->kvm, cpuid);
>
> please check the return value of this function in any case...
>
> > +     reg_attr->addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
> > +
> > +     return 0;
> > +}
> > +
> > +/**
> > + * vgic_attr_regs_access_v3 - allows user space to access VGIC v3 state
> > + *
> > + * @dev:      kvm device handle
> > + * @attr:     kvm device attribute
> > + * @reg:      address the value is read or written
> > + * @is_write: true if userspace is writing a register
> > + */
> > +static int vgic_attr_regs_access_v3(struct kvm_device *dev,
> > +                                 struct kvm_device_attr *attr,
> > +                                 u64 *reg, bool is_write)
> > +{
> > +     struct vgic_reg_attr reg_attr;
> > +     gpa_t addr;
> > +     struct kvm_vcpu *vcpu;
> > +     int ret;
> > +     u32 tmp32;
> > +
> > +     ret = parse_vgic_v3_attr(dev, attr, &reg_attr);
> > +     if (ret)
> > +             return ret;
> > +
> > +     vcpu = reg_attr.vcpu;
> > +     addr = reg_attr.addr;
> > +
> > +     mutex_lock(&dev->kvm->lock);
> > +
> > +     ret = vgic_init(dev->kvm);
> > +     if (ret)
> > +             goto out;
>
> no, no, please no more auto-init at userspace access time.  This code
> should instead check vgic_initialized() and return an error to userspace
> if not initialized.
>
> Ok. I wil fix it. It is coming from v2 code.
>


> > +
> > +     if (!lock_all_vcpus(dev->kvm)) {
> > +             ret = -EBUSY;
> > +             goto out;
> > +     }
> > +
> > +     switch (attr->group) {
> > +     case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> > +             tmp32 = *reg;
>
> why is this assignment not predicated on if (is_write) ?
>
> also, all this type conversion nonsense is probably unnecessary, see my
> comment below.
>
> > +             ret = vgic_v3_dist_uaccess(vcpu, is_write, addr, &tmp32);
> > +             if (!is_write)
> > +                     *reg = tmp32;
> > +             break;
> > +     case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> > +             tmp32 = *reg;
> > +             ret = vgic_v3_redist_uaccess(vcpu, is_write, addr, &tmp32);
> > +             if (!is_write)
> > +                     *reg = tmp32;
> > +             break;
> > +     default:
> > +             ret = -EINVAL;
> > +             break;
> > +     }
> > +
> > +     unlock_all_vcpus(dev->kvm);
> > +out:
> > +     mutex_unlock(&dev->kvm->lock);
> > +     return ret;
> > +}
> > +
> >  static int vgic_v3_set_attr(struct kvm_device *dev,
> >                           struct kvm_device_attr *attr)
> >  {
> > -     return vgic_set_common_attr(dev, attr);
> > +     int ret;
> > +
> > +     ret = vgic_set_common_attr(dev, attr);
> > +     if (ret != -ENXIO)
> > +             return ret;
> > +
> > +     switch (attr->group) {
> > +     case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> > +     case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS: {
> > +             u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> > +             u32 tmp32;
> > +             u64 reg;
> > +
> > +             if (get_user(tmp32, uaddr))
> > +                     return -EFAULT;
> > +
> > +             reg = tmp32;
> > +             return vgic_attr_regs_access_v3(dev, attr, &reg, true);
>
> oh, but wait, you already had a 32-bit value, which you convert into a
> 64-bit value, just to convert it back again, to do some extra data
> copies?
>
> I'm really confused as to why this has to be so complicated.
>
> Why not simply use u32 all the way?
>

    vgic_attr_regs_access_v3() is used for handling both GICD/GICR and
SYSREGS. For this reason we convert u32 to 64 and vice versa.
To avoid these conversions, I can create separate vgic_attr_regs_access_v3()
functions for GICD and SYSREGS.

--001a113d47f2259bfe053bd708e0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Tue, Aug 30, 2016 at 6:01 PM, Christoffer Dall <span dir=3D"ltr">&lt=
;<a href=3D"mailto:christoffer.dall@linaro.org" target=3D"_blank">christoff=
er.dall@linaro.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quot=
e" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204)=
;padding-left:1ex"><div><div><div>On Wed, Aug 24, 2016 at 04:50:06PM +0530,=
 <a href=3D"mailto:vijay.kilari@gmail.com" target=3D"_blank">vijay.kilari@g=
mail.com</a> wrote:<br>
&gt; From: Vijaya Kumar K &lt;<a href=3D"mailto:Vijaya.Kumar@cavium.com" ta=
rget=3D"_blank">Vijaya.Kumar@cavium.com</a>&gt;<br>
&gt;<br>
&gt; VGICv3 Distributor and Redistributor registers are accessed using<br>
&gt; KVM_DEV_ARM_VGIC_GRP_DIST_REGS and KVM_DEV_ARM_VGIC_GRP_DIST_REGS<br>
&gt; with KVM_SET_DEVICE_ATTR and KVM_GET_DEVICE_ATTR ioctls.<br>
&gt; These registers are accessed as 32-bit and cpu mpidr<br>
&gt; value passed along with register offset is used to identify the<br>
&gt; cpu for redistributor registers access.<br>
&gt;<br>
&gt; The version of VGIC v3 specification is define here<br>
&gt; <a href=3D"http://lists.infradead.org/pipermail/linux-arm-kernel/2016-=
July/445611.html" rel=3D"noreferrer" target=3D"_blank">http://lists.infrade=
ad.org/pip<wbr>ermail/linux-arm-kernel/2016-<wbr>July/445611.html</a><br>
&gt;<br>
&gt; Signed-off-by: Vijaya Kumar K &lt;<a href=3D"mailto:Vijaya.Kumar@caviu=
m.com" target=3D"_blank">Vijaya.Kumar@cavium.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 arch/arm64/include/uapi/asm/kv<wbr>m.h=C2=A0 =C2=A0|=C2=A0 =C2=
=A03 +<br>
&gt;=C2=A0 virt/kvm/arm/vgic/vgic-kvm-dev<wbr>ice.c | 127 +++++++++++++++++=
+++++++++++++<wbr>+++++-<br>
&gt;=C2=A0 virt/kvm/arm/vgic/vgic-mmio-v3<wbr>.c=C2=A0 =C2=A0 | 113 +++++++=
+++++++++++++++++++++++<wbr>++<br>
&gt;=C2=A0 virt/kvm/arm/vgic/vgic-mmio.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =
=C2=A02 +-<br>
&gt;=C2=A0 virt/kvm/arm/vgic/vgic.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 =C2=A08 +++<br>
&gt;=C2=A0 5 files changed, 250 insertions(+), 3 deletions(-)<br>
&gt;<br>
&gt; diff --git a/arch/arm64/include/uapi/asm/<wbr>kvm.h b/arch/arm64/inclu=
de/uapi/asm/<wbr>kvm.h<br>
&gt; index 3051f86..94ea676 100644<br>
&gt; --- a/arch/arm64/include/uapi/asm/<wbr>kvm.h<br>
&gt; +++ b/arch/arm64/include/uapi/asm/<wbr>kvm.h<br>
&gt; @@ -201,10 +201,13 @@ struct kvm_arch_memory_slot {<br>
&gt;=C2=A0 #define KVM_DEV_ARM_VGIC_GRP_CPU_REGS=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 2<br>
&gt;=C2=A0 #define=C2=A0 =C2=A0KVM_DEV_ARM_VGIC_CPUID_SHIFT=C2=A0 =C2=A0 =
=C2=A0 =C2=A032<br>
&gt;=C2=A0 #define=C2=A0 =C2=A0KVM_DEV_ARM_VGIC_CPUID_MASK=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 (0xffULL &lt;&lt; KVM_DEV_ARM_VGIC_CPUID_SHIFT)<br>
&gt; +#define=C2=A0 =C2=A0KVM_DEV_ARM_VGIC_V3_CPUID_<wbr>MASK \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(0xffffffffULL &lt;&lt; KVM_DEV_ARM_VGIC=
_CPUID_SHIFT)<br>
<br>
</div></div>I think this should be KVM_DEV_ARM_VGIC_V3_MPIDR_MASK<wbr>, and=
 I would<br>
probably define a V3 of the shift as well, since we&#39;re really talking<b=
r>
about two distinct APIs here.<br>
<span><br>
&gt;=C2=A0 #define=C2=A0 =C2=A0KVM_DEV_ARM_VGIC_OFFSET_<wbr>SHIFT=C2=A0 =C2=
=A0 =C2=A0 0<br>
&gt;=C2=A0 #define=C2=A0 =C2=A0KVM_DEV_ARM_VGIC_OFFSET_MASK=C2=A0 =C2=A0 =
=C2=A0 =C2=A0(0xffffffffULL &lt;&lt; KVM_DEV_ARM_VGIC_OFFSET_SHIFT)<br>
&gt;=C2=A0 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS 3<br>
&gt;=C2=A0 #define KVM_DEV_ARM_VGIC_GRP_CTRL=C2=A0 =C2=A0 4<br>
&gt; +#define KVM_DEV_ARM_VGIC_GRP_REDIST_RE<wbr>GS 5<br>
&gt;=C2=A0 #define=C2=A0 =C2=A0KVM_DEV_ARM_VGIC_CTRL_INIT 0<br>
&gt;<br>
&gt;=C2=A0 /* Device Control API on vcpu fd */<br>
&gt; diff --git a/virt/kvm/arm/vgic/vgic-kvm-d<wbr>evice.c b/virt/kvm/arm/v=
gic/vgic-kvm-d<wbr>evice.c<br>
&gt; index 163b057..06f0158 100644<br>
&gt; --- a/virt/kvm/arm/vgic/vgic-kvm-d<wbr>evice.c<br>
&gt; +++ b/virt/kvm/arm/vgic/vgic-kvm-d<wbr>evice.c<br>
&gt; @@ -433,16 +433,136 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops =3D {=
<br>
&gt;<br>
&gt;=C2=A0 #ifdef CONFIG_KVM_ARM_VGIC_V3<br>
&gt;<br>
&gt; +static int parse_vgic_v3_attr(struct kvm_device *dev,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct kvm_device_attr *attr,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct vgic_reg_attr *reg_attr)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int cpuid;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0cpuid =3D (attr-&gt;attr &amp; KVM_DEV_ARM_VGIC_V=
3_CPUID_MASK<wbr>) &gt;&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 KVM_DEV_ARM_VGIC_CPU=
ID_SHIFT;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (cpuid &gt;=3D atomic_read(&amp;dev-&gt;kvm-&g=
t;online_<wbr>vcpus))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
<br>
</span>huh?=C2=A0 it&#39;s an MPIDR, not a cpu id.<br>
<br>
just resolve it with kvm_mpidr_to_vcpu and check its return value.<br>
<span><br>
<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0reg_attr-&gt;vcpu =3D kvm_mpidr_to_vcpu(dev-&gt;k=
vm, cpuid);<br>
<br>
</span>please check the return value of this function in any case...<br>
<div><div><br>
&gt; +=C2=A0 =C2=A0 =C2=A0reg_attr-&gt;addr =3D attr-&gt;attr &amp; KVM_DEV=
_ARM_VGIC_OFFSET_MASK;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +}<br>
&gt; +<br>
&gt; +/**<br>
&gt; + * vgic_attr_regs_access_v3 - allows user space to access VGIC v3 sta=
te<br>
&gt; + *<br>
&gt; + * @dev:=C2=A0 =C2=A0 =C2=A0 kvm device handle<br>
&gt; + * @attr:=C2=A0 =C2=A0 =C2=A0kvm device attribute<br>
&gt; + * @reg:=C2=A0 =C2=A0 =C2=A0 address the value is read or written<br>
&gt; + * @is_write: true if userspace is writing a register<br>
&gt; + */<br>
&gt; +static int vgic_attr_regs_access_v3(struc<wbr>t kvm_device *dev,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct kvm_device_attr *at=
tr,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u64 *reg, bool is_write)<b=
r>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct vgic_reg_attr reg_attr;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0gpa_t addr;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct kvm_vcpu *vcpu;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int ret;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0u32 tmp32;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0ret =3D parse_vgic_v3_attr(dev, attr, &amp;reg_at=
tr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (ret)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0vcpu =3D reg_attr.vcpu;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0addr =3D reg_attr.addr;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0mutex_lock(&amp;dev-&gt;kvm-&gt;lock);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0ret =3D vgic_init(dev-&gt;kvm);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (ret)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
<br>
</div></div>no, no, please no more auto-init at userspace access time.=C2=
=A0 This code<br>
should instead check vgic_initialized() and return an error to userspace<br=
>
if not initialized.<br>
<span><br>
</span></div><span>Ok. I wil fix it. It is coming from v2 code.<br></span><=
/blockquote><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1=
ex"><span></span><div><span>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!lock_all_vcpus(dev-&gt;kvm)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EBUSY;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0switch (attr-&gt;group) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0case KVM_DEV_ARM_VGIC_GRP_DIST_REGS<wbr>:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tmp32 =3D *reg;<br>
<br>
</span>why is this assignment not predicated on if (is_write) ?<br>
<br>
also, all this type conversion nonsense is probably unnecessary, see my<br>
comment below.<br>
<div><div><br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D vgic_v3_dist_=
uaccess(vcpu, is_write, addr, &amp;tmp32);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!is_write)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0*reg =3D tmp32;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0case KVM_DEV_ARM_VGIC_GRP_REDIST_RE<wbr>GS:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tmp32 =3D *reg;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D vgic_v3_redis=
t_uaccess(vcpu, is_write, addr, &amp;tmp32);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!is_write)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0*reg =3D tmp32;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0default:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EINVAL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0unlock_all_vcpus(dev-&gt;kvm);<br>
&gt; +out:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0mutex_unlock(&amp;dev-&gt;kvm-&gt;lock)<wbr>;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt; +}<br>
&gt; +<br>
&gt;=C2=A0 static int vgic_v3_set_attr(struct kvm_device *dev,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct kvm_device_attr *attr)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return vgic_set_common_attr(dev, attr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int ret;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0ret =3D vgic_set_common_attr(dev, attr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (ret !=3D -ENXIO)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0switch (attr-&gt;group) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0case KVM_DEV_ARM_VGIC_GRP_DIST_REGS<wbr>:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0case KVM_DEV_ARM_VGIC_GRP_REDIST_RE<wbr>GS: {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 __user *uaddr =3D=
 (u32 __user *)(long)attr-&gt;addr;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 tmp32;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u64 reg;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (get_user(tmp32, u=
addr))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return -EFAULT;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0reg =3D tmp32;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return vgic_attr_regs=
_access_v3(dev, attr, &amp;reg, true);<br>
<br>
</div></div>oh, but wait, you already had a 32-bit value, which you convert=
 into a<br>
64-bit value, just to convert it back again, to do some extra data<br>
copies?<br>
<br>
I&#39;m really confused as to why this has to be so complicated.<br>
<br>
Why not simply use u32 all the way?<br></div></blockquote><div><br>=C2=A0=
=C2=A0=C2=A0 vgic_attr_regs_access_v3() is used for handling both GICD/GICR=
 and<br></div><div>SYSREGS. For this reason we convert u32 to 64 and vice v=
ersa.<br></div><div>To avoid these conversions, I can create separate vgic_=
attr_regs_access_v3()<br></div><div>functions for GICD and SYSREGS.<br><br>=
</div><br></div></div></div>

--001a113d47f2259bfe053bd708e0--

--===============2099161562832472340==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2099161562832472340==--
