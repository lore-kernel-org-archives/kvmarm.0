From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/5] iommu/virtio: Add probe request
Date: Fri, 22 Jun 2018 03:55:21 +0300
Message-ID: <20180622035442-mutt-send-email-mst@kernel.org>
References: <20180621190655.56391-1-jean-philippe.brucker@arm.com>
	<20180621190655.56391-4-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180621190655.56391-4-jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jayachandran.nair-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 21, 2018 at 08:06:53PM +0100, Jean-Philippe Brucker wrote:
> When the device offers the probe feature, send a probe request for each
> device managed by the IOMMU. Extract RESV_MEM information. When we
> encounter a MSI doorbell region, set it up as a IOMMU_RESV_MSI region.
> This will tell other subsystems that there is no need to map the MSI
> doorbell in the virtio-iommu, because MSIs bypass it.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
> ---
>  drivers/iommu/virtio-iommu.c      | 149 ++++++++++++++++++++++++++++--
>  include/uapi/linux/virtio_iommu.h |  37 ++++++++
>  2 files changed, 180 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
> index ea0242d8624b..29ce9f4398ef 100644
> --- a/drivers/iommu/virtio-iommu.c
> +++ b/drivers/iommu/virtio-iommu.c
> @@ -48,6 +48,7 @@ struct viommu_dev {
>  	struct iommu_domain_geometry	geometry;
>  	u64				pgsize_bitmap;
>  	u8				domain_bits;
> +	u32				probe_size;
>  };
>  
>  struct viommu_mapping {
> @@ -69,8 +70,10 @@ struct viommu_domain {
>  };
>  
>  struct viommu_endpoint {
> +	struct device			*dev;
>  	struct viommu_dev		*viommu;
>  	struct viommu_domain		*vdomain;
> +	struct list_head		resv_regions;
>  };
>  
>  struct viommu_request {
> @@ -121,6 +124,9 @@ static off_t viommu_get_req_offset(struct viommu_dev *viommu,
>  {
>  	size_t tail_size = sizeof(struct virtio_iommu_req_tail);
>  
> +	if (req->type == VIRTIO_IOMMU_T_PROBE)
> +		return len - viommu->probe_size - tail_size;
> +
>  	return len - tail_size;
>  }
>  
> @@ -404,6 +410,103 @@ static int viommu_replay_mappings(struct viommu_domain *vdomain)
>  	return ret;
>  }
>  
> +static int viommu_add_resv_mem(struct viommu_endpoint *vdev,
> +			       struct virtio_iommu_probe_resv_mem *mem,
> +			       size_t len)
> +{
> +	struct iommu_resv_region *region = NULL;
> +	unsigned long prot = IOMMU_WRITE | IOMMU_NOEXEC | IOMMU_MMIO;
> +
> +	u64 start = le64_to_cpu(mem->start);
> +	u64 end = le64_to_cpu(mem->end);
> +	size_t size = end - start + 1;
> +
> +	if (len < sizeof(*mem))
> +		return -EINVAL;
> +
> +	switch (mem->subtype) {
> +	default:
> +		if (mem->subtype != VIRTIO_IOMMU_RESV_MEM_T_RESERVED &&
> +		    mem->subtype != VIRTIO_IOMMU_RESV_MEM_T_MSI)
> +			dev_warn(vdev->dev, "unknown resv mem subtype 0x%x\n",
> +				 mem->subtype);
> +		/* Fall-through */
> +	case VIRTIO_IOMMU_RESV_MEM_T_RESERVED:
> +		region = iommu_alloc_resv_region(start, size, 0,
> +						 IOMMU_RESV_RESERVED);
> +		break;
> +	case VIRTIO_IOMMU_RESV_MEM_T_MSI:
> +		region = iommu_alloc_resv_region(start, size, prot,
> +						 IOMMU_RESV_MSI);
> +		break;
> +	}
> +
> +	list_add(&vdev->resv_regions, &region->list);
> +	return 0;
> +}
> +
> +static int viommu_probe_endpoint(struct viommu_dev *viommu, struct device *dev)
> +{
> +	int ret;
> +	u16 type, len;
> +	size_t cur = 0;
> +	size_t probe_len;
> +	struct virtio_iommu_req_probe *probe;
> +	struct virtio_iommu_probe_property *prop;
> +	struct iommu_fwspec *fwspec = dev->iommu_fwspec;
> +	struct viommu_endpoint *vdev = fwspec->iommu_priv;
> +
> +	if (!fwspec->num_ids)
> +		return -EINVAL;
> +
> +	probe_len = sizeof(*probe) + viommu->probe_size +
> +		    sizeof(struct virtio_iommu_req_tail);
> +	probe = kzalloc(probe_len, GFP_KERNEL);
> +	if (!probe)
> +		return -ENOMEM;
> +
> +	probe->head.type = VIRTIO_IOMMU_T_PROBE;
> +	/*
> +	 * For now, assume that properties of an endpoint that outputs multiple
> +	 * IDs are consistent. Only probe the first one.
> +	 */
> +	probe->endpoint = cpu_to_le32(fwspec->ids[0]);
> +
> +	ret = viommu_send_req_sync(viommu, probe, probe_len);
> +	if (ret)
> +		goto out_free;
> +
> +	prop = (void *)probe->properties;
> +	type = le16_to_cpu(prop->type) & VIRTIO_IOMMU_PROBE_T_MASK;
> +
> +	while (type != VIRTIO_IOMMU_PROBE_T_NONE &&
> +	       cur < viommu->probe_size) {
> +		len = le16_to_cpu(prop->length);
> +
> +		switch (type) {
> +		case VIRTIO_IOMMU_PROBE_T_RESV_MEM:
> +			ret = viommu_add_resv_mem(vdev, (void *)prop->value, len);
> +			break;
> +		default:
> +			dev_dbg(dev, "unknown viommu prop 0x%x\n", type);
> +		}
> +
> +		if (ret)
> +			dev_err(dev, "failed to parse viommu prop 0x%x\n", type);
> +
> +		cur += sizeof(*prop) + len;
> +		if (cur >= viommu->probe_size)
> +			break;
> +
> +		prop = (void *)probe->properties + cur;
> +		type = le16_to_cpu(prop->type) & VIRTIO_IOMMU_PROBE_T_MASK;
> +	}
> +
> +out_free:
> +	kfree(probe);
> +	return ret;
> +}
> +
>  /* IOMMU API */
>  
>  static struct iommu_domain *viommu_domain_alloc(unsigned type)
> @@ -627,15 +730,33 @@ static void viommu_iotlb_sync(struct iommu_domain *domain)
>  
>  static void viommu_get_resv_regions(struct device *dev, struct list_head *head)
>  {
> -	struct iommu_resv_region *region;
> +	struct iommu_resv_region *entry, *new_entry, *msi = NULL;
> +	struct viommu_endpoint *vdev = dev->iommu_fwspec->iommu_priv;
>  	int prot = IOMMU_WRITE | IOMMU_NOEXEC | IOMMU_MMIO;
>  
> -	region = iommu_alloc_resv_region(MSI_IOVA_BASE, MSI_IOVA_LENGTH, prot,
> -					 IOMMU_RESV_SW_MSI);
> -	if (!region)
> -		return;
> +	list_for_each_entry(entry, &vdev->resv_regions, list) {
> +		/*
> +		 * If the device registered a bypass MSI windows, use it.
> +		 * Otherwise add a software-mapped region
> +		 */
> +		if (entry->type == IOMMU_RESV_MSI)
> +			msi = entry;
> +
> +		new_entry = kmemdup(entry, sizeof(*entry), GFP_KERNEL);
> +		if (!new_entry)
> +			return;
> +		list_add_tail(&new_entry->list, head);
> +	}
> +
> +	if (!msi) {
> +		msi = iommu_alloc_resv_region(MSI_IOVA_BASE, MSI_IOVA_LENGTH,
> +					      prot, IOMMU_RESV_SW_MSI);
> +		if (!msi)
> +			return;
> +
> +		list_add_tail(&msi->list, head);
> +	}
>  
> -	list_add_tail(&region->list, head);
>  	iommu_dma_get_resv_regions(dev, head);
>  }
>  
> @@ -683,9 +804,18 @@ static int viommu_add_device(struct device *dev)
>  	if (!vdev)
>  		return -ENOMEM;
>  
> +	vdev->dev = dev;
>  	vdev->viommu = viommu;
> +	INIT_LIST_HEAD(&vdev->resv_regions);
>  	fwspec->iommu_priv = vdev;
>  
> +	if (viommu->probe_size) {
> +		/* Get additional information for this endpoint */
> +		ret = viommu_probe_endpoint(viommu, dev);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	ret = iommu_device_link(&viommu->iommu, dev);
>  	if (ret)
>  		goto err_free_dev;
> @@ -708,6 +838,7 @@ static int viommu_add_device(struct device *dev)
>  	iommu_device_unlink(&viommu->iommu, dev);
>  
>  err_free_dev:
> +	viommu_put_resv_regions(dev, &vdev->resv_regions);
>  	kfree(vdev);
>  
>  	return ret;
> @@ -725,6 +856,7 @@ static void viommu_remove_device(struct device *dev)
>  
>  	iommu_group_remove_device(dev);
>  	iommu_device_unlink(&vdev->viommu->iommu, dev);
> +	viommu_put_resv_regions(dev, &vdev->resv_regions);
>  	kfree(vdev);
>  }
>  
> @@ -821,6 +953,10 @@ static int viommu_probe(struct virtio_device *vdev)
>  			     struct virtio_iommu_config, domain_bits,
>  			     &viommu->domain_bits);
>  
> +	virtio_cread_feature(vdev, VIRTIO_IOMMU_F_PROBE,
> +			     struct virtio_iommu_config, probe_size,
> +			     &viommu->probe_size);
> +
>  	viommu->geometry = (struct iommu_domain_geometry) {
>  		.aperture_start	= input_start,
>  		.aperture_end	= input_end,
> @@ -902,6 +1038,7 @@ static unsigned int features[] = {
>  	VIRTIO_IOMMU_F_MAP_UNMAP,
>  	VIRTIO_IOMMU_F_DOMAIN_BITS,
>  	VIRTIO_IOMMU_F_INPUT_RANGE,
> +	VIRTIO_IOMMU_F_PROBE,
>  };
>  
>  static struct virtio_device_id id_table[] = {
> diff --git a/include/uapi/linux/virtio_iommu.h b/include/uapi/linux/virtio_iommu.h
> index f4fafa0b41a7..2fd802a860cd 100644
> --- a/include/uapi/linux/virtio_iommu.h
> +++ b/include/uapi/linux/virtio_iommu.h
> @@ -14,6 +14,7 @@
>  #define VIRTIO_IOMMU_F_DOMAIN_BITS		1
>  #define VIRTIO_IOMMU_F_MAP_UNMAP		2
>  #define VIRTIO_IOMMU_F_BYPASS			3
> +#define VIRTIO_IOMMU_F_PROBE			4
>  
>  struct virtio_iommu_config {
>  	/* Supported page sizes */
> @@ -25,6 +26,9 @@ struct virtio_iommu_config {
>  	} input_range;
>  	/* Max domain ID size */
>  	__u8					domain_bits;
> +	__u8					padding[3];
> +	/* Probe buffer size */
> +	__u32					probe_size;
>  } __packed;
>  
>  /* Request types */
> @@ -32,6 +36,7 @@ struct virtio_iommu_config {
>  #define VIRTIO_IOMMU_T_DETACH			0x02
>  #define VIRTIO_IOMMU_T_MAP			0x03
>  #define VIRTIO_IOMMU_T_UNMAP			0x04
> +#define VIRTIO_IOMMU_T_PROBE			0x05
>  
>  /* Status types */
>  #define VIRTIO_IOMMU_S_OK			0x00
> @@ -105,6 +110,37 @@ struct virtio_iommu_req_unmap {
>  	struct virtio_iommu_req_tail		tail;
>  } __packed;
>  
> +#define VIRTIO_IOMMU_RESV_MEM_T_RESERVED	0
> +#define VIRTIO_IOMMU_RESV_MEM_T_MSI		1
> +
> +struct virtio_iommu_probe_resv_mem {
> +	__u8					subtype;
> +	__u8					reserved[3];
> +	__le64					start;
> +	__le64					end;
> +} __packed;


start/end are not aligned you need to pad more.

> +
> +#define VIRTIO_IOMMU_PROBE_T_NONE		0
> +#define VIRTIO_IOMMU_PROBE_T_RESV_MEM		1
> +
> +#define VIRTIO_IOMMU_PROBE_T_MASK		0xfff
> +
> +struct virtio_iommu_probe_property {
> +	__le16					type;
> +	__le16					length;
> +	__u8					value[];
> +} __packed;
> +
> +struct virtio_iommu_req_probe {
> +	struct virtio_iommu_req_head		head;
> +	__le32					endpoint;
> +	__u8					reserved[64];
> +
> +	__u8					properties[];
> +
> +	/* Tail follows the variable-length properties array (no padding) */
> +} __packed;
> +
>  union virtio_iommu_req {
>  	struct virtio_iommu_req_head		head;
>  
> @@ -112,6 +148,7 @@ union virtio_iommu_req {
>  	struct virtio_iommu_req_detach		detach;
>  	struct virtio_iommu_req_map		map;
>  	struct virtio_iommu_req_unmap		unmap;
> +	struct virtio_iommu_req_probe		probe;
>  };
>  
>  #endif
> -- 
> 2.17.0
