From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 30/55] KVM: arm/arm64: vgic-new: Add SGIR register
 handler
Date: Thu, 12 May 2016 10:40:39 +0200
Message-ID: <20160512084039.GA27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-31-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 940B749B2F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 04:37:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d57ouX5Fn5yL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 May 2016 04:37:03 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A78949B1D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 04:37:02 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id n129so249647112wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 01:40:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1462531568-9799-31-git-send-email-andre.przywara@arm.com>
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

On Fri, May 06, 2016 at 11:45:43AM +0100, Andre Przywara wrote:
> Triggering an IPI via this register is v2 specific, so the
> implementation lives entirely in vgic-mmio-v2.c.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog RFC..v1:
> - silently return on illegal TargetListFilter value (=3)
> 
> Changelog v1 .. v2:
> - adapt to new MMIO framework
> 
>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 43 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index 888529e..8f8ea57 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -66,6 +66,47 @@ static void vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
> +				 gpa_t addr, unsigned int len,
> +				 unsigned long val)
> +{
> +	int nr_vcpus = atomic_read(&source_vcpu->kvm->online_vcpus);
> +	int intid = val & 0xf;
> +	int targets = (val >> 16) & 0xff;
> +	int mode = (val >> 24) & 0x03;
> +	int c;
> +	struct kvm_vcpu *vcpu;
> +
> +	switch (mode) {
> +	case 0x0:		/* as specified by targets */
> +		break;
> +	case 0x1:
> +		targets = (1U << nr_vcpus) - 1;			/* all, ... */
> +		targets &= ~(1U << source_vcpu->vcpu_id);	/* but self */
> +		break;
> +	case 0x2:		/* this very vCPU only */
> +		targets = (1U << source_vcpu->vcpu_id);
> +		break;
> +	case 0x3:		/* reserved */
> +		return;
> +	}
> +
> +	kvm_for_each_vcpu(c, vcpu, source_vcpu->kvm) {
> +		struct vgic_irq *irq;
> +
> +		if (!(targets & (1U << c)))
> +			continue;
> +
> +		irq = vgic_get_irq(source_vcpu->kvm, vcpu, intid);
> +
> +		spin_lock(&irq->irq_lock);
> +		irq->pending = true;
> +		irq->source |= 1U << source_vcpu->vcpu_id;
> +
> +		vgic_queue_irq_unlock(source_vcpu->kvm, irq);
> +	}
> +}
> +
>  static unsigned long vgic_mmio_read_target(struct kvm_vcpu *vcpu,
>  					   gpa_t addr, unsigned int len)
>  {
> @@ -131,7 +172,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
>  		vgic_mmio_read_config, vgic_mmio_write_config, 2),
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
> +		vgic_mmio_read_raz, vgic_mmio_write_sgir, 4),
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 16),
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_SET,
> -- 
> 2.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

(assuming the alignment check is fixed by other patches)

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
