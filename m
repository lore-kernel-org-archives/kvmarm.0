From: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v5 5/7] iommu: Add virtio-iommu driver
Date: Tue, 11 Dec 2018 16:29:37 +0000
Message-ID: <2a34ceb8-da24-fd24-f181-7d1ab15be8f8@arm.com>
References: <20181122193801.50510-1-jean-philippe.brucker@arm.com>
	<20181122193801.50510-6-jean-philippe.brucker@arm.com>
	<20181123165742-mutt-send-email-mst@kernel.org>
	<fd221210-7e12-1d15-0c80-52a761f6893d@arm.com>
	<20181127125424-mutt-send-email-mst@kernel.org>
	<ef97313f-4795-9537-e0b8-8bf6751db6a6@arm.com>
	<20181127131455-mutt-send-email-mst@kernel.org>
	<29bdf062-06cb-4b7d-1753-33fac609ddc3@arm.com>
	<20181210175132-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20181210175132-mutt-send-email-mst-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org" <virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org>, "tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org" <tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Marc Zyngier <Marc.Zyngier-5wv7dgnIgG8@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Robin Murphy <Robin.Murphy-5wv7dgnIgG8@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/12/2018 22:53, Michael S. Tsirkin wrote:
> On Mon, Dec 10, 2018 at 03:06:47PM +0000, Jean-Philippe Brucker wrote:
>> On 27/11/2018 18:53, Michael S. Tsirkin wrote:
>>> On Tue, Nov 27, 2018 at 06:10:46PM +0000, Jean-Philippe Brucker wrote:
>>>> On 27/11/2018 18:04, Michael S. Tsirkin wrote:
>>>>> On Tue, Nov 27, 2018 at 05:50:50PM +0000, Jean-Philippe Brucker wrote:
>>>>>> On 23/11/2018 22:02, Michael S. Tsirkin wrote:
>>>>>>>> +/*
>>>>>>>> + * __viommu_sync_req - Complete all in-flight requests
>>>>>>>> + *
>>>>>>>> + * Wait for all added requests to complete. When this function returns, all
>>>>>>>> + * requests that were in-flight at the time of the call have completed.
>>>>>>>> + */
>>>>>>>> +static int __viommu_sync_req(struct viommu_dev *viommu)
>>>>>>>> +{
>>>>>>>> +	int ret = 0;
>>>>>>>> +	unsigned int len;
>>>>>>>> +	size_t write_len;
>>>>>>>> +	struct viommu_request *req;
>>>>>>>> +	struct virtqueue *vq = viommu->vqs[VIOMMU_REQUEST_VQ];
>>>>>>>> +
>>>>>>>> +	assert_spin_locked(&viommu->request_lock);
>>>>>>>> +
>>>>>>>> +	virtqueue_kick(vq);
>>>>>>>> +
>>>>>>>> +	while (!list_empty(&viommu->requests)) {
>>>>>>>> +		len = 0;
>>>>>>>> +		req = virtqueue_get_buf(vq, &len);
>>>>>>>> +		if (!req)
>>>>>>>> +			continue;
>>>>>>>> +
>>>>>>>> +		if (!len)
>>>>>>>> +			viommu_set_req_status(req->buf, req->len,
>>>>>>>> +					      VIRTIO_IOMMU_S_IOERR);
>>>>>>>> +
>>>>>>>> +		write_len = req->len - req->write_offset;
>>>>>>>> +		if (req->writeback && len == write_len)
>>>>>>>> +			memcpy(req->writeback, req->buf + req->write_offset,
>>>>>>>> +			       write_len);
>>>>>>>> +
>>>>>>>> +		list_del(&req->list);
>>>>>>>> +		kfree(req);
>>>>>>>> +	}
>>>>>>>
>>>>>>> I didn't notice this in the past but it seems this will spin
>>>>>>> with interrupts disabled until host handles the request.
>>>>>>> Please do not do this - host execution can be another
>>>>>>> task that needs the same host CPU. This will then disable
>>>>>>> interrupts for a very very long time.
>>>>>>
>>>>>> In the guest yes, but that doesn't prevent the host from running another
>>>>>> task right?
>>>>>
>>>>> Doesn't prevent it but it will delay it significantly
>>>>> until scheduler decides to kick the VCPU task out.
>>>>>
>>>>>> My tests run fine when QEMU is bound to a single CPU, even
>>>>>> though vcpu and viommu run in different threads
>>>>>>
>>>>>>> What to do then? Queue in software and wake up task.
>>>>>>
>>>>>> Unfortunately I can't do anything here, because IOMMU drivers can't
>>>>>> sleep in the iommu_map() or iommu_unmap() path.
>>>>>>
>>>>>> The problem is the same
>>>>>> for all IOMMU drivers. That's because the DMA API allows drivers to call
>>>>>> some functions with interrupts disabled. For example
>>>>>> Documentation/DMA-API-HOWTO.txt allows dma_alloc_coherent() and
>>>>>> dma_unmap_single() to be called in interrupt context.
>>>>>
>>>>> In fact I don't really understand how it's supposed to
>>>>> work at all: you only sync when ring is full.
>>>>> So host may not have seen your map request if ring
>>>>> is not full.
>>>>> Why is it safe to use the address with a device then?
>>>>
>>>> viommu_map() calls viommu_send_req_sync(), which does the sync
>>>> immediately after adding the MAP request.
>>>>
>>>> Thanks,
>>>> Jean
>>>
>>> I see. So it happens on every request. Maybe you should clear
>>> event index then. This way if exits are disabled you know that
>>> host is processing the ring. Event index is good for when
>>> you don't care when it will be processed, you just want
>>> to reduce number of exits as much as possible.
>>>
>>
>> I think that's already the case: since we don't attach a callback to the
>> request queue, VRING_AVAIL_F_NO_INTERRUPT is set in avail_flags_shadow,
>> which causes the used event index to stay clear.
>>
>> Thanks,
>> Jean
> 
> VRING_AVAIL_F_NO_INTERRUPT has no effect when the event index
> feature has been negotiated. In any case, it also does not
> affect kick notifications from guest - it affects
> device interrupts.

Ok, I thought we were talking about the used event. Then this is a
device-side optimization right?

In QEMU, disabling notifications while processing the queue didn't show
any difference in netperf. Kvmtool already masks events when processing
the ring - if the host is still handling requests while the guest adds
more, then the avail event is at least one behind the new avail index,
and the guest doesn't kick the host.

Anyway I think we can look at optimizations later, since I don't think
there is any trivial one that we can squash into the initial driver.
I'll resend this series with the Kconfig and header change.

Thanks,
Jean
