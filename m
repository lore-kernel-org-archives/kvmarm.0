From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 3/7] KVM: arm/arm64: directly pass virtual IRQ number on
 kvm_vgic_map_is_active()
Date: Thu, 21 Apr 2016 19:09:32 +0200
Message-ID: <5719094C.4080101@linaro.org>
References: <1460729047-6346-1-git-send-email-andre.przywara@arm.com>
 <1460729047-6346-4-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C22D49B45
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2016 13:08:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PfZbivWGqgSg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2016 13:08:45 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82BFA49B51
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2016 13:08:45 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id n3so143857682wmn.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2016 10:10:48 -0700 (PDT)
In-Reply-To: <1460729047-6346-4-git-send-email-andre.przywara@arm.com>
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

Hi Andre,
On 04/15/2016 04:04 PM, Andre Przywara wrote:
> For getting the active state of a mapped IRQ, we actually only need
> the virtual IRQ number, not the pointer to the mapping entry.
> Pass the virtual IRQ number from the arch timer to the VGIC directly.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/arm_vgic.h    | 2 +-
>  virt/kvm/arm/arch_timer.c | 2 +-
>  virt/kvm/arm/vgic.c       | 6 +++---
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index c4574da..5a34adc 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -347,7 +347,7 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>  struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>  					   int virt_irq, int irq);
>  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
> -bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
> +bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>  
>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
>  #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index eb56f1e..793465b 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -246,7 +246,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>  	* to ensure that hardware interrupts from the timer triggers a guest
>  	* exit.
>  	*/
> -	if (timer->irq.level || kvm_vgic_map_is_active(vcpu, timer->map))
> +	if (timer->irq.level || kvm_vgic_map_is_active(vcpu, timer->map->virt_irq))
>  		phys_active = true;
>  	else
>  		phys_active = false;
nit:
phys_active =
	(timer->irq.level ||
		kvm_vgic_map_is_active(vcpu, timer->map->virt_irq)); ?

checkpatch warning:

#40: FILE: virt/kvm/arm/arch_timer.c:278:
+	if (timer->irq.level || kvm_vgic_map_is_active(vcpu,
timer->map->virt_irq))

Besides
Reviewed-by: Eric Auger <eric.auger@linaro.org>

Cheers

Eric
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 9937d41..6911327 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1103,18 +1103,18 @@ static bool dist_active_irq(struct kvm_vcpu *vcpu)
>  	return test_bit(vcpu->vcpu_id, dist->irq_active_on_cpu);
>  }
>  
> -bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
> +bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
>  {
>  	int i;
>  
>  	for (i = 0; i < vcpu->arch.vgic_cpu.nr_lr; i++) {
>  		struct vgic_lr vlr = vgic_get_lr(vcpu, i);
>  
> -		if (vlr.irq == map->virt_irq && vlr.state & LR_STATE_ACTIVE)
> +		if (vlr.irq == virt_irq && vlr.state & LR_STATE_ACTIVE)
>  			return true;
>  	}
>  
> -	return vgic_irq_is_active(vcpu, map->virt_irq);
> +	return vgic_irq_is_active(vcpu, virt_irq);
>  }
>  
>  /*
> 
