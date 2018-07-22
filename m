From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4 01/20] virtio: mmio-v1: Validate queue PFN
Date: Sun, 22 Jul 2018 18:55:40 +0300
Message-ID: <20180722185407-mutt-send-email-mst@kernel.org>
References: <1531905547-25478-1-git-send-email-suzuki.poulose@arm.com>
 <1531905547-25478-2-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF6644A0D2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Jul 2018 11:42:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9joqEybGYwcn for <kvmarm@lists.cs.columbia.edu>;
 Sun, 22 Jul 2018 11:42:30 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DFDA402B8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Jul 2018 11:42:30 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1531905547-25478-2-git-send-email-suzuki.poulose@arm.com>
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

On Wed, Jul 18, 2018 at 10:18:44AM +0100, Suzuki K Poulose wrote:
> virtio-mmio with virtio-v1 uses a 32bit PFN for the queue.
> If the queue pfn is too large to fit in 32bits, which
> we could hit on arm64 systems with 52bit physical addresses
> (even with 64K page size), we simply miss out a proper link
> to the other side of the queue.
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
>  drivers/virtio/virtio_mmio.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 67763d3..4cd9ea5 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -397,9 +397,23 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
>  	/* Activate the queue */
>  	writel(virtqueue_get_vring_size(vq), vm_dev->base + VIRTIO_MMIO_QUEUE_NUM);
>  	if (vm_dev->version == 1) {
> +		u64 q_pfn = virtqueue_get_desc_addr(vq) >> PAGE_SHIFT;
> +
> +		/*
> +		 * virtio-mmio v1 uses a 32bit QUEUE PFN. If we have something
> +		 * that doesn't fit in 32bit, fail the setup rather than
> +		 * pretending to be successful.

I'd drop the "rather than pretending to be successful." if you fail
you are not pretending to be successful. Pls fix if you have to respin
anyway.

> +		 */
> +		if (q_pfn >> 32) {
> +			dev_err(&vdev->dev,
> +				"platform bug: legacy virtio-mmio must not be used with RAM above 0x%llxGB\n",
> +				0x1ULL << (32 + PAGE_SHIFT - 30));
> +			err = -E2BIG;
> +			goto error_bad_pfn;
> +		}
> +
>  		writel(PAGE_SIZE, vm_dev->base + VIRTIO_MMIO_QUEUE_ALIGN);
> -		writel(virtqueue_get_desc_addr(vq) >> PAGE_SHIFT,
> -				vm_dev->base + VIRTIO_MMIO_QUEUE_PFN);
> +		writel(q_pfn, vm_dev->base + VIRTIO_MMIO_QUEUE_PFN);
>  	} else {
>  		u64 addr;
>  
> @@ -430,6 +444,8 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
>  
>  	return vq;
>  
> +error_bad_pfn:
> +	vring_del_virtqueue(vq);
>  error_new_virtqueue:
>  	if (vm_dev->version == 1) {
>  		writel(0, vm_dev->base + VIRTIO_MMIO_QUEUE_PFN);
> -- 
> 2.7.4
