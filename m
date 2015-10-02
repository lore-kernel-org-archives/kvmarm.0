From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH 5/6] vfio-pci: Create iommu mapping for msi interrupt
Date: Fri, 02 Oct 2015 16:46:33 -0600
Message-ID: <1443825993.26107.190.camel@redhat.com>
References: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1443624989-24346-5-git-send-email-Bharat.Bhushan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443624989-24346-5-git-send-email-Bharat.Bhushan@freescale.com>
Sender: kvm-owner@vger.kernel.org
To: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, eric.auger@linaro.org, pranavkumar@linaro.org, marc.zyngier@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 2015-09-30 at 20:26 +0530, Bharat Bhushan wrote:
> An MSI-address is allocated and programmed in pcie device
> during interrupt configuration. Now for a pass-through device,
> try to create the iommu mapping for this allocted/programmed
> msi-address.  If the iommu mapping is created and the msi
> address programmed in the pcie device is different from
> msi-iova as per iommu programming then reconfigure the pci
> device to use msi-iova as msi address.
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 36 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 1f577b4..c9690af 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -312,13 +312,23 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
>  	int irq = msix ? vdev->msix[vector].vector : pdev->irq + vector;
>  	char *name = msix ? "vfio-msix" : "vfio-msi";
>  	struct eventfd_ctx *trigger;
> +	struct msi_msg msg;
> +	struct vfio_device *device;
> +	uint64_t msi_addr, msi_iova;
>  	int ret;
>  
>  	if (vector >= vdev->num_ctx)
>  		return -EINVAL;
>  
> +	device = vfio_device_get_from_dev(&pdev->dev);

Have you looked at this function?  I don't think we want to be doing
that every time we want to poke the interrupt configuration.  Also note
that IOMMU mappings don't operate on devices, but groups, so maybe we
want to pass the group.

> +	if (device == NULL)
> +		return -EINVAL;

This would be a legitimate BUG_ON(!device)

> +
>  	if (vdev->ctx[vector].trigger) {
>  		free_irq(irq, vdev->ctx[vector].trigger);
> +		get_cached_msi_msg(irq, &msg);
> +		msi_iova = ((u64)msg.address_hi << 32) | msg.address_lo;
> +		vfio_device_unmap_msi(device, msi_iova, PAGE_SIZE);
>  		kfree(vdev->ctx[vector].name);
>  		eventfd_ctx_put(vdev->ctx[vector].trigger);
>  		vdev->ctx[vector].trigger = NULL;
> @@ -346,12 +356,11 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
>  	 * cached value of the message prior to enabling.
>  	 */
>  	if (msix) {
> -		struct msi_msg msg;
> -
>  		get_cached_msi_msg(irq, &msg);
>  		pci_write_msi_msg(irq, &msg);
>  	}
>  
> +

gratuitous newline

>  	ret = request_irq(irq, vfio_msihandler, 0,
>  			  vdev->ctx[vector].name, trigger);
>  	if (ret) {
> @@ -360,6 +369,29 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
>  		return ret;
>  	}
>  
> +	/* Re-program the new-iova in pci-device in case there is
> +	 * different iommu-mapping created for programmed msi-address.
> +	 */
> +	get_cached_msi_msg(irq, &msg);
> +	msi_iova = 0;
> +	msi_addr = (u64)(msg.address_hi) << 32 | (u64)(msg.address_lo);
> +	ret = vfio_device_map_msi(device, msi_addr, PAGE_SIZE, &msi_iova);
> +	if (ret) {
> +		free_irq(irq, vdev->ctx[vector].trigger);
> +		kfree(vdev->ctx[vector].name);
> +		eventfd_ctx_put(trigger);
> +		return ret;
> +	}
> +
> +	/* Reprogram only if iommu-mapped iova is different from msi-address */
> +	if (msi_iova && (msi_iova != msi_addr)) {
> +		msg.address_hi = (u32)(msi_iova >> 32);
> +		/* Keep Lower bits from original msi message address */
> +		msg.address_lo &= PAGE_MASK;
> +		msg.address_lo |= (u32)(msi_iova & 0x00000000ffffffff);

Seems like you're making some assumptions here that are dependent on the
architecture and maybe the platform.

> +		pci_write_msi_msg(irq, &msg);
> +	}
> +
>  	vdev->ctx[vector].trigger = trigger;
>  
>  	return 0;



