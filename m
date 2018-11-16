From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v4 5/7] iommu: Add virtio-iommu driver
Date: Fri, 16 Nov 2018 18:46:54 +0000
Message-ID: <41460260-417b-762f-f007-ccfd5ac1e8a5@arm.com>
References: <20181115165234.43990-1-jean-philippe.brucker@arm.com>
 <20181115165234.43990-6-jean-philippe.brucker@arm.com>
 <64abfb83-c555-c518-1030-cb73846517fc@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <virtio-dev-return-4978-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <64abfb83-c555-c518-1030-cb73846517fc@redhat.com>
Content-Language: en-US
To: Auger Eric <eric.auger@redhat.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>, "joro@8bytes.org" <joro@8bytes.org>, "mst@redhat.com" <mst@redhat.com>
Cc: "frowand.list@gmail.com" <frowand.list@gmail.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>, "bhelgaas@google.com" <bhelgaas@google.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "tnowicki@caviumnetworks.com" <tnowicki@caviumnetworks.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Robin Murphy <Robin.Murphy@arm.com>, Will Deacon <Will.Deacon@arm.com>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, "bharat.bhushan@nxp.com" <bharat.bhushan@nxp.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 16/11/2018 06:08, Auger Eric wrote:
>> +struct viommu_domain {
>> +	struct iommu_domain		domain;
>> +	struct viommu_dev		*viommu;
>> +	struct mutex			mutex;
> same naming/comment as in smmu driver may help here
> struct mutex                 init_mutex; /* Protects viommu pointer */

ok

>> +	unsigned int			id;
>> +
>> +	spinlock_t			mappings_lock;
>> +	struct rb_root_cached		mappings;
>> +
>> +	unsigned long			nr_endpoints;
>> +};
>> +
>> +struct viommu_endpoint {
>> +	struct viommu_dev		*viommu;
>> +	struct viommu_domain		*vdomain;
>> +};
>> +
>> +struct viommu_request {
>> +	struct list_head		list;
>> +	void				*writeback;
>> +	unsigned int			write_offset;
>> +	unsigned int			len;
>> +	char				buf[];
>> +};
>> +
>> +#define to_viommu_domain(domain)	\
>> +	container_of(domain, struct viommu_domain, domain)
>> +
>> +static int viommu_get_req_errno(void *buf, size_t len)
>> +{
>> +	struct virtio_iommu_req_tail *tail = buf + len - sizeof(*tail);
>> +
>> +	switch (tail->status) {
>> +	case VIRTIO_IOMMU_S_OK:
>> +		return 0;
>> +	case VIRTIO_IOMMU_S_UNSUPP:
>> +		return -ENOSYS;
>> +	case VIRTIO_IOMMU_S_INVAL:
>> +		return -EINVAL;
>> +	case VIRTIO_IOMMU_S_RANGE:
>> +		return -ERANGE;
>> +	case VIRTIO_IOMMU_S_NOENT:
>> +		return -ENOENT;
>> +	case VIRTIO_IOMMU_S_FAULT:
>> +		return -EFAULT;
>> +	case VIRTIO_IOMMU_S_IOERR:
>> +	case VIRTIO_IOMMU_S_DEVERR:
>> +	default:
>> +		return -EIO;
>> +	}
>> +}
>> +
>> +static void viommu_set_req_status(void *buf, size_t len, int status)
>> +{
>> +	struct virtio_iommu_req_tail *tail = buf + len - sizeof(*tail);
>> +
>> +	tail->status = status;
>> +}
>> +
>> +static off_t viommu_get_req_offset(struct viommu_dev *viommu,
>> +				   struct virtio_iommu_req_head *req,
>> +				   size_t len)
> nit: viommu_get_write_desc_offset would be more self-explanatory?

ok

>> +{
>> +	size_t tail_size = sizeof(struct virtio_iommu_req_tail);
>> +
>> +	return len - tail_size;
>> +}
>> +
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
>> +		if (req->writeback && len >= write_len)
> I don't get "len >= write_len". Is it valid for the device to write more
> than write_len? If it writes less than write_len, the status is not set,
> is it?

No on both counts, I'll change this to ==

There is a problem in the spec regarding this: to get the status, the
driver expects the device to set len to the size of the whole writeable
part of the buffer, even if it only filled a few properties. But the
device doesn't have to do it at the moment. I need to change this sentence:

	The device MAY fill the remaining bytes of properties, if any,
	with zeroes.

Into somthing like:

	The device SHOULD fill the remaining bytes of properties, if
	any, with zeroes.

The QEMU and kvmtool devices already do this.

