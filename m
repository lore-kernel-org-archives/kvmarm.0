From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v5 5/7] iommu: Add virtio-iommu driver
Date: Tue, 27 Nov 2018 17:55:20 +0000
Message-ID: <e76a51ba-7a0f-3fca-a1ae-640131f9dfe1@arm.com>
References: <20181122193801.50510-1-jean-philippe.brucker@arm.com>
 <20181122193801.50510-6-jean-philippe.brucker@arm.com>
 <20181123165206-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <virtio-dev-return-5052-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20181123165206-mutt-send-email-mst@kernel.org>
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: mark.rutland@arm.com, virtio-dev@lists.oasis-open.org, lorenzo.pieralisi@arm.com, tnowicki@caviumnetworks.com, devicetree@vger.kernel.org, marc.zyngier@arm.com, linux-pci@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com, virtualization@lists.linux-foundation.org, eric.auger@redhat.com, iommu@lists.linux-foundation.org, robh+dt@kernel.org, bhelgaas@google.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 23/11/2018 21:56, Michael S. Tsirkin wrote:
>> +config VIRTIO_IOMMU
>> +	bool "Virtio IOMMU driver"
>> +	depends on VIRTIO=y
>> +	select IOMMU_API
>> +	select INTERVAL_TREE
>> +	select ARM_DMA_USE_IOMMU if ARM
>> +	help
>> +	  Para-virtualised IOMMU driver with virtio.
>> +
>> +	  Say Y here if you intend to run this kernel as a guest.
>> +
> 
> Given it is arm specific right now, shouldn't this depend on ARM?
> E.g. there's a hack for x86 right now.

Sure, I'll make it depend on ARM64 for now

[..]
>> +static int viommu_probe(struct virtio_device *vdev)
>> +{
>> +	struct device *parent_dev = vdev->dev.parent;
>> +	struct viommu_dev *viommu = NULL;
>> +	struct device *dev = &vdev->dev;
>> +	u64 input_start = 0;
>> +	u64 input_end = -1UL;
>> +	int ret;
>> +
>> +	if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1) ||
>> +	    !virtio_has_feature(vdev, VIRTIO_IOMMU_F_MAP_UNMAP))
> 
> Why bother with a feature bit for this then btw?

We'll need a new feature bit for sharing page tables with the hardware,
because they require different requests (attach_table/invalidate instead
of map/unmap.) A future device supporting page table sharing won't
necessarily need to support map/unmap.

Thanks,
Jean
