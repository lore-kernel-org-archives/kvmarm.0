From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v5 5/7] iommu: Add virtio-iommu driver
Date: Tue, 27 Nov 2018 18:10:46 +0000
Message-ID: <ef97313f-4795-9537-e0b8-8bf6751db6a6@arm.com>
References: <20181122193801.50510-1-jean-philippe.brucker@arm.com>
 <20181122193801.50510-6-jean-philippe.brucker@arm.com>
 <20181123165742-mutt-send-email-mst@kernel.org>
 <fd221210-7e12-1d15-0c80-52a761f6893d@arm.com>
 <20181127125424-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <virtio-dev-return-5058-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20181127125424-mutt-send-email-mst@kernel.org>
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: mark.rutland@arm.com, virtio-dev@lists.oasis-open.org, lorenzo.pieralisi@arm.com, tnowicki@caviumnetworks.com, devicetree@vger.kernel.org, marc.zyngier@arm.com, linux-pci@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com, virtualization@lists.linux-foundation.org, eric.auger@redhat.com, iommu@lists.linux-foundation.org, robh+dt@kernel.org, bhelgaas@google.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 27/11/2018 18:04, Michael S. Tsirkin wrote:
> On Tue, Nov 27, 2018 at 05:50:50PM +0000, Jean-Philippe Brucker wrote:
>> On 23/11/2018 22:02, Michael S. Tsirkin wrote:
>>>> +/*
>>>> + * __viommu_sync_req - Complete all in-flight requests
>>>> + *
>>>> + * Wait for all added requests to complete. When this function returns, all
>>>> + * requests that were in-flight at the time of the call have completed.
>>>> + */
>>>> +static int __viommu_sync_req(struct viommu_dev *viommu)
>>>> +{
>>>> +	int ret = 0;
>>>> +	unsigned int len;
>>>> +	size_t write_len;
>>>> +	struct viommu_request *req;
>>>> +	struct virtqueue *vq = viommu->vqs[VIOMMU_REQUEST_VQ];
>>>> +
>>>> +	assert_spin_locked(&viommu->request_lock);
>>>> +
>>>> +	virtqueue_kick(vq);
>>>> +
>>>> +	while (!list_empty(&viommu->requests)) {
>>>> +		len = 0;
>>>> +		req = virtqueue_get_buf(vq, &len);
>>>> +		if (!req)
>>>> +			continue;
>>>> +
>>>> +		if (!len)
>>>> +			viommu_set_req_status(req->buf, req->len,
>>>> +					      VIRTIO_IOMMU_S_IOERR);
>>>> +
>>>> +		write_len = req->len - req->write_offset;
>>>> +		if (req->writeback && len == write_len)
>>>> +			memcpy(req->writeback, req->buf + req->write_offset,
>>>> +			       write_len);
>>>> +
>>>> +		list_del(&req->list);
>>>> +		kfree(req);
>>>> +	}
>>>
>>> I didn't notice this in the past but it seems this will spin
>>> with interrupts disabled until host handles the request.
>>> Please do not do this - host execution can be another
>>> task that needs the same host CPU. This will then disable
>>> interrupts for a very very long time.
>>
>> In the guest yes, but that doesn't prevent the host from running another
>> task right?
> 
> Doesn't prevent it but it will delay it significantly
> until scheduler decides to kick the VCPU task out.
> 
>> My tests run fine when QEMU is bound to a single CPU, even
>> though vcpu and viommu run in different threads
>>
>>> What to do then? Queue in software and wake up task.
>>
>> Unfortunately I can't do anything here, because IOMMU drivers can't
>> sleep in the iommu_map() or iommu_unmap() path.
>>
>> The problem is the same
>> for all IOMMU drivers. That's because the DMA API allows drivers to call
>> some functions with interrupts disabled. For example
>> Documentation/DMA-API-HOWTO.txt allows dma_alloc_coherent() and
>> dma_unmap_single() to be called in interrupt context.
> 
> In fact I don't really understand how it's supposed to
> work at all: you only sync when ring is full.
> So host may not have seen your map request if ring
> is not full.
> Why is it safe to use the address with a device then?

viommu_map() calls viommu_send_req_sync(), which does the sync
immediately after adding the MAP request.

Thanks,
Jean
