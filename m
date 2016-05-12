From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 46/55] KVM: arm/arm64: vgic-new: Add GICH_VMCR
 accessors
Date: Thu, 12 May 2016 20:43:16 +0200
Message-ID: <20160512184316.GL27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-47-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462531568-9799-47-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 06, 2016 at 11:45:59AM +0100, Andre Przywara wrote:
> Since the GIC CPU interface is always virtualized by the hardware,
> we don't have CPU interface state information readily available in our
> emulation if userland wants to save or restore it.
> Fortunately the GIC hypervisor interface provides the VMCR register to
> access the required virtual CPU interface bits.
> Provide wrappers for GICv2 and GICv3 hosts to have access to this
> register.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog v2 .. v3:
> - remove exported v2/v3 selector functions (as per Marc's patch)
> 
>  include/kvm/vgic/vgic.h     |  7 +++++++
>  virt/kvm/arm/vgic/vgic-v2.c | 29 +++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v3.c | 22 ++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h    | 14 ++++++++++++++
>  4 files changed, 72 insertions(+)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 73cab36..cfc3640 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -171,6 +171,13 @@ struct vgic_v3_cpu_if {
>  #endif
>  };
>  
> +struct vgic_vmcr {
> +	u32	ctlr;
> +	u32	abpr;
> +	u32	bpr;
> +	u32	pmr;
> +};
> +

is this going to be used outside the vgic code?

otherwise it could go in virt/kvm/arm/vgic/vgic.h instead?

>  struct vgic_cpu {
>  	/* CPU vif control registers for world switch */
>  	union {
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index 4cee616..70cac63 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -176,3 +176,32 @@ void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr)
>  {
>  	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = 0;
>  }
> +
> +void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> +{
> +	u32 vmcr;
> +
> +	vmcr  = (vmcrp->ctlr << GICH_VMCR_CTRL_SHIFT) & GICH_VMCR_CTRL_MASK;
> +	vmcr |= (vmcrp->abpr << GICH_VMCR_ALIAS_BINPOINT_SHIFT) &
> +		GICH_VMCR_ALIAS_BINPOINT_MASK;
> +	vmcr |= (vmcrp->bpr << GICH_VMCR_BINPOINT_SHIFT) &
> +		GICH_VMCR_BINPOINT_MASK;
> +	vmcr |= (vmcrp->pmr << GICH_VMCR_PRIMASK_SHIFT) &
> +		GICH_VMCR_PRIMASK_MASK;
> +
> +	vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr = vmcr;
> +}
> +
> +void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> +{
> +	u32 vmcr = vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr;
> +
> +	vmcrp->ctlr = (vmcr & GICH_VMCR_CTRL_MASK) >>
> +			GICH_VMCR_CTRL_SHIFT;
> +	vmcrp->abpr = (vmcr & GICH_VMCR_ALIAS_BINPOINT_MASK) >>
> +			GICH_VMCR_ALIAS_BINPOINT_SHIFT;
> +	vmcrp->bpr  = (vmcr & GICH_VMCR_BINPOINT_MASK) >>
> +			GICH_VMCR_BINPOINT_SHIFT;
> +	vmcrp->pmr  = (vmcr & GICH_VMCR_PRIMASK_MASK) >>
> +			GICH_VMCR_PRIMASK_SHIFT;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 43d1dd7..dca52b3 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -166,3 +166,25 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
>  {
>  	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr] = 0;
>  }
> +
> +void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> +{
> +	u32 vmcr;
> +
> +	vmcr  = (vmcrp->ctlr << ICH_VMCR_CTLR_SHIFT) & ICH_VMCR_CTLR_MASK;
> +	vmcr |= (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
> +	vmcr |= (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
> +	vmcr |= (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
> +
> +	vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr = vmcr;
> +}
> +
> +void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> +{
> +	u32 vmcr = vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr;
> +
> +	vmcrp->ctlr = (vmcr & ICH_VMCR_CTLR_MASK) >> ICH_VMCR_CTLR_SHIFT;
> +	vmcrp->abpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
> +	vmcrp->bpr  = (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
> +	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index bc5750e..5260d23 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -39,6 +39,8 @@ void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
>  int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
>  int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 int offset, u32 *val);
> +void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
> +void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
>  			     enum vgic_type);
>  
> @@ -48,6 +50,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
>  void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
>  void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
>  void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
> +void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
> +void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
>  #else
>  static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
> @@ -71,6 +75,16 @@ static inline void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
>  {
>  }
>  
> +static inline
> +void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
> +{
> +}
> +
> +static inline
> +void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
> +{
> +}
> +
>  static inline int vgic_register_redist_iodevs(struct kvm *kvm,
>  					      gpa_t dist_base_address)
>  {
> -- 
> 2.7.3
> 
