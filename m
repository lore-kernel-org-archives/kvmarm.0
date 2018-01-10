From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v1 01/16] virtio: Validate queue pfn for 32bit transports
Date: Wed, 10 Jan 2018 13:06:44 +0200
Message-ID: <20180110130230-mutt-send-email-mst@kernel.org>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-2-suzuki.poulose@arm.com>
 <20180110012429-mutt-send-email-mst@kernel.org>
 <f53478fc-c0c1-7502-1b8c-c23e332cae9c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1430D49DAD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jan 2018 06:02:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5lZypcwGtNui for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jan 2018 06:02:04 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E09E549D19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jan 2018 06:02:03 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <f53478fc-c0c1-7502-1b8c-c23e332cae9c@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, Jason Wang <jasowang@redhat.com>, ard.biesheuvel@linaro.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, Christoffer Dall <cdall@linaro.org>, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 10, 2018 at 10:54:09AM +0000, Suzuki K Poulose wrote:
> On 09/01/18 23:29, Michael S. Tsirkin wrote:
> > On Tue, Jan 09, 2018 at 07:03:56PM +0000, Suzuki K Poulose wrote:
> > > virtio-mmio using virtio-v1 and virtio legacy pci use a 32bit PFN
> > > for the queue. If the queue pfn is too large to fit in 32bits, which
> > > we could hit on arm64 systems with 52bit physical addresses (even with
> > > 64K page size), we simply miss out a proper link to the other side of
> > > the queue.
> > > 
> > > Add a check to validate the PFN, rather than silently breaking
> > > the devices.
> > > 
> > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > > Cc: Jason Wang <jasowang@redhat.com>
> > > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > > Cc: Christoffer Dall <cdall@linaro.org>
> > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > 
> > Could you guys please work on virtio 1 support in
> > for virtio mmio in qemu though?
> > It's not a lot of code.
> 
> Did you mean kvmtool ? Qemu already supports virto-1.

For virtio-mmio? I don't seem to see that code in
hw/virtio/virtio-mmio.c
For example I still see handling for VIRTIO_MMIO_QUEUE_PFN
there, and no handling for VIRTIO_MMIO_QUEUE_DESC_LOW
and such.

What am I missing?

> > 
> > > ---
> > >   drivers/virtio/virtio_mmio.c       | 19 ++++++++++++++++---
> > >   drivers/virtio/virtio_pci_legacy.c | 11 +++++++++--
> > >   2 files changed, 25 insertions(+), 5 deletions(-)
> > 
> > I'd rather see this as 2 patches.
> 
> OK, I will split them.
> 
> > 
> > > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> > > index a9192fe4f345..47109baf37f7 100644
> > > --- a/drivers/virtio/virtio_mmio.c
> > > +++ b/drivers/virtio/virtio_mmio.c
> > > @@ -358,6 +358,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
> > >   	struct virtqueue *vq;
> > >   	unsigned long flags;
> > >   	unsigned int num;
> > > +	u64 addr;
> > >   	int err;
> > >   	if (!name)
> > > @@ -394,16 +395,26 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
> > >   		goto error_new_virtqueue;
> > >   	}
> > > +	addr = virtqueue_get_desc_addr(vq);
> > > +	/*
> > > +	 * virtio-mmio v1 uses a 32bit QUEUE PFN. If we have something that
> > > +	 * doesn't fit in 32bit, fail the setup rather than pretending to
> > > +	 * be successful.
> > > +	 */
> > > +	if (vm_dev->version == 1 && (addr >> (PAGE_SHIFT + 32))) {
> > > +		dev_err(&vdev->dev, "virtio-mmio: queue address too large\n");
> > > +		err = -ENOMEM;
> > > +		goto error_bad_pfn;
> > > +	}
> > > +
> > 
> > Can you please move this below to where it's actually used?
> > 
> 
> The reason for keeping it here was to skip selecting the Queue number if we
> have a bad PFN.

Why is selecting a problem if we don't program anything?

> May be it doesn't make much difference as we write PFN = 0 anyway
> down.
> 
> > >   	/* Activate the queue */
> > >   	writel(virtqueue_get_vring_size(vq), vm_dev->base + VIRTIO_MMIO_QUEUE_NUM);
> > >   	if (vm_dev->version == 1) {
> > >   		writel(PAGE_SIZE, vm_dev->base + VIRTIO_MMIO_QUEUE_ALIGN);
> > > -		writel(virtqueue_get_desc_addr(vq) >> PAGE_SHIFT,
> > > +		writel(addr >> PAGE_SHIFT,
> > >   				vm_dev->base + VIRTIO_MMIO_QUEUE_PFN);
> > >   	} else {
> > > -		u64 addr;
> > > -		addr = virtqueue_get_desc_addr(vq);
> > >   		writel((u32)addr, vm_dev->base + VIRTIO_MMIO_QUEUE_DESC_LOW);
> > >   		writel((u32)(addr >> 32),
> > >   				vm_dev->base + VIRTIO_MMIO_QUEUE_DESC_HIGH);
> > > @@ -430,6 +441,8 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
> > >   	return vq;
> > > +error_bad_pfn:
> > > +	vring_del_virtqueue(vq);
> > >   error_new_virtqueue:
> > >   	if (vm_dev->version == 1) {
> > >   		writel(0, vm_dev->base + VIRTIO_MMIO_QUEUE_PFN);
> > > diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
> > > index 2780886e8ba3..099d2cfb47b3 100644
> > > --- a/drivers/virtio/virtio_pci_legacy.c
> > > +++ b/drivers/virtio/virtio_pci_legacy.c
> > > @@ -122,6 +122,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
> > >   	struct virtqueue *vq;
> > >   	u16 num;
> > >   	int err;
> > > +	u64 q_pfn;
> > >   	/* Select the queue we're interested in */
> > >   	iowrite16(index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
> > > @@ -141,9 +142,15 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
> > >   	if (!vq)
> > >   		return ERR_PTR(-ENOMEM);
> > > +	q_pfn = virtqueue_get_desc_addr(vq) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT;
> > > +	if (q_pfn >> 32) {
> > > +		dev_err(&vp_dev->pci_dev->dev, "virtio-pci queue PFN too large\n");
> > > +		err = -ENOMEM;
> > > +		goto out_deactivate;
> > 
> > You never set up the address, it's cleaner to add another target
> > and not reset it.
> 
> Thats right. However, the only thing we do is writing PFN=0, which would be a good
> thing to do to indicate the error to the host ?

It isn't, a good way to indicate error is to set a bad status
which happens anyway I think. Writing PFN 0 resets the device
instead.

> I could skip it if you think it is
> not needed.
> 
> 
> Thanks
> Suzuki
