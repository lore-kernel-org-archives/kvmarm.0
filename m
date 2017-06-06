From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 07/25] KVM: arm64: vgic-v3: Add ICV_IAR1_EL1 handler
Date: Tue, 6 Jun 2017 13:09:46 +0200
Message-ID: <20170606110946.GL9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-8-marc.zyngier@arm.com>
 <20170605092100.GI9464@cbox>
 <4aa402b8-a6fe-fc1c-445d-17be50752d00@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4aa402b8-a6fe-fc1c-445d-17be50752d00@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 05, 2017 at 11:33:52AM +0100, Marc Zyngier wrote:
> On 05/06/17 10:21, Christoffer Dall wrote:
> > On Thu, Jun 01, 2017 at 11:20:59AM +0100, Marc Zyngier wrote:
> >> Add a handler for reading the guest's view of the ICC_IAR1_EL1
> >> register. This involves finding the highest priority Group-1
> >> interrupt, checking against both PMR and the active group
> >> priority, activating the interrupt and setting the group
> >> priority as active.
> >>
> >> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  include/linux/irqchip/arm-gic-v3.h |   1 +
> >>  virt/kvm/arm/hyp/vgic-v3-sr.c      | 150 +++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 151 insertions(+)
> >>
> >> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> >> index fffb91202bc9..401db585a534 100644
> >> --- a/include/linux/irqchip/arm-gic-v3.h
> >> +++ b/include/linux/irqchip/arm-gic-v3.h
> >> @@ -405,6 +405,7 @@
> >>  #define ICH_LR_PHYS_ID_SHIFT		32
> >>  #define ICH_LR_PHYS_ID_MASK		(0x3ffULL << ICH_LR_PHYS_ID_SHIFT)
> >>  #define ICH_LR_PRIORITY_SHIFT		48
> >> +#define ICH_LR_PRIORITY_MASK		(0xffULL << ICH_LR_PRIORITY_SHIFT)
> >>  
> >>  /* These are for GICv2 emulation only */
> >>  #define GICH_LR_VIRTUALID		(0x3ffUL << 0)
> >> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> >> index 168539dfd0b9..16a2eadc7a5c 100644
> >> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> >> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> >> @@ -24,6 +24,7 @@
> >>  
> >>  #define vtr_to_max_lr_idx(v)		((v) & 0xf)
> >>  #define vtr_to_nr_pre_bits(v)		(((u32)(v) >> 26) + 1)
> >> +#define vtr_to_nr_apr_regs(v)		(1 << (vtr_to_nr_pre_bits(v) - 5))
> >>  
> >>  static u64 __hyp_text __gic_v3_get_lr(unsigned int lr)
> >>  {
> >> @@ -375,6 +376,79 @@ void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
> >>  
> >>  #ifdef CONFIG_ARM64
> >>  
> >> +static int __hyp_text __vgic_v3_get_group(struct kvm_vcpu *vcpu)
> >> +{
> >> +	u32 esr = kvm_vcpu_get_hsr(vcpu);
> >> +	u8 crm = (esr & ESR_ELx_SYS64_ISS_CRM_MASK) >> ESR_ELx_SYS64_ISS_CRM_SHIFT;
> >> +
> >> +	return crm != 8;
> >> +}
> >> +
> >> +#define GICv3_IDLE_PRIORITY	0xff
> >> +
> >> +static int __hyp_text __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu,
> >> +						    u32 vmcr,
> >> +						    u64 *lr_val)
> >> +{
> >> +	unsigned int used_lrs = vcpu->arch.vgic_cpu.used_lrs;
> >> +	u8 priority = GICv3_IDLE_PRIORITY;
> >> +	int i, lr = -1;
> >> +
> >> +	for (i = 0; i < used_lrs; i++) {
> >> +		u64 val = __gic_v3_get_lr(i);
> >> +		u8 lr_prio = (val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
> >> +
> >> +		/* Not pending in the state? */
> >> +		if ((val & ICH_LR_STATE) != ICH_LR_PENDING_BIT)
> >> +			continue;
> >> +
> >> +		/* Group-0 interrupt, but Group-0 disabled? */
> >> +		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG0_MASK))
> >> +			continue;
> >> +
> >> +		/* Group-1 interrupt, but Group-1 disabled? */
> >> +		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG1_MASK))
> >> +			continue;
> >> +
> >> +		/* Not the highest priority? */
> >> +		if (lr_prio >= priority)
> >> +			continue;
> >> +
> >> +		/* This is a candidate */
> >> +		priority = lr_prio;
> >> +		*lr_val = val;
> >> +		lr = i;
> >> +	}
> >> +
> >> +	if (lr == -1)
> >> +		*lr_val = ICC_IAR1_EL1_SPURIOUS;
> >> +
> >> +	return lr;
> >> +}
> >> +
> >> +static int __hyp_text __vgic_v3_get_highest_active_priority(void)
> >> +{
> >> +	u8 nr_pre_bits = vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
> >> +	u8 nr_apr_regs = vtr_to_nr_apr_regs(read_gicreg(ICH_VTR_EL2));
> >> +	u32 hap = 0;
> >> +	int i;
> >> +
> >> +	for (i = 0; i < nr_apr_regs; i++) {
> >> +		u32 val;
> >> +
> >> +		val  = __vgic_v3_read_ap0rn(i);
> >> +		val |= __vgic_v3_read_ap1rn(i);
> >> +		if (!val) {
> >> +			hap += 32;
> >> +			continue;
> >> +		}
> >> +
> >> +		return (hap + __ffs(val)) << (8 - nr_pre_bits);
> > 
> > I don't understand this shift, and I think I asked about it before, so
> > maybe if it's a reused concept we can use a static inline or at least
> > provide a comment?
> 
> I tried to explain it in my reply to your comment on patch #5. Can
> definitely make that a helper. I think part of the confusion is that
> this constant is used in a number of ways to express the conversion
> between a preemption level and a priority.
> 

ok, I understand it now, but it's weird that we use 8 as a constant here
(which applied to both group 0 and group 1) but 7 and 8, respecitvely,
for the writes to the bpr0.

I understand that these two concepts are actually independent and
loosely related, so maybe adding something like this would help:

		/*
		 * The ICH_AP0Rn_EL2 and ICH_AP1Rn_EL2 registers contain
		 * the active priority levels for this VCPU for the
		 * maximum number of supported priority levels, and we
		 * return the full priority level only if the BPR is
		 * programmed to its minimum, otherwise we return a
		 * combination of the priority level and subpriority, as
		 * determined by the setting of the BPR, but without the
		 * full subpriority.
		 */

Maybe this is wrong and will just confuse people more?

> >> +	}
> >> +
> >> +	return GICv3_IDLE_PRIORITY;
> >> +}
> >> +
> >>  static unsigned int __hyp_text __vgic_v3_get_bpr0(u32 vmcr)
> >>  {
> >>  	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
> >> @@ -395,6 +469,79 @@ static unsigned int __hyp_text __vgic_v3_get_bpr1(u32 vmcr)
> >>  	return bpr;
> >>  }
> >>  
> >> +/*
> >> + * Convert a priority to a preemption level, taking the relevant BPR
> >> + * into account by zeroing the sub-priority bits.
> >> + */
> >> +static u8 __hyp_text __vgic_v3_pri_to_pre(u8 pri, u32 vmcr, int grp)
> >> +{
> >> +	unsigned int bpr;
> >> +
> >> +	if (!grp)
> >> +		bpr = __vgic_v3_get_bpr0(vmcr) + 1;
> >> +	else
> >> +		bpr = __vgic_v3_get_bpr1(vmcr);
> >> +
> >> +	return pri & (GENMASK(7, 0) << bpr);
> >> +}
> >> +
> >> +/*
> >> + * The priority value is independent of any of the BPR values, so we
> >> + * normalize it using nr_pre_bits. This guarantees that no matter what
> >> + * the guest does with its BPR, we can always set/get the same value
> >> + * of a priority.
> >> + */
> >> +static void __hyp_text __vgic_v3_set_active_priority(u8 pri, u32 vmcr, int grp)
> >> +{
> >> +	u8 nr_pre_bits, pre, ap;
> >> +	u32 val;
> >> +	int apr;
> >> +
> >> +	nr_pre_bits = vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
> >> +	pre = __vgic_v3_pri_to_pre(pri, vmcr, grp);
> >> +	ap = pre >> (8 - nr_pre_bits);
> > 
> > Again here, I don't get this shift.
> > 
> >> +	apr = ap / 32;
> >> +
> >> +	val = __vgic_v3_read_ap1rn(apr);
> >> +	__vgic_v3_write_ap1rn(val | BIT(ap % 32), apr);
> > 
> > How are we sure this is a group 1 interrupt here?
> 
> That's a bug, as we should definitely check grp here. Thanks for
> noticing it!
> 

Sure.  Also, the spec says "Writing to these registers with any value
other than the last read value of the register (or 0x00000000 for a
newly set up virtual machine) can result in UNPREDICTABLE behavior of
the virtual interrupt prioritization system allowing either: ...".  Does
that just translate to "You should know what you're doing", or could we
be breaking something here?

> >> +}
> >> +
> >> +static void __hyp_text __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> >> +{
> >> +	u64 lr_val;
> >> +	u8 lr_prio, pmr;
> >> +	int lr, grp;
> >> +
> >> +	grp = __vgic_v3_get_group(vcpu);
> >> +
> >> +	lr = __vgic_v3_highest_priority_lr(vcpu, vmcr, &lr_val);
> >> +	if (lr < 0)
> >> +		goto spurious;
> >> +
> >> +	if (grp != !!(lr_val & ICH_LR_GROUP))
> >> +		goto spurious;
> >> +
> >> +	pmr = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
> >> +	lr_prio = (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
> >> +	if (pmr <= lr_prio)
> >> +		goto spurious;
> >> +
> >> +	if (__vgic_v3_get_highest_active_priority() <= lr_prio)
> >> +		goto spurious;

Based on what I wrote above, don't you need to consider the actual
setting of the BPR here?

For example, if __vgic_v3_get_highest_active_priority() == 100.10 and
lr_prio == 100.09  (BPR == 5 for a group 1 interrupt) then you'll
compare 10010 <= 10009, you won't take the branch and you'll let the
guest ack another interrupt at the same-and-already-active preemption
level.

Or am I again misunderstandin how this whole thing works?

> >> +
> >> +	lr_val &= ~ICH_LR_STATE;
> >> +	/* No active state for LPIs */
> >> +	if ((lr_val & ICH_LR_VIRTUAL_ID_MASK) <= VGIC_MAX_SPI)
> >> +		lr_val |= ICH_LR_ACTIVE_BIT;
> >> +	__gic_v3_set_lr(lr_val, lr);
> >> +	__vgic_v3_set_active_priority(lr_prio, vmcr, grp);
> >> +	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
> >> +	return;
> >> +
> >> +spurious:
> >> +	vcpu_set_reg(vcpu, rt, ICC_IAR1_EL1_SPURIOUS);
> >> +}
> >> +
> >>  static void __hyp_text __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> >>  {
> >>  	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
> >> @@ -459,6 +606,9 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
> >>  	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
> >>  
> >>  	switch (sysreg) {
> >> +	case SYS_ICC_IAR1_EL1:
> >> +		fn = __vgic_v3_read_iar;
> >> +		break;
> > 
> > So we don't provide a write-ignore function here because we rely on the
> > hardware to always trap that at EL1 instead?
> > 
> > I remember we discussed this before, but I don't remember if the
> > conclusion was that this is 100% safe.
> 
> A properly designed CPU would UNDEF at EL1. I'm happy to try and detect
> broken failing implementations here, but I'm not sure of what to do, as
> we're not in the best context to handle this. We could continue exiting
> to EL1 and handle things there...
> 

I feel like we decided that other parts of KVM relies on this being
implemented correctly, so maybe this is not the place to begin being
overly cautious about things.

That said, having a path back to EL1 where we can print stuff and
create warnings, may not be an entirely bad idea.

Thanks,
-Christoffer
