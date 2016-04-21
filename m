From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 6/7] KVM: arm/arm64: remove irq_phys_map from the arch
 timer
Date: Thu, 21 Apr 2016 19:56:03 +0200
Message-ID: <57191433.40508@linaro.org>
References: <1460729047-6346-1-git-send-email-andre.przywara@arm.com>
 <1460729047-6346-7-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AD9A49B55
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2016 13:55:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wZ9dHJHhMx5G for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2016 13:55:17 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EF5349B53
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2016 13:55:16 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id u206so144984718wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2016 10:57:19 -0700 (PDT)
In-Reply-To: <1460729047-6346-7-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/15/2016 04:04 PM, Andre Przywara wrote:
> Now that the interface between the arch timer and the VGIC does not
> require passing the irq_phys_map entry pointer anymore, let's remove
> it from the virtual arch timer and use the virtual IRQ number instead
> directly.
> The remaining pointer returned by kvm_vgic_map_phys_irq() will be
> removed in the following patch.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/arm_arch_timer.h |  4 ++--
>  virt/kvm/arm/arch_timer.c    | 12 ++++++------
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index b651aed..1ed70f6 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -53,8 +53,8 @@ struct arch_timer_cpu {
>  	/* Timer IRQ */
>  	struct kvm_irq_level		irq;
>  
> -	/* VGIC mapping */
> -	struct irq_phys_map		*map;
> +	/* The virtual IRQ number */
> +	unsigned int			virt_irq;
what's the difference between irq.irq and virt_irq? aren't they duplicates?
>  
>  	/* Active IRQ state caching */
>  	bool				active_cleared_last;
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index cfdf88f..1598e23 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -137,10 +137,10 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
>  
>  	timer->active_cleared_last = false;
>  	timer->irq.level = new_level;
> -	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->map->virt_irq,
> +	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->virt_irq,
>  				   timer->irq.level);
>  	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
> -					 timer->map->virt_irq,
> +					 timer->virt_irq,
>  					 timer->irq.level);
>  	WARN_ON(ret);
>  }
> @@ -246,7 +246,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>  	* to ensure that hardware interrupts from the timer triggers a guest
>  	* exit.
>  	*/
> -	if (timer->irq.level || kvm_vgic_map_is_active(vcpu, timer->map->virt_irq))
> +	if (timer->irq.level || kvm_vgic_map_is_active(vcpu, timer->virt_irq))
>  		phys_active = true;
>  	else
>  		phys_active = false;
> @@ -351,7 +351,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>  	if (WARN_ON(IS_ERR(map)))
>  		return PTR_ERR(map);
>  
> -	timer->map = map;
> +	timer->virt_irq = irq->irq;
you also have a duplicate above:
        timer->irq.irq = irq->irq;
>  	return 0;
>  }
>  
> @@ -494,8 +494,8 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  
>  	timer_disarm(timer);
> -	if (timer->map)
> -		kvm_vgic_unmap_phys_irq(vcpu, timer->map->virt_irq);
> +	if (timer->virt_irq)
> +		kvm_vgic_unmap_phys_irq(vcpu, timer->virt_irq);
always unmap?

Cheers

Eric
>  }
>  
>  void kvm_timer_enable(struct kvm *kvm)
> 
