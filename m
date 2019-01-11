From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC v3 06/21] vfio: VFIO_IOMMU_BIND_MSI
Date: Fri, 11 Jan 2019 16:02:44 -0700
Message-ID: <20190111160244.107c4f37@x1.home>
References: <20190108102633.17482-1-eric.auger@redhat.com>
        <20190108102633.17482-7-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190108102633.17482-7-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com, kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue,  8 Jan 2019 11:26:18 +0100
Eric Auger <eric.auger@redhat.com> wrote:

> This patch adds the VFIO_IOMMU_BIND_MSI ioctl which aims at
> passing the guest MSI binding to the host.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v2 -> v3:
> - adapt to new proto of bind_guest_msi
> - directly use vfio_iommu_for_each_dev
> 
> v1 -> v2:
> - s/vfio_iommu_type1_guest_msi_binding/vfio_iommu_type1_bind_guest_msi
> ---
>  drivers/vfio/vfio_iommu_type1.c | 27 +++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       |  7 +++++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index c3ba3f249438..59229f6e2d84 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1673,6 +1673,15 @@ static int vfio_cache_inv_fn(struct device *dev, void *data)
>  	return iommu_cache_invalidate(d, dev, &ustruct->info);
>  }
>  
> +static int vfio_bind_guest_msi_fn(struct device *dev, void *data)
> +{
> +	struct vfio_iommu_type1_bind_guest_msi *ustruct =
> +		(struct vfio_iommu_type1_bind_guest_msi *)data;
> +	struct iommu_domain *d = iommu_get_domain_for_dev(dev);
> +
> +	return iommu_bind_guest_msi(d, dev, &ustruct->binding);
> +}
> +
>  static int
>  vfio_set_pasid_table(struct vfio_iommu *iommu,
>  		      struct vfio_iommu_type1_set_pasid_table *ustruct)
> @@ -1792,6 +1801,24 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  					      vfio_cache_inv_fn);
>  		mutex_unlock(&iommu->lock);
>  		return ret;
> +	} else if (cmd == VFIO_IOMMU_BIND_MSI) {
> +		struct vfio_iommu_type1_bind_guest_msi ustruct;
> +		int ret;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_bind_guest_msi,
> +				    binding);
> +
> +		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (ustruct.argsz < minsz || ustruct.flags)
> +			return -EINVAL;
> +
> +		mutex_lock(&iommu->lock);
> +		ret = vfio_iommu_for_each_dev(iommu, &ustruct,
> +					      vfio_bind_guest_msi_fn);

The vfio_iommu_for_each_dev() interface is fine for invalidation, where
a partial failure requires no unwind, but it's not sufficiently robust
here.

> +		mutex_unlock(&iommu->lock);
> +		return ret;
>  	}
>  
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 11a07165e7e1..352e795a93c8 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -774,6 +774,13 @@ struct vfio_iommu_type1_cache_invalidate {
>  };
>  #define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 23)
>  
> +struct vfio_iommu_type1_bind_guest_msi {
> +	__u32   argsz;
> +	__u32   flags;
> +	struct iommu_guest_msi_binding binding;
> +};
> +#define VFIO_IOMMU_BIND_MSI      _IO(VFIO_TYPE, VFIO_BASE + 24)

-ENOCOMMENTS  MSIs are setup and torn down, is this only a machine init
sort of interface?  How does the user un-bind?  Thanks,

Alex

> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*
