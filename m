From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 5/8] KVM: arm/arm64: vgic: Handle mapped level
 sensitive SPIs
Date: Tue, 4 Jul 2017 13:15:40 +0100
Message-ID: <f21e17b7-9437-ca96-6847-91e7ecee3af4@arm.com>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
 <1497531160-29162-6-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497531160-29162-6-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, pbonzini@redhat.com, christoffer.dall@linaro.org
Cc: drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 15/06/17 13:52, Eric Auger wrote:
> Currently, the line level of unmapped level sensitive SPIs is
> toggled down by the maintenance IRQ handler/resamplefd mechanism.
> 
> As mapped SPI completion is not trapped, we cannot rely on this
> mechanism and the line level needs to be observed at distributor
> level instead.
> 
> This patch handles the physical IRQ case in vgic_validate_injection
> and get the line level of a mapped SPI at distributor level.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v1 -> v2:
> - renamed is_unshared_mapped into is_mapped_spi
> - changes to kvm_vgic_map_phys_irq moved in the previous patch
> - make vgic_validate_injection more readable
> - reword the commit message
> ---
>  virt/kvm/arm/vgic/vgic.c | 16 ++++++++++++++--
>  virt/kvm/arm/vgic/vgic.h |  7 ++++++-
>  2 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 075f073..2e35ac7 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -139,6 +139,17 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  	kfree(irq);
>  }
>  
> +bool irq_line_level(struct vgic_irq *irq)
> +{
> +	bool line_level = irq->line_level;
> +
> +	if (unlikely(is_mapped_spi(irq)))
> +		WARN_ON(irq_get_irqchip_state(irq->host_irq,
> +					      IRQCHIP_STATE_PENDING,
> +					      &line_level));
> +	return line_level;
> +}
> +
>  /**
>   * kvm_vgic_target_oracle - compute the target vcpu for an irq
>   *
> @@ -236,13 +247,14 @@ static void vgic_sort_ap_list(struct kvm_vcpu *vcpu)
>  
>  /*
>   * Only valid injection if changing level for level-triggered IRQs or for a
> - * rising edge.
> + * rising edge. Injection of virtual interrupts associated to physical
> + * interrupts always is valid.
>   */
>  static bool vgic_validate_injection(struct vgic_irq *irq, bool level)
>  {
>  	switch (irq->config) {
>  	case VGIC_CONFIG_LEVEL:
> -		return irq->line_level != level;
> +		return (irq->line_level != level || unlikely(is_mapped_spi(irq)));
>  	case VGIC_CONFIG_EDGE:
>  		return level;
>  	}
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index bba7fa2..da254ae 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -96,14 +96,19 @@
>  /* we only support 64 kB translation table page size */
>  #define KVM_ITS_L1E_ADDR_MASK		GENMASK_ULL(51, 16)
>  
> +bool irq_line_level(struct vgic_irq *irq);
> +
>  static inline bool irq_is_pending(struct vgic_irq *irq)
>  {
>  	if (irq->config == VGIC_CONFIG_EDGE)
>  		return irq->pending_latch;
>  	else
> -		return irq->pending_latch || irq->line_level;
> +		return irq->pending_latch || irq_line_level(irq);

I'm a bit concerned that an edge interrupt doesn't take the distributor
state into account here. Why is that so? Once an SPI is forwarded to a
guest, a large part of the edge vs level differences move into the HW,
and are not that different anymore from a SW PoV.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
