From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v5 5/7] iommu: Add virtio-iommu driver
Date: Tue, 27 Nov 2018 17:50:50 +0000
Message-ID: <fd221210-7e12-1d15-0c80-52a761f6893d@arm.com>
References: <20181122193801.50510-1-jean-philippe.brucker@arm.com>
 <20181122193801.50510-6-jean-philippe.brucker@arm.com>
 <20181123165742-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <virtio-dev-return-5051-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20181123165742-mutt-send-email-mst@kernel.org>
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: mark.rutland@arm.com, virtio-dev@lists.oasis-open.org, lorenzo.pieralisi@arm.com, tnowicki@caviumnetworks.com, devicetree@vger.kernel.org, marc.zyngier@arm.com, linux-pci@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com, virtualization@lists.linux-foundation.org, eric.auger@redhat.com, iommu@lists.linux-foundation.org, robh+dt@kernel.org, bhelgaas@google.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 23/11/2018 22:02, Michael S. Tsirkin wrote:
>> +/*
>> + * __viommu_sync_req - Complete all in-flight requests
>> + *
>> + * Wait for all added requests to complete. When this function returns, all
>> + * requests that were in-flight at the time of the call have completed.
>> + */
>> +static int __viommu_sync_req(struct viommu_dev *viommu)
>> +{
>> +	int ret = 0;
>> +	unsigned int len;
>> +	size_t write_len;
>> +	struct viommu_request *req;
>> +	struct virtqueue *vq = viommu->vqs[VIOMMU_REQUEST_VQ];
>> +
>> +	assert_spin_locked(&viommu->request_lock);
>> +
>> +	virtqueue_kick(vq);
>> +
>> +	while (!list_empty(&viommu->requests)) {
>> +		len = 0;
>> +		req = virtqueue_get_buf(vq, &len);
>> +		if (!req)
>> +			continue;
>> +
>> +		if (!len)
>> +			viommu_set_req_status(req->buf, req->len,
>> +					      VIRTIO_IOMMU_S_IOERR);
>> +
>> +		write_len = req->len - req->write_offset;
>> +		if (req->writeback && len == write_len)
>> +			memcpy(req->writeback, req->buf + req->write_offset,
>> +			       write_len);
>> +
>> +		list_del(&req->list);
>> +		kfree(req);
>> +	}
> 
> I didn't notice this in the past but it seems this will spin
> with interrupts disabled until host handles the request.
> Please do not do this - host execution can be another
> task that needs the same host CPU. This will then disable
> interrupts for a very very long time.

In the guest yes, but that doesn't prevent the host from running another
task right? My tests run fine when QEMU is bound to a single CPU, even
though vcpu and viommu run in different threads

> What to do then? Queue in software and wake up task.

Unfortunately I can't do anything here, because IOMMU drivers can't
sleep in the iommu_map() or iommu_unmap() path. The problem is the same
for all IOMMU drivers. That's because the DMA API allows drivers to call
some functions with interrupts disabled. For example
Documentation/DMA-API-HOWTO.txt allows dma_alloc_coherent() and
dma_unmap_single() to be called in interrupt context.

> As kick is vm exit, kick under interrupts disabled is discouraged too:
> better to prepare for kick enable interrupts then kick.

That was on my list of things to look at, because it could relax
things for device drivers that don't call us with interrupts disabled. I
just tried it and I can see some performance improvement (7% and 4% on
tcp_stream and tcp_maerts respectively, +/-2.5%).

Since it's an optimization I'll leave it for later (ACPI and module
support is higher on my list). The resulting change is complicated
because we now need to deal with threads adding new requests while
sync() is running. With my current prototype one thread could end up
staying in sync() while other threads add new async requests, so I need
to find a way to bound it.

Thanks,
Jean
