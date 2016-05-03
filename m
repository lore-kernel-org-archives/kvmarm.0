From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 05/54] KVM: arm/arm64: Remove the IRQ field from struct
 irq_phys_map
Date: Tue, 3 May 2016 13:15:44 +0100
Message-ID: <57289670.6030405@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-6-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1461861973-26464-6-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 28/04/16 17:45, Andre Przywara wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> The communication of a Linux IRQ number from outside the VGIC to the
> vgic was a leftover from the day when the vgic code cared about how a
> particular device injects virtual interrupts mapped to a physical
> interrupt.
> 
> We can safely remove this notion, leaving all physical IRQ handling to
> be done in the device driver (the arch timer in this case), which makes
> room for a saner API for the new VGIC.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Reviewed-by: Eric Auger <eric.auger@linaro.org>
> ---
> Changelog v1 .. v2:
> - update kerneldoc comments on kvm_vgic_map_phys_irq()
> 
>  include/kvm/arm_vgic.h    |  3 +--
>  virt/kvm/arm/arch_timer.c | 22 ++++++++++++++++++++--
>  virt/kvm/arm/vgic.c       | 28 ++++++----------------------
>  3 files changed, 27 insertions(+), 26 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 43eeb18..49c559e 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -157,7 +157,6 @@ struct vgic_io_device {
>  struct irq_phys_map {
>  	u32			virt_irq;
>  	u32			phys_irq;
> -	u32			irq;
>  };
>  
>  struct irq_phys_map_entry {
> @@ -345,7 +344,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
>  void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>  struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
> -					   int virt_irq, int irq);
> +					   int virt_irq, int phys_irq);
>  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>  bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>  
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 58b2439..b470632 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -301,7 +301,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>  	if (timer->active_cleared_last && !phys_active)
>  		return;
>  
> -	ret = irq_set_irqchip_state(timer->map->irq,
> +	ret = irq_set_irqchip_state(host_vtimer_irq,
>  				    IRQCHIP_STATE_ACTIVE,
>  				    phys_active);
>  	WARN_ON(ret);
> @@ -334,6 +334,9 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  	struct irq_phys_map *map;
> +	struct irq_desc *desc;
> +	struct irq_data *data;
> +	int phys_irq;
>  
>  	/*
>  	 * The vcpu timer irq number cannot be determined in
> @@ -353,10 +356,25 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>  	kvm_timer_update_state(vcpu);
>  
>  	/*
> +	 * Find the physical IRQ number corresponding to the host_vtimer_irq
> +	 */
> +	desc = irq_to_desc(host_vtimer_irq);

Consider adding a #include <linux/irq.h> at the top of this file. Things
do break once the linux/of_irq.h include is removed with the KVM/ACPI
patches.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
