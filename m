From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 28/55] KVM: arm/arm64: vgic-new: Add CONFIG registers
 handlers
Date: Thu, 12 May 2016 10:32:49 +0200
Message-ID: <20160512083249.GY27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-29-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9E6949B2F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 04:29:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QJrI1f4UERYk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 May 2016 04:29:13 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EF5749B1D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 04:29:13 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id n129so249386922wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 01:32:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1462531568-9799-29-git-send-email-andre.przywara@arm.com>
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

On Fri, May 06, 2016 at 11:45:41AM +0100, Andre Przywara wrote:
> The config register handlers are shared between the v2 and v3
> emulation, so their implementation goes into vgic-mmio.c, to be
> easily referenced from the v3 emulation as well later.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog v1 .. v2:
> - adapt to new MMIO framework
> 
>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  2 +-
>  virt/kvm/arm/vgic/vgic-mmio.c    | 46 ++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.h    |  7 ++++++
>  3 files changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index 2e17250..2a953ec 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -88,7 +88,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 2),
> +		vgic_mmio_read_config, vgic_mmio_write_config, 2),
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index d7fe9e6..19fed56 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -321,6 +321,52 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +unsigned long vgic_mmio_read_config(struct kvm_vcpu *vcpu,
> +				    gpa_t addr, unsigned int len)
> +{
> +	u32 intid = (addr & 0xff) * 4;
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
> +	return extract_bytes(value, addr & 3, len);
> +}
> +
> +void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
> +			    gpa_t addr, unsigned int len,
> +			    unsigned long val)
> +{
> +	u32 intid = (addr & 0xff) * 4;
> +	int i;
> +
> +	for (i = 0; i < len * 4; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		if (intid + i < 16)

s/16/VGIC_NR_SGIS/

> +			continue;

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

not sure what this comment tells us about the implementation?  Should we
check that the IRQ is disabled before proceeding?

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
> index cd04ac5..884eb71 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -114,6 +114,13 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
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
> 2.7.3
> 
