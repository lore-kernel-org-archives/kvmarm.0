From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC PATCH v2 1/5] iommu: Add virtio-iommu driver
Date: Tue, 16 Jan 2018 17:45:05 +0000
Message-ID: <5011918c-0893-8098-a0d2-e340bd740871@arm.com>
References: <20171117185211.32593-1-jean-philippe.brucker@arm.com>
 <20171117185211.32593-2-jean-philippe.brucker@arm.com>
 <54320f26-05a5-9a09-f6cf-ae610c41e077@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54320f26-05a5-9a09-f6cf-ae610c41e077@redhat.com>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "devel@acpica.org" <devel@acpica.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>
Cc: "jasowang@redhat.com" <jasowang@redhat.com>, "mst@redhat.com" <mst@redhat.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, Sudeep Holla <Sudeep.Holla@arm.com>, "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, "lenb@kernel.org" <lenb@kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, Marc Zyngier <Marc.Zyngier@arm.com>, Robin Murphy <Robin.Murphy@arm.com>, Will Deacon <Will.Deacon@arm.com>, "bharat.bhushan@nxp.com" <bharat.bhushan@nxp.com>, "Jayachandran.Nair@cavium.com" <Jayachandran.Nair@cavium.com>, "ashok.raj@intel.com" <ashok.raj@intel.com>, peterx@red
List-Id: kvmarm@lists.cs.columbia.edu

On 15/01/18 15:12, Auger Eric wrote:
[...]
>> +/*
>> + * viommu_get_req_size - compute request size
>> + *
>> + * A virtio-iommu request is split into one device-read-only part (top) and one
>> + * device-write-only part (bottom). Given a request, return the sizes of the two
>> + * parts in @top and @bottom.
> for all but virtio_iommu_req_probe, which has a variable bottom size

The comment still stands for the probe request, viommu_get_req_size will
return @bottom depending on viommu->probe_size.

[...]
>> +/* Must be called with request_lock held */
>> +static int _viommu_send_reqs_sync(struct viommu_dev *viommu,
>> +				  struct viommu_request *req, int nr,
>> +				  int *nr_sent)
>> +{
>> +	int i, ret;
>> +	ktime_t timeout;
>> +	LIST_HEAD(pending);
>> +	int nr_received = 0;
>> +	struct scatterlist *sg[2];
>> +	/*
>> +	 * Yes, 1s timeout. As a guest, we don't necessarily have a precise
>> +	 * notion of time and this just prevents locking up a CPU if the device
>> +	 * dies.
>> +	 */
>> +	unsigned long timeout_ms = 1000;
>> +
>> +	*nr_sent = 0;
>> +
>> +	for (i = 0; i < nr; i++, req++) {
>> +		req->written = 0;
>> +
>> +		sg[0] = &req->top;
>> +		sg[1] = &req->bottom;
>> +
>> +		ret = virtqueue_add_sgs(viommu->vq, sg, 1, 1, req,
>> +					GFP_ATOMIC);
>> +		if (ret)
>> +			break;
>> +
>> +		list_add_tail(&req->list, &pending);
>> +	}
>> +
>> +	if (i && !virtqueue_kick(viommu->vq))
>> +		return -EPIPE;
>> +
>> +	timeout = ktime_add_ms(ktime_get(), timeout_ms * i);
> I don't really understand how you choose your timeout value: 1s per sent
> request.

1s isn't a good timeout value, but I don't know what's good. In a
prototype I have, even 1s isn't enough. The attach request (for nested
mode) requires my device to pin down the whole guest memory, and the guest
ends up timing out on the fastmodel because the request takes too long and
the model timer runs too fast...

I was tempted to simply remove this timeout, but I still think having a
way out when the host device fails is preferable. Otherwise this
completely locks up the CPU.

