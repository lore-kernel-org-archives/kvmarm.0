From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [RFC PATCH v3 4/5] arm/arm64: vgic-new: Implement VGICv3 CPU
 interface access
Date: Tue, 6 Sep 2016 19:18:55 +0530
Message-ID: <CALicx6vW9Lu7nNu86d-+a985iSH2vZ7ekb_5AgCxct-z90M7Wg@mail.gmail.com>
References: <1472037609-4164-1-git-send-email-vijay.kilari@gmail.com>
 <1472037609-4164-5-git-send-email-vijay.kilari@gmail.com>
 <20160830134514.GJ10162@cbox>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1125443888910466816=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9512C49B53
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 09:40:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wukuqg7DZq+k for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 09:40:32 -0400 (EDT)
Received: from mail-oi0-f43.google.com (mail-oi0-f43.google.com
 [209.85.218.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 025ED49B47
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 09:40:31 -0400 (EDT)
Received: by mail-oi0-f43.google.com with SMTP id y2so72284190oie.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2016 06:48:56 -0700 (PDT)
In-Reply-To: <20160830134514.GJ10162@cbox>
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

--===============1125443888910466816==
Content-Type: multipart/alternative; boundary=001a113d47f2ceb4c7053bd70e48

--001a113d47f2ceb4c7053bd70e48
Content-Type: text/plain; charset=UTF-8

On Tue, Aug 30, 2016 at 7:15 PM, Christoffer Dall <
christoffer.dall@linaro.org> wrote:

> On Wed, Aug 24, 2016 at 04:50:08PM +0530, vijay.kilari@gmail.com wrote:
> > From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>


> > diff --git a/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> > new file mode 100644
> > index 0000000..581d053
> > --- /dev/null
> > +++ b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> > @@ -0,0 +1,211 @@
> > +#include <linux/irqchip/arm-gic-v3.h>
> > +#include <linux/kvm.h>
> > +#include <linux/kvm_host.h>
> > +#include <kvm/iodev.h>
> > +#include <kvm/arm_vgic.h>
> > +#include <asm/kvm_emulate.h>
> > +#include <asm/kvm_arm.h>
> > +#include <asm/kvm_mmu.h>
> > +
> > +#include "vgic.h"
> > +#include "vgic-mmio.h"
> > +#include "sys_regs.h"
> > +
> > +static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct
> sys_reg_params *p,
> > +                         const struct sys_reg_desc *r)
> > +{
> > +     struct vgic_vmcr vmcr;
> > +
> > +     vgic_get_vmcr(vcpu, &vmcr);
> > +     if (p->is_write) {
> > +             vmcr.ctlr = (u32)p->regval;
> > +             vgic_set_vmcr(vcpu, &vmcr);
> > +     } else {
> > +             p->regval = vmcr.ctlr;
> > +     }
> > +
>
> really?  Have you looked at the spec and implementation of this or did
> you just copy the v2 code?
>
> The ICH_VMCR_EL2 register field mappings are not identical to the ctlr
> mappings.  I think this causes some rework for much of this patch, so
> I'll have a look at the next revision.
>

  ICH_VMCR_EL2.VEOIM &  ICH_VMCR_EL2.CBPR holds
ICC_CTLR_EL1.EOImode & ICC_CTLR_EL1.CBPR  respectively.
Remaining fields are Readonly except PHME. AFAIK, vgic is not
holding ICC_CTLR_EL1 except the fields in ICH_VMCR_EL2.

>
> > +     return true;
> > +}
> > +
> > +static bool access_gic_pmr(struct kvm_vcpu *vcpu, struct sys_reg_params
> *p,
> > +                        const struct sys_reg_desc *r)
> > +{
> > +     struct vgic_vmcr vmcr;
> > +
> > +     vgic_get_vmcr(vcpu, &vmcr);
> > +     if (p->is_write) {
> > +             vmcr.pmr = (u32)p->regval;
> > +             vgic_set_vmcr(vcpu, &vmcr);
> > +     } else {
> > +             p->regval = vmcr.pmr;
> > +     }
> > +
> > +     return true;
> > +}
> > +
> > +static bool access_gic_bpr0(struct kvm_vcpu *vcpu, struct
> sys_reg_params *p,
> > +                         const struct sys_reg_desc *r)
> > +{
> > +     struct vgic_vmcr vmcr;
> > +
> > +     vgic_get_vmcr(vcpu, &vmcr);
> > +     if (p->is_write) {
> > +             vmcr.bpr = (u32)p->regval;
> > +             vgic_set_vmcr(vcpu, &vmcr);
> > +     } else {
> > +             p->regval = vmcr.bpr;
> > +     }
> > +
> > +     return true;
> > +}
> > +
> > +static bool access_gic_bpr1(struct kvm_vcpu *vcpu, struct
> sys_reg_params *p,
> > +                         const struct sys_reg_desc *r)
> > +{
> > +     struct vgic_vmcr vmcr;
> > +
> > +     vgic_get_vmcr(vcpu, &vmcr);
> > +     if (p->is_write) {
> > +             vmcr.abpr = (u32)p->regval;
> > +             vgic_set_vmcr(vcpu, &vmcr);
> > +     } else {
> > +             p->regval = vmcr.abpr;
> > +     }
> > +
> > +     return true;
> > +}
> > +
> > +static bool access_gic_grpen0(struct kvm_vcpu *vcpu, struct
> sys_reg_params *p,
> > +                           const struct sys_reg_desc *r)
> > +{
> > +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> > +
> > +     if (p->is_write) {
> > +             vgicv3->vgic_vmcr &= ~ICH_VMCR_ENG0;
> > +             vgicv3->vgic_vmcr |= (p->regval << ICH_VMCR_ENG0_SHIFT) &
> > +                                   ICH_VMCR_ENG0;
> > +     } else {
> > +             p->regval = (vgicv3->vgic_vmcr & ICH_VMCR_ENG0) >>
> > +                          ICH_VMCR_ENG0_SHIFT;
> > +     }
>
> so for example, why shouldn't these go through the vgic_set/get_vmcr
> wrappers?
>

The vgic_vmcr struct as below is not managing ENG0 and ENG1 fields.
So could not use vgic_set/get wrappers.

struct vgic_vmcr {
        u32     ctlr;
        u32     abpr;
        u32     bpr;
        u32     pmr;
};



>
> > +
> > +     return true;
> > +}
> > +
> > +static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct
> sys_reg_params *p,
> > +                           const struct sys_reg_desc *r)
> > +{
> > +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> > +
> > +     if (p->is_write) {
> > +             vgicv3->vgic_vmcr &= ~ICH_VMCR_ENG1;
> > +             vgicv3->vgic_vmcr |= (p->regval << ICH_VMCR_ENG1_SHIFT) &
> > +                                   ICH_VMCR_ENG1;
> > +     } else {
> > +             p->regval = (vgicv3->vgic_vmcr & ICH_VMCR_ENG1) >>
> > +                          ICH_VMCR_ENG1_SHIFT;
> > +     }
> > +
> > +     return true;
> > +}
> > +
> > +static bool access_gic_ap0r(struct kvm_vcpu *vcpu, struct
> sys_reg_params *p,
> > +                         const struct sys_reg_desc *r)
> > +{
> > +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> > +     u8 idx = r->Op2 & 3;
> > +
> > +     if (p->is_write)
> > +             vgicv3->vgic_ap0r[idx] = p->regval;
> > +     else
> > +             p->regval = vgicv3->vgic_ap0r[idx];
> > +
> > +     return true;
> > +}
> > +
> > +static bool access_gic_ap1r(struct kvm_vcpu *vcpu, struct
> sys_reg_params *p,
> > +                         const struct sys_reg_desc *r)
> > +{
> > +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> > +     u8 idx = r->Op2 & 3;
> > +
> > +     if (p->is_write)
> > +             vgicv3->vgic_ap1r[idx] = p->regval;
> > +     else
> > +             p->regval = vgicv3->vgic_ap1r[idx];
> > +
> > +     return true;
> > +}
> > +
> > +static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
> > +     /* ICC_PMR_EL1 */
> > +     { Op0(3), Op1(0), CRn(4), CRm(6), Op2(0), access_gic_pmr },
> > +     /* ICC_BPR0_EL1 */
> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(3), access_gic_bpr0 },
> > +     /* ICC_AP0R0_EL1 */
> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(4), access_gic_ap0r },
> > +     /* ICC_AP0R1_EL1 */
> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(5), access_gic_ap0r },
> > +     /* ICC_AP0R2_EL1 */
> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(6), access_gic_ap0r },
> > +     /* ICC_AP0R3_EL1 */
> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(7), access_gic_ap0r },
> > +     /* ICC_AP1R0_EL1 */
> > +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(0), access_gic_ap1r },
> > +     /* ICC_AP1R1_EL1 */
> > +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(1), access_gic_ap1r },
> > +     /* ICC_AP1R2_EL1 */
> > +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(2), access_gic_ap1r },
> > +     /* ICC_AP1R3_EL1 */
> > +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(3), access_gic_ap1r },
> > +     /* ICC_BPR1_EL1 */
> > +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(3), access_gic_bpr1 },
> > +     /* ICC_CTLR_EL1 */
> > +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(4), access_gic_ctlr },
> > +     /* ICC_IGRPEN0_EL1 */
> > +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(6), access_gic_grpen0 },
> > +     /* ICC_GRPEN1_EL1 */
> > +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(7), access_gic_grpen1 },
>
> Do we need to allow userspace to at least read ICC_SRE_EL1?


