From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm64: ITS: return 1 on successful MSI injection
Date: Wed, 3 Aug 2016 19:32:50 +0200
Message-ID: <20160803173250.GA32244@cbox>
References: <20160802125605.31665-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C02C149B2C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2016 13:24:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qhtSSIYwmDyn for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Aug 2016 13:24:20 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E70549B1D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2016 13:24:19 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id f65so456715241wmi.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Aug 2016 10:31:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160802125605.31665-1-andre.przywara@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 02, 2016 at 01:56:05PM +0100, Andre Przywara wrote:
> According to the KVM API documentation a successful MSI injection
> should return a value > 0 on success.
> Return possible errors in vgic_its_trigger_msi() and report a
> successful injection back to userland, while also reporting the
> case where the MSI could not be delivered due to the guest not
> having the LPI mapped, for instance.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Hi,
> 
> my brain is too toasted at the moment to find the proper error values
> that we should return in vgic_its_trigger_msi() for the various cases
> that could go wrong, so please feel free to suggest better values.
> In the end we return either 0 or 1 (and ignore any error value at the
> ITS level), so it shouldn't really make much difference.
> 
> Cheers,
> Andre.
> 
> Changelog v1 .. v2:
> - rework vgic_its_trigger_msi() to return proper error values
> - return 0 to userland if the LPI could not be injected
> 
>  include/linux/irqchip/arm-gic-v3.h |  1 +
>  virt/kvm/arm/vgic/vgic-its.c       | 48 +++++++++++++++++++++++---------------
>  2 files changed, 30 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 56b0b7e..99ac022 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -337,6 +337,7 @@
>   */
>  #define E_ITS_MOVI_UNMAPPED_INTERRUPT		0x010107
>  #define E_ITS_MOVI_UNMAPPED_COLLECTION		0x010109
> +#define E_ITS_INT_UNMAPPED_INTERRUPT		0x010307
>  #define E_ITS_CLEAR_UNMAPPED_INTERRUPT		0x010507
>  #define E_ITS_MAPD_DEVICE_OOR			0x010801
>  #define E_ITS_MAPC_PROCNUM_OOR			0x010902
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 07411cf..456903c 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -441,39 +441,48 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
>   * Find the target VCPU and the LPI number for a given devid/eventid pair
>   * and make this IRQ pending, possibly injecting it.
>   * Must be called with the its_lock mutex held.
> + * Returns 0 on success, a positive error value for any ITS mapping
> + * related errors and negative error values for generic errors.
>   */
> -static void vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
> -				 u32 devid, u32 eventid)
> +static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
> +				u32 devid, u32 eventid)
>  {
> +	struct kvm_vcpu *vcpu;
>  	struct its_itte *itte;
>  
>  	if (!its->enabled)
> -		return;
> +		return -EBUSY;
>  
>  	itte = find_itte(its, devid, eventid);
> -	/* Triggering an unmapped IRQ gets silently dropped. */
> -	if (itte && its_is_collection_mapped(itte->collection)) {
> -		struct kvm_vcpu *vcpu;
> -
> -		vcpu = kvm_get_vcpu(kvm, itte->collection->target_addr);
> -		if (vcpu && vcpu->arch.vgic_cpu.lpis_enabled) {
> -			spin_lock(&itte->irq->irq_lock);
> -			itte->irq->pending = true;
> -			vgic_queue_irq_unlock(kvm, itte->irq);
> -		}
> -	}
> +	if (!itte || !its_is_collection_mapped(itte->collection))
> +		return E_ITS_INT_UNMAPPED_INTERRUPT;
> +
> +	vcpu = kvm_get_vcpu(kvm, itte->collection->target_addr);
> +	if (!vcpu)
> +		return E_ITS_INT_UNMAPPED_INTERRUPT;
> +
> +	if (!vcpu->arch.vgic_cpu.lpis_enabled)
> +		return -EBUSY;
> +
> +	spin_lock(&itte->irq->irq_lock);
> +	itte->irq->pending = true;
> +	vgic_queue_irq_unlock(kvm, itte->irq);
> +
> +	return 0;
>  }
>  
>  /*
>   * Queries the KVM IO bus framework to get the ITS pointer from the given
>   * doorbell address.
>   * We then call vgic_its_trigger_msi() with the decoded data.
> + * According to the KVM_SIGNAL_MSI API description returns 1 on success.
>   */
>  int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
>  {
>  	u64 address;
>  	struct kvm_io_device *kvm_io_dev;
>  	struct vgic_io_device *iodev;
> +	int ret;
>  
>  	if (!vgic_has_its(kvm))
>  		return -ENODEV;
> @@ -490,10 +499,13 @@ int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
>  	iodev = container_of(kvm_io_dev, struct vgic_io_device, dev);
>  
>  	mutex_lock(&iodev->its->its_lock);
> -	vgic_its_trigger_msi(kvm, iodev->its, msi->devid, msi->data);
> +	ret = vgic_its_trigger_msi(kvm, iodev->its, msi->devid, msi->data);
>  	mutex_unlock(&iodev->its->its_lock);
>  
> -	return 0;
> +	if (ret)
> +		return 0;
> +	else
> +		return 1;

I think this should be:

  if (ret < 0)
  	return ret;
  else if (ret)
  	return 0;
  else
  	return 1;


Thanks,
-Christoffer
