From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 5/6] KVM: arm/arm64: Rearrange kvm_vgic_[un]map_phys
 code in vgic.c
Date: Tue, 5 Sep 2017 12:26:14 +0200
Message-ID: <56431c9d-3f7e-f8b2-2d31-6baec4e294da@redhat.com>
References: <20170904102456.9025-1-cdall@linaro.org>
 <20170904102456.9025-6-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170904102456.9025-6-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,
On 04/09/2017 12:24, Christoffer Dall wrote:
> The small indirection of a static function made the locking very obvious
> but becomes pretty ugly as we start passing function pointer around.
> Let's inline these two functions first to make the following patch more
> readable.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic.c | 38 +++++++++++++-------------------------
>  1 file changed, 13 insertions(+), 25 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 7aec730..b704ff5 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -435,12 +435,17 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  	return 0;
>  }
>  
> -/* @irq->irq_lock must be held */
I chose to hold the lock outside of kvm_vgic_map/unmap_irq because in
kvm_vgic_set_forwarding(see https://lkml.org/lkml/2017/6/15/278) I was
also testing hw and target_vcpu fields. As you pointed out maybe I am
not obliged to check them but that was the rationale.

Thanks

Eric
> -static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> -			    unsigned int host_irq)
> +int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> +			  u32 vintid)
>  {
> +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
>  	struct irq_desc *desc;
>  	struct irq_data *data;
> +	int ret = 0;
> +
> +	BUG_ON(!irq);
> +
> +	spin_lock(&irq->irq_lock);
>  
>  	/*
>  	 * Find the physical IRQ number corresponding to @host_irq
> @@ -448,7 +453,8 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  	desc = irq_to_desc(host_irq);
>  	if (!desc) {
>  		kvm_err("%s: no interrupt descriptor\n", __func__);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto out;
>  	}
>  	data = irq_desc_get_irq_data(desc);
>  	while (data->parent_data)
> @@ -457,29 +463,10 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  	irq->hw = true;
>  	irq->host_irq = host_irq;
>  	irq->hwintid = data->hwirq;
> -	return 0;
> -}
> -
> -/* @irq->irq_lock must be held */
> -static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
> -{
> -	irq->hw = false;
> -	irq->hwintid = 0;
> -}
> -
> -int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> -			  u32 vintid)
> -{
> -	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
> -	int ret;
>  
> -	BUG_ON(!irq);
> -
> -	spin_lock(&irq->irq_lock);
> -	ret = kvm_vgic_map_irq(vcpu, irq, host_irq);
> +out:
>  	spin_unlock(&irq->irq_lock);
>  	vgic_put_irq(vcpu->kvm, irq);
> -
>  	return ret;
>  }
>  
> @@ -494,7 +481,8 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
>  	BUG_ON(!irq);
>  
>  	spin_lock(&irq->irq_lock);
> -	kvm_vgic_unmap_irq(irq);
> +	irq->hw = false;
> +	irq->hwintid = 0;
>  	spin_unlock(&irq->irq_lock);
>  	vgic_put_irq(vcpu->kvm, irq);
>  
> 
