From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 13/31] KVM: arm64: vgic-v3: Add ICV_IAR1_EL1 handler
Date: Thu, 18 May 2017 09:41:42 +0200
Message-ID: <9c11669c-ea66-bbe1-093d-907bcd190bab@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-14-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503104606.19342-14-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 03/05/2017 12:45, Marc Zyngier wrote:
> Add a handler for reading the guest's view of the ICC_IAR1_EL1
> register. This involves finding the highest priority Group-1
> interrupt, checking against both PMR and the active group
> priority, activating the interrupt and setting the group
> priority as active.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/linux/irqchip/arm-gic-v3.h |   1 +
>  virt/kvm/arm/hyp/vgic-v3-sr.c      | 134 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 135 insertions(+)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 97cbca19430d..7610ea4e8337 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -391,6 +391,7 @@
>  #define ICH_LR_PHYS_ID_SHIFT		32
>  #define ICH_LR_PHYS_ID_MASK		(0x3ffULL << ICH_LR_PHYS_ID_SHIFT)
>  #define ICH_LR_PRIORITY_SHIFT		48
> +#define ICH_LR_PRIORITY_MASK		(0xffULL << ICH_LR_PRIORITY_SHIFT)
>  
>  /* These are for GICv2 emulation only */
>  #define GICH_LR_VIRTUALID		(0x3ffUL << 0)
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 473ef22508e6..49aad1de3ac8 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -375,6 +375,77 @@ void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
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
> +	u8 nr_aprs = 1 << (nr_pre_bits - 5);
s/nr_aprs/nr_apr_regs ?

> +	u32 hap = 0;
> +	int i;
> +
> +	for (i = 0; i < nr_aprs; i++) {
> +		u32 val;
> +
> +		val  = __vgic_v3_read_ap0rn(i);
> +		val |= __vgic_v3_read_ap1rn(i);
> +		if (val)
> +			return (hap + __ffs(val)) << (8 - nr_pre_bits);
here don't we need to shift by the actual number of subpriority bits?
isn't nr_pre_bits the max implemented preemption bits but not
necessarily the actual chosen number set by bpr?
> +
> +		hap += 32;
> +	}
> +
> +	return GICv3_IDLE_PRIORITY;
> +}
> +
>  static unsigned int __hyp_text __vgic_v3_get_bpr0(u32 vmcr)
>  {
>  	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
> @@ -395,6 +466,66 @@ static unsigned int __hyp_text __vgic_v3_get_bpr1(u32 vmcr)
>  	return bpr;
>  }
>  
Would be nice to have a short doc comment.
I understand this zeros the subpriority field in the priority value, is
it correct? pseudocode PriorityGroup()?
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
 & GENMASK(7, bpr)?
> +}
> +
> +static void __hyp_text __vgic_v3_set_active_priority(u8 pre)
> +{
> +	u8 nr_pre_bits = vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
> +	u8 hap = pre >> (8 - nr_pre_bits);
Could you add a comment about what is hap. I tend to think it is the
group priority but then I don't get why we don't shift by 8 -bpr

Thanks

Eric
> +	int apr = hap / 32;
> +	u32 bit = BIT(hap % 32);
> +	u32 val;
> +
> +	val = __vgic_v3_read_ap1rn(apr);
> +	__vgic_v3_write_ap1rn(val | bit, apr);
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
> +	__vgic_v3_set_active_priority(__vgic_v3_pri_to_pre(lr_prio, vmcr, grp));
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
> @@ -457,6 +588,9 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
>  
>  	switch (sysreg) {
> +	case SYS_ICC_IAR1_EL1:
> +		fn = __vgic_v3_read_iar;
> +		break;
>  	case SYS_ICC_GRPEN1_EL1:
>  		if (is_read)
>  			fn = __vgic_v3_read_igrpen1;
> 
