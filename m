From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4 02/20] virtio: pci-legacy: Validate queue pfn
Date: Sun, 22 Jul 2018 18:53:59 +0300
Message-ID: <20180722185335-mutt-send-email-mst@kernel.org>
References: <1531905547-25478-1-git-send-email-suzuki.poulose@arm.com>
 <1531905547-25478-3-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CF904A0D2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Jul 2018 11:40:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DxMjAAkPjC7L for <kvmarm@lists.cs.columbia.edu>;
 Sun, 22 Jul 2018 11:40:51 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A0D3402B8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Jul 2018 11:40:51 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1531905547-25478-3-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, Jason Wang <jasowang@redhat.com>, will.deacon@arm.com, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 18, 2018 at 10:18:45AM +0100, Suzuki K Poulose wrote:
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

Acked-by: Michael S. Tsirkin <mst@redhat.com>

I assume this will be merged through some other tree.

> ---
> Changes since v2:
>  - Change errno to -E2BIG
> ---
>  drivers/virtio/virtio_pci_legacy.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
> index 2780886..de062fb 100644
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
> @@ -141,9 +142,17 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>  	if (!vq)
>  		return ERR_PTR(-ENOMEM);
>  
> +	q_pfn = virtqueue_get_desc_addr(vq) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT;
> +	if (q_pfn >> 32) {
> +		dev_err(&vp_dev->pci_dev->dev,
> +			"platform bug: legacy virtio-mmio must not be used with RAM above 0x%llxGB\n",
> +			0x1ULL << (32 + PAGE_SHIFT - 30));
> +		err = -E2BIG;
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
> @@ -160,6 +169,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>  
>  out_deactivate:
>  	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
> +out_del_vq:
>  	vring_del_virtqueue(vq);
>  	return ERR_PTR(err);
>  }
> -- 
> 2.7.4
