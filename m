From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v9 06/11] arm/arm64: vgic: Implement VGICv3 CPU interface
 access
Date: Tue, 29 Nov 2016 09:37:47 +0100
Message-ID: <20161129083747.GA9838@cbox>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
 <1479906118-15832-7-git-send-email-vijay.kilari@gmail.com>
 <20161128193938.GF18170@cbox>
 <CALicx6s4E0-VJMm6Ff5qu=sZgXu-mUnJdDCmaiZO0i3yzF8wxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25622407EC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 03:37:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LYSgJ2vt3+dr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Nov 2016 03:37:03 -0500 (EST)
Received: from mail-lf0-f42.google.com (mail-lf0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A57C405C4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 03:37:03 -0500 (EST)
Received: by mail-lf0-f42.google.com with SMTP id t196so116104429lff.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 00:37:51 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CALicx6s4E0-VJMm6Ff5qu=sZgXu-mUnJdDCmaiZO0i3yzF8wxA@mail.gmail.com>
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

On Tue, Nov 29, 2016 at 01:08:26PM +0530, Vijay Kilari wrote:
> On Tue, Nov 29, 2016 at 1:09 AM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Wed, Nov 23, 2016 at 06:31:53PM +0530, vijay.kilari@gmail.com wrote:
> >> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >>
> >> VGICv3 CPU interface registers are accessed using
> >> KVM_DEV_ARM_VGIC_CPU_SYSREGS ioctl. These registers are accessed
> >> as 64-bit. The cpu MPIDR value is passed along with register id.
> >> is used to identify the cpu for registers access.
> >>
> >> The VM that supports SEIs expect it on destination machine to handle
> >> guest aborts and hence checked for ICC_CTLR_EL1.SEIS compatibility.
> >> Similarly, VM that supports Affinity Level 3 that is required for AArch64
> >> mode, is required to be supported on destination machine. Hence checked
> >> for ICC_CTLR_EL1.A3V compatibility.
> >>
> >> The CPU system register handling is spitted into two files
> >
> > spitted?  Did you mean 'split into' ?
> >
> >> vgic-sys-reg-common.c and vgic-sys-reg-v3.c.
> >> The vgic-sys-reg-common.c handles read and write of VGIC CPU registers
> >
> > So this is weird because everything in virt/kvm/arm/ is exactly supposed
> > to be common between arm and arm64 already.
> >
> > I would rather that you had a copy of vgic-sys-reg-v3.c in arch/arm/kvm/
> > and in arch/arm64/kvm/ each taking care of its own architecture.
> >
> > But note that I didn't actually require that you implemented support for
> > GICv3 migration on AArch32 hosts for these patches, I just didn't want
> > thigns to silently break.
> >
> > If we cannot test the AArch32 implementation, we should potentially just
> > make sure that is not supported yet, return a proper error to userspace
> > and get the AArch64 host implementation correct.
> >
> > I suggest you move your:
> >   virt/kvm/arm/vgic/vgic-sys-reg-v3.c to
> >   arch/arm64/kvm/vgic-sys-reg-v3.c
> >
> > and rename
> >   virt/kvm/arm/vgic/vgic-sys-reg-common.c to
> >   virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> >
> > And then wait with the AArch32 host side for now, but just make sure it
> > compiles and returns an error as opposed to crashing the system if
> > someone tries to excercise this interface on an AArch32 host.
> 
> I will add arch/arm/kvm/vgic-coproc-v3.c (pls check if file name is ok or not?)

I would call it vgic-v3-coproc.c

> and return -ENXIO as shown below and update document accordingly.
> 
> int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
>                                u64 *reg)
> {
>        /*
>         * TODO: Implement for AArch32
>         */
>        return -ENXIO;
> }
> 
> int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
>                                u64 *reg)
> {
>        /*
>         * TODO: Implement for AArch32
>         */
>        return -ENXIO;
> }


