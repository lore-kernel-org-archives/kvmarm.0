From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v1 01/16] virtio: Validate queue pfn for 32bit transports
Date: Wed, 10 Jan 2018 11:18:09 +0000
Message-ID: <ba6f3c6f-dd73-398b-b714-dd82df58deed@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-2-suzuki.poulose@arm.com>
 <20180110012429-mutt-send-email-mst@kernel.org>
 <f53478fc-c0c1-7502-1b8c-c23e332cae9c@arm.com>
 <20180110130230-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180110130230-mutt-send-email-mst@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com, Jason Wang <jasowang@redhat.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/01/18 11:06, Michael S. Tsirkin wrote:
> On Wed, Jan 10, 2018 at 10:54:09AM +0000, Suzuki K Poulose wrote:
>> On 09/01/18 23:29, Michael S. Tsirkin wrote:
>>> On Tue, Jan 09, 2018 at 07:03:56PM +0000, Suzuki K Poulose wrote:
>>>> virtio-mmio using virtio-v1 and virtio legacy pci use a 32bit PFN
>>>> for the queue. If the queue pfn is too large to fit in 32bits, which
>>>> we could hit on arm64 systems with 52bit physical addresses (even with
>>>> 64K page size), we simply miss out a proper link to the other side of
>>>> the queue.
>>>>
>>>> Add a check to validate the PFN, rather than silently breaking
>>>> the devices.
>>>>
>>>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>>>> Cc: Jason Wang <jasowang@redhat.com>
>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>> Cc: Christoffer Dall <cdall@linaro.org>
>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>
>>> Could you guys please work on virtio 1 support in
>>> for virtio mmio in qemu though?
>>> It's not a lot of code.
>>
>> Did you mean kvmtool ? Qemu already supports virto-1.
> 
> For virtio-mmio? I don't seem to see that code in
> hw/virtio/virtio-mmio.c
> For example I still see handling for VIRTIO_MMIO_QUEUE_PFN
> there, and no handling for VIRTIO_MMIO_QUEUE_DESC_LOW
> and such.
> 
> What am I missing?

Nah, you're right. Its the PCI that uses QUEUE_DESC_LOW/HIGH.
Btw, I can't work on Qemu.

> 
>>>
>>>> ---
>>>>    drivers/virtio/virtio_mmio.c       | 19 ++++++++++++++++---
>>>>    drivers/virtio/virtio_pci_legacy.c | 11 +++++++++--
>>>>    2 files changed, 25 insertions(+), 5 deletions(-)
>>>
>>> I'd rather see this as 2 patches.
>>
>> OK, I will split them.
>>
>>>
>>>> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
>>>> index a9192fe4f345..47109baf37f7 100644
>>>> --- a/drivers/virtio/virtio_mmio.c
>>>> +++ b/drivers/virtio/virtio_mmio.c
>>>> @@ -358,6 +358,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
>>>>    	struct virtqueue *vq;
>>>>    	unsigned long flags;
>>>>    	unsigned int num;
>>>> +	u64 addr;
>>>>    	int err;
>>>>    	if (!name)
>>>> @@ -394,16 +395,26 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
>>>>    		goto error_new_virtqueue;
>>>>    	}
>>>> +	addr = virtqueue_get_desc_addr(vq);
>>>> +	/*
>>>> +	 * virtio-mmio v1 uses a 32bit QUEUE PFN. If we have something that
>>>> +	 * doesn't fit in 32bit, fail the setup rather than pretending to
>>>> +	 * be successful.
>>>> +	 */
>>>> +	if (vm_dev->version == 1 && (addr >> (PAGE_SHIFT + 32))) {
>>>> +		dev_err(&vdev->dev, "virtio-mmio: queue address too large\n");
>>>> +		err = -ENOMEM;
>>>> +		goto error_bad_pfn;
>>>> +	}
>>>> +
>>>
>>> Can you please move this below to where it's actually used?
>>>
>>
>> The reason for keeping it here was to skip selecting the Queue number if we
>> have a bad PFN.
> 
> Why is selecting a problem if we don't program anything?
> 

I will be honest here, I don't know :-). The only reasoning was why do something
that you are not going to use after all. I will move it down.

>> May be it doesn't make much difference as we write PFN = 0 anyway
>> down.


>>>> --- a/drivers/virtio/virtio_pci_legacy.c
>>>> +++ b/drivers/virtio/virtio_pci_legacy.c
>>>> @@ -122,6 +122,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>>>>    	struct virtqueue *vq;
>>>>    	u16 num;
>>>>    	int err;
>>>> +	u64 q_pfn;
>>>>    	/* Select the queue we're interested in */
>>>>    	iowrite16(index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
>>>> @@ -141,9 +142,15 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>>>>    	if (!vq)
>>>>    		return ERR_PTR(-ENOMEM);
>>>> +	q_pfn = virtqueue_get_desc_addr(vq) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT;
>>>> +	if (q_pfn >> 32) {
>>>> +		dev_err(&vp_dev->pci_dev->dev, "virtio-pci queue PFN too large\n");
>>>> +		err = -ENOMEM;
>>>> +		goto out_deactivate;
>>>
>>> You never set up the address, it's cleaner to add another target
>>> and not reset it.
>>
>> Thats right. However, the only thing we do is writing PFN=0, which would be a good
>> thing to do to indicate the error to the host ?
> 
> It isn't, a good way to indicate error is to set a bad status
> which happens anyway I think. Writing PFN 0 resets the device
> instead.

Ok, thats good to know. I will make the necessary changes. Thanks for the explanation.

Cheers
Suzuki
