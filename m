From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 27/55] KVM: arm/arm64: vgic-new: Add PRIORITY
 registers handlers
Date: Wed, 11 May 2016 15:37:48 +0200
Message-ID: <20160511133748.GT27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-28-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ED6849B2C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:34:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NNY4ZG7NTTOZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 09:34:16 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5048B49B47
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:34:14 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id g17so83215694wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 06:37:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1462531568-9799-28-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 06, 2016 at 11:45:40AM +0100, Andre Przywara wrote:
> The priority register handlers are shared between the v2 and v3
> emulation, so their implementation goes into vgic-mmio.c, to be
> easily referenced from the v3 emulation as well later.
> There is a corner case when we change the priority of a pending
> interrupt which we don't handle at the moment.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog v1 .. v2:
> - adapt to new MMIO framework
> 
>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  2 +-
>  virt/kvm/arm/vgic/vgic-mmio.c    | 39 +++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.h    |  7 +++++++
>  3 files changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index 054b52d..2e17250 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -84,7 +84,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
>  		vgic_mmio_read_active, vgic_mmio_write_cactive, 1),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
> +		vgic_mmio_read_priority, vgic_mmio_write_priority, 8),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index dbf683e..d7fe9e6 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -282,6 +282,45 @@ retry:
>  	}
>  }
>  
> +unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
> +				      gpa_t addr, unsigned int len)
> +{
> +	u32 intid = addr & 0x3ff;
> +	int i;
> +	u64 val = 0;
> +
> +	for (i = 0; i < len; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		val |= (u64)irq->priority << (i * 8);
> +	}
> +
> +	return val;

IPRIORITYRn is specifically one of the registers requiring byte access
to be implemented; why are we not doing the extract_bytes thing here?

> +}
> +
> +/*
> + * We currently don't handle changing the priority of an interrupt that
> + * is already pending on a VCPU. If there is a need for this, we would
> + * need to make this VCPU exit and re-evaluate the priorities, potentially
> + * leading to this interrupt getting presented now to the guest (if it has
> + * been masked by the priority mask before).

I thought we were just going to do a vcpu_kick here?

> + */
> +void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
> +			      gpa_t addr, unsigned int len,
> +			      unsigned long val)
> +{
> +	u32 intid = addr & 0x3ff;
> +	int i;
> +
> +	for (i = 0; i < len; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock(&irq->irq_lock);
> +		irq->priority = (val >> (i * 8)) & 0xff;

If I wasn't mistaken on my comment in the previous patch, then you have
a problem here too...

> +		spin_unlock(&irq->irq_lock);
> +	}
> +}
> +
>  static int match_region(const void *key, const void *elt)
>  {
>  	const unsigned int offset = (unsigned long)key;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index fa875dc..cd04ac5 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -107,6 +107,13 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
>  			     gpa_t addr, unsigned int len,
>  			     unsigned long val);
>  
> +unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
> +				      gpa_t addr, unsigned int len);
> +
> +void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
> +			      gpa_t addr, unsigned int len,
> +			      unsigned long val);
> +
>  unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
>  
>  #endif
> -- 
> 2.7.3
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
