From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 5/8] KVM: arm/arm64: vgic: Handle mapped level
 sensitive SPIs
Date: Fri, 21 Jul 2017 14:11:37 +0200
Message-ID: <20170721121137.GF16350@cbox>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
 <1497531160-29162-6-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F54D40D17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jul 2017 08:10:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iBG00d2fqsKm for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Jul 2017 08:10:45 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B34640C5A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jul 2017 08:10:44 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id w191so12335508wmw.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jul 2017 05:11:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1497531160-29162-6-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 15, 2017 at 02:52:37PM +0200, Eric Auger wrote:
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

why?  I don't remember this now, and that means I probably won't in the
future either.

When I look at this now, I'm thinking, if we're not going to change
anything, why proceed beyond validate injection?

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
>  }
>  
> +#define is_mapped_spi(i) \
> +((i)->hw && (i)->intid >= VGIC_NR_PRIVATE_IRQS && (i)->intid < 1020)
> +

nit: why is this not a static inline ?

>  /*
>   * This struct provides an intermediate representation of the fields contained
>   * in the GICH_VMCR and ICH_VMCR registers, such that code exporting the GIC
> -- 
> 2.5.5
> 

Thanks,
-Christoffer
