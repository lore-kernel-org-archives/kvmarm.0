From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 7/7] KVM: arm/arm64: remove irq_phys_map pointer from
 kvm_vgic_map_phys_irq()
Date: Thu, 21 Apr 2016 20:04:16 +0200
Message-ID: <57191620.5020404@linaro.org>
References: <1460729047-6346-1-git-send-email-andre.przywara@arm.com>
 <1460729047-6346-8-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1460729047-6346-8-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/15/2016 04:04 PM, Andre Przywara wrote:
> Now that the virtual arch timer does not care about the irq_phys_map
> anymore, let's rework kvm_vgic_map_phys_irq() to return an error
> value instead. Any reference to thap mapping can later be done by
> passing the correct combination of VCPU and virtual IRQ number.
> This makes the irq_phys_map handling completely private to the
> VGIC code.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/arm_vgic.h    |  3 +--
>  virt/kvm/arm/arch_timer.c |  8 ++++----
>  virt/kvm/arm/vgic.c       | 23 +++++++++++------------
>  3 files changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 49c559e..f842d7d 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -343,8 +343,7 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
>  			       unsigned int virt_irq, bool level);
>  void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
> -struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
> -					   int virt_irq, int phys_irq);
> +int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq);
>  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>  bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>  
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 1598e23..270f971 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -306,10 +306,10 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>  			 const struct kvm_irq_level *irq)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> -	struct irq_phys_map *map;
>  	struct irq_desc *desc;
>  	struct irq_data *data;
>  	int phys_irq;
> +	int ret;
>  
>  	/*
>  	 * The vcpu timer irq number cannot be determined in
> @@ -347,9 +347,9 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>  	 * Tell the VGIC that the virtual interrupt is tied to a
>  	 * physical interrupt. We do that once per VCPU.
>  	 */
> -	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
> -	if (WARN_ON(IS_ERR(map)))
> -		return PTR_ERR(map);
> +	ret = kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
> +	if (ret)
> +		return ret;
>  
>  	timer->virt_irq = irq->irq;
>  	return 0;
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index ac5838b..00386df 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1712,29 +1712,28 @@ static struct list_head *vgic_get_irq_phys_map_list(struct kvm_vcpu *vcpu,
>  /**
>   * kvm_vgic_map_phys_irq - map a virtual IRQ to a physical IRQ
>   * @vcpu: The VCPU pointer
> - * @virt_irq: The virtual irq number
> - * @irq: The Linux IRQ number
> + * @virt_irq: The virtual IRQ number for the guest
> + * @phys_irq: The hardware IRQ number of the host
nit: not belonging to this patch ;-)
>   *
>   * Establish a mapping between a guest visible irq (@virt_irq) and a
> - * Linux irq (@irq). On injection, @virt_irq will be associated with
> - * the physical interrupt represented by @irq. This mapping can be
> + * hardware irq (@phys_irq). On injection, @virt_irq will be associated with
> + * the physical interrupt represented by @phys_irq. This mapping can be
same

Besides Reviewed-by: Eric Auger <eric.auger@linaro.org>

Have a nice evening

Cheers

Eric


>   * established multiple times as long as the parameters are the same.
>   *
> - * Returns a valid pointer on success, and an error pointer otherwise
> + * Returns 0 on success or an error value otherwise.
>   */
> -struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
> -					   int virt_irq, int phys_irq)
> +int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq)
>  {
>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>  	struct list_head *root = vgic_get_irq_phys_map_list(vcpu, virt_irq);
>  	struct irq_phys_map *map;
>  	struct irq_phys_map_entry *entry;
> -
> +	int ret = 0;
>  
>  	/* Create a new mapping */
>  	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
>  	if (!entry)
> -		return ERR_PTR(-ENOMEM);
> +		return -ENOMEM;
>  
>  	spin_lock(&dist->irq_phys_map_lock);
>  
> @@ -1743,7 +1742,7 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
>  	if (map) {
>  		/* Make sure this mapping matches */
>  		if (map->phys_irq != phys_irq)
> -			map = ERR_PTR(-EINVAL);
> +			ret = -EINVAL;
>  
>  		/* Found an existing, valid mapping */
>  		goto out;
> @@ -1759,9 +1758,9 @@ out:
>  	spin_unlock(&dist->irq_phys_map_lock);
>  	/* If we've found a hit in the existing list, free the useless
>  	 * entry */
> -	if (IS_ERR(map) || map != &entry->map)
> +	if (ret || map != &entry->map)
>  		kfree(entry);
> -	return map;
> +	return ret;
>  }
>  
>  static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
> 

