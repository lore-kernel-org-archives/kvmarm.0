From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 3/3] KVM: arm64: Implement accessors for vGIC CPU
 interface registers
Date: Sun, 30 Aug 2015 18:50:15 +0200
Message-ID: <20150830165015.GE24113@cbox>
References: <cover.1440766141.git.p.fedin@samsung.com>
 <2857f7cad7c17109dfa3028f79af28893c0171ce.1440766141.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2857f7cad7c17109dfa3028f79af28893c0171ce.1440766141.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Aug 28, 2015 at 03:56:12PM +0300, Pavel Fedin wrote:
> This commit adds accessors for all registers, being part of saved vGIC
> context in the form of ICH_VMCR_EL2. This is necessary for enabling vGICv3
> live migration.
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  arch/arm64/kvm/sys_regs.c          | 176 +++++++++++++++++++++++++++++++++++++
>  include/linux/irqchip/arm-gic-v3.h |  18 +++-
>  2 files changed, 192 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 8cc4a5e..7a4f982 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -23,6 +23,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/mm.h>
>  #include <linux/uaccess.h>
> +#include <linux/irqchip/arm-gic-v3.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/cputype.h>
> @@ -136,6 +137,162 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool access_gic_ctlr(struct kvm_vcpu *vcpu,
> +			    const struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	u64 val;
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	if (vcpu->kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
> +		return false;
> +
> +	if (p->is_write) {
> +		val = *vcpu_reg(vcpu, p->Rt);
> +
> +		vgicv3->vgic_vmcr &= ~(ICH_VMCR_CBPR|ICH_VMCR_EOIM);
> +		vgicv3->vgic_vmcr |= (val << (ICH_VMCR_CBPR_SHIFT -
> +						ICC_CTLR_EL1_CBPR_SHIFT)) &
> +					ICH_VMCR_CBPR;
> +		vgicv3->vgic_vmcr |= (val << (ICH_VMCR_EOIM_SHIFT -
> +						ICC_CTLR_EL1_EOImode_SHIFT)) &
> +					ICH_VMCR_EOIM;
> +	} else {
> +		asm volatile("mrs_s %0," __stringify(ICC_IAR1_EL1)
> +			     : "=r" (val));
> +		val &= (ICC_CTLR_EL1_A3V | ICC_CTLR_EL1_SEIS |
> +			ICC_CTLR_EL1_IDbits_MASK | ICC_CTLR_EL1_PRIbits_MASK);
> +		val |= (vgicv3->vgic_vmcr & ICH_VMCR_CBPR) >>
> +			(ICH_VMCR_CBPR_SHIFT - ICC_CTLR_EL1_CBPR_SHIFT);
> +		val |= (vgicv3->vgic_vmcr & ICH_VMCR_EOIM) >>
> +			(ICH_VMCR_EOIM_SHIFT - ICC_CTLR_EL1_EOImode_SHIFT);
> +
> +		*vcpu_reg(vcpu, p->Rt) = val;
> +	}
> +
> +	return true;
> +}
> +
> +static bool access_gic_pmr(struct kvm_vcpu *vcpu,
> +			   const struct sys_reg_params *p,
> +			   const struct sys_reg_desc *r)
> +{
> +	u64 val;
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	if (vcpu->kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
> +		return false;
> +
> +	if (p->is_write) {
> +		val = *vcpu_reg(vcpu, p->Rt);
> +		vgicv3->vgic_vmcr &= ~ICH_VMCR_PMR_MASK;
> +		vgicv3->vgic_vmcr |= (val << ICH_VMCR_PMR_SHIFT) &
> +					ICH_VMCR_PMR_MASK;
> +	} else {
> +		val = (vgicv3->vgic_vmcr & ICH_VMCR_PMR_MASK) >>
> +			ICH_VMCR_PMR_SHIFT;
> +		*vcpu_reg(vcpu, p->Rt) = val;
> +	}
> +
> +	return true;
> +}
> +
> +static bool access_gic_bpr0(struct kvm_vcpu *vcpu,
> +			    const struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	u64 val;
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	if (vcpu->kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
> +		return false;
> +
> +	if (p->is_write) {
> +		val = *vcpu_reg(vcpu, p->Rt);
> +		vgicv3->vgic_vmcr &= ~ICH_VMCR_BPR0_MASK;
> +		vgicv3->vgic_vmcr |= (val << ICH_VMCR_BPR0_SHIFT) &
> +					ICH_VMCR_BPR0_MASK;
> +	} else {
> +		val = (vgicv3->vgic_vmcr & ICH_VMCR_BPR0_MASK) >>
> +			ICH_VMCR_BPR0_SHIFT;
> +		*vcpu_reg(vcpu, p->Rt) = val;
> +	}
> +
> +	return true;
> +}
> +
> +static bool access_gic_bpr1(struct kvm_vcpu *vcpu,
> +			    const struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	u64 val;
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	if (vcpu->kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
> +		return false;
> +
> +	if (p->is_write) {
> +		val = *vcpu_reg(vcpu, p->Rt);
> +		vgicv3->vgic_vmcr &= ~ICH_VMCR_BPR1_MASK;
> +		vgicv3->vgic_vmcr |= (val << ICH_VMCR_BPR1_SHIFT) &
> +					ICH_VMCR_BPR1_MASK;
> +	} else {
> +		val = (vgicv3->vgic_vmcr & ICH_VMCR_BPR1_MASK) >>
> +			ICH_VMCR_BPR1_SHIFT;
> +		*vcpu_reg(vcpu, p->Rt) = val;
> +	}
> +
> +	return true;
> +}
> +
> +static bool access_gic_grpen0(struct kvm_vcpu *vcpu,
> +			      const struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
> +{
> +	u64 val;
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	if (vcpu->kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
> +		return false;
> +
> +	if (p->is_write) {
> +		val = *vcpu_reg(vcpu, p->Rt);
> +		vgicv3->vgic_vmcr &= ~ICH_VMCR_ENG0;
> +		vgicv3->vgic_vmcr |= (val << ICH_VMCR_ENG0_SHIFT) &
> +					ICH_VMCR_ENG0;
> +	} else {
> +		val = (vgicv3->vgic_vmcr & ICH_VMCR_ENG0) >>
> +			ICH_VMCR_ENG0_SHIFT;
> +		*vcpu_reg(vcpu, p->Rt) = val;
> +	}
> +
> +	return true;
> +}
> +
> +static bool access_gic_grpen1(struct kvm_vcpu *vcpu,
> +			      const struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
> +{
> +	u64 val;
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	if (vcpu->kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
> +		return false;
> +
> +	if (p->is_write) {
> +		val = *vcpu_reg(vcpu, p->Rt);
> +		vgicv3->vgic_vmcr &= ~ICH_VMCR_ENG1;
> +		vgicv3->vgic_vmcr |= (val << ICH_VMCR_ENG1_SHIFT) &
> +					ICH_VMCR_ENG1;
> +	} else {
> +		val = (vgicv3->vgic_vmcr & ICH_VMCR_ENG1) >>
> +			ICH_VMCR_ENG1_SHIFT;
> +		*vcpu_reg(vcpu, p->Rt) = val;
> +	}
> +
> +	return true;
> +}
> +
>  static bool trap_raz_wi(struct kvm_vcpu *vcpu,
>  			const struct sys_reg_params *p,
>  			const struct sys_reg_desc *r)
> @@ -579,6 +736,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ Op0(0b11), Op1(0b000), CRn(0b0010), CRm(0b0000), Op2(0b010),
>  	  access_vm_reg, reset_val, TCR_EL1, 0 },
>  
> +	/* ICC_PMR_EL1 */
> +	{ Op0(0b11), Op1(0b000), CRn(0b0100), CRm(0b0110), Op2(0b000),
> +	  access_gic_pmr },
> +
>  	/* AFSR0_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b0101), CRm(0b0001), Op2(0b000),
>  	  access_vm_reg, reset_unknown, AFSR0_EL1 },
> @@ -613,12 +774,27 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b0000), Op2(0b000),
>  	  NULL, reset_val, VBAR_EL1, 0 },
>  
> +	/* ICC_BPR0_EL1 */
> +	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1000), Op2(0b011),
> +	  access_gic_bpr0 },
>  	/* ICC_SGI1R_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1011), Op2(0b101),
>  	  access_gic_sgi },
> +	/* ICC_BPR1_EL1 */
> +	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1100), Op2(0b011),
> +	  access_gic_bpr1 },
> +	/* ICC_CTLR_EL1 */
> +	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1100), Op2(0b100),
> +	  access_gic_ctlr },
>  	/* ICC_SRE_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1100), Op2(0b101),
>  	  trap_raz_wi },
> +	/* ICC_IGRPEN0_EL1 */
> +	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1100), Op2(0b110),
> +	  access_gic_grpen0 },
> +	/* ICC_GRPEN1_EL1 */
> +	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b1100), Op2(0b111),
> +	  access_gic_grpen1 },
>  

I had imagined we would encode the GICv3 register accesses through the
device API and not through the system register API, since I'm not crazy
about polluting the general system register handling logic with GIC
registers solely for the purposes of migration.

I'd much rather have this logic locally to the gic files.

Have you thought about proper locking/serializing of access to the GIC
state in these accessor functions?  Seems like this deserves a comment
in the commit log at least and will probably be easier to understand in
the context of the vgic code.

-Christoffer
