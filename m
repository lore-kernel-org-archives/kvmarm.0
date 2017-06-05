From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 07/25] KVM: arm64: vgic-v3: Add ICV_IAR1_EL1 handler
Date: Mon, 5 Jun 2017 11:21:00 +0200
Message-ID: <20170605092100.GI9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-8-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84FB940C49
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 05:17:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dlol5yKuWHa9 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Jun 2017 05:17:13 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3378B40C47
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 05:17:12 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id 7so68132176wmo.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Jun 2017 02:21:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-8-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 11:20:59AM +0100, Marc Zyngier wrote:
> Add a handler for reading the guest's view of the ICC_IAR1_EL1
> register. This involves finding the highest priority Group-1
> interrupt, checking against both PMR and the active group
> priority, activating the interrupt and setting the group
> priority as active.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/linux/irqchip/arm-gic-v3.h |   1 +
>  virt/kvm/arm/hyp/vgic-v3-sr.c      | 150 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 151 insertions(+)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index fffb91202bc9..401db585a534 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -405,6 +405,7 @@
>  #define ICH_LR_PHYS_ID_SHIFT		32
>  #define ICH_LR_PHYS_ID_MASK		(0x3ffULL << ICH_LR_PHYS_ID_SHIFT)
>  #define ICH_LR_PRIORITY_SHIFT		48
> +#define ICH_LR_PRIORITY_MASK		(0xffULL << ICH_LR_PRIORITY_SHIFT)
>  
>  /* These are for GICv2 emulation only */
>  #define GICH_LR_VIRTUALID		(0x3ffUL << 0)
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 168539dfd0b9..16a2eadc7a5c 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -24,6 +24,7 @@
>  
>  #define vtr_to_max_lr_idx(v)		((v) & 0xf)
>  #define vtr_to_nr_pre_bits(v)		(((u32)(v) >> 26) + 1)
> +#define vtr_to_nr_apr_regs(v)		(1 << (vtr_to_nr_pre_bits(v) - 5))
>  
>  static u64 __hyp_text __gic_v3_get_lr(unsigned int lr)
>  {
> @@ -375,6 +376,79 @@ void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
>  
>  #ifdef CONFIG_ARM64
>  
> +static int __hyp_text __vgic_v3_get_group(struct kvm_vcpu *vcpu)
> +{
> +	u32 esr = kvm_vcpu_get_hsr(vcpu);
> +	u8 crm = (esr & ESR_ELx_SYS64_ISS_CRM_MASK) >> ESR_ELx_SYS64_ISS_CRM_SHIFT;
> +
> +	return crm != 8;
> +}
> +
> +#define GICv3_IDLE_PRIORITY	0xff
> +
> +static int __hyp_text __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu,
> +						    u32 vmcr,
> +						    u64 *lr_val)
> +{
> +	unsigned int used_lrs = vcpu->arch.vgic_cpu.used_lrs;
> +	u8 priority = GICv3_IDLE_PRIORITY;
> +	int i, lr = -1;
> +
> +	for (i = 0; i < used_lrs; i++) {
> +		u64 val = __gic_v3_get_lr(i);
> +		u8 lr_prio = (val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
> +
> +		/* Not pending in the state? */
> +		if ((val & ICH_LR_STATE) != ICH_LR_PENDING_BIT)
> +			continue;
> +
> +		/* Group-0 interrupt, but Group-0 disabled? */
> +		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG0_MASK))
> +			continue;
> +
> +		/* Group-1 interrupt, but Group-1 disabled? */
> +		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG1_MASK))
> +			continue;
> +
> +		/* Not the highest priority? */
> +		if (lr_prio >= priority)
> +			continue;
> +
> +		/* This is a candidate */
> +		priority = lr_prio;
> +		*lr_val = val;
> +		lr = i;
> +	}
> +
> +	if (lr == -1)
> +		*lr_val = ICC_IAR1_EL1_SPURIOUS;
> +
> +	return lr;
> +}
> +
> +static int __hyp_text __vgic_v3_get_highest_active_priority(void)
> +{
> +	u8 nr_pre_bits = vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
> +	u8 nr_apr_regs = vtr_to_nr_apr_regs(read_gicreg(ICH_VTR_EL2));
> +	u32 hap = 0;
> +	int i;
> +
> +	for (i = 0; i < nr_apr_regs; i++) {
> +		u32 val;
> +
> +		val  = __vgic_v3_read_ap0rn(i);
> +		val |= __vgic_v3_read_ap1rn(i);
> +		if (!val) {
> +			hap += 32;
> +			continue;
> +		}
> +
> +		return (hap + __ffs(val)) << (8 - nr_pre_bits);

I don't understand this shift, and I think I asked about it before, so
maybe if it's a reused concept we can use a static inline or at least
provide a comment?

> +	}
> +
> +	return GICv3_IDLE_PRIORITY;
> +}
> +
>  static unsigned int __hyp_text __vgic_v3_get_bpr0(u32 vmcr)
>  {
>  	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
> @@ -395,6 +469,79 @@ static unsigned int __hyp_text __vgic_v3_get_bpr1(u32 vmcr)
>  	return bpr;
>  }
>  
> +/*
> + * Convert a priority to a preemption level, taking the relevant BPR
> + * into account by zeroing the sub-priority bits.
> + */
> +static u8 __hyp_text __vgic_v3_pri_to_pre(u8 pri, u32 vmcr, int grp)
> +{
> +	unsigned int bpr;
> +
> +	if (!grp)
> +		bpr = __vgic_v3_get_bpr0(vmcr) + 1;
> +	else
> +		bpr = __vgic_v3_get_bpr1(vmcr);
> +
> +	return pri & (GENMASK(7, 0) << bpr);
> +}
> +
> +/*
> + * The priority value is independent of any of the BPR values, so we
> + * normalize it using nr_pre_bits. This guarantees that no matter what
> + * the guest does with its BPR, we can always set/get the same value
> + * of a priority.
> + */
> +static void __hyp_text __vgic_v3_set_active_priority(u8 pri, u32 vmcr, int grp)
> +{
> +	u8 nr_pre_bits, pre, ap;
> +	u32 val;
> +	int apr;
> +
> +	nr_pre_bits = vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
> +	pre = __vgic_v3_pri_to_pre(pri, vmcr, grp);
> +	ap = pre >> (8 - nr_pre_bits);

Again here, I don't get this shift.

> +	apr = ap / 32;
> +
> +	val = __vgic_v3_read_ap1rn(apr);
> +	__vgic_v3_write_ap1rn(val | BIT(ap % 32), apr);

How are we sure this is a group 1 interrupt here?

> +}
> +
> +static void __hyp_text __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> +{
> +	u64 lr_val;
> +	u8 lr_prio, pmr;
> +	int lr, grp;
> +
> +	grp = __vgic_v3_get_group(vcpu);
> +
> +	lr = __vgic_v3_highest_priority_lr(vcpu, vmcr, &lr_val);
> +	if (lr < 0)
> +		goto spurious;
> +
> +	if (grp != !!(lr_val & ICH_LR_GROUP))
> +		goto spurious;
> +
> +	pmr = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
> +	lr_prio = (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
> +	if (pmr <= lr_prio)
> +		goto spurious;
> +
> +	if (__vgic_v3_get_highest_active_priority() <= lr_prio)
> +		goto spurious;
> +
> +	lr_val &= ~ICH_LR_STATE;
> +	/* No active state for LPIs */
> +	if ((lr_val & ICH_LR_VIRTUAL_ID_MASK) <= VGIC_MAX_SPI)
> +		lr_val |= ICH_LR_ACTIVE_BIT;
> +	__gic_v3_set_lr(lr_val, lr);
> +	__vgic_v3_set_active_priority(lr_prio, vmcr, grp);
> +	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
> +	return;
> +
> +spurious:
> +	vcpu_set_reg(vcpu, rt, ICC_IAR1_EL1_SPURIOUS);
> +}
> +
>  static void __hyp_text __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  {
>  	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
> @@ -459,6 +606,9 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
>  
>  	switch (sysreg) {
> +	case SYS_ICC_IAR1_EL1:
> +		fn = __vgic_v3_read_iar;
> +		break;

So we don't provide a write-ignore function here because we rely on the
hardware to always trap that at EL1 instead?

I remember we discussed this before, but I don't remember if the
conclusion was that this is 100% safe.


>  	case SYS_ICC_GRPEN1_EL1:
>  		if (is_read)
>  			fn = __vgic_v3_read_igrpen1;
> -- 
> 2.11.0
> 

Thanks,
-Christoffer
