From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 4/5] KVM: arm64: vgic: Get rid of struct vmcr for GICv3
Date: Tue, 21 Mar 2017 14:17:51 +0000
Message-ID: <fb3c89aa-7d74-9043-3185-f7c7845ddac5@arm.com>
References: <20170321110530.15857-1-cdall@linaro.org>
 <20170321110530.15857-5-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170321110530.15857-5-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Vijaya.Kumar@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

On 21/03/17 11:05, Christoffer Dall wrote:
> There is no common code in the VGIC that uses the VMCR, so we have no
> use of the intermediate architecture-agnostic representation of the VMCR
> and might as well manipulate the bits specifically using the logic for
> the version of the GIC that the code supports.
> 
> For GICv3, this means translating between the ICH_VMCR register format
> stored in memory and the ICC_X_EL1 registers exported to user space.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  arch/arm64/kvm/vgic-sys-reg-v3.c | 133 +++++++++++++++------------------------
>  virt/kvm/arm/vgic/vgic-mmio.c    |   4 +-
>  virt/kvm/arm/vgic/vgic-v3.c      |  38 -----------
>  virt/kvm/arm/vgic/vgic.h         |   2 -
>  4 files changed, 53 insertions(+), 124 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
> index 33f111c..cd51433 100644
> --- a/arch/arm64/kvm/vgic-sys-reg-v3.c
> +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
> @@ -21,10 +21,9 @@
>  static bool write_gic_ctlr(struct kvm_vcpu *vcpu, u32 val)
>  {
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	u32 *vmcr = &vgic_cpu->vgic_v3.vgic_vmcr;
>  	u32 host_pri_bits, host_id_bits, host_seis, host_a3v, seis, a3v;
> -	struct vgic_vmcr vmcr;
> -
> -	vgic_get_vmcr(vcpu, &vmcr);
> +	u32 cbpr, eoimode;
>  
>  	/*
>  	 * Disallow restoring VM state if not supported by this
> @@ -57,24 +56,26 @@ static bool write_gic_ctlr(struct kvm_vcpu *vcpu, u32 val)
>  	if (host_a3v != a3v)
>  		return false;
>  
> -	/*
> -	 * Here set VMCR.CTLR in ICC_CTLR_EL1 layout.
> -	 * The vgic_set_vmcr() will convert to ICH_VMCR layout.
> -	 */
> -	vmcr.ctlr = val & ICC_CTLR_EL1_CBPR_MASK;
> -	vmcr.ctlr |= val & ICC_CTLR_EL1_EOImode_MASK;
> +	/* Mask off any immutable bits from the ICC_CTLR_EL1 layout. */
> +	eoimode = val & ICC_CTLR_EL1_EOImode_MASK;
> +	cbpr = val & ICC_CTLR_EL1_CBPR_MASK;
>  
> -	vgic_set_vmcr(vcpu, &vmcr);
> +	/* Convert the remaining bits to ICH_VMCR layout. */
> +	*vmcr &= ~(ICH_VMCR_EOIM_MASK | ICH_VMCR_CBPR_MASK);
> +	*vmcr |= (eoimode >> ICC_CTLR_EL1_EOImode_SHIFT) <<
> +		ICH_VMCR_EOIM_SHIFT;
> +	*vmcr |= (cbpr >> ICC_CTLR_EL1_CBPR_SHIFT) <<
> +		ICH_VMCR_CBPR_SHIFT;
> +
> +	*vmcr = val;

Something is wrong here. You can't possibly want to carefully clear and
insert bits, only to corrupt the whole thing later. Rework leftover?

>  	return true;
>  }
>  
>  static u32 read_gic_ctlr(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	u32 vmcr = vgic_cpu->vgic_v3.vgic_vmcr;
>  	u32 val = 0;
> -	struct vgic_vmcr vmcr;
> -
> -	vgic_get_vmcr(vcpu, &vmcr);
>  
>  	val |= (vgic_cpu->num_pri_bits - 1) <<
>  		ICC_CTLR_EL1_PRI_BITS_SHIFT;
> @@ -85,12 +86,12 @@ static u32 read_gic_ctlr(struct kvm_vcpu *vcpu)
>  	val |= ((kvm_vgic_global_state.ich_vtr_el2 &
>  		ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT) <<
>  		ICC_CTLR_EL1_A3V_SHIFT;
> -	/*
> -	 * The VMCR.CTLR value is in ICC_CTLR_EL1 layout.
> -	 * Extract it directly using ICC_CTLR_EL1 reg definitions.
> -	 */
> -	val |= vmcr.ctlr & ICC_CTLR_EL1_CBPR_MASK;
> -	val |= vmcr.ctlr & ICC_CTLR_EL1_EOImode_MASK;
> +
> +	/* Convert the data in the ICH_VMCR_EL1 to the ICC_CTLR_EL1 layout */
> +	val |= ((vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT) <<
> +		ICC_CTLR_EL1_EOImode_SHIFT;
> +	val |= ((vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT) <<
> +		ICC_CTLR_EL1_CBPR_SHIFT;
>  
>  	return val;
>  }
> @@ -108,99 +109,67 @@ static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	return ret;
>  }
>  
> -static bool access_gic_pmr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> -			   const struct sys_reg_desc *r)
> +static void access_vmcr_field(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			      u32 ich_mask, u32 ich_shift, u32 icc_shift)
>  {
> -	struct vgic_vmcr vmcr;
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	u32 *vmcr = &vgic_cpu->vgic_v3.vgic_vmcr;
>  
> -	vgic_get_vmcr(vcpu, &vmcr);
>  	if (p->is_write) {
> -		vmcr.pmr = (p->regval & ICC_PMR_EL1_MASK) >> ICC_PMR_EL1_SHIFT;
> -		vgic_set_vmcr(vcpu, &vmcr);
> +		*vmcr &= ~ich_mask;
> +		*vmcr |= ((p->regval >> icc_shift) << ich_shift) & ich_mask;
>  	} else {
> -		p->regval = (vmcr.pmr << ICC_PMR_EL1_SHIFT) & ICC_PMR_EL1_MASK;
> +		p->regval = ((*vmcr & ich_mask) >> ich_shift) << icc_shift;
>  	}
> +}
>  
> +static bool access_gic_pmr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			   const struct sys_reg_desc *r)
> +{
> +	access_vmcr_field(vcpu, p,
> +			  ICH_VMCR_PMR_MASK,
> +			  ICH_VMCR_PMR_SHIFT,
> +			  ICC_PMR_EL1_SHIFT);
>  	return true;
>  }
>  
>  static bool access_gic_bpr0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			    const struct sys_reg_desc *r)
>  {
> -	struct vgic_vmcr vmcr;
> -
> -	vgic_get_vmcr(vcpu, &vmcr);
> -	if (p->is_write) {
> -		vmcr.bpr = (p->regval & ICC_BPR0_EL1_MASK) >>
> -			    ICC_BPR0_EL1_SHIFT;
> -		vgic_set_vmcr(vcpu, &vmcr);
> -	} else {
> -		p->regval = (vmcr.bpr << ICC_BPR0_EL1_SHIFT) &
> -			     ICC_BPR0_EL1_MASK;
> -	}
> -
> +	access_vmcr_field(vcpu, p,
> +			  ICH_VMCR_BPR0_MASK,
> +			  ICH_VMCR_BPR0_SHIFT,
> +			  ICC_BPR0_EL1_SHIFT);
>  	return true;
>  }
>  
>  static bool access_gic_bpr1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			    const struct sys_reg_desc *r)
>  {
> -	struct vgic_vmcr vmcr;
> -
> -	if (!p->is_write)
> -		p->regval = 0;
> -
> -	vgic_get_vmcr(vcpu, &vmcr);
> -	if (!((vmcr.ctlr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT)) {
> -		if (p->is_write) {
> -			vmcr.abpr = (p->regval & ICC_BPR1_EL1_MASK) >>
> -				     ICC_BPR1_EL1_SHIFT;
> -			vgic_set_vmcr(vcpu, &vmcr);
> -		} else {
> -			p->regval = (vmcr.abpr << ICC_BPR1_EL1_SHIFT) &
> -				     ICC_BPR1_EL1_MASK;
> -		}
> -	} else {
> -		if (!p->is_write)
> -			p->regval = min((vmcr.bpr + 1), 7U);
> -	}
> -
> +	access_vmcr_field(vcpu, p,
> +			  ICH_VMCR_BPR1_MASK,
> +			  ICH_VMCR_BPR1_SHIFT,
> +			  ICC_BPR1_EL1_SHIFT);

Aren't we loosing some of the existing semantics of reading BPR1 when
CBPR is set?

>  	return true;
>  }
>  
>  static bool access_gic_grpen0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			      const struct sys_reg_desc *r)
>  {
> -	struct vgic_vmcr vmcr;
> -
> -	vgic_get_vmcr(vcpu, &vmcr);
> -	if (p->is_write) {
> -		vmcr.grpen0 = (p->regval & ICC_IGRPEN0_EL1_MASK) >>
> -			       ICC_IGRPEN0_EL1_SHIFT;
> -		vgic_set_vmcr(vcpu, &vmcr);
> -	} else {
> -		p->regval = (vmcr.grpen0 << ICC_IGRPEN0_EL1_SHIFT) &
> -			     ICC_IGRPEN0_EL1_MASK;
> -	}
> -
> +	access_vmcr_field(vcpu, p,
> +			  ICH_VMCR_ENG0_MASK,
> +			  ICH_VMCR_ENG0_SHIFT,
> +			  ICC_IGRPEN0_EL1_SHIFT);
>  	return true;
>  }
>  
>  static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			      const struct sys_reg_desc *r)
>  {
> -	struct vgic_vmcr vmcr;
> -
> -	vgic_get_vmcr(vcpu, &vmcr);
> -	if (p->is_write) {
> -		vmcr.grpen1 = (p->regval & ICC_IGRPEN1_EL1_MASK) >>
> -			       ICC_IGRPEN1_EL1_SHIFT;
> -		vgic_set_vmcr(vcpu, &vmcr);
> -	} else {
> -		p->regval = (vmcr.grpen1 << ICC_IGRPEN1_EL1_SHIFT) &
> -			     ICC_IGRPEN1_EL1_MASK;
> -	}
> -
> +	access_vmcr_field(vcpu, p,
> +			  ICH_VMCR_ENG1_MASK,
> +			  ICH_VMCR_ENG1_SHIFT,
> +			  ICC_IGRPEN1_EL1_SHIFT);
>  	return true;
>  }
>  
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 3654b4c..b53c66e 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -444,7 +444,7 @@ void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
>  	if (kvm_vgic_global_state.type == VGIC_V2)
>  		vgic_v2_set_vmcr(vcpu, vmcr);
>  	else
> -		vgic_v3_set_vmcr(vcpu, vmcr);
> +		BUG();
>  }
>  
>  void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
> @@ -452,7 +452,7 @@ void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
>  	if (kvm_vgic_global_state.type == VGIC_V2)
>  		vgic_v2_get_vmcr(vcpu, vmcr);
>  	else
> -		vgic_v3_get_vmcr(vcpu, vmcr);
> +		BUG();
>  }
>  
>  /*
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index edc6ee2..4697f5d 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -171,44 +171,6 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
>  	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr] = 0;
>  }
>  
> -void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> -{
> -	u32 vmcr;
> -
> -	/*
> -	 * Ignore the FIQen bit, because GIC emulation always implies
> -	 * SRE=1 which means the vFIQEn bit is also RES1.
> -	 */
> -	vmcr = ((vmcrp->ctlr >> ICC_CTLR_EL1_EOImode_SHIFT) <<
> -		 ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
> -	vmcr |= (vmcrp->ctlr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
> -	vmcr |= (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
> -	vmcr |= (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
> -	vmcr |= (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
> -	vmcr |= (vmcrp->grpen0 << ICH_VMCR_ENG0_SHIFT) & ICH_VMCR_ENG0_MASK;
> -	vmcr |= (vmcrp->grpen1 << ICH_VMCR_ENG1_SHIFT) & ICH_VMCR_ENG1_MASK;
> -
> -	vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr = vmcr;
> -}
> -
> -void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> -{
> -	u32 vmcr = vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr;
> -
> -	/*
> -	 * Ignore the FIQen bit, because GIC emulation always implies
> -	 * SRE=1 which means the vFIQEn bit is also RES1.
> -	 */
> -	vmcrp->ctlr = ((vmcr >> ICH_VMCR_EOIM_SHIFT) <<
> -			ICC_CTLR_EL1_EOImode_SHIFT) & ICC_CTLR_EL1_EOImode_MASK;
> -	vmcrp->ctlr |= (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
> -	vmcrp->abpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
> -	vmcrp->bpr  = (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
> -	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
> -	vmcrp->grpen0 = (vmcr & ICH_VMCR_ENG0_MASK) >> ICH_VMCR_ENG0_SHIFT;
> -	vmcrp->grpen1 = (vmcr & ICH_VMCR_ENG1_MASK) >> ICH_VMCR_ENG1_SHIFT;
> -}
> -
>  #define INITIAL_PENDBASER_VALUE						  \
>  	(GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWb)		| \
>  	GIC_BASER_CACHEABILITY(GICR_PENDBASER, OUTER, SameAsInner)	| \
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index db28f7c..5652983 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -143,8 +143,6 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
>  void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
>  void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
>  void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
> -void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
> -void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  void vgic_v3_enable(struct kvm_vcpu *vcpu);
>  int vgic_v3_probe(const struct gic_kvm_info *info);
>  int vgic_v3_map_resources(struct kvm *kvm);
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
