From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v9 14/17] KVM: arm64: allow updates of LPI configuration
 table
Date: Thu, 14 Jul 2016 10:46:50 +0100
Message-ID: <57875F8A.2070009@arm.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
 <20160713015909.28793-15-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160713015909.28793-15-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 13/07/16 02:59, Andre Przywara wrote:
> The (system-wide) LPI configuration table is held in a table in
> (guest) memory. To achieve reasonable performance, we cache this data
> in our struct vgic_irq. If the guest updates the configuration data
> (which consists of the enable bit and the priority value), it issues
> an INV or INVALL command to allow us to update our information.
> Provide functions that update that information for one LPI or all LPIs
> mapped to a specific collection.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index f400ef1..60108f8 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -64,6 +64,45 @@ struct its_itte {
>  
>  #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
>  #define PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 16))
> +#define PROPBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))

Again, these masks are wrong as we limit the ITS to 48 bits PA.

> +
> +#define GIC_LPI_OFFSET 8192
> +
> +#define LPI_PROP_ENABLE_BIT(p)	((p) & LPI_PROP_ENABLED)
> +#define LPI_PROP_PRIORITY(p)	((p) & 0xfc)
> +
> +/*
> + * Reads the configuration data for a given LPI from guest memory and
> + * updates the fields in struct vgic_irq.
> + * If filter_vcpu is not NULL, applies only if the IRQ is targeting this
> + * VCPU. Unconditionally applies if filter_vcpu is NULL.
> + */
> +static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
> +			     struct kvm_vcpu *filter_vcpu)
> +{
> +	u64 propbase = PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
> +	u8 prop;
> +	int ret;
> +
> +	ret = kvm_read_guest(kvm, propbase + irq->intid - GIC_LPI_OFFSET,
> +			     &prop, 1);
> +
> +	if (ret)
> +		return ret;
> +
> +	spin_lock(&irq->irq_lock);
> +
> +	if (!filter_vcpu || filter_vcpu == irq->target_vcpu) {
> +		irq->priority = LPI_PROP_PRIORITY(prop);
> +		irq->enabled = LPI_PROP_ENABLE_BIT(prop);
> +
> +		vgic_queue_irq_unlock(kvm, irq);
> +	} else {
> +		spin_unlock(&irq->irq_lock);
> +	}
> +
> +	return 0;
> +}
>  
>  /*
>   * Create a snapshot of the current LPI list, so that we can enumerate all
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
