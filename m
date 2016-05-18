From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 29/56] KVM: arm/arm64: vgic-new: Add CONFIG registers
 handlers
Date: Wed, 18 May 2016 15:08:18 +0200
Message-ID: <20160518130818.GH3827@cbox>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-30-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 756E740FA2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 09:04:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ng8kE-6j1uGA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2016 09:04:16 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C9FB40F9B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 09:04:15 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id n129so184139002wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 06:07:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1463392481-26583-30-git-send-email-andre.przywara@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 16, 2016 at 10:53:17AM +0100, Andre Przywara wrote:
> The config register handlers are shared between the v2 and v3
> emulation, so their implementation goes into vgic-mmio.c, to be
> easily referenced from the v3 emulation as well later.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog v1 .. v2:
> - adapt to new MMIO framework
> 
> Changelog v3 .. v4:
> - specify accessor width
> - use IRQ number accessor macro
> - replace extract_bytes() with simple return
> 
>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  2 +-
>  virt/kvm/arm/vgic/vgic-mmio.c    | 46 ++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.h    |  7 ++++++
>  3 files changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index d564a30..bb7389e 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -96,7 +96,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
>  		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 2,
> +		vgic_mmio_read_config, vgic_mmio_write_config, 2,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 5c8af05..5fe6896 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -277,6 +277,52 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +unsigned long vgic_mmio_read_config(struct kvm_vcpu *vcpu,
> +				    gpa_t addr, unsigned int len)
> +{
> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 2);
> +	u32 value = 0;
> +	int i;
> +
> +	for (i = 0; i < len * 4; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		if (irq->config == VGIC_CONFIG_EDGE)
> +			value |= (2U << (i * 2));
> +	}
> +
> +	return value;
> +}
> +
> +void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
> +			    gpa_t addr, unsigned int len,
> +			    unsigned long val)
> +{
> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 2);
> +	int i;
> +
> +	for (i = 0; i < len * 4; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		if (intid + i < 16)
> +			continue;

from my last round of commenting:

s/16/VGIC_NR_SGIS/

It's implementation defined if software can program the configuration of
PPIs, and since our timer code relies on its virtual PPI always being
level triggered, I think we should change the above to
VGIC_NR_PRIVATE_IRQS and then if someone ever needs a configurable
virtual PPI, we can add that later.

> +
> +		/*
> +		 * The spec says that interrupts must be disabled before
> +		 * changing the configuration to avoid UNDEFINED behaviour.
> +		 */

I'm still not sure what the benefit of having this comment here is?

> +
> +		spin_lock(&irq->irq_lock);
> +		if (test_bit(i * 2 + 1, &val)) {
> +			irq->config = VGIC_CONFIG_EDGE;
> +		} else {
> +			irq->config = VGIC_CONFIG_LEVEL;
> +			irq->pending = irq->line_level | irq->soft_pending;
> +		}
> +		spin_unlock(&irq->irq_lock);
> +	}
> +}
> +
>  static int match_region(const void *key, const void *elt)
>  {
>  	const unsigned int offset = (unsigned long)key;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index 6983922..0bd0ece 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -124,6 +124,13 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
>  			      gpa_t addr, unsigned int len,
>  			      unsigned long val);
>  
> +unsigned long vgic_mmio_read_config(struct kvm_vcpu *vcpu,
> +				    gpa_t addr, unsigned int len);
> +
> +void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
> +			    gpa_t addr, unsigned int len,
> +			    unsigned long val);
> +
>  unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
>  
>  #endif
> -- 
> 2.8.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,
-Christoffer
