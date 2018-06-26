From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v2 3/5] iommu/virtio: Add probe request
Date: Tue, 26 Jun 2018 18:59:26 +0100
Message-ID: <057c626c-f870-f99e-93f0-058cd75b02b9@arm.com>
References: <20180621190655.56391-1-jean-philippe.brucker@arm.com>
 <20180621190655.56391-4-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <virtio-dev-return-4548-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20180621190655.56391-4-jean-philippe.brucker@arm.com>
Content-Language: en-US
To: iommu@lists.linux-foundation.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, devicetree@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: joro@8bytes.org, alex.williamson@redhat.com, robh+dt@kernel.org, mark.rutland@arm.com, mst@redhat.com, jasowang@redhat.com, marc.zyngier@arm.com, robin.murphy@arm.com, will.deacon@arm.com, lorenzo.pieralisi@arm.com, eric.auger@redhat.com, peterx@redhat.com, bharat.bhushan@nxp.com, tnowicki@caviumnetworks.com, jayachandran.nair@cavium.com, kevin.tian@intel.com
List-Id: kvmarm@lists.cs.columbia.edu

On 21/06/18 20:06, Jean-Philippe Brucker wrote:
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

Hm, I messed it up while rebasing. I'll remove this condition.

Thanks,
Jean

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
