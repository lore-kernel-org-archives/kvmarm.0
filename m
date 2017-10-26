From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 21/26] KVM: arm/arm64: GICv4: Hook vPE scheduling into
 vgic flush/sync
Date: Thu, 26 Oct 2017 17:24:45 +0200
Message-ID: <20171026152445.GB2166@lvm>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
 <20171006153401.5481-22-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171006153401.5481-22-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 06, 2017 at 04:33:56PM +0100, Marc Zyngier wrote:
> The redistributor needs to be told which vPE is about to be run,
> and tells us whether there is any pending VLPI on exit.
> 
> Let's add the scheduling calls to the vgic flush/sync functions,
> allowing the VLPIs to be delivered to the guest.
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-v4.c | 39 +++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.c    |  4 ++++
>  virt/kvm/arm/vgic/vgic.h    |  2 ++
>  3 files changed, 45 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index 5ee69aec990a..68a2ef6df161 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -130,6 +130,45 @@ void vgic_v4_teardown(struct kvm *kvm)
>  	its_vm->vpes = NULL;
>  }
>  
> +int vgic_v4_sync_hwstate(struct kvm_vcpu *vcpu)
> +{
> +	if (!vgic_supports_direct_msis(vcpu->kvm))
> +		return 0;
> +
> +	return its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, false);
> +}
> +
> +int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu)
> +{
> +	int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
> +	int err;
> +
> +	if (!vgic_supports_direct_msis(vcpu->kvm))
> +		return 0;
> +
> +	/*
> +	 * Before making the VPE resident, make sure the redistributor
> +	 * corresponding to our current CPU expects us here. See the
> +	 * doc in drivers/irqchip/irq-gic-v4.c to understand how this
> +	 * turns into a VMOVP command at the ITS level.
> +	 */
> +	err = irq_set_affinity(irq, cpumask_of(smp_processor_id()));
> +	if (err)
> +		return err;
> +
> +	err = its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, true);
> +	if (err)
> +		return err;
> +
> +	/*
> +	 * Now that the VPE is resident, let's get rid of a potential
> +	 * doorbell interrupt that would still be pending.
> +	 */
> +	err = irq_set_irqchip_state(irq, IRQCHIP_STATE_PENDING, false);
> +
> +	return err;
> +}
> +
>  static struct vgic_its *vgic_get_its(struct kvm *kvm,
>  				     struct kvm_kernel_irq_routing_entry *irq_entry)
>  {
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 0691a2250949..71ca0ff1b35a 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -709,6 +709,8 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  
> +	WARN_ON(vgic_v4_sync_hwstate(vcpu));
> +
>  	/* An empty ap_list_head implies used_lrs == 0 */
>  	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
>  		return;
> @@ -721,6 +723,8 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  /* Flush our emulation state into the GIC hardware before entering the guest. */
>  void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  {
> +	WARN_ON(vgic_v4_flush_hwstate(vcpu));
> +
>  	/*
>  	 * If there are no virtual interrupts active or pending for this
>  	 * VCPU, then there is no work to do and we can bail out without
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 1bd2e28ac097..1c65750892d7 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -245,5 +245,7 @@ int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>  bool vgic_supports_direct_msis(struct kvm *kvm);
>  int vgic_v4_init(struct kvm *kvm);
>  void vgic_v4_teardown(struct kvm *kvm);
> +int vgic_v4_sync_hwstate(struct kvm_vcpu *vcpu);
> +int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu);
>  
>  #endif
> -- 
> 2.14.1
> 
