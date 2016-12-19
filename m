From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [PATCH v10 6/8] arm/arm64: vgic: Implement VGICv3 CPU interface
 access
Date: Mon, 19 Dec 2016 15:17:37 +0530
Message-ID: <CALicx6spkmp4ipvCA_TUfzaJ0K38tpWHsV9CGU4MEQzTwa00sw@mail.gmail.com>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
 <1480576187-5012-7-git-send-email-vijay.kilari@gmail.com>
 <af6f17a5-f20a-91f7-c280-1669e9b805a4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1035401B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2016 04:46:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0ckTq50R00KD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2016 04:46:24 -0500 (EST)
Received: from mail-oi0-f68.google.com (mail-oi0-f68.google.com
 [209.85.218.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA96C4019C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2016 04:46:23 -0500 (EST)
Received: by mail-oi0-f68.google.com with SMTP id u15so18792734oie.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2016 01:47:38 -0800 (PST)
In-Reply-To: <af6f17a5-f20a-91f7-c280-1669e9b805a4@redhat.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 16, 2016 at 5:55 PM, Auger Eric <eric.auger@redhat.com> wrote:
> Hi Vijaya,
>
> On 01/12/2016 08:09, vijay.kilari@gmail.com wrote:
>> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>>
>> VGICv3 CPU interface registers are accessed using
>> KVM_DEV_ARM_VGIC_CPU_SYSREGS ioctl. These registers are accessed
>> as 64-bit. The cpu MPIDR value is passed along with register id.
>> is used to identify the cpu for registers access.
> s/is/It is
>>
>> The VM that supports SEIs expect it on destination machine to handle
>> guest aborts and hence checked for ICC_CTLR_EL1.SEIS compatibility.
>> Similarly, VM that supports Affinity Level 3 that is required for AArch64
>> mode, is required to be supported on destination machine. Hence checked
>> for ICC_CTLR_EL1.A3V compatibility.
> We make sure ICC_CTLR_EL1 SEIS and A3V are compatible on source and target?
>>
>> The arch/arm64/kvm/vgic-sys-reg-v3.c handles read and write of VGIC
>> CPU registers for AArch64.
>>
>> For AArch32 mode, arch/arm/kvm/vgic-v3-coproc.c file is created but
>> APIs are not implemented.
>>
>> Updated arch/arm/include/uapi/asm/kvm.h with new definitions
>> required to compile for AArch32.
>>
>> The version of VGIC v3 specification is define here
> s/define/defined
>> Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>>
>> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
>> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>> ---
>> --- /dev/null
>> +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
>> @@ -0,0 +1,338 @@
>> +/*
>> + * VGIC system registers handling functions for AArch64 mode
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/irqchip/arm-gic-v3.h>
>> +#include <linux/kvm.h>
>> +#include <linux/kvm_host.h>
>> +#include <asm/kvm_emulate.h>
>> +#include "vgic.h"
>> +#include "sys_regs.h"
>> +
>> +static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> +                         const struct sys_reg_desc *r)
>> +{
>> +     u32 host_pri_bits, host_id_bits, host_seis, host_a3v, seis, a3v;
>> +     struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
>> +     struct vgic_vmcr vmcr;
>> +     u64 val;
>> +
>> +     vgic_get_vmcr(vcpu, &vmcr);
>> +     if (p->is_write) {
>> +             val = p->regval;
>> +
>> +             /*
>> +              * Disallow restoring VM state if not supported by this
>> +              * hardware.
>> +              */
>> +             host_pri_bits = ((val & ICC_CTLR_EL1_PRI_BITS_MASK) >>
>> +                              ICC_CTLR_EL1_PRI_BITS_SHIFT) + 1;
> I am confused by the "host" terminology. Those are the "source" values
> we want to restore and we compare with the destination current value, right?

yes

>> +             if (host_pri_bits > vgic_v3_cpu->num_pri_bits)
>> +                     return false;
> I am lost. Who did set num_pri_bits and num_id_bits we compare with?

In vgic_v3_enable()  these values are computed

> Seis and a3v I get this is computed on probe
>> +
>> +             vgic_v3_cpu->num_pri_bits = host_pri_bits;
>> +
>> +             host_id_bits = (val & ICC_CTLR_EL1_ID_BITS_MASK) >>
>> +                             ICC_CTLR_EL1_ID_BITS_SHIFT;
>> +             if (host_id_bits > vgic_v3_cpu->num_id_bits)
>> +                     return false;
>> +
>> +             vgic_v3_cpu->num_id_bits = host_id_bits;
>> +
>> +             host_seis = ((kvm_vgic_global_state.ich_vtr_el2 &
>> +                          ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT);
>> +             seis = (val & ICC_CTLR_EL1_SEIS_MASK) >>
>> +                     ICC_CTLR_EL1_SEIS_SHIFT;
>> +             if (host_seis != seis)
>> +                     return false;
>> +
>> +             host_a3v = ((kvm_vgic_global_state.ich_vtr_el2 &
>> +                         ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT);
>> +             a3v = (val & ICC_CTLR_EL1_A3V_MASK) >> ICC_CTLR_EL1_A3V_SHIFT;
>> +             if (host_a3v != a3v)
>> +                     return false;
>> +
>> +             vmcr.ctlr = val & ICC_CTLR_EL1_CBPR_MASK;
>> +             vmcr.ctlr |= val & ICC_CTLR_EL1_EOImode_MASK;
> nit: I still don't get why the vmcr has CPBR and EOImode set with the
> ICC_CTLR_EL1 layout and then this gets transformed in the proper vmcr
> format by vgic_set_vmcr. This is confusing to me and would at least
> deserve a comment attached to struct vgic_vmcr definition.

I will add a comment
>
> Why don't we set the vmcr.ctlr directly in its ICH_VMCR format? In
> set/get_vmcr all the other struct vgic_vmcr fields are handled in
> ICH_VMCR native layout except the ctrl field.

None of the fields of struct vgic_vmcr are in ICH_VMCR native layout.
Except ctlr all the other fields are registers having single field value.
Ex: pmr, bpr0 etc.,

>
>> +             vgic_set_vmcr(vcpu, &vmcr);
>> +     } else {
>> +             val = 0;
>> +             val |= (vgic_v3_cpu->num_pri_bits - 1) <<
>> +                     ICC_CTLR_EL1_PRI_BITS_SHIFT;
>> +             val |= vgic_v3_cpu->num_id_bits << ICC_CTLR_EL1_ID_BITS_SHIFT;
>> +             val |= ((kvm_vgic_global_state.ich_vtr_el2 &
>> +                     ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT) <<
>> +                     ICC_CTLR_EL1_SEIS_SHIFT;
>> +             val |= ((kvm_vgic_global_state.ich_vtr_el2 &
>> +                     ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT) <<
>> +                     ICC_CTLR_EL1_A3V_SHIFT;
>> +             val |= vmcr.ctlr & ICC_CTLR_EL1_CBPR_MASK;
>> +             val |= vmcr.ctlr & ICC_CTLR_EL1_EOImode_MASK;
>> +
>> +             p->regval = val;
>> +     }
>> +
>> +     return true;
>> +}
>> +
>> +static bool access_gic_pmr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> +                        const struct sys_reg_desc *r)
>> +{
>> +     struct vgic_vmcr vmcr;
>> +
>> +     vgic_get_vmcr(vcpu, &vmcr);
>> +     if (p->is_write) {
>> +             vmcr.pmr = (p->regval & ICC_PMR_EL1_MASK) >> ICC_PMR_EL1_SHIFT;
>> +             vgic_set_vmcr(vcpu, &vmcr);
>> +     } else {
>> +             p->regval = (vmcr.pmr << ICC_PMR_EL1_SHIFT) & ICC_PMR_EL1_MASK;
>> +     }
>> +
>> +     return true;
>> +}
>> +
>> +static bool access_gic_bpr0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> +                         const struct sys_reg_desc *r)
>> +{
>> +     struct vgic_vmcr vmcr;
>> +
>> +     vgic_get_vmcr(vcpu, &vmcr);
>> +     if (p->is_write) {
>> +             vmcr.bpr = (p->regval & ICC_BPR0_EL1_MASK) >>
>> +                         ICC_BPR0_EL1_SHIFT;
>> +             vgic_set_vmcr(vcpu, &vmcr);
>> +     } else {
>> +             p->regval = (vmcr.bpr << ICC_BPR0_EL1_SHIFT) &
>> +                          ICC_BPR0_EL1_MASK;
>> +     }
>> +
>> +     return true;
>> +}
>> +
>> +static bool access_gic_bpr1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> +                         const struct sys_reg_desc *r)
>> +{
>> +     struct vgic_vmcr vmcr;
>> +
>> +     if (!p->is_write)
>> +             p->regval = 0;
>> +
>> +     vgic_get_vmcr(vcpu, &vmcr);
>> +     if (!((vmcr.ctlr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT)) {
>> +             if (p->is_write) {
>> +                     vmcr.abpr = (p->regval & ICC_BPR1_EL1_MASK) >>
>> +                                  ICC_BPR1_EL1_SHIFT;
>> +                     vgic_set_vmcr(vcpu, &vmcr);
>> +             } else {
>> +                     p->regval = (vmcr.abpr << ICC_BPR1_EL1_SHIFT) &
>> +                                  ICC_BPR1_EL1_MASK;
>> +             }
>> +     } else {
>> +             if (!p->is_write)
>> +                     p->regval = min((vmcr.bpr + 1), 7U);
>> +     }
>> +
>> +     return true;
>> +}
>> +
>> +static bool access_gic_grpen0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> +                           const struct sys_reg_desc *r)
>> +{
>> +     struct vgic_vmcr vmcr;
>> +
>> +     vgic_get_vmcr(vcpu, &vmcr);
>> +     if (p->is_write) {
>> +             vmcr.grpen0 = (p->regval & ICC_IGRPEN0_EL1_MASK) >>
>> +                            ICC_IGRPEN0_EL1_SHIFT;
>> +             vgic_set_vmcr(vcpu, &vmcr);
>> +     } else {
>> +             p->regval = (vmcr.grpen0 << ICC_IGRPEN0_EL1_SHIFT) &
>> +                          ICC_IGRPEN0_EL1_MASK;
>> +     }
>> +
>> +     return true;
>> +}
>> +
>> +static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> +                           const struct sys_reg_desc *r)
>> +{
>> +     struct vgic_vmcr vmcr;
>> +
>> +     vgic_get_vmcr(vcpu, &vmcr);
>> +     if (p->is_write) {
>> +             vmcr.grpen1 = (p->regval & ICC_IGRPEN1_EL1_MASK) >>
>> +                            ICC_IGRPEN1_EL1_SHIFT;
>> +             vgic_set_vmcr(vcpu, &vmcr);
>> +     } else {
>> +             p->regval = (vmcr.grpen1 << ICC_IGRPEN1_EL1_SHIFT) &
>> +                          ICC_IGRPEN1_EL1_MASK;
>> +     }
>> +
>> +     return true;
>> +}
>> +
>> +static void vgic_v3_access_apr_reg(struct kvm_vcpu *vcpu,
>> +                                struct sys_reg_params *p, u8 apr, u8 idx)
>> +{
>> +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
>> +     uint32_t *ap_reg;
>> +
>> +     if (apr)
>> +             ap_reg = &vgicv3->vgic_ap1r[idx];
>> +     else
>> +             ap_reg = &vgicv3->vgic_ap0r[idx];
>> +
>> +     if (p->is_write)
>> +             *ap_reg = p->regval;
>> +     else
>> +             p->regval = *ap_reg;
>> +}
>> +
>> +static bool access_gic_aprn(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> +                         const struct sys_reg_desc *r, u8 apr)
>> +{
>> +     struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
>> +     u8 idx = r->Op2 & 3;
>> +
>> +     /*
>> +      * num_pri_bits are initialized with HW supported values.
>> +      * We can rely safely on num_pri_bits even if VM has not
>> +      * restored ICC_CTLR_EL1 before restoring APnR registers.
>> +      */
>> +     switch (vgic_v3_cpu->num_pri_bits) {
>> +     case 7:
>> +             vgic_v3_access_apr_reg(vcpu, p, apr, idx);
>> +             break;
>> +     case 6:
>> +             if (idx > 1)
>> +                     goto err;
>> +             vgic_v3_access_apr_reg(vcpu, p, apr, idx);
>> +             break;
>> +     default:
>> +             if (idx > 0)
>> +                     goto err;
>> +             vgic_v3_access_apr_reg(vcpu, p, apr, idx);
>> +     }
>> +
>> +     return true;
>> +err:
>> +     if (!p->is_write)
>> +             p->regval = 0;
>> +
>> +     return false;
>> +}
>> +
>> +static bool access_gic_ap0r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> +                         const struct sys_reg_desc *r)
>> +
>> +{
>> +     return access_gic_aprn(vcpu, p, r, 0);
>> +}
>> +
>> +static bool access_gic_ap1r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> +                         const struct sys_reg_desc *r)
>> +{
>> +     return access_gic_aprn(vcpu, p, r, 1);
>> +}
>> +
>> +static bool access_gic_sre(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> +                        const struct sys_reg_desc *r)
>> +{
>> +     struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
>> +
>> +     /* Validate SRE bit */
>> +     if (p->is_write) {
>> +             if (!(p->regval & ICC_SRE_EL1_SRE))
>> +                     return false;
>> +     } else {
>> +             p->regval = vgicv3->vgic_sre;
>> +     }
>> +
>> +     return true;
>> +}
>> +static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
>> +     /* ICC_PMR_EL1 */
>> +     { Op0(3), Op1(0), CRn(4), CRm(6), Op2(0), access_gic_pmr },
>> +     /* ICC_BPR0_EL1 */
>> +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(3), access_gic_bpr0 },
>> +     /* ICC_AP0R0_EL1 */
>> +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(4), access_gic_ap0r },
>> +     /* ICC_AP0R1_EL1 */
>> +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(5), access_gic_ap0r },
>> +     /* ICC_AP0R2_EL1 */
>> +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(6), access_gic_ap0r },
>> +     /* ICC_AP0R3_EL1 */
>> +     { Op0(3), Op1(0), CRn(12), CRm(8), Op2(7), access_gic_ap0r },
>> +     /* ICC_AP1R0_EL1 */
>> +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(0), access_gic_ap1r },
>> +     /* ICC_AP1R1_EL1 */
>> +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(1), access_gic_ap1r },
>> +     /* ICC_AP1R2_EL1 */
>> +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(2), access_gic_ap1r },
>> +     /* ICC_AP1R3_EL1 */
>> +     { Op0(3), Op1(0), CRn(12), CRm(9), Op2(3), access_gic_ap1r },
>> +     /* ICC_BPR1_EL1 */
>> +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(3), access_gic_bpr1 },
>> +     /* ICC_CTLR_EL1 */
>> +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(4), access_gic_ctlr },
>> +     /* ICC_SRE_EL1 */
>> +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(5), access_gic_sre },
>> +     /* ICC_IGRPEN0_EL1 */
>> +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(6), access_gic_grpen0 },
>> +     /* ICC_GRPEN1_EL1 */
>> +     { Op0(3), Op1(0), CRn(12), CRm(12), Op2(7), access_gic_grpen1 },
>> +};
>> +
>> +int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
>> +                             u64 *reg)
>> +{
>> +     struct sys_reg_params params;
>> +     u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
> At the beginning I asked myself why we did not OR with KVM_REG_ARM64 as
> stated in include/uapi/linux/kvm.h but then looking at
> index_to_params() implementation it looks it is not used.
>> +
>> +     params.regval = *reg;
>> +     params.is_write = is_write;
>> +     params.is_aarch32 = false;
>> +     params.is_32bit = false;
>> +
>> +     if (find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
>> +                           ARRAY_SIZE(gic_v3_icc_reg_descs)))
>> +             return 0;
>> +
>> +     return -ENXIO;
>> +}
>> +
>> +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
>> +                             u64 *reg)
>> +{
>> +     struct sys_reg_params params;
>> +     const struct sys_reg_desc *r;
>> +     u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
>> +
>> +     if (is_write)
>> +             params.regval = *reg;
>> +     params.is_write = is_write;
>> +     params.is_aarch32 = false;
>> +     params.is_32bit = false;
>> +
>> +     r = find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
>> +                        ARRAY_SIZE(gic_v3_icc_reg_descs));
>> +     if (!r)
>> +             return -ENXIO;
>> +
>> +     if (!r->access(vcpu, &params, r))
>> +             return -EINVAL;
>> +
>> +     if (!is_write)
>> +             *reg = params.regval;
>> +
>> +     return 0;
>> +}
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 002f092..730a18a 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -71,6 +71,9 @@ struct vgic_global {
>>
>>       /* GIC system register CPU interface */
>>       struct static_key_false gicv3_cpuif;
>> +
>> +     /* Cache ICH_VTR_EL2 reg value */
> nit: comment does not bring much value I think
>> +     u32                     ich_vtr_el2;
>>  };
>>
>>  extern struct vgic_global kvm_vgic_global_state;
>> @@ -269,6 +272,12 @@ struct vgic_cpu {
>>       u64 pendbaser;
>>
>>       bool lpis_enabled;
>> +
>> +     /* Cache guest priority bits */
>> +     u32 num_pri_bits;
>> +
>> +     /* Cache guest interrupt ID bits */
>> +     u32 num_id_bits;
>>  };
>>
>>  extern struct static_key_false vgic_v2_cpuif_trap;
>> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> index bc7de95..b6266fe 100644
>> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
>> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> @@ -16,6 +16,7 @@
>>  #include <linux/kvm_host.h>
>>  #include <kvm/arm_vgic.h>
>>  #include <linux/uaccess.h>
>> +#include <asm/kvm_emulate.h>
> not needed I think
OK.
