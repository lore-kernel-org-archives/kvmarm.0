From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [RFC PATCH v3 4/5] arm/arm64: vgic-new: Implement VGICv3 CPU
 interface access
Date: Tue, 6 Sep 2016 19:43:23 +0530
Message-ID: <CALicx6s=ih2E-KrCD=J2beJ_=PmSUcf55T77A00USwu1WiJbxw@mail.gmail.com>
References: <1472037609-4164-1-git-send-email-vijay.kilari@gmail.com>
 <1472037609-4164-5-git-send-email-vijay.kilari@gmail.com>
 <20160830134514.GJ10162@cbox>
 <CALicx6vW9Lu7nNu86d-+a985iSH2vZ7ekb_5AgCxct-z90M7Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B231D49B5C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 10:05:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ASelGM63+VEf for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 10:04:59 -0400 (EDT)
Received: from mail-oi0-f67.google.com (mail-oi0-f67.google.com
 [209.85.218.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BEE7840FA2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 10:04:59 -0400 (EDT)
Received: by mail-oi0-f67.google.com with SMTP id v82so8021722oie.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2016 07:13:24 -0700 (PDT)
In-Reply-To: <CALicx6vW9Lu7nNu86d-+a985iSH2vZ7ekb_5AgCxct-z90M7Wg@mail.gmail.com>
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

On Tue, Sep 6, 2016 at 7:18 PM, Vijay Kilari <vijay.kilari@gmail.com> wrote:
>
>
> On Tue, Aug 30, 2016 at 7:15 PM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
>>
>> On Wed, Aug 24, 2016 at 04:50:08PM +0530, vijay.kilari@gmail.com wrote:
>> > From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>
>
>>
>> > diff --git a/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
>> > b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
>>
>> > new file mode 100644
>> > index 0000000..581d053
>> > --- /dev/null
>> > +++ b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
>> > @@ -0,0 +1,211 @@
>> > +#include <linux/irqchip/arm-gic-v3.h>
>> > +#include <linux/kvm.h>
>> > +#include <linux/kvm_host.h>
>> > +#include <kvm/iodev.h>
>> > +#include <kvm/arm_vgic.h>
>> > +#include <asm/kvm_emulate.h>
>> > +#include <asm/kvm_arm.h>
>> > +#include <asm/kvm_mmu.h>
>> > +
>> > +#include "vgic.h"
>> > +#include "vgic-mmio.h"
>> > +#include "sys_regs.h"
>> > +
>> > +static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct
>> > sys_reg_params *p,
>> > +                         const struct sys_reg_desc *r)
>> > +{
>> > +     struct vgic_vmcr vmcr;
>> > +
>> > +     vgic_get_vmcr(vcpu, &vmcr);
>> > +     if (p->is_write) {
>> > +             vmcr.ctlr = (u32)p->regval;
>> > +             vgic_set_vmcr(vcpu, &vmcr);
>> > +     } else {
>> > +             p->regval = vmcr.ctlr;
>> > +     }
>> > +
>>
>> really?  Have you looked at the spec and implementation of this or did
>> you just copy the v2 code?
>>
>> The ICH_VMCR_EL2 register field mappings are not identical to the ctlr
>> mappings.  I think this causes some rework for much of this patch, so
>> I'll have a look at the next revision.
>
>
>   ICH_VMCR_EL2.VEOIM &  ICH_VMCR_EL2.CBPR holds
> ICC_CTLR_EL1.EOImode & ICC_CTLR_EL1.CBPR  respectively.
> Remaining fields are Readonly except PHME. AFAIK, vgic is not
> holding ICC_CTLR_EL1 except the fields in ICH_VMCR_EL2.
>>
>>
>> > +     return true;
>> > +}
>> > +
>> > +static bool access_gic_pmr(struct kvm_vcpu *vcpu, struct sys_reg_params
>> > *p,
>> > +                        const struct sys_reg_desc *r)
>> > +{
>> > +     struct vgic_vmcr vmcr;
>> > +
>> > +     vgic_get_vmcr(vcpu, &vmcr);
>> > +     if (p->is_write) {
>> > +             vmcr.pmr = (u32)p->regval;
>> > +             vgic_set_vmcr(vcpu, &vmcr);
>> > +     } else {
>> > +             p->regval = vmcr.pmr;
>> > +     }
>> > +
>> > +     return true;
>> > +}
>> > +
>> > +static bool access_gic_bpr0(struct kvm_vcpu *vcpu, struct
>> > sys_reg_params *p,
>> > +                         const struct sys_reg_desc *r)
>> > +{
>> > +     struct vgic_vmcr vmcr;
>> > +
>> > +     vgic_get_vmcr(vcpu, &vmcr);
>> > +     if (p->is_write) {
>> > +             vmcr.bpr = (u32)p->regval;
>> > +             vgic_set_vmcr(vcpu, &vmcr);
>> > +     } else {
>> > +             p->regval = vmcr.bpr;
>> > +     }
>> > +
>> > +     return true;
>> > +}
>> > +
>> > +static bool access_gic_bpr1(struct kvm_vcpu *vcpu, struct
>> > sys_reg_params *p,
>> > +                         const struct sys_reg_desc *r)
>> > +{
>> > +     struct vgic_vmcr vmcr;
>> > +
>> > +     vgic_get_vmcr(vcpu, &vmcr);
>> > +     if (p->is_write) {
>> > +             vmcr.abpr = (u32)p->regval;
>> > +             vgic_set_vmcr(vcpu, &vmcr);
>> > +     } else {
>> > +             p->regval = vmcr.abpr;
>> > +     }
>> > +
>> > +     return true;
>> > +}
>> > +
>> > +static bool access_gic_grpen0(struct kvm_vcpu *vcpu, struct
>> > sys_reg_params *p,
>> > +                           const struct sys_reg_desc *r)
>> > +{
>> > +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
>> > +
>> > +     if (p->is_write) {
>> > +             vgicv3->vgic_vmcr &= ~ICH_VMCR_ENG0;
>> > +             vgicv3->vgic_vmcr |= (p->regval << ICH_VMCR_ENG0_SHIFT) &
>> > +                                   ICH_VMCR_ENG0;
>> > +     } else {
>> > +             p->regval = (vgicv3->vgic_vmcr & ICH_VMCR_ENG0) >>
>> > +                          ICH_VMCR_ENG0_SHIFT;
>> > +     }
>>
>> so for example, why shouldn't these go through the vgic_set/get_vmcr
>> wrappers?
>
>
> The vgic_vmcr struct as below is not managing ENG0 and ENG1 fields.
> So could not use vgic_set/get wrappers.
>
> struct vgic_vmcr {
>         u32     ctlr;
>         u32     abpr;
>         u32     bpr;
>         u32     pmr;
> };
>
>
>>
>>
>> > +
>> > +     return true;
>> > +}
>> > +
>> > +static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct
>> > sys_reg_params *p,
>> > +                           const struct sys_reg_desc *r)
>> > +{
>> > +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
>> > +
>> > +     if (p->is_write) {
>> > +             vgicv3->vgic_vmcr &= ~ICH_VMCR_ENG1;
>> > +             vgicv3->vgic_vmcr |= (p->regval << ICH_VMCR_ENG1_SHIFT) &
>> > +                                   ICH_VMCR_ENG1;
>> > +     } else {
>> > +             p->regval = (vgicv3->vgic_vmcr & ICH_VMCR_ENG1) >>
>> > +                          ICH_VMCR_ENG1_SHIFT;
>> > +     }
>> > +
>> > +     return true;
>> > +}
>> > +
>> > +static bool access_gic_ap0r(struct kvm_vcpu *vcpu, struct
>> > sys_reg_params *p,
>> > +                         const struct sys_reg_desc *r)
>> > +{
>> > +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
>> > +     u8 idx = r->Op2 & 3;
>> > +
>> > +     if (p->is_write)
>> > +             vgicv3->vgic_ap0r[idx] = p->regval;
>> > +     else
>> > +             p->regval = vgicv3->vgic_ap0r[idx];
>> > +
>> > +     return true;
>> > +}
>> > +
>> > +static bool access_gic_ap1r(struct kvm_vcpu *vcpu, struct
>> > sys_reg_params *p,
>> > +                         const struct sys_reg_desc *r)
>> > +{
>> > +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
>> > +     u8 idx = r->Op2 & 3;
>> > +
>> > +     if (p->is_write)
>> > +             vgicv3->vgic_ap1r[idx] = p->regval;
>> > +     else
>> > +             p->regval = vgicv3->vgic_ap1r[idx];
>> > +
>> > +     return true;
>> > +}
>> > +
>> > +static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
>> > +     /* ICC_PMR_EL1 */
>> > +     { Op0(3), Op1(0), CRn(4), CRm(6), Op2(0), access_gic_pmr },
>> > +     /* ICC_BPR0_EL1 */
>> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(3), access_gic_bpr0 },
>> > +     /* ICC_AP0R0_EL1 */
>> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(4), access_gic_ap0r },
>> > +     /* ICC_AP0R1_EL1 */
>> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(5), access_gic_ap0r },
>> > +     /* ICC_AP0R2_EL1 */
>> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(6), access_gic_ap0r },
>> > +     /* ICC_AP0R3_EL1 */
>> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(7), access_gic_ap0r },
>> > +     /* ICC_AP1R0_EL1 */
>> > +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(0), access_gic_ap1r },
>> > +     /* ICC_AP1R1_EL1 */
>> > +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(1), access_gic_ap1r },
>> > +     /* ICC_AP1R2_EL1 */
>> > +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(2), access_gic_ap1r },
>> > +     /* ICC_AP1R3_EL1 */
>> > +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(3), access_gic_ap1r },
>> > +     /* ICC_BPR1_EL1 */
>> > +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(3), access_gic_bpr1 },
>> > +     /* ICC_CTLR_EL1 */
>> > +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(4), access_gic_ctlr },
>> > +     /* ICC_IGRPEN0_EL1 */
>> > +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(6), access_gic_grpen0 },
>> > +     /* ICC_GRPEN1_EL1 */
>> > +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(7), access_gic_grpen1 },
>>
>> Do we need to allow userspace to at least read ICC_SRE_EL1?
>
>
> ICC_SRE_EL1.SRE is enabled at vgic initialization and DIB and FDB are not
> configured.
>     So save and restore does not make any effect.
>
>>
>> Should we verify that the DIB and FDB fields of that register are
>> written as the system understands them (clear, WI)?
>
>
>   What kind of verification we can do on DIB and FDB by userspace?.
>>
>>
>> > +
>> > +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>> > u64 id,
>> > +                             u64 *reg)
>> > +{
>> > +     struct sys_reg_params params;
>> > +     const struct sys_reg_desc *r;
>> > +
>> > +     if (is_write)
>> > +             params.regval = le64_to_cpu(*reg);
>>
>> why do we need this conversion here?
>>
>    The registers are managed in LE mode. So here the value to be
> writtern is coverted to LE mode and similarly on reading back it is
> converted
> from LE.
>
>> > +     params.is_write = is_write;
>> > +     params.is_aarch32 = false;
>> > +     params.is_32bit = false;
>> > +
>> > +     r = find_reg_by_id(id, &params, gic_v3_icc_reg_descs,
>> > +                        ARRAY_SIZE(gic_v3_icc_reg_descs));
>> > +     if (!r)
>> > +             return -ENXIO;
>> > +
>> > +     if (!r->access(vcpu, &params, r))
>> > +             return -EINVAL;
>> > +
>> > +     if (!is_write)
>> > +             *reg = cpu_to_le64(params.regval);
>>
>> same question as above
>>
>
