From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v3 4/5] arm/arm64: vgic-new: Implement VGICv3 CPU
 interface access
Date: Wed, 7 Sep 2016 16:15:00 +0200
Message-ID: <20160907141500.GR23592@cbox>
References: <1472037609-4164-1-git-send-email-vijay.kilari@gmail.com>
 <1472037609-4164-5-git-send-email-vijay.kilari@gmail.com>
 <20160830134514.GJ10162@cbox>
 <CALicx6vW9Lu7nNu86d-+a985iSH2vZ7ekb_5AgCxct-z90M7Wg@mail.gmail.com>
 <CALicx6s=ih2E-KrCD=J2beJ_=PmSUcf55T77A00USwu1WiJbxw@mail.gmail.com>
 <20160906191918.GM23592@cbox>
 <CALicx6uDU9Adrxro6AS55-17yDe62Eq4gTW_qmwWtLrXSZ_Orw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E381948531
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2016 10:04:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Detc6WE8Hzum for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Sep 2016 10:04:03 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A68BC40C9D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2016 10:04:03 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id w12so35138372wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Sep 2016 07:12:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CALicx6uDU9Adrxro6AS55-17yDe62Eq4gTW_qmwWtLrXSZ_Orw@mail.gmail.com>
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

On Wed, Sep 07, 2016 at 07:19:48PM +0530, Vijay Kilari wrote:
> On Wed, Sep 7, 2016 at 12:49 AM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Tue, Sep 06, 2016 at 07:43:23PM +0530, Vijay Kilari wrote:
> >> Resending in plain text mode
> >>
> >> On Tue, Sep 6, 2016 at 7:18 PM, Vijay Kilari <vijay.kilari@gmail.com> wrote:
> >> >
> >> >
> >> > On Tue, Aug 30, 2016 at 7:15 PM, Christoffer Dall
> >> > <christoffer.dall@linaro.org> wrote:
> >> >>
> >> >> On Wed, Aug 24, 2016 at 04:50:08PM +0530, vijay.kilari@gmail.com wrote:
> >> >> > From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >> >
> >> >
> >> >>
> >> >> > diff --git a/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> >> >> > b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> >> >>
> >> >> > new file mode 100644
> >> >> > index 0000000..581d053
> >> >> > --- /dev/null
> >> >> > +++ b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> >> >> > @@ -0,0 +1,211 @@
> >> >> > +#include <linux/irqchip/arm-gic-v3.h>
> >> >> > +#include <linux/kvm.h>
> >> >> > +#include <linux/kvm_host.h>
> >> >> > +#include <kvm/iodev.h>
> >> >> > +#include <kvm/arm_vgic.h>
> >> >> > +#include <asm/kvm_emulate.h>
> >> >> > +#include <asm/kvm_arm.h>
> >> >> > +#include <asm/kvm_mmu.h>
> >> >> > +
> >> >> > +#include "vgic.h"
> >> >> > +#include "vgic-mmio.h"
> >> >> > +#include "sys_regs.h"
> >> >> > +
> >> >> > +static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct
> >> >> > sys_reg_params *p,
> >> >> > +                         const struct sys_reg_desc *r)
> >> >> > +{
> >> >> > +     struct vgic_vmcr vmcr;
> >> >> > +
> >> >> > +     vgic_get_vmcr(vcpu, &vmcr);
> >> >> > +     if (p->is_write) {
> >> >> > +             vmcr.ctlr = (u32)p->regval;
> >> >> > +             vgic_set_vmcr(vcpu, &vmcr);
> >> >> > +     } else {
> >> >> > +             p->regval = vmcr.ctlr;
> >> >> > +     }
> >> >> > +
> >> >>
> >> >> really?  Have you looked at the spec and implementation of this or did
> >> >> you just copy the v2 code?
> >> >>
> >> >> The ICH_VMCR_EL2 register field mappings are not identical to the ctlr
> >> >> mappings.  I think this causes some rework for much of this patch, so
> >> >> I'll have a look at the next revision.
> >> >
> >> >
> >> >   ICH_VMCR_EL2.VEOIM &  ICH_VMCR_EL2.CBPR holds
> >> > ICC_CTLR_EL1.EOImode & ICC_CTLR_EL1.CBPR  respectively.
> >> > Remaining fields are Readonly except PHME. AFAIK, vgic is not
> >> > holding ICC_CTLR_EL1 except the fields in ICH_VMCR_EL2.
> >
> > This function implements the accessor for ICC_CTLR_EL1 according to your
> > own comment (and the system register encoding).
> >
> > If you planned on exposing ICH_VMCR_EL2 to userspace, then why did you
> > expose it for the encoding of ICC_CTLR_EL1?
> >
> > More to the point, you're exposing the *VM's* state of the GIC, not
> > details about the hypervisor implementation.
> 
> ICH_VMCR_EL2 provides virtual access to ICC_CTLR_EL1, PMR_EL1, BPR0_EL1,
> and few more regs. So access for these registers, we rely on VMCR_EL2.

I know how this works, I'm not asking you to explain me how VMCR_EL2
works.

> and more over VMCR_EL2 is EL2 register to expose to userspace.
> 

If you wanted to go that route, you shouldn't export it using the
encoding of ICC_CTRL_EL1, then you should export it using VMCR_EL2.

But this is now what we do for all the other state, so it's fairly
obvious to me what you need to do.  But let me spell it out for you:

Export the VM's state in shape of the EL1 registers as they are
presented to the guest, similar to what we do for the distributor with
the exception of the latch state for the pending state.

You have failed to explain the design of what you are implementing, and
what you have here is wildly inconsistent.  Please try to understand
what I'm saying instead of just insisting on your original understanding
of how to solve this problem.


> >
> >> >> > +     return true;
> >> >> > +}
> >> >> > +
> >> >> > +static bool access_gic_pmr(struct kvm_vcpu *vcpu, struct sys_reg_params
> >> >> > *p,
> >> >> > +                        const struct sys_reg_desc *r)
> >> >> > +{
> >> >> > +     struct vgic_vmcr vmcr;
> >> >> > +
> >> >> > +     vgic_get_vmcr(vcpu, &vmcr);
> >> >> > +     if (p->is_write) {
> >> >> > +             vmcr.pmr = (u32)p->regval;
> >> >> > +             vgic_set_vmcr(vcpu, &vmcr);
> >> >> > +     } else {
> >> >> > +             p->regval = vmcr.pmr;
> >> >> > +     }
> >> >> > +
> >> >> > +     return true;
> >> >> > +}
> >> >> > +
> >> >> > +static bool access_gic_bpr0(struct kvm_vcpu *vcpu, struct
> >> >> > sys_reg_params *p,
> >> >> > +                         const struct sys_reg_desc *r)
> >> >> > +{
> >> >> > +     struct vgic_vmcr vmcr;
> >> >> > +
> >> >> > +     vgic_get_vmcr(vcpu, &vmcr);
> >> >> > +     if (p->is_write) {
> >> >> > +             vmcr.bpr = (u32)p->regval;
> >> >> > +             vgic_set_vmcr(vcpu, &vmcr);
> >> >> > +     } else {
> >> >> > +             p->regval = vmcr.bpr;
> >> >> > +     }
> >> >> > +
> >> >> > +     return true;
> >> >> > +}
> >> >> > +
> >> >> > +static bool access_gic_bpr1(struct kvm_vcpu *vcpu, struct
> >> >> > sys_reg_params *p,
> >> >> > +                         const struct sys_reg_desc *r)
> >> >> > +{
> >> >> > +     struct vgic_vmcr vmcr;
> >> >> > +
> >> >> > +     vgic_get_vmcr(vcpu, &vmcr);
> >> >> > +     if (p->is_write) {
> >> >> > +             vmcr.abpr = (u32)p->regval;
> >> >> > +             vgic_set_vmcr(vcpu, &vmcr);
> >> >> > +     } else {
> >> >> > +             p->regval = vmcr.abpr;
> >> >> > +     }
> >> >> > +
> >> >> > +     return true;
> >> >> > +}
> >> >> > +
> >> >> > +static bool access_gic_grpen0(struct kvm_vcpu *vcpu, struct
> >> >> > sys_reg_params *p,
> >> >> > +                           const struct sys_reg_desc *r)
> >> >> > +{
> >> >> > +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> >> >> > +
> >> >> > +     if (p->is_write) {
> >> >> > +             vgicv3->vgic_vmcr &= ~ICH_VMCR_ENG0;
> >> >> > +             vgicv3->vgic_vmcr |= (p->regval << ICH_VMCR_ENG0_SHIFT) &
> >> >> > +                                   ICH_VMCR_ENG0;
> >> >> > +     } else {
> >> >> > +             p->regval = (vgicv3->vgic_vmcr & ICH_VMCR_ENG0) >>
> >> >> > +                          ICH_VMCR_ENG0_SHIFT;
> >> >> > +     }
> >> >>
> >> >> so for example, why shouldn't these go through the vgic_set/get_vmcr
> >> >> wrappers?
> >> >
> >> >
> >> > The vgic_vmcr struct as below is not managing ENG0 and ENG1 fields.
> >> > So could not use vgic_set/get wrappers.
> >
> > eh, but you could expand this structure, right?
> OK, I will try to expand this structure
> >
> > It's strange that some things go through access functions, while others
> > do not.  If there is a good reason for that, then document that somehow.
> >
> >> >
> >> > struct vgic_vmcr {
> >> >         u32     ctlr;
> >> >         u32     abpr;
> >> >         u32     bpr;
> >> >         u32     pmr;
> >> > };
> >> >
> >> >
> >> >>
> >> >>
> >> >> > +
> >> >> > +     return true;
> >> >> > +}
> >> >> > +
> >> >> > +static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct
> >> >> > sys_reg_params *p,
> >> >> > +                           const struct sys_reg_desc *r)
> >> >> > +{
> >> >> > +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> >> >> > +
> >> >> > +     if (p->is_write) {
> >> >> > +             vgicv3->vgic_vmcr &= ~ICH_VMCR_ENG1;
> >> >> > +             vgicv3->vgic_vmcr |= (p->regval << ICH_VMCR_ENG1_SHIFT) &
> >> >> > +                                   ICH_VMCR_ENG1;
> >> >> > +     } else {
> >> >> > +             p->regval = (vgicv3->vgic_vmcr & ICH_VMCR_ENG1) >>
> >> >> > +                          ICH_VMCR_ENG1_SHIFT;
> >> >> > +     }
> >> >> > +
> >> >> > +     return true;
> >> >> > +}
> >> >> > +
> >> >> > +static bool access_gic_ap0r(struct kvm_vcpu *vcpu, struct
> >> >> > sys_reg_params *p,
> >> >> > +                         const struct sys_reg_desc *r)
> >> >> > +{
> >> >> > +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> >> >> > +     u8 idx = r->Op2 & 3;
> >> >> > +
> >> >> > +     if (p->is_write)
> >> >> > +             vgicv3->vgic_ap0r[idx] = p->regval;
> >> >> > +     else
> >> >> > +             p->regval = vgicv3->vgic_ap0r[idx];
> >> >> > +
> >> >> > +     return true;
> >> >> > +}
> >> >> > +
> >> >> > +static bool access_gic_ap1r(struct kvm_vcpu *vcpu, struct
> >> >> > sys_reg_params *p,
> >> >> > +                         const struct sys_reg_desc *r)
> >> >> > +{
> >> >> > +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> >> >> > +     u8 idx = r->Op2 & 3;
> >> >> > +
> >> >> > +     if (p->is_write)
> >> >> > +             vgicv3->vgic_ap1r[idx] = p->regval;
> >> >> > +     else
> >> >> > +             p->regval = vgicv3->vgic_ap1r[idx];
> >> >> > +
> >> >> > +     return true;
> >> >> > +}
> >> >> > +
> >> >> > +static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
> >> >> > +     /* ICC_PMR_EL1 */
> >> >> > +     { Op0(3), Op1(0), CRn(4), CRm(6), Op2(0), access_gic_pmr },
> >> >> > +     /* ICC_BPR0_EL1 */
> >> >> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(3), access_gic_bpr0 },
> >> >> > +     /* ICC_AP0R0_EL1 */
> >> >> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(4), access_gic_ap0r },
> >> >> > +     /* ICC_AP0R1_EL1 */
> >> >> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(5), access_gic_ap0r },
> >> >> > +     /* ICC_AP0R2_EL1 */
> >> >> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(6), access_gic_ap0r },
> >> >> > +     /* ICC_AP0R3_EL1 */
> >> >> > +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(7), access_gic_ap0r },
> >> >> > +     /* ICC_AP1R0_EL1 */
> >> >> > +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(0), access_gic_ap1r },
> >> >> > +     /* ICC_AP1R1_EL1 */
> >> >> > +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(1), access_gic_ap1r },
> >> >> > +     /* ICC_AP1R2_EL1 */
> >> >> > +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(2), access_gic_ap1r },
> >> >> > +     /* ICC_AP1R3_EL1 */
> >> >> > +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(3), access_gic_ap1r },
> >> >> > +     /* ICC_BPR1_EL1 */
> >> >> > +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(3), access_gic_bpr1 },
> >> >> > +     /* ICC_CTLR_EL1 */
> >> >> > +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(4), access_gic_ctlr },
> >> >> > +     /* ICC_IGRPEN0_EL1 */
> >> >> > +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(6), access_gic_grpen0 },
> >> >> > +     /* ICC_GRPEN1_EL1 */
> >> >> > +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(7), access_gic_grpen1 },
> >> >>
> >> >> Do we need to allow userspace to at least read ICC_SRE_EL1?
> >> >
> >> >
> >> > ICC_SRE_EL1.SRE is enabled at vgic initialization and DIB and FDB are not
> >> > configured.
> >> >     So save and restore does not make any effect.
> >
> > I know, but that doesn't mean that userspace shouldn't be able to tell
> > what the result of the vgic initialization was by looking at the
> > register.
> >
> Ok, I will save and restore this registers with some verification in
> userspace.
> 