>> +	while (nr_received < i && ktime_before(ktime_get(), timeout)) {
>> +		nr_received += viommu_receive_resp(viommu, i - nr_received,
>> +						   &pending);
>> +		if (nr_received < i) {
>> +			/*
>> +			 * FIXME: what's a good way to yield to host? A second
>> +			 * virtqueue_kick won't have any effect since we haven't
>> +			 * added any descriptor.
>> +			 */
>> +			udelay(10);
> could you explain why udelay gets used here?

I was hoping this could switch to the host quicker than cpu_relax(),
allowing it to handle the request faster (on ARM udelay could do WFE
instead of YIELD). The value is completely arbitrary.

Maybe I can replace this with cpu_relax for now. I'd like to refine this
function anyway when working on performance improvements, but I'm not too
hopeful we'll get something nicer here.

[...]
>> +/*
>> + * viommu_send_req_sync - send one request and wait for reply
>> + *
>> + * @top: pointer to a virtio_iommu_req_* structure
>> + *
>> + * Returns 0 if the request was successful, or an error number otherwise. No
>> + * distinction is done between transport and request errors.
>> + */
>> +static int viommu_send_req_sync(struct viommu_dev *viommu, void *top)
>> +{
>> +	int ret;
>> +	int nr_sent;
>> +	void *bottom;
>> +	struct viommu_request req = {0};
>          ^
> drivers/iommu/virtio-iommu.c:326:9: warning: (near initialization for
> ‘req.top’) [-Wmissing-braces]

Ok

[...]
>> +/*
>> + * viommu_del_mappings - remove mappings from the internal tree
>> + *
>> + * @vdomain: the domain
>> + * @iova: start of the range
>> + * @size: size of the range. A size of 0 corresponds to the entire address
>> + *	space.
>> + * @out_mapping: if not NULL, the first removed mapping is returned in there.
>> + *	This allows the caller to reuse the buffer for the unmap request. Caller
>> + *	must always free the returned mapping, whether the function succeeds or
>> + *	not.
> if unmapped > 0?

Ok

>> + *
>> + * On success, returns the number of unmapped bytes (>= size)
>> + */
>> +static size_t viommu_del_mappings(struct viommu_domain *vdomain,
>> +				 unsigned long iova, size_t size,
>> +				 struct viommu_mapping **out_mapping)
>> +{
>> +	size_t unmapped = 0;
>> +	unsigned long flags;
>> +	unsigned long last = iova + size - 1;
>> +	struct viommu_mapping *mapping = NULL;
>> +	struct interval_tree_node *node, *next;
>> +
>> +	spin_lock_irqsave(&vdomain->mappings_lock, flags);
>> +	next = interval_tree_iter_first(&vdomain->mappings, iova, last);
>> +
>> +	if (next) {
>> +		mapping = container_of(next, struct viommu_mapping, iova);
>> +		/* Trying to split a mapping? */
>> +		if (WARN_ON(mapping->iova.start < iova))
>> +			next = NULL;
>> +	}
>> +
>> +	while (next) {
>> +		node = next;
>> +		mapping = container_of(node, struct viommu_mapping, iova);
>> +
>> +		next = interval_tree_iter_next(node, iova, last);
>> +
>> +		/*
>> +		 * Note that for a partial range, this will return the full
>> +		 * mapping so we avoid sending split requests to the device.
>> +		 */
>> +		unmapped += mapping->iova.last - mapping->iova.start + 1;
>> +
>> +		interval_tree_remove(node, &vdomain->mappings);
>> +
>> +		if (out_mapping && !(*out_mapping))
>> +			*out_mapping = mapping;
>> +		else
>> +			kfree(mapping);
>> +	}
>> +	spin_unlock_irqrestore(&vdomain->mappings_lock, flags);
>> +
>> +	return unmapped;
>> +}
>> +
>> +/*
>> + * viommu_replay_mappings - re-send MAP requests
>> + *
>> + * When reattaching a domain that was previously detached from all devices,
>> + * mappings were deleted from the device. Re-create the mappings available in
>> + * the internal tree.
>> + *
>> + * Caller should hold the mapping lock if necessary.
> the only caller does not hold the lock. At this point we are attaching
> our fisrt ep to the domain. I think it would be worth a comment in the
> caller.

Right

[...]
>> +	/*
>> +	 * When attaching the device to a new domain, it will be detached from
>> +	 * the old one and, if as as a result the old domain isn't attached to
> as as
>> +	 * any device, all mappings are removed from the old domain and it is
>> +	 * freed. (Note that we can't use get_domain_for_dev here, it returns
>> +	 * the default domain during initial attach.)
> I don't see where the old domain is freed. I see you descrement the
> endpoints ref count. Also if you replay the mapping, I guess the
> mappings were not destroyed?

That comment applies to the virtio-iommu domain - the virtio-iommu
device needs to destroy the old domain when attaching to a new domain,
to avoid any mapping leak. I'll change the comment to clarify this.

In the kernel the domain lifetime differs from the virtio-iommu domain,
the detached domain isn't freed until someone calls free_domain()
explicitly:

- Initially each device is attached to the default domain, used for
  kernel DMA.
- Then VFIO attaches the group to a new domain. The IOMMU core calls
  attach_dev(). Default domain is detached and the VFIO domain is
  attached.
- When VFIO removes the device from its container, the IOMMU core
  attaches the default domain again. The default domain may still have
  mappings (SW_MSI for instance) but the device deleted them, so they
  need to be replayed after the attach request.
- VFIO issues iommu_domain_free when no group is attached to the VFIO
  domain anymore.

>> +	 *
>> +	 * Take note of the device disappearing, so we can ignore unmap request
>> +	 * on stale domains (that is, between this detach and the upcoming
>> +	 * free.)
>> +	 *
>> +	 * vdev->vdomain is protected by group->mutex
>> +	 */
>> +	if (vdev->vdomain)
>> +		refcount_dec(&vdev->vdomain->endpoints);
>> +
>> +	/* DMA to the stack is forbidden, store request on the heap */
>> +	req = kzalloc(sizeof(*req), GFP_KERNEL);
>> +	if (!req)
>> +		return -ENOMEM;
>> +
>> +	*req = (struct virtio_iommu_req_attach) {
>> +		.head.type	= VIRTIO_IOMMU_T_ATTACH,
>> +		.domain		= cpu_to_le32(vdomain->id),
>> +	};
>> +
>> +	for (i = 0; i < fwspec->num_ids; i++) {
>> +		req->endpoint = cpu_to_le32(fwspec->ids[i]);
>> +
>> +		ret = viommu_send_req_sync(vdomain->viommu, req);
>> +		if (ret)
>> +			break;
>> +	}
>> +
>> +	kfree(req);
>> +
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (!refcount_read(&vdomain->endpoints)) {
>> +		/*
>> +		 * This endpoint is the first to be attached to the domain.
>> +		 * Replay existing mappings if any.
>> +		 */
>> +		ret = viommu_replay_mappings(vdomain);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	refcount_inc(&vdomain->endpoints);
> This does not work for me as the ref counter is initialized to 0 and
> ref_count does not work if the counter is 0. It emits a WARN_ON and
> stays at 0. I worked around the issue by explicitly setting
> recount_set(&vdomain->endpoints, 1) if it was 0 and reffount_inc otherwise.

Yes, I went back to a simple int instead of refcount

[...]
>> +
>> +struct virtio_iommu_config {
>> +	/* Supported page sizes */
>> +	__u64					page_size_mask;
> Get a warning
> ./usr/include/linux/virtio_iommu.h:45: found __[us]{8,16,32,64} type
> without #include <linux/types.h>

Right, adding HEADERS_CHECK to my config :)

Thanks a lot the review,
Jean

