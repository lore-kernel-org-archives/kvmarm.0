From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: VGIC: extend !vgic_is_initialized guard
Date: Mon, 20 Nov 2017 12:23:06 +0100
Message-ID: <20171120112306.GG28855@cbox>
References: <20171117175821.23250-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171117175821.23250-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On Fri, Nov 17, 2017 at 05:58:21PM +0000, Andre Przywara wrote:
> Commit f39d16cbabf9 ("KVM: arm/arm64: Guard kvm_vgic_map_is_active against
> !vgic_initialized") introduced a check whether the VGIC has been
> initialized before accessing the spinlock and the VGIC data structure.
> However the vgic_get_irq() call in the variable declaration sneaked
> through the net, so lets make sure that this also gets called only after
> we actually allocated the arrays this function accesses.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index e54ef2fdf73d..967983a33ab2 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -786,13 +786,14 @@ void vgic_kick_vcpus(struct kvm *kvm)
>  
>  bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
>  {
> -	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
> +	struct vgic_irq *irq;
>  	bool map_is_active;
>  	unsigned long flags;
>  
>  	if (!vgic_initialized(vcpu->kvm))
>  		return false;
>  
> +	irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
>  	spin_lock_irqsave(&irq->irq_lock, flags);
>  	map_is_active = irq->hw && irq->active;
>  	spin_unlock_irqrestore(&irq->irq_lock, flags);
> -- 
> 2.14.1
> 
As explained in the other e-mail this isn't actually strictly necessary
anymore, but I think our current appraoch of "how do we handle calls
from generic code the VGIC when the VGIC potentially hasn't been
initialized yet?" is to have an initialized check on most entry points
to the VGIC, unless strictly performance sensitive.

Therefore:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
