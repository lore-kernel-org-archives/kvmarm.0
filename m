From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH 1/4] iommu: Add virtio-iommu driver
Date: Wed, 11 Apr 2018 19:33:53 +0100
Message-ID: <a67a759a-e12b-998e-40aa-84e539619484@arm.com>
References: <20180214145340.1223-1-jean-philippe.brucker@arm.com>
	<20180214145340.1223-2-jean-philippe.brucker@arm.com>
	<d0cfe602-f6e8-2d6e-0942-23012f3facef@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <d0cfe602-f6e8-2d6e-0942-23012f3facef@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Robin Murphy <robin.murphy@arm.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: "jayachandran.nair@cavium.com" <jayachandran.nair@cavium.com>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, Tomasz.Nowicki@caviumnetworks.com, "tnowicki@caviumnetworks.com" <tnowicki@caviumnetworks.com>, "mst@redhat.com" <mst@redhat.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>, "jintack@cs.columbia.edu" <jintack@cs.columbia.edu>, "eric.auger@redhat.com" <eric.auger@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/03/18 14:48, Robin Murphy wrote:
[..]
>> + * Virtio driver for the paravirtualized IOMMU
>> + *
>> + * Copyright (C) 2018 ARM Limited
>> + * Author: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
>> + *
>> + * SPDX-License-Identifier: GPL-2.0
> 
> This wants to be a // comment at the very top of the file (thankfully 
> the policy is now properly documented in-tree since 
> Documentation/process/license-rules.rst got merged)

Ok

[...]
>> +
>> +/*
>> + * viommu_del_mappings - remove mappings from the internal tree
>> + *
>> + * @vdomain: the domain
>> + * @iova: start of the range
>> + * @size: size of the range. A size of 0 corresponds to the entire address
>> + *	space.
>> + * @out_mapping: if not NULL, the first removed mapping is returned in there.
>> + *	This allows the caller to reuse the buffer for the unmap request. When
>> + *	the returned size is greater than zero, if a mapping is returned, the
>> + *	caller must free it.
> 
> This "free multiple mappings except maybe hand one of them off to the 
> caller" interface is really unintuitive. AFAICS it's only used by 
> viommu_unmap() to grab mapping->req, but that doesn't seem to care about 
> mapping itself, so I wonder whether it wouldn't make more sense to just 
> have a global kmem_cache of struct virtio_iommu_req_unmap for that and 
> avoid a lot of complexity...

Well it's a small complication for what I hoped would be a meanignful
performance difference, but more below.

>> +
>> +/* IOMMU API */
>> +
>> +static bool viommu_capable(enum iommu_cap cap)
>> +{
>> +	return false;
>> +}
> 
> The .capable callback is optional, so it's only worth implementing once 
> you want it to do something beyond the default behaviour.
> 

Ah, right

[...]
>> +static size_t viommu_unmap(struct iommu_domain *domain, unsigned long iova,
>> +			   size_t size)
>> +{
>> +	int ret = 0;
>> +	size_t unmapped;
>> +	struct viommu_mapping *mapping = NULL;
>> +	struct viommu_domain *vdomain = to_viommu_domain(domain);
>> +
>> +	unmapped = viommu_del_mappings(vdomain, iova, size, &mapping);
>> +	if (unmapped < size) {
>> +		ret = -EINVAL;
>> +		goto out_free;
>> +	}
>> +
>> +	/* Device already removed all mappings after detach. */
>> +	if (!vdomain->endpoints)
>> +		goto out_free;
>> +
>> +	if (WARN_ON(!mapping))
>> +		return 0;
>> +
>> +	mapping->req.unmap = (struct virtio_iommu_req_unmap) {
>> +		.head.type	= VIRTIO_IOMMU_T_UNMAP,
>> +		.domain		= cpu_to_le32(vdomain->id),
>> +		.virt_start	= cpu_to_le64(iova),
>> +		.virt_end	= cpu_to_le64(iova + unmapped - 1),
>> +	};
> 
> ...In fact, the kmem_cache idea might be moot since it looks like with a 
> bit of restructuring you could get away with just a single per-viommu 
> virtio_iommu_req_unmap structure; this lot could be passed around on the 
> stack until request_lock is taken, at which point it would be copied 
> into the 'real' DMA-able structure. The equivalent might apply to 
> viommu_map() too - now that I'm looking at it, it seems like it would 
> take pretty minimal effort to encapsulate the whole business cleanly in 
> viommu_send_req_sync(), which could do something like this instead of 
> going through viommu_send_reqs_sync():
> 
> 	...
> 	spin_lock_irqsave(&viommu->request_lock, flags);
> 	viommu_copy_req(viommu->dma_req, req);
> 	ret = _viommu_send_reqs_sync(viommu, viommu->dma_req, 1, &sent);
> 	spin_unlock_irqrestore(&viommu->request_lock, flags);
> 	...

I'll have to come back to that sorry, still conducting some experiments
with map/unmap.

I'd rather avoid introducing a single dma_req per viommu, because I'd
like to move to the iotlb_range_add/iotlb_sync interface as soon as
possible, and the request logic changes a lot when multiple threads are
susceptible to interleave map/unmap requests.

I ran some tests, and adding a kmem_cache (or simply using kmemdup, it
doesn't make a noticeable difference at our scale) reduces netperf
stream/maerts throughput by 1.1%/1.4% (+/- 0.5% over 30 tests). That's
for a virtio-net device (1 tx/rx vq), and with a vfio device the
difference isn't measurable. At this point I'm not fussy about such
small difference, so don't mind simplifying viommu_del_mapping.

[...]
>> +	/*
>> +	 * Last step creates a default domain and attaches to it. Everything
>> +	 * must be ready.
>> +	 */
>> +	group = iommu_group_get_for_dev(dev);
>> +	if (!IS_ERR(group))
>> +		iommu_group_put(group);
> 
> Since you create the sysfs IOMMU device, maybe also create the links for 
> the masters?

Ok

>> +
>> +	return PTR_ERR_OR_ZERO(group);
>> +}
>> +
>> +static void viommu_remove_device(struct device *dev)
>> +{
> 
> You need to remove dev from its group, too (basically, .remove_device 
> should always undo everything .add_device did)
> 
> It would also be good practice to verify that dev->iommu_fwspec exists 
> and is one of yours before touching anything, although having checked 
> the core code I see we do currently just about get away with it thanks 
> to the horrible per-bus ops.

Ok

> 
>> +	kfree(dev->iommu_fwspec->iommu_priv);
>> +}
>> +
>> +static struct iommu_group *viommu_device_group(struct device *dev)
>> +{
>> +	if (dev_is_pci(dev))
>> +		return pci_device_group(dev);
>> +	else
>> +		return generic_device_group(dev);
>> +}
>> +
>> +static int viommu_of_xlate(struct device *dev, struct of_phandle_args *args)
>> +{
>> +	return iommu_fwspec_add_ids(dev, args->args, 1);
> 
> I'm sure a DT binding somewhere needs to document the appropriate value 
> and meaning for #iommu-cells - I guess that probably falls under the 
> virtio-mmio binding?

Yes I guess mmio.txt would be the best place for this.

[...]
>> +/*
>> + * Virtio-iommu definition v0.6
>> + *
>> + * Copyright (C) 2018 ARM Ltd.
>> + *
>> + * SPDX-License-Identifier: BSD-3-Clause
> 
> Again, at the top, although in /* */ here since it's a header.

Right

Thanks for the review,
Jean
