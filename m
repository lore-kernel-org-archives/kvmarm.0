From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3 06/55] KVM: arm/arm64: arch_timer: Remove irq_phys_map
Date: Tue, 10 May 2016 10:33:40 +0200
Message-ID: <57319CE4.30608@linaro.org>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-7-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462531568-9799-7-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,
On 05/06/2016 12:45 PM, Andre Przywara wrote:
> Now that the interface between the arch timer and the VGIC does not
> require passing the irq_phys_map entry pointer anymore, let's remove
> it from the virtual arch timer and use the virtual IRQ number instead
> directly.
> The remaining pointer returned by kvm_vgic_map_phys_irq() will be
> removed in the following patch.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog v1 .. v2:
> - remove extra virt_irq member from struct, instead use irq.irq directly
> 
> Changelog v2 .. v3:
> - remove bogus validity check from kvm_vgic_unmap_phys_irq()
> 
>  include/kvm/arm_arch_timer.h |  3 ---
>  virt/kvm/arm/arch_timer.c    | 10 ++++------
>  2 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index b651aed..a47b7de 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -53,9 +53,6 @@ struct arch_timer_cpu {
>  	/* Timer IRQ */
>  	struct kvm_irq_level		irq;
>  
> -	/* VGIC mapping */
> -	struct irq_phys_map		*map;
> -
>  	/* Active IRQ state caching */
>  	bool				active_cleared_last;
>  };
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 29d597d..f2cd188 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -176,10 +176,10 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
>  
>  	timer->active_cleared_last = false;
>  	timer->irq.level = new_level;
> -	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->map->virt_irq,
> +	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
>  				   timer->irq.level);
>  	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
> -					 timer->map->virt_irq,
> +					 timer->irq.irq,
>  					 timer->irq.level);
>  	WARN_ON(ret);
>  }
> @@ -277,7 +277,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>  	* exit.
>  	*/
>  	phys_active = timer->irq.level ||
> -			kvm_vgic_map_is_active(vcpu, timer->map->virt_irq);
> +			kvm_vgic_map_is_active(vcpu, timer->irq.irq);
>  
>  	/*
>  	 * We want to avoid hitting the (re)distributor as much as
> @@ -379,7 +379,6 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>  	if (WARN_ON(IS_ERR(map)))
>  		return PTR_ERR(map);
>  
> -	timer->map = map;
>  	return 0;
>  }
>  
> @@ -522,8 +521,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  
>  	timer_disarm(timer);
> -	if (timer->map)
> -		kvm_vgic_unmap_phys_irq(vcpu, timer->map->virt_irq);
> +	kvm_vgic_unmap_phys_irq(vcpu, timer->irq.irq);
Reviewed-by: Eric Auger <eric.auger@linaro.org>

Eric
>  }
>  
>  void kvm_timer_enable(struct kvm *kvm)
> 