ICC_SRE_EL1.SRE is enabled at vgic initialization and DIB and FDB are not
configured.
    So save and restore does not make any effect.


> Should we verify that the DIB and FDB fields of that register are
> written as the system understands them (clear, WI)?
>

  What kind of verification we can do on DIB and FDB by userspace?.

>
> > +
> > +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> u64 id,
> > +                             u64 *reg)
> > +{
> > +     struct sys_reg_params params;
> > +     const struct sys_reg_desc *r;
> > +
> > +     if (is_write)
> > +             params.regval = le64_to_cpu(*reg);
>
> why do we need this conversion here?
>
>    The registers are managed in LE mode. So here the value to be
writtern is coverted to LE mode and similarly on reading back it is
converted
from LE.

> +     params.is_write = is_write;
> > +     params.is_aarch32 = false;
> > +     params.is_32bit = false;
> > +
> > +     r = find_reg_by_id(id, &params, gic_v3_icc_reg_descs,
> > +                        ARRAY_SIZE(gic_v3_icc_reg_descs));
> > +     if (!r)
> > +             return -ENXIO;
> > +
> > +     if (!r->access(vcpu, &params, r))
> > +             return -EINVAL;
> > +
> > +     if (!is_write)
> > +             *reg = cpu_to_le64(params.regval);
>
> same question as above
>
>

--001a113d47f2ceb4c7053bd70e48
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Tue, Aug 30, 2016 at 7:15 PM, Christoffer Dall <span dir=3D"ltr">&lt=
;<a href=3D"mailto:christoffer.dall@linaro.org" target=3D"_blank">christoff=
er.dall@linaro.org</a>&gt;</span> wrote:<br><blockquote style=3D"margin:0px=
 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex" cla=
ss=3D"gmail_quote"><div><div>On Wed, Aug 24, 2016 at 04:50:08PM +0530, <a h=
ref=3D"mailto:vijay.kilari@gmail.com" target=3D"_blank">vijay.kilari@gmail.=
com</a> wrote:<br>
&gt; From: Vijaya Kumar K &lt;<a href=3D"mailto:Vijaya.Kumar@cavium.com" ta=
rget=3D"_blank">Vijaya.Kumar@cavium.com</a>&gt;<br></div></div></blockquote=
><div>=C2=A0</div><blockquote style=3D"margin:0px 0px 0px 0.8ex;border-left=
:1px solid rgb(204,204,204);padding-left:1ex" class=3D"gmail_quote"><div><d=
iv></div></div>
<span></span><div><div>
&gt; diff --git a/virt/kvm/arm/vgic/vgic-sys-r<wbr>eg-v3.c b/virt/kvm/arm/v=
gic/vgic-sys-r<wbr>eg-v3.c<br>
&gt; new file mode 100644<br>
&gt; index 0000000..581d053<br>
&gt; --- /dev/null<br>
&gt; +++ b/virt/kvm/arm/vgic/vgic-sys-r<wbr>eg-v3.c<br>
&gt; @@ -0,0 +1,211 @@<br>
&gt; +#include &lt;linux/irqchip/arm-gic-v3.h&gt;<br>
&gt; +#include &lt;linux/kvm.h&gt;<br>
&gt; +#include &lt;linux/kvm_host.h&gt;<br>
&gt; +#include &lt;kvm/iodev.h&gt;<br>
&gt; +#include &lt;kvm/arm_vgic.h&gt;<br>
&gt; +#include &lt;asm/kvm_emulate.h&gt;<br>
&gt; +#include &lt;asm/kvm_arm.h&gt;<br>
&gt; +#include &lt;asm/kvm_mmu.h&gt;<br>
&gt; +<br>
&gt; +#include &quot;vgic.h&quot;<br>
&gt; +#include &quot;vgic-mmio.h&quot;<br>
&gt; +#include &quot;sys_regs.h&quot;<br>
&gt; +<br>
&gt; +static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_par=
ams *p,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0const struct sys_reg_desc *r)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct vgic_vmcr vmcr;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0vgic_get_vmcr(vcpu, &amp;vmcr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (p-&gt;is_write) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vmcr.ctlr =3D (u32)p-=
&gt;regval;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vgic_set_vmcr(vcpu, &=
amp;vmcr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p-&gt;regval =3D vmcr=
.ctlr;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
<br>
</div></div>really?=C2=A0 Have you looked at the spec and implementation of=
 this or did<br>
you just copy the v2 code?<br>
<br>
The ICH_VMCR_EL2 register field mappings are not identical to the ctlr<br>
mappings.=C2=A0 I think this causes some rework for much of this patch, so<=
br>
I&#39;ll have a look at the next revision.<br></blockquote><div><br></div><=
div>=C2=A0 ICH_VMCR_EL2.VEOIM &amp;=C2=A0 ICH_VMCR_EL2.CBPR holds<br></div>=
<div>ICC_CTLR_EL1.EOImode &amp; ICC_CTLR_EL1.CBPR=C2=A0 respectively.<br></=
div><div>Remaining fields are Readonly except PHME. AFAIK, vgic is not<br><=
/div><div>holding ICC_CTLR_EL1 except the fields in ICH_VMCR_EL2.<br></div>=
<blockquote style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204=
,204,204);padding-left:1ex" class=3D"gmail_quote">
<div><div><br>
&gt; +=C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +}<br>
&gt; +<br>
&gt; +static bool access_gic_pmr(struct kvm_vcpu *vcpu, struct sys_reg_para=
ms *p,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 const struct sys_reg_desc *r)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct vgic_vmcr vmcr;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0vgic_get_vmcr(vcpu, &amp;vmcr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (p-&gt;is_write) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vmcr.pmr =3D (u32)p-&=
gt;regval;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vgic_set_vmcr(vcpu, &=
amp;vmcr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p-&gt;regval =3D vmcr=
.pmr;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +}<br>
&gt; +<br>
&gt; +static bool access_gic_bpr0(struct kvm_vcpu *vcpu, struct sys_reg_par=
ams *p,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0const struct sys_reg_desc *r)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct vgic_vmcr vmcr;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0vgic_get_vmcr(vcpu, &amp;vmcr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (p-&gt;is_write) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vmcr.bpr =3D (u32)p-&=
gt;regval;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vgic_set_vmcr(vcpu, &=
amp;vmcr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p-&gt;regval =3D vmcr=
.bpr;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +}<br>
&gt; +<br>
&gt; +static bool access_gic_bpr1(struct kvm_vcpu *vcpu, struct sys_reg_par=
ams *p,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0const struct sys_reg_desc *r)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct vgic_vmcr vmcr;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0vgic_get_vmcr(vcpu, &amp;vmcr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (p-&gt;is_write) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vmcr.abpr =3D (u32)p-=
&gt;regval;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vgic_set_vmcr(vcpu, &=
amp;vmcr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p-&gt;regval =3D vmcr=
.abpr;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +}<br>
&gt; +<br>
&gt; +static bool access_gic_grpen0(struct kvm_vcpu *vcpu, struct sys_reg_p=
arams *p,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct sys_reg_desc *r)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct vgic_v3_cpu_if *vgicv3 =3D &amp;vcpu-&gt;a=
rch.vgic_cpu.vgic_v3;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (p-&gt;is_write) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vgicv3-&gt;vgic_vmcr =
&amp;=3D ~ICH_VMCR_ENG0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vgicv3-&gt;vgic_vmcr =
|=3D (p-&gt;regval &lt;&lt; ICH_VMCR_ENG0_SHIFT) &amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ICH_VMCR_ENG0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p-&gt;regval =3D (vgi=
cv3-&gt;vgic_vmcr &amp; ICH_VMCR_ENG0) &gt;&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 ICH_VMCR_ENG0_SHIFT;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
<br>
</div></div>so for example, why shouldn&#39;t these go through the vgic_set=
/get_vmcr<br>
wrappers?<br></blockquote><div><br></div><div>The vgic_vmcr struct as below=
 is not managing ENG0 and ENG1 fields.<br></div><div>So could not use vgic_=
set/get wrappers.<br></div><div><br>struct vgic_vmcr {<br>=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32=C2=A0=C2=A0=C2=A0=C2=A0 ctlr;<br>=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32=C2=A0=C2=A0=C2=A0=C2=A0 abpr;<br>=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32=C2=A0=C2=A0=C2=A0=C2=A0 bpr;<br=
>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32=C2=A0=C2=A0=C2=A0=C2=A0 pmr=
;<br>};<br><br>=C2=A0<br></div><blockquote style=3D"margin:0px 0px 0px 0.8e=
x;border-left:1px solid rgb(204,204,204);padding-left:1ex" class=3D"gmail_q=
uote">
<div><div><br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +}<br>
&gt; +<br>
&gt; +static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct sys_reg_p=
arams *p,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct sys_reg_desc *r)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct vgic_v3_cpu_if *vgicv3 =3D &amp;vcpu-&gt;a=
rch.vgic_cpu.vgic_v3;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (p-&gt;is_write) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vgicv3-&gt;vgic_vmcr =
&amp;=3D ~ICH_VMCR_ENG1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vgicv3-&gt;vgic_vmcr =
|=3D (p-&gt;regval &lt;&lt; ICH_VMCR_ENG1_SHIFT) &amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ICH_VMCR_ENG1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p-&gt;regval =3D (vgi=
cv3-&gt;vgic_vmcr &amp; ICH_VMCR_ENG1) &gt;&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 ICH_VMCR_ENG1_SHIFT;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +}<br>
&gt; +<br>
&gt; +static bool access_gic_ap0r(struct kvm_vcpu *vcpu, struct sys_reg_par=
ams *p,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0const struct sys_reg_desc *r)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct vgic_v3_cpu_if *vgicv3 =3D &amp;vcpu-&gt;a=
rch.vgic_cpu.vgic_v3;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0u8 idx =3D r-&gt;Op2 &amp; 3;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (p-&gt;is_write)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vgicv3-&gt;vgic_ap0r[=
idx] =3D p-&gt;regval;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0else<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p-&gt;regval =3D vgic=
v3-&gt;vgic_ap0r[idx];<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +}<br>
&gt; +<br>
&gt; +static bool access_gic_ap1r(struct kvm_vcpu *vcpu, struct sys_reg_par=
ams *p,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0const struct sys_reg_desc *r)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct vgic_v3_cpu_if *vgicv3 =3D &amp;vcpu-&gt;a=
rch.vgic_cpu.vgic_v3;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0u8 idx =3D r-&gt;Op2 &amp; 3;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (p-&gt;is_write)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vgicv3-&gt;vgic_ap1r[=
idx] =3D p-&gt;regval;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0else<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p-&gt;regval =3D vgic=
v3-&gt;vgic_ap1r[idx];<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +}<br>
&gt; +<br>
&gt; +static const struct sys_reg_desc gic_v3_icc_reg_descs[] =3D {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* ICC_PMR_EL1 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op0(3), Op1(0), CRn(4), CRm(6), Op2(0), access_=
gic_pmr },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* ICC_BPR0_EL1 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(3), access=
_gic_bpr0 },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* ICC_AP0R0_EL1 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(4), access=
_gic_ap0r },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* ICC_AP0R1_EL1 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(5), access=
_gic_ap0r },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* ICC_AP0R2_EL1 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(6), access=
_gic_ap0r },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* ICC_AP0R3_EL1 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(7), access=
_gic_ap0r },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* ICC_AP1R0_EL1 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(0), access=
_gic_ap1r },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* ICC_AP1R1_EL1 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(1), access=
_gic_ap1r },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* ICC_AP1R2_EL1 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(2), access=
_gic_ap1r },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* ICC_AP1R3_EL1 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(3), access=
_gic_ap1r },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* ICC_BPR1_EL1 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(3), acces=
s_gic_bpr1 },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* ICC_CTLR_EL1 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(4), acces=
s_gic_ctlr },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* ICC_IGRPEN0_EL1 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(6), acces=
s_gic_grpen0 },<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* ICC_GRPEN1_EL1 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(7), acces=
s_gic_grpen1 },<br>
<br>
</div></div>Do we need to allow userspace to at least read ICC_SRE_EL1?</bl=
ockquote><div>=C2=A0<br>ICC_SRE_EL1.SRE is enabled at vgic initialization a=
nd DIB and FDB are not configured.<br></div><div>=C2=A0 =C2=A0 So save and =
restore does not make any effect.<br>=C2=A0<br></div><blockquote style=3D"m=
argin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left=
:1ex" class=3D"gmail_quote">
Should we verify that the DIB and FDB fields of that register are<br>
written as the system understands them (clear, WI)?<br></blockquote><div><b=
r></div><div>=C2=A0 What kind of verification we can do on DIB and FDB by u=
serspace?.<br></div><blockquote style=3D"margin:0px 0px 0px 0.8ex;border-le=
ft:1px solid rgb(204,204,204);padding-left:1ex" class=3D"gmail_quote">
<span><br>
&gt; +<br>
&gt; +int vgic_v3_cpu_sysregs_uaccess(st<wbr>ruct kvm_vcpu *vcpu, bool is_w=
rite, u64 id,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u64 *reg)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct sys_reg_params params;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0const struct sys_reg_desc *r;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (is_write)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0params.regval =3D le6=
4_to_cpu(*reg);<br>
<br>
</span>why do we need this conversion here?<br>
<span><br></span></blockquote><div>=C2=A0=C2=A0 The registers are managed i=
n LE mode. So here the value to be<br></div><div>writtern is coverted to LE=
 mode and similarly on reading back it is converted<br></div><div>from LE.<=
br><br></div><blockquote style=3D"margin:0px 0px 0px 0.8ex;border-left:1px =
solid rgb(204,204,204);padding-left:1ex" class=3D"gmail_quote"><span>
&gt; +=C2=A0 =C2=A0 =C2=A0params.is_write =3D is_write;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0params.is_aarch32 =3D false;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0params.is_32bit =3D false;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0r =3D find_reg_by_id(id, &amp;params, gic_v3_icc_=
reg_descs,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 ARRAY_SIZE(gic_v3_icc_reg_desc<wbr>s));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!r)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENXIO;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!r-&gt;access(vcpu, &amp;params, r))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!is_write)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*reg =3D cpu_to_le64(=
params.regval);<br>
<br>
</span>same question as above<br>
<div><div><br>
</div></div></blockquote></div><br></div></div>

--001a113d47f2ceb4c7053bd70e48--

--===============1125443888910466816==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1125443888910466816==--
