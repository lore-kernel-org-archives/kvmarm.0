From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 01/17] virtio: mmio-v1: Validate queue PFN
Date: Tue, 27 Mar 2018 17:07:27 +0300
Message-ID: <20180327170119-mutt-send-email-mst@kernel.org>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
 <1522156531-28348-2-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1522156531-28348-2-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@kernel.org, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, ard.biesheuvel@linaro.org, peter.maydell@linaro.org, kristina.martsenko@arm.com, mark.rutland@arm.com, Jason Wang <jasowang@redhat.com>, Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 27, 2018 at 02:15:11PM +0100, Suzuki K Poulose wrote:
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

OK - seems harmless so I will queue this.
But I really think effort should be spent on
adding v1.0 support in QEMU.

> ---
>  drivers/virtio/virtio_mmio.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 67763d3..b2f9b5c 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -397,9 +397,21 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
>  	/* Activate the queue */
>  	writel(virtqueue_get_vring_size(vq), vm_dev->base + VIRTIO_MMIO_QUEUE_NUM);
>  	if (vm_dev->version == 1) {
> +		u64 q_pfn = virtqueue_get_desc_addr(vq) >> PAGE_SHIFT;
> +
> +		/*
> +		 * virtio-mmio v1 uses a 32bit QUEUE PFN. If we have something
> +		 * that doesn't fit in 32bit, fail the setup rather than
> +		 * pretending to be successful.
> +		 */
> +		if (q_pfn >> 32) {
> +			dev_err(&vdev->dev, "virtio-mmio: queue address too large\n");
> +			err = -ENOMEM;
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
> @@ -430,6 +442,8 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
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