My point was that the kernel could verify that the systems are
consistent, similar to what we do for invariant sysregs.

> > So I am looking for slightly better arguments than 'it doesn't seem to
> > matter in practice right now'.
> >
> >> >
> >> >>
> >> >> Should we verify that the DIB and FDB fields of that register are
> >> >> written as the system understands them (clear, WI)?
> >> >
> >> >
> >> >   What kind of verification we can do on DIB and FDB by userspace?.
> >
> > That userspace tries to write a value as it thinks they should be and
> > the kernel code checks that this corresponds to the underlying hardware.
> >
> >> >>
> >> >>
> >> >> > +
> >> >> > +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> >> >> > u64 id,
> >> >> > +                             u64 *reg)
> >> >> > +{
> >> >> > +     struct sys_reg_params params;
> >> >> > +     const struct sys_reg_desc *r;
> >> >> > +
> >> >> > +     if (is_write)
> >> >> > +             params.regval = le64_to_cpu(*reg);
> >> >>
> >> >> why do we need this conversion here?
> >> >>
> >> >    The registers are managed in LE mode.
> >
> > What do you mean?  They are stored as typed values, right?  Why is
> > endianness a factor here.
> >
> > System registers are registers, they do not have an endianness.
> >
> >
> >> >  So here the value to be
> >> > writtern is coverted to LE mode and similarly on reading back it is
> >> > converted
> >> > from LE.
> >> >
> >
> > I don't understand where you feel the mismatch in endianness comes from?
> >
> > The reason why we use vgic_data_host_to_mmio_bus() is historic and I
> > think we can actually get rid of that in the uaccess part.  (Looking at
> > the symmetry between vgic_uaccess and vgic_mmio_uaccess_{read,write}
> > should tell us that this is completely unnecessary and we can just
> > replace the prototype to take an unsigned long instead of a void * for
> > the val parameter.)
> >
> > Can you provide an example of how it goes bad if you don't have this
> > conversion?
> 
> You have added a comment for vgic_uaccess() that conversion is required
> from the patch commit c3199f28e09496aa9fec9313b4f6e90e7dc913f0
> "KVM: arm/arm64: vgic-new: Export register access interface"

Again, I didn't ask you to quote a commit, but to actually understand
what you are implementing.

I've already stated that I do not see a need for the endianness
conversion here, yet you persist that it is needed.  To substantiate
your claim, I asked to provide an example of a situation where we would
write the wrong value to the kernel without the le64_to_cpu operation,
not to quote a commit on a different function, which uses an existing
function to conveniently place date into a byte array.

As I told you, this was needed *before your patches* because we reused
dispatch_mmio_write, but now you do the region lookup in
vgic_mmio_uaccess_write() and do not reuse the mmio path that expected a
void * to a byte array.

> 
> If sysregs does not have endianess, then this conversion can be dropped
> for sysregs.
> 

As I've said, I don't see where there would be an endianness mismatch
here.

-Christoffer
