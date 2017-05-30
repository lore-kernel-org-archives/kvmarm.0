From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 14/31] KVM: arm64: vgic-v3: Add ICV_EOIR1_EL1 handler
Date: Tue, 30 May 2017 09:48:31 +0200
Message-ID: <c3baec82-20c6-c948-9cb8-8247802cbff5@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-15-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503104606.19342-15-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc

On 03/05/2017 12:45, Marc Zyngier wrote:
> Add a handler for writing the guest's view of the ICC_EOIR1_EL1
> register. This involves dropping the priority of the interrupt,
> and deactivating it if required (EOImode == 0).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/linux/irqchip/arm-gic-v3.h |   2 +
>  virt/kvm/arm/hyp/vgic-v3-sr.c      | 119 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 121 insertions(+)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 7610ea4e8337..c56d9bc2c904 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -403,6 +403,8 @@
>  
>  #define ICH_HCR_EN			(1 << 0)
>  #define ICH_HCR_UIE			(1 << 1)
> +#define ICH_HCR_EOIcount_SHIFT		27
> +#define ICH_HCR_EOIcount_MASK		(0x1f << ICH_HCR_EOIcount_SHIFT)
>  
>  #define ICH_VMCR_CBPR_SHIFT		4
>  #define ICH_VMCR_CBPR_MASK		(1 << ICH_VMCR_CBPR_SHIFT)
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 49aad1de3ac8..a76351b3ad66 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -425,6 +425,26 @@ static int __hyp_text __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu,
>  	return lr;
>  }
>  
> +static int __hyp_text __vgic_v3_find_active_lr(struct kvm_vcpu *vcpu,
> +					       int intid, u64 *lr_val)
> +{
> +	unsigned int used_lrs = vcpu->arch.vgic_cpu.used_lrs;
> +	int i;
> +
> +	for (i = 0; i < used_lrs; i++) {
> +		u64 val = __gic_v3_get_lr(i);
> +
> +		if ((val & ICH_LR_VIRTUAL_ID_MASK) == intid &&
> +		    (val & ICH_LR_ACTIVE_BIT)) {
I guess it is safe because we don't have yet virtual interrupts directly
mapped to phys IRQs, besides timer one?
> +			*lr_val = val;
> +			return i;
> +		}
> +	}
> +
> +	*lr_val = ICC_IAR1_EL1_SPURIOUS;
> +	return -1;
> +}
> +
>  static int __hyp_text __vgic_v3_get_highest_active_priority(void)
>  {
>  	u8 nr_pre_bits = vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
> @@ -490,6 +510,44 @@ static void __hyp_text __vgic_v3_set_active_priority(u8 pre)
>  	__vgic_v3_write_ap1rn(val | bit, apr);
>  }
>  
> +static int __hyp_text __vgic_v3_clear_highest_active_priority(void)
> +{
> +	u8 nr_pre_bits = vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
> +	u8 nr_aprs = 1 << (nr_pre_bits - 5);
may be worth to introduce a macro to compute the number of APRn regs.
This may be more understandable.
> +	u32 hap = 0;
> +	int i;
> +
> +	for (i = 0; i < nr_aprs; i++) {
> +		u32 ap0, ap1;
> +		int c0, c1;
> +
> +		ap0 = __vgic_v3_read_ap0rn(i);
> +		ap1 = __vgic_v3_read_ap1rn(i);
> +		if (!ap0 && !ap1) {
> +			hap += 32;
> +			continue;
> +		}
> +
> +		c0 = ap0 ? __ffs(ap0) : 32;
> +		c1 = ap1 ? __ffs(ap1) : 32;
> +
> +		/* Always clear the LSB, which is the highest priority */
> +		if (c0 < c1) {
> +			ap0 &= ap0 - 1;
> +			__vgic_v3_write_ap0rn(ap0, i);
> +			hap += c0;
> +		} else {
> +			ap1 &= ap1 - 1;
> +			__vgic_v3_write_ap1rn(ap1, i);
> +			hap += c1;
> +		}
> +
> +		return hap << (8 - nr_pre_bits);
> +	}
> +
> +	return GICv3_IDLE_PRIORITY;
> +}
> +
>  static void __hyp_text __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  {
>  	u64 lr_val;
> @@ -526,6 +584,64 @@ static void __hyp_text __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int r
>  	vcpu_set_reg(vcpu, rt, ICC_IAR1_EL1_SPURIOUS);
>  }
>  
> +static void __hyp_text __vgic_v3_clear_active_lr(int lr, u64 lr_val)
> +{
> +	lr_val &= ~ICH_LR_ACTIVE_BIT;
> +	if (lr_val & ICH_LR_HW) {
> +		u32 pid;
nit: insert a line
> +		pid = (lr_val & ICH_LR_PHYS_ID_MASK) >> ICH_LR_PHYS_ID_SHIFT;
> +		gic_write_dir(pid);
> +	}
> +
> +	__gic_v3_set_lr(lr_val, lr);
> +}
> +
> +static void __hyp_text __vgic_v3_bump_eoicount(void)
> +{
> +	u32 hcr;
> +
> +	hcr = read_gicreg(ICH_HCR_EL2);
> +	hcr += 1 << ICH_HCR_EOIcount_SHIFT;
> +	write_gicreg(hcr, ICH_HCR_EL2);
> +}
> +
> +static void __hyp_text __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> +{
> +	u32 vid = vcpu_get_reg(vcpu, rt);
> +	u64 lr_val;
> +	u8 lr_prio, act_prio;
> +	int lr, grp;
> +
> +	grp = __vgic_v3_get_group(vcpu);
> +
> +	/* Drop priority in any case */
> +	act_prio = __vgic_v3_clear_highest_active_priority();
> +
> +	/* If EOIing an LPI, no deactivate to be performed */
> +	if (vid >= VGIC_MIN_LPI)
> +		return;
> +
> +	/* EOImode == 1, nothing to be done here */
> +	if (vmcr & ICH_VMCR_EOIM_MASK)
> +		return;
> +
> +	lr = __vgic_v3_find_active_lr(vcpu, vid, &lr_val);
> +	if (lr == -1) {
> +		__vgic_v3_bump_eoicount();
> +		return;
> +	}
> +
> +	lr_prio = (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
> +
> +	/* If priorities or group do not match, the guest has fscked-up. */
> +	if (grp != !!(lr_val & ICH_LR_GROUP) ||
> +	    __vgic_v3_pri_to_pre(lr_prio, vmcr, grp) != act_prio)
> +		return;
> +
> +	/* Let's now perform the deactivation */
> +	__vgic_v3_clear_active_lr(lr, lr_val);
> +}
> +
>  static void __hyp_text __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  {
>  	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
> @@ -591,6 +707,9 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	case SYS_ICC_IAR1_EL1:
>  		fn = __vgic_v3_read_iar;
>  		break;
> +	case SYS_ICC_EOIR1_EL1:
> +		fn = __vgic_v3_write_eoir;
> +		break;
>  	case SYS_ICC_GRPEN1_EL1:
>  		if (is_read)
>  			fn = __vgic_v3_read_igrpen1;

Looks good to me

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> 
