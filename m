From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3/3] KVM: arm/arm64: vgic: Trust the LR state for HW
 IRQs
Date: Tue, 24 Nov 2015 16:13:25 +0000
Message-ID: <20151124161325.77b91d7d@arm.com>
References: <1448379840-17516-1-git-send-email-christoffer.dall@linaro.org>
	<1448379840-17516-4-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1448379840-17516-4-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 24 Nov 2015 16:44:00 +0100
Christoffer Dall <christoffer.dall@linaro.org> wrote:

> We were probing the physial distributor state for the active state of a
> HW virtual IRQ, because we had seen evidence that the LR state was not
> cleared when the guest deactivated a virtual interrupted.
> 
> However, this issue turned out to be a software bug in the GIC, which
> was solved by: 84aab5e68c2a5e1e18d81ae8308c3ce25d501b29
> (KVM: arm/arm64: arch_timer: Preserve physical dist. active
> state on LR.active, 2015-11-24)
> 
> Therefore, get rid of the complexities and just look at the LR.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/vgic.c | 16 ++--------------
>  1 file changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 9002f0d..55cd7e3 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1420,25 +1420,13 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>  static bool vgic_sync_hwirq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
>  {
>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> -	struct irq_phys_map *map;
> -	bool phys_active;
>  	bool level_pending;
> -	int ret;
>  
>  	if (!(vlr.state & LR_HW))
>  		return false;
>  
> -	map = vgic_irq_map_search(vcpu, vlr.irq);
> -	BUG_ON(!map);
> -
> -	ret = irq_get_irqchip_state(map->irq,
> -				    IRQCHIP_STATE_ACTIVE,
> -				    &phys_active);
> -
> -	WARN_ON(ret);
> -
> -	if (phys_active)
> -		return 0;
> +	if (vlr.state & LR_STATE_ACTIVE)
> +		return false;
>  
>  	spin_lock(&dist->lock);
>  	level_pending = process_queued_irq(vcpu, lr, vlr);

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
