From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v5 5/7] iommu: Add virtio-iommu driver
Date: Tue, 27 Nov 2018 13:04:08 -0500
Message-ID: <20181127125424-mutt-send-email-mst@kernel.org>
References: <20181122193801.50510-1-jean-philippe.brucker@arm.com>
	<20181122193801.50510-6-jean-philippe.brucker@arm.com>
	<20181123165742-mutt-send-email-mst@kernel.org>
	<fd221210-7e12-1d15-0c80-52a761f6893d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <fd221210-7e12-1d15-0c80-52a761f6893d@arm.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc: mark.rutland@arm.com, virtio-dev@lists.oasis-open.org, lorenzo.pieralisi@arm.com, tnowicki@caviumnetworks.com, devicetree@vger.kernel.org, marc.zyngier@arm.com, linux-pci@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com, virtualization@lists.linux-foundation.org, eric.auger@redhat.com, iommu@lists.linux-foundation.org, robh+dt@kernel.org, bhelgaas@google.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 27, 2018 at 05:50:50PM +0000, Jean-Philippe Brucker wrote:
> On 23/11/2018 22:02, Michael S. Tsirkin wrote:
> >> +/*
> >> + * __viommu_sync_req - Complete all in-flight requests
> >> + *
> >> + * Wait for all added requests to complete. When this function returns, all
> >> + * requests that were in-flight at the time of the call have completed.
> >> + */
> >> +static int __viommu_sync_req(struct viommu_dev *viommu)
> >> +{
> >> +	int ret = 0;
> >> +	unsigned int len;
> >> +	size_t write_len;
> >> +	struct viommu_request *req;
> >> +	struct virtqueue *vq = viommu->vqs[VIOMMU_REQUEST_VQ];
> >> +
> >> +	assert_spin_locked(&viommu->request_lock);
> >> +
> >> +	virtqueue_kick(vq);
> >> +
> >> +	while (!list_empty(&viommu->requests)) {
> >> +		len = 0;
> >> +		req = virtqueue_get_buf(vq, &len);
> >> +		if (!req)
> >> +			continue;
> >> +
> >> +		if (!len)
> >> +			viommu_set_req_status(req->buf, req->len,
> >> +					      VIRTIO_IOMMU_S_IOERR);
> >> +
> >> +		write_len = req->len - req->write_offset;
> >> +		if (req->writeback && len == write_len)
> >> +			memcpy(req->writeback, req->buf + req->write_offset,
> >> +			       write_len);
> >> +
> >> +		list_del(&req->list);
> >> +		kfree(req);
> >> +	}
> > 
> > I didn't notice this in the past but it seems this will spin
> > with interrupts disabled until host handles the request.
> > Please do not do this - host execution can be another
> > task that needs the same host CPU. This will then disable
> > interrupts for a very very long time.
> 
> In the guest yes, but that doesn't prevent the host from running another
> task right?

Doesn't prevent it but it will delay it significantly
until scheduler decides to kick the VCPU task out.

> My tests run fine when QEMU is bound to a single CPU, even
> though vcpu and viommu run in different threads
> 
> > What to do then? Queue in software and wake up task.
> 
> Unfortunately I can't do anything here, because IOMMU drivers can't
> sleep in the iommu_map() or iommu_unmap() path.
>
> The problem is the same
> for all IOMMU drivers. That's because the DMA API allows drivers to call
> some functions with interrupts disabled. For example
> Documentation/DMA-API-HOWTO.txt allows dma_alloc_coherent() and
> dma_unmap_single() to be called in interrupt context.

In fact I don't really understand how it's supposed to
work at all: you only sync when ring is full.
So host may not have seen your map request if ring
is not full.
Why is it safe to use the address with a device then?


> > As kick is vm exit, kick under interrupts disabled is discouraged too:
> > better to prepare for kick enable interrupts then kick.
> 
> That was on my list of things to look at, because it could relax
> things for device drivers that don't call us with interrupts disabled. I
> just tried it and I can see some performance improvement (7% and 4% on
> tcp_stream and tcp_maerts respectively, +/-2.5%).
> 
> Since it's an optimization I'll leave it for later (ACPI and module
> support is higher on my list). The resulting change is complicated
> because we now need to deal with threads adding new requests while
> sync() is running. With my current prototype one thread could end up
> staying in sync() while other threads add new async requests, so I need
> to find a way to bound it.
> 
> Thanks,
> Jean
