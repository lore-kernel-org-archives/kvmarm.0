From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 2/7] KVM: arm/arm64: directly pass virtual IRQ number on
 injecting mapped IRQ
Date: Thu, 21 Apr 2016 19:09:25 +0200
Message-ID: <57190945.3020005@linaro.org>
References: <1460729047-6346-1-git-send-email-andre.przywara@arm.com>
 <1460729047-6346-3-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1460729047-6346-3-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,
On 04/15/2016 04:04 PM, Andre Przywara wrote:
> When we want to inject a hardware mapped IRQ into a guest, we actually
> only need the virtual IRQ number from the irq_phys_map.
> So let's pass this number directly from the arch timer to the VGIC
> to avoid using the map as a parameter.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/arm_vgic.h    | 2 +-
>  virt/kvm/arm/arch_timer.c | 2 +-
>  virt/kvm/arm/vgic.c       | 6 +++---
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 281caf8..c4574da 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -341,7 +341,7 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
>  			bool level);
>  int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
> -			       struct irq_phys_map *map, bool level);
> +			       unsigned int virt_irq, bool level);
>  void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>  struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index a9ad4fe..eb56f1e 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -140,7 +140,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
>  	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->map->virt_irq,
>  				   timer->irq.level);
>  	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
> -					 timer->map,
> +					 timer->map->virt_irq,
>  					 timer->irq.level);
>  	WARN_ON(ret);
>  }
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 7282881..9937d41 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1667,7 +1667,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
>   * kvm_vgic_inject_mapped_irq - Inject a physically mapped IRQ to the vgic
>   * @kvm:     The VM structure pointer
>   * @cpuid:   The CPU for PPIs
> - * @map:     Pointer to a irq_phys_map structure describing the mapping
> + * @virt_irq: The virtual IRQ to be injected
>   * @level:   Edge-triggered:  true:  to trigger the interrupt
>   *			      false: to ignore the call
>   *	     Level-sensitive  true:  raise the input signal
> @@ -1678,7 +1678,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
>   * being HIGH and 0 being LOW and all devices being active-HIGH.
>   */
>  int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
> -			       struct irq_phys_map *map, bool level)
> +			       unsigned int virt_irq, bool level)
>  {
Could make sense to merge kvm_vgic_inject_mapped_irq and
kvm_vgic_inject_irq and just add a bool argument telling whether the
request comes from the userspace (if I remember well we wanted to
prevent the userspace from injecting a mapping irq). This would avoid
duplication. We can make it later though.

Reviewed-by: Eric Auger <eric.auger@linaro.org>

Cheers

Eric


>  	int ret;
>  
> @@ -1686,7 +1686,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
>  	if (ret)
>  		return ret;
>  
> -	return vgic_update_irq_pending(kvm, cpuid, map->virt_irq, level);
> +	return vgic_update_irq_pending(kvm, cpuid, virt_irq, level);
>  }
>  
>  static irqreturn_t vgic_maintenance_handler(int irq, void *data)
> 