> 
> >
> >> for both AArch64 and AArch32 mode. The vgic-sys-reg-v3.c handles AArch64
> >> mode and is compiled only for AArch64 mode.
> >>
> >> Updated arch/arm/include/uapi/asm/kvm.h with new definitions
> >> required to compile for AArch32.
> >>
> >> The version of VGIC v3 specification is define here
> >> Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> >>
> >> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> >> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >> ---
> [...]
> >> +static bool access_gic_aprn(struct kvm_vcpu *vcpu, bool is_write, u8 apr,
> >> +                         u8 idx, unsigned long *reg)
> >> +{
> >> +     struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
> >> +
> >> +     /* num_pri_bits are initialized with HW supported values.
> >> +      * We can rely safely on num_pri_bits even if VM has not
> >> +      * restored ICC_CTLR_EL1 before restoring APnR registers.
> >> +      */
> >
> > nit: commenting style
> ok
> >
> >> +     switch (vgic_v3_cpu->num_pri_bits) {
> >> +     case 7:
> >> +             vgic_v3_access_apr_reg(vcpu, is_write, apr, idx, reg);
> >> +             break;
> >> +     case 6:
> >> +             if (idx > 1)
> >> +                     goto err;
> >> +             vgic_v3_access_apr_reg(vcpu, is_write, apr, idx, reg);
> >> +             break;
> >> +     default:
> >> +             if (idx > 0)
> >> +                     goto err;
> >> +             vgic_v3_access_apr_reg(vcpu, is_write, apr, idx, reg);
> >> +     }
> >
> > It looks to me like userspace can then program active priorities with
> > higher numbers than what it will program num_pri_bits to later.  Is that
> > not weird, or am I missing something?
> 
> As long as it is within HW supported priorities it is safe.

I know that it is safe on the hardware, but it is weird to define a VM
with some max priority and still be able to set a higher active priority
is it not?

On the other hand, if we cannot enforce this at runtime, it may not
matter?

Hint: I'd like for you to actually think about these constraints and
make sure the sematics of the emulated VM environment remain intact
across migrations.

> >
> >> +
> >> +     return true;
> >> +err:
> >> +     if (!is_write)
> >> +             *reg = 0;
> >> +
> >> +     return false;
> >> +}
> >> +
> >> +bool access_gic_ap0r_reg(struct kvm_vcpu *vcpu, bool is_write, u8 idx,
> >> +                      unsigned long *reg)
> >> +{
> >> +     return access_gic_aprn(vcpu, is_write, 0, idx, reg);
> >> +}
> >> +
> >> +bool access_gic_ap1r_reg(struct kvm_vcpu *vcpu, bool is_write, u8 idx,
> >> +                      unsigned long *reg)
> >> +{
> >> +     return access_gic_aprn(vcpu, is_write, 1, idx, reg);
> >> +}
> >> +
> >> +bool access_gic_sre_reg(struct kvm_vcpu *vcpu, bool is_write,
> >> +                     unsigned long *reg)
> >> +{
> >> +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> >> +
> >> +     /* Validate SRE bit */
> >> +     if (is_write) {
> >> +             if (!(*reg & ICC_SRE_EL1_SRE))
> >> +                     return false;
> >> +     } else {
> >> +             *reg = vgicv3->vgic_sre;
> >> +     }
> >> +
> >> +     return true;
> >> +}
> >> diff --git a/virt/kvm/arm/vgic/vgic-sys-reg-v3.c b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> >> new file mode 100644
> >> index 0000000..82c2f02
> >> --- /dev/null
> >> +++ b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> >> @@ -0,0 +1,142 @@
> >> +/*
> >> + * VGIC system registers handling functions
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + */
> >> +
> >> +#include <linux/kvm.h>
> >> +#include <linux/kvm_host.h>
> >> +#include <asm/kvm_emulate.h>
> >> +#include "vgic.h"
> >> +#include "sys_regs.h"
> >> +
> >> +#define ACCESS_SYS_REG(REG)                                          \
> >> +static bool access_gic_##REG##_sys_reg(struct kvm_vcpu *vcpu,                \
> >> +                                 struct sys_reg_params *p,           \
> >> +                                 const struct sys_reg_desc *r)       \
> >> +{                                                                    \
> >> +     unsigned long tmp;                                              \
> >> +     bool ret;                                                       \
> >> +                                                                     \
> >> +     if (p->is_write)                                                \
> >> +             tmp = p->regval;                                        \
> >> +     ret = access_gic_##REG##_reg(vcpu, p->is_write, &tmp);          \
> >> +     if (!p->is_write)                                               \
> >> +             p->regval = tmp;                                        \
> >> +                                                                     \
> >> +     return ret;                                                     \
> >> +}
> >> +
> >> +ACCESS_SYS_REG(ctlr)
> >> +ACCESS_SYS_REG(pmr)
> >> +ACCESS_SYS_REG(bpr0)
> >> +ACCESS_SYS_REG(bpr1)
> >> +ACCESS_SYS_REG(sre)
> >> +ACCESS_SYS_REG(grpen0)
> >> +ACCESS_SYS_REG(grpen1)
> >> +
> >> +#define ACCESS_APNR_SYS_REG(REG)                                     \
> >> +static bool access_gic_##REG##_sys_reg(struct kvm_vcpu *vcpu,                \
> >> +                                 struct sys_reg_params *p,           \
> >> +                                 const struct sys_reg_desc *r)       \
> >> +{                                                                    \
> >> +     unsigned long tmp;                                              \
> >> +     u8 idx = p->Op2 & 3;                                            \
> >> +     bool ret;                                                       \
> >> +                                                                     \
> >> +     if (p->is_write)                                                \
> >> +             tmp = p->regval;                                        \
> >> +     ret = access_gic_##REG##_reg(vcpu, p->is_write, idx, &tmp);     \
> >> +     if (!p->is_write)                                               \
> >> +             p->regval = tmp;                                        \
> >> +                                                                     \
> >> +     return ret;                                                     \
> >> +}
> >> +
> >> +ACCESS_APNR_SYS_REG(ap0r)
> >> +ACCESS_APNR_SYS_REG(ap1r)
> >
> > I don't get these indirections.  Why can't you call the functions
> > directly?
> 
> The code is same for accessing the registers hence added this indirection.
> 

That's not answering my question.

What is the benefit of adding this indirection as opposed to having the
functions called directly?

To make my point clear:  I hate this kind of preprocessor macro fun, and
I think it should only ever be used when there's a huge benefit in terms
of code reuse or simplicity of some sort.  I don't see anything like
that in this case.

Thanks,
-Christoffer
