From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 02/20] virtio: pci-legacy: Validate queue pfn
Date: Fri, 29 Jun 2018 20:42:40 +0300
Message-ID: <20180629204213-mutt-send-email-mst@kernel.org>
References: <1530270944-11351-1-git-send-email-suzuki.poulose@arm.com>
 <1530270944-11351-3-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1530270944-11351-3-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, julien.grall@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, qemu-devel@nongnu.org, Jason Wang <jasowang@redhat.com>, Peter Maydel <peter.maydell@linaro.org>, Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jun 29, 2018 at 12:15:22PM +0100, Suzuki K Poulose wrote:
> Legacy PCI over virtio uses a 32bit PFN for the queue. If the
> queue pfn is too large to fit in 32bits, which we could hit on
> arm64 systems with 52bit physical addresses (even with 64K page
> size), we simply miss out a proper link to the other side of
> the queue.
> 
> Add a check to validate the PFN, rather than silently breaking
> the devices.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Cc: Peter Maydel <peter.maydell@linaro.org>
> Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v2:
>  - Change errno to -E2BIG
> ---
>  drivers/virtio/virtio_pci_legacy.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
> index 2780886..c0d6987a 100644
> --- a/drivers/virtio/virtio_pci_legacy.c
> +++ b/drivers/virtio/virtio_pci_legacy.c
> @@ -122,6 +122,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>  	struct virtqueue *vq;
>  	u16 num;
>  	int err;
> +	u64 q_pfn;
>  
>  	/* Select the queue we're interested in */
>  	iowrite16(index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
> @@ -141,9 +142,15 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>  	if (!vq)
>  		return ERR_PTR(-ENOMEM);
>  
> +	q_pfn = virtqueue_get_desc_addr(vq) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT;
> +	if (q_pfn >> 32) {
> +		dev_err(&vp_dev->pci_dev->dev, "virtio-pci queue PFN too large\n");
> +		err = -E2BIG;

Same comment here. Let's make it clear it's host not guest problem.

> +		goto out_del_vq;
> +	}
> +
>  	/* activate the queue */
> -	iowrite32(virtqueue_get_desc_addr(vq) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT,
> -		  vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
> +	iowrite32(q_pfn, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
>  
>  	vq->priv = (void __force *)vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NOTIFY;
>  
> @@ -160,6 +167,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>  
>  out_deactivate:
>  	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
> +out_del_vq:
>  	vring_del_virtqueue(vq);
>  	return ERR_PTR(err);
>  }
> -- 
> 2.7.4