>> +			memcpy(req->writeback, req->buf + req->write_offset,
>> +			       write_len);
>> +
>> +		list_del(&req->list);
>> +		kfree(req);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int viommu_sync_req(struct viommu_dev *viommu)
>> +{
>> +	int ret;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&viommu->request_lock, flags);
>> +	ret = __viommu_sync_req(viommu);
>> +	if (ret)
>> +		dev_dbg(viommu->dev, "could not sync requests (%d)\n", ret);
>> +	spin_unlock_irqrestore(&viommu->request_lock, flags);
>> +
>> +	return ret;
>> +}
>> +
>> +/*
>> + * __viommu_add_request - Add one request to the queue
>> + * @buf: pointer to the request buffer
>> + * @len: length of the request buffer
>> + * @writeback: copy data back to the buffer when the request completes.
>> + *
>> + * Add a request to the queue. Only synchronize the queue if it's already full.
>> + * Otherwise don't kick the queue nor wait for requests to complete.
>> + *
>> + * When @writeback is true, data written by the device, including the request
>> + * status, is copied into @buf after the request completes. This is unsafe if
>> + * the caller allocates @buf on stack and drops the lock between add_req() and
>> + * sync_req().
>> + *
>> + * Return 0 if the request was successfully added to the queue.
>> + */
>> +static int __viommu_add_req(struct viommu_dev *viommu, void *buf, size_t len,
>> +			    bool writeback)
>> +{
>> +	int ret;
>> +	off_t write_offset;
>> +	struct viommu_request *req;
>> +	struct scatterlist top_sg, bottom_sg;
>> +	struct scatterlist *sg[2] = { &top_sg, &bottom_sg };
>> +	struct virtqueue *vq = viommu->vqs[VIOMMU_REQUEST_VQ];
>> +
>> +	assert_spin_locked(&viommu->request_lock);
>> +
>> +	write_offset = viommu_get_req_offset(viommu, buf, len);
>> +	if (!write_offset)
> could be < 0 as well?

Ah, yes

[...]
>> +/*
>> + * viommu_del_mappings - remove mappings from the internal tree
>> + *
>> + * @vdomain: the domain
>> + * @iova: start of the range
>> + * @size: size of the range. A size of 0 corresponds to the entire address
>> + *	space.
>> + *
>> + * On success, returns the number of unmapped bytes (>= size)
>> + */
>> +static size_t viommu_del_mappings(struct viommu_domain *vdomain,
>> +				  unsigned long iova, size_t size)
>> +{
>> +	size_t unmapped = 0;
>> +	unsigned long flags;
>> +	unsigned long last = iova + size - 1;
>> +	struct viommu_mapping *mapping = NULL;
>> +	struct interval_tree_node *node, *next;
>> +
>> +	spin_lock_irqsave(&vdomain->mappings_lock, flags);
>> +	next = interval_tree_iter_first(&vdomain->mappings, iova, last);
>> +	while (next) {
>> +		node = next;
>> +		mapping = container_of(node, struct viommu_mapping, iova);
>> +		next = interval_tree_iter_next(node, iova, last);
>> +
>> +		/* Trying to split a mapping? */
>> +		if (mapping->iova.start < iova)
>> +			break;
>> +
>> +		/*
>> +		 * Note that for a partial range, this will return the full
>> +		 * mapping so we avoid sending split requests to the device.
>> +		 */
> This comment is not crystal clear to me, ie. why do we remove the entire
> node even if @size is less than mapping->iova.last - mapping->iova.start
> + 1.

The spec forbids splitting mappings (2.6.6 UNMAP request):

(4) a = map(start=0, end=9);
    unmap(start=0, end=4) -> faults, doesn't unmap anything

The rationale is that it complicates the implementation on both sides
and probably isn't useful. It's also the VFIO semantics - if the host is
VFIO, then UNMAP will return an error if you try to split a range like this.

On the guest side though, passing a size smaller than what was mapped is
valid, and the IOMMU API expects us to return the actual unmapped size.
The guest VFIO driver tests this behavior in vfio_test_domain_fgsp().


I could also remove the "Trying to split a mapping" check above, which
rejects things like:

iommu_map(iova=0, sz=2)
iommu_unmap(iova=1, sz=1)

We could simply turn this into an UNMAP request for range [0, 1]. But I
don't think we care at the moment. If the caller is the DMA API, then it
requires the same dma_handle in alloc() and free(). If it is VFIO, then
it rejects this kind of request from userspace.

>> +		unmapped += mapping->iova.last - mapping->iova.start + 1;
>> +
>> +		interval_tree_remove(node, &vdomain->mappings);
>> +		kfree(mapping);
>> +	}
>> +	spin_unlock_irqrestore(&vdomain->mappings_lock, flags);
>> +
>> +	return unmapped;
>> +}
>> +
>> +/*
>> + * viommu_replay_mappings - re-send MAP requests
>> + *
>> + * When reattaching a domain that was previously detached from all endpoints,
>> + * mappings were deleted from the device. Re-create the mappings available in
>> + * the internal tree.
>> + */
>> +static int viommu_replay_mappings(struct viommu_domain *vdomain)
>> +{
>> +	int ret = 0;
>> +	unsigned long flags;
>> +	struct viommu_mapping *mapping;
>> +	struct interval_tree_node *node;
>> +	struct virtio_iommu_req_map map;
>> +
>> +	spin_lock_irqsave(&vdomain->mappings_lock, flags);
>> +	node = interval_tree_iter_first(&vdomain->mappings, 0, -1UL);
>> +	while (node) {
>> +		mapping = container_of(node, struct viommu_mapping, iova);
>> +		map = (struct virtio_iommu_req_map) {
>> +			.head.type	= VIRTIO_IOMMU_T_MAP,
>> +			.domain		= cpu_to_le32(vdomain->id),
>> +			.virt_start	= cpu_to_le64(mapping->iova.start),
>> +			.virt_end	= cpu_to_le64(mapping->iova.last),
>> +			.phys_start	= cpu_to_le64(mapping->paddr),
>> +			.flags		= cpu_to_le32(mapping->flags),
>> +		};
>> +
>> +		ret = viommu_send_req_sync(vdomain->viommu, &map, sizeof(map));
>> +		if (ret)
>> +			break;
>> +
>> +		node = interval_tree_iter_next(node, 0, -1UL);
>> +	}
>> +	spin_unlock_irqrestore(&vdomain->mappings_lock, flags);
>> +
>> +	return ret;
>> +}
>> +
>> +/* IOMMU API */
>> +
>> +static struct iommu_domain *viommu_domain_alloc(unsigned type)
>> +{
>> +	struct viommu_domain *vdomain;
>> +
>> +	if (type != IOMMU_DOMAIN_UNMANAGED && type != IOMMU_DOMAIN_DMA)
> smmu drivers also support the IDENTITY type. Don't we want to support it
> as well?

Eventually yes. The IDENTITY domain is useful when an IOMMU has been
forced upon you and gets in the way of performance, in which case you
get rid of it with CONFIG_IOMMU_DEFAULT_PASSTHROUGH=y or
iommu.passthrough=y. For virtio-iommu though, you could simply not
instantiate the device.

I don't think it's difficult to add: if the device supports
VIRTIO_IOMMU_F_BYPASS, then we simply don't send an ATTACH request.
Otherwise after ATTACH we send a MAP for the whole input range. If the
change isn't bigger than this, I'll add it to v5.

>> +		return NULL;
>> +
>> +	vdomain = kzalloc(sizeof(*vdomain), GFP_KERNEL);
>> +	if (!vdomain)
>> +		return NULL;
>> +
>> +	mutex_init(&vdomain->mutex);
>> +	spin_lock_init(&vdomain->mappings_lock);
>> +	vdomain->mappings = RB_ROOT_CACHED;
>> +
>> +	if (type == IOMMU_DOMAIN_DMA &&
>> +	    iommu_get_dma_cookie(&vdomain->domain)) {
>> +		kfree(vdomain);
>> +		return NULL;
>> +	}
>> +
>> +	return &vdomain->domain;
>> +}
>> +
>> +static int viommu_domain_finalise(struct viommu_dev *viommu,
>> +				  struct iommu_domain *domain)
>> +{
>> +	int ret;
>> +	struct viommu_domain *vdomain = to_viommu_domain(domain);
>> +	unsigned int max_domain = viommu->domain_bits > 31 ? ~0 :
>> +				  (1U << viommu->domain_bits) - 1;
>> +
>> +	vdomain->viommu		= viommu;
>> +
>> +	domain->pgsize_bitmap	= viommu->pgsize_bitmap;
>> +	domain->geometry	= viommu->geometry;
>> +
>> +	ret = ida_alloc_max(&viommu->domain_ids, max_domain, GFP_KERNEL);
>> +	if (ret >= 0)
>> +		vdomain->id = (unsigned int)ret;
>> +
>> +	return ret > 0 ? 0 : ret;
>> +}
>> +
>> +static void viommu_domain_free(struct iommu_domain *domain)
>> +{
>> +	struct viommu_domain *vdomain = to_viommu_domain(domain);
>> +
>> +	iommu_put_dma_cookie(domain);
>> +
>> +	/* Free all remaining mappings (size 2^64) */
>> +	viommu_del_mappings(vdomain, 0, 0);
>> +
>> +	if (vdomain->viommu)
>> +		ida_free(&vdomain->viommu->domain_ids, vdomain->id);
>> +
>> +	kfree(vdomain);
>> +}
>> +
>> +static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
>> +{
>> +	int i;
>> +	int ret = 0;
>> +	struct virtio_iommu_req_attach req;
>> +	struct iommu_fwspec *fwspec = dev->iommu_fwspec;
>> +	struct viommu_endpoint *vdev = fwspec->iommu_priv;
>> +	struct viommu_domain *vdomain = to_viommu_domain(domain);
>> +
>> +	mutex_lock(&vdomain->mutex);
>> +	if (!vdomain->viommu) {
>> +		/*
>> +		 * Initialize the domain proper now that we know which viommu
> properly initialize the domain now we know which viommu owns it?

Sure

Thanks!
Jean
