From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 7/8] arm/arm64: KVM: Rework the arch timer to use
 level-triggered semantics
Date: Mon, 14 Sep 2015 16:51:35 +0100
Message-ID: <55F6ED07.6070101@arm.com>
References: <1441395650-19663-1-git-send-email-christoffer.dall@linaro.org>
 <1441395650-19663-8-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E180440FA7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 11:49:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a8QQA6G0E03Y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2015 11:49:24 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FCB940F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 11:49:23 -0400 (EDT)
In-Reply-To: <1441395650-19663-8-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

just one small nit I stumbled upon:

On 04/09/15 20:40, Christoffer Dall wrote:
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 9ed8d53..f4ea950 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1422,34 +1422,43 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>  /*
>   * Save the physical active state, and reset it to inactive.
>   *
> - * Return 1 if HW interrupt went from active to inactive, and 0 otherwise.
> + * Return true if there's a pending level triggered interrupt line to queue.
>   */
> -static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
> +static bool vgic_sync_hwirq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
>  {
>  	struct irq_phys_map *map;
> +	bool phys_active;
>  	int ret;
>  
>  	if (!(vlr.state & LR_HW))
>  		return 0;

This should read "return false;" now.

Cheers,
Andre.

>  
>  	map = vgic_irq_map_search(vcpu, vlr.irq);
> -	BUG_ON(!map || !map->active);
> +	BUG_ON(!map);
>  
>  	ret = irq_get_irqchip_state(map->irq,
>  				    IRQCHIP_STATE_ACTIVE,
> -				    &map->active);
> +				    &phys_active);
>  
>  	WARN_ON(ret);
>  
> -	if (map->active) {
> +	if (phys_active) {
> +		/*
> +		 * Interrupt still marked as active on the physical
> +		 * distributor, so guest did not EOI it yet.  Reset to
> +		 * non-active so that other VMs can see interrupts from this
> +		 * device.
> +		 */
>  		ret = irq_set_irqchip_state(map->irq,
>  					    IRQCHIP_STATE_ACTIVE,
>  					    false);
>  		WARN_ON(ret);
> -		return 0;
> +		return false;
>  	}
>  
> -	return 1;
> +	/* Mapped edge-triggered interrupts not yet supported. */
> +	WARN_ON(vgic_irq_is_edge(vcpu, vlr.irq));
> +	return process_level_irq(vcpu, lr, vlr);
>  }
>  
>  /* Sync back the VGIC state after a guest run */
