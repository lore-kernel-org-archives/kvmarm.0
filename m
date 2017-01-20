From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v10 6/8] arm/arm64: vgic: Implement VGICv3 CPU interface
 access
Date: Fri, 20 Jan 2017 20:26:39 +0100
Message-ID: <20170120192639.GE13531@cbox>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
 <1480576187-5012-7-git-send-email-vijay.kilari@gmail.com>
 <af6f17a5-f20a-91f7-c280-1669e9b805a4@redhat.com>
 <CALicx6spkmp4ipvCA_TUfzaJ0K38tpWHsV9CGU4MEQzTwa00sw@mail.gmail.com>
 <159a2963-6a58-22a2-a49d-f09bb9679219@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E67664095A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 14:26:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SlJvqmAPTaXX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Jan 2017 14:26:47 -0500 (EST)
Received: from mail-lf0-f52.google.com (mail-lf0-f52.google.com
 [209.85.215.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D29340783
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 14:26:46 -0500 (EST)
Received: by mail-lf0-f52.google.com with SMTP id z134so63897132lff.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 11:26:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <159a2963-6a58-22a2-a49d-f09bb9679219@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 19, 2016 at 11:20:02AM +0100, Auger Eric wrote:
> Hi Vijaya,
> 
> On 19/12/2016 10:47, Vijay Kilari wrote:
> > On Fri, Dec 16, 2016 at 5:55 PM, Auger Eric <eric.auger@redhat.com> wrote:
> >> Hi Vijaya,
> >>
> >> On 01/12/2016 08:09, vijay.kilari@gmail.com wrote:
> >>> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >>>
> >>> VGICv3 CPU interface registers are accessed using
> >>> KVM_DEV_ARM_VGIC_CPU_SYSREGS ioctl. These registers are accessed
> >>> as 64-bit. The cpu MPIDR value is passed along with register id.
> >>> is used to identify the cpu for registers access.
> >> s/is/It is
> >>>
> >>> The VM that supports SEIs expect it on destination machine to handle
> >>> guest aborts and hence checked for ICC_CTLR_EL1.SEIS compatibility.
> >>> Similarly, VM that supports Affinity Level 3 that is required for AArch64
> >>> mode, is required to be supported on destination machine. Hence checked
> >>> for ICC_CTLR_EL1.A3V compatibility.
> >> We make sure ICC_CTLR_EL1 SEIS and A3V are compatible on source and target?
> >>>
> >>> The arch/arm64/kvm/vgic-sys-reg-v3.c handles read and write of VGIC
> >>> CPU registers for AArch64.
> >>>
> >>> For AArch32 mode, arch/arm/kvm/vgic-v3-coproc.c file is created but
> >>> APIs are not implemented.
> >>>
> >>> Updated arch/arm/include/uapi/asm/kvm.h with new definitions
> >>> required to compile for AArch32.
> >>>
> >>> The version of VGIC v3 specification is define here
> >> s/define/defined
> >>> Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> >>>
> >>> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> >>> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >>> ---
> >>> --- /dev/null
> >>> +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
> >>> @@ -0,0 +1,338 @@
> >>> +/*
> >>> + * VGIC system registers handling functions for AArch64 mode
> >>> + *
> >>> + * This program is free software; you can redistribute it and/or modify
> >>> + * it under the terms of the GNU General Public License version 2 as
> >>> + * published by the Free Software Foundation.
> >>> + *
> >>> + * This program is distributed in the hope that it will be useful,
> >>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>> + * GNU General Public License for more details.
> >>> + */
> >>> +
> >>> +#include <linux/irqchip/arm-gic-v3.h>
> >>> +#include <linux/kvm.h>
> >>> +#include <linux/kvm_host.h>
> >>> +#include <asm/kvm_emulate.h>
> >>> +#include "vgic.h"
> >>> +#include "sys_regs.h"
> >>> +
> >>> +static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >>> +                         const struct sys_reg_desc *r)
> >>> +{
> >>> +     u32 host_pri_bits, host_id_bits, host_seis, host_a3v, seis, a3v;
> >>> +     struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
> >>> +     struct vgic_vmcr vmcr;
> >>> +     u64 val;
> >>> +
> >>> +     vgic_get_vmcr(vcpu, &vmcr);
> >>> +     if (p->is_write) {
> >>> +             val = p->regval;
> >>> +
> >>> +             /*
> >>> +              * Disallow restoring VM state if not supported by this
> >>> +              * hardware.
> >>> +              */
> >>> +             host_pri_bits = ((val & ICC_CTLR_EL1_PRI_BITS_MASK) >>
> >>> +                              ICC_CTLR_EL1_PRI_BITS_SHIFT) + 1;
> >> I am confused by the "host" terminology. Those are the "source" values
> >> we want to restore and we compare with the destination current value, right?
> > 
> > yes
> > 
> >>> +             if (host_pri_bits > vgic_v3_cpu->num_pri_bits)
> >>> +                     return false;
> >> I am lost. Who did set num_pri_bits and num_id_bits we compare with?
> > 
> > In vgic_v3_enable()  these values are computed
> OK I missed that.
> > 
> >> Seis and a3v I get this is computed on probe
> >>> +
> >>> +             vgic_v3_cpu->num_pri_bits = host_pri_bits;
> >>> +
> >>> +             host_id_bits = (val & ICC_CTLR_EL1_ID_BITS_MASK) >>
> >>> +                             ICC_CTLR_EL1_ID_BITS_SHIFT;
> >>> +             if (host_id_bits > vgic_v3_cpu->num_id_bits)
> >>> +                     return false;
> >>> +
> >>> +             vgic_v3_cpu->num_id_bits = host_id_bits;
> >>> +
> >>> +             host_seis = ((kvm_vgic_global_state.ich_vtr_el2 &
> >>> +                          ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT);
> >>> +             seis = (val & ICC_CTLR_EL1_SEIS_MASK) >>
> >>> +                     ICC_CTLR_EL1_SEIS_SHIFT;
> >>> +             if (host_seis != seis)
> >>> +                     return false;
> >>> +
> >>> +             host_a3v = ((kvm_vgic_global_state.ich_vtr_el2 &
> >>> +                         ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT);
> >>> +             a3v = (val & ICC_CTLR_EL1_A3V_MASK) >> ICC_CTLR_EL1_A3V_SHIFT;
> >>> +             if (host_a3v != a3v)
> >>> +                     return false;
> >>> +
> >>> +             vmcr.ctlr = val & ICC_CTLR_EL1_CBPR_MASK;
> >>> +             vmcr.ctlr |= val & ICC_CTLR_EL1_EOImode_MASK;
> >> nit: I still don't get why the vmcr has CPBR and EOImode set with the
> >> ICC_CTLR_EL1 layout and then this gets transformed in the proper vmcr
> >> format by vgic_set_vmcr. This is confusing to me and would at least
> >> deserve a comment attached to struct vgic_vmcr definition.
> > 
> > I will add a comment
> >>
> >> Why don't we set the vmcr.ctlr directly in its ICH_VMCR format? In
> >> set/get_vmcr all the other struct vgic_vmcr fields are handled in
> >> ICH_VMCR native layout except the ctrl field.
> > 
> > None of the fields of struct vgic_vmcr are in ICH_VMCR native layout.
> > Except ctlr all the other fields are registers having single field value.
> > Ex: pmr, bpr0 etc.,
> OK but to me would be more natural to keep vmcr.ctlr in original format
> but well that's just my pov. If you add a comment that helps already.
> 
Honestly this has been confusing and I'm forgetting the history, but I
think it currently serves the purpose that code shared between v2 and v3
can look at vgic_vmcr.bpr in some canonical format that works for both
v2 and v3.  Originally I think the ctlr field only contained the bits
that then had the common bit position between v2 and v3.

A comment will help, and someone taking a look at reworking it to be
more clear would also be welcome.

But the currently code (incl this patch) looks right to me at this
point.

Thanks,
-Christoffer
