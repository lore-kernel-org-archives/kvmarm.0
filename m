From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 07/10] KVM: arm/arm64: vgic: Allow HW interrupts to be
 queued to a guest
Date: Thu, 11 Jun 2015 09:44:42 +0100
Message-ID: <55794A7A.2080306@arm.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
 <1433783045-8002-8-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E63353C73
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2015 04:34:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h4UFAw6NVW32 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jun 2015 04:34:08 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 764B0539E1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2015 04:34:07 -0400 (EDT)
In-Reply-To: <1433783045-8002-8-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 06/08/2015 06:04 PM, Marc Zyngier wrote:
> To allow a HW interrupt to be injected into a guest, we lookup the
> guest virtual interrupt in the irq_phys_map rbtree, and if we have
> a match, encode both interrupts in the LR.
> 
> We also mark the interrupt as "active" at the host distributor level.
> 
> On guest EOI on the virtual interrupt, the host interrupt will be
> deactivated.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 68 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index c6604f2..495ac7d 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1120,6 +1120,26 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
>  	if (!vgic_irq_is_edge(vcpu, irq))
>  		vlr.state |= LR_EOI_INT;
>  
> +	if (vlr.irq >= VGIC_NR_SGIS) {
> +		struct irq_phys_map *map;
> +		map = vgic_irq_map_search(vcpu, irq);
> +
> +		if (map) {
> +			int ret;
> +
> +			BUG_ON(!map->active);
> +			vlr.hwirq = map->phys_irq;
> +			vlr.state |= LR_HW;
> +			vlr.state &= ~LR_EOI_INT;
> +
> +			ret = irq_set_irqchip_state(map->irq,
> +						    IRQCHIP_STATE_ACTIVE,
> +						    true);
> +			vgic_irq_set_queued(vcpu, irq);
> +			WARN_ON(ret);
> +		}
> +	}
> +
>  	vgic_set_lr(vcpu, lr_nr, vlr);
>  	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
>  }
> @@ -1344,6 +1364,35 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>  	return level_pending;
>  }
>  
> +/* Return 1 if HW interrupt went from active to inactive, and 0 otherwise */
> +static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
> +{
> +	struct irq_phys_map *map;
> +	int ret;
> +
> +	if (!(vlr.state & LR_HW))
> +		return 0;
> +
> +	map = vgic_irq_map_search(vcpu, vlr.irq);

I wonder if it's safe to rely on that mapping here. Are we sure that
this hasn't changed while the VCPU was running? If I got this correctly,
currently only vcpu_reset will actually add a map entry, but I guess in
the future there will be more users.
Also we rely on the irqdomain mapping to be still the same, but that is
probably a safe assumption.

But I'd still find it more natural to use the hwirq number from the LR
at this point. Can't we use irq_find_mapping() here to learn Linux'
(current) irq number from that?

Or am I too paranoid here?

Cheers,
Andre.

> +	BUG_ON(!map || !map->active);
> +
> +	ret = irq_get_irqchip_state(map->irq,
> +				    IRQCHIP_STATE_ACTIVE,
> +				    &map->active);
> +
> +	WARN_ON(ret);
> +
> +	if (map->active) {
> +		ret = irq_set_irqchip_state(map->irq,
> +					    IRQCHIP_STATE_ACTIVE,
> +					    false);
> +		WARN_ON(ret);
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
>  /* Sync back the VGIC state after a guest run */
>  static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  {
> @@ -1358,14 +1407,30 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  	elrsr = vgic_get_elrsr(vcpu);
>  	elrsr_ptr = u64_to_bitmask(&elrsr);
>  
> -	/* Clear mappings for empty LRs */
> -	for_each_set_bit(lr, elrsr_ptr, vgic->nr_lr) {
> +	/* Deal with HW interrupts, and clear mappings for empty LRs */
> +	for (lr = 0; lr < vgic->nr_lr; lr++) {
>  		struct vgic_lr vlr;
>  
> -		if (!test_and_clear_bit(lr, vgic_cpu->lr_used))
> +		if (!test_bit(lr, vgic_cpu->lr_used))
>  			continue;
>  
>  		vlr = vgic_get_lr(vcpu, lr);
> +		if (vgic_sync_hwirq(vcpu, vlr)) {
> +			/*
> +			 * So this is a HW interrupt that the guest
> +			 * EOI-ed. Clean the LR state and allow the
> +			 * interrupt to be queued again.
> +			 */
> +			vlr.state &= ~LR_HW;
> +			vlr.hwirq = 0;
> +			vgic_set_lr(vcpu, lr, vlr);
> +			vgic_irq_clear_queued(vcpu, vlr.irq);
> +		}
> +
> +		if (!test_bit(lr, elrsr_ptr))
> +			continue;
> +
> +		clear_bit(lr, vgic_cpu->lr_used);
>  
>  		BUG_ON(vlr.irq >= dist->nr_irqs);
>  		vgic_cpu->vgic_irq_lr_map[vlr.irq] = LR_EMPTY;
> 
