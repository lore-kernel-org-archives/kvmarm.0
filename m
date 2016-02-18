From: Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC v3 02/15] vfio: expose MSI mapping requirement through
	VFIO_IOMMU_GET_INFO
Date: Thu, 18 Feb 2016 09:34:54 +0000
Message-ID: <20160218093454.660b20c6@arm.com>
References: <1455264797-2334-1-git-send-email-eric.auger@linaro.org>
	<1455264797-2334-3-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1455264797-2334-3-git-send-email-eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: eric.auger-qxv4g6HH51o@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Thomas.Lendacky-5C7GfCeVMHo@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sherry.hurwitz-5C7GfCeVMHo@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 12 Feb 2016 08:13:04 +0000
Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> This patch allows the user-space to retrieve whether msi write
> transaction addresses must be mapped. This is returned through the
> VFIO_IOMMU_GET_INFO API and its new flag: VFIO_IOMMU_INFO_REQUIRE_MSI_MAP.
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
> Signed-off-by: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> ---
> 
> RFC v1 -> v1:
> - derived from
>   [RFC PATCH 3/6] vfio: Extend iommu-info to return MSIs automap state
> - renamed allow_msi_reconfig into require_msi_mapping
> - fixed VFIO_IOMMU_GET_INFO
> ---
>  drivers/vfio/vfio_iommu_type1.c | 26 ++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       |  1 +
>  2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 6f1ea3d..c5b57e1 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -255,6 +255,29 @@ static int vaddr_get_pfn(unsigned long vaddr, int prot, unsigned long *pfn)
>  }
>  
>  /*
> + * vfio_domains_require_msi_mapping: indicates whether MSI write transaction
> + * addresses must be mapped
> + *
> + * returns true if it does
> + */
> +static bool vfio_domains_require_msi_mapping(struct vfio_iommu *iommu)
> +{
> +	struct vfio_domain *d;
> +	bool ret;
> +
> +	mutex_lock(&iommu->lock);
> +	/* All domains have same require_msi_map property, pick first */
> +	d = list_first_entry(&iommu->domain_list, struct vfio_domain, next);
> +	if (iommu_domain_get_attr(d->domain, DOMAIN_ATTR_MSI_MAPPING, NULL) < 0)
> +		ret = false;
> +	else
> +		ret = true;

nit: this could be simplified as:

ret = (iommu_domain_get_attr(d->domain, DOMAIN_ATTR_MSI_MAPPING, NULL) == 0);

> +	mutex_unlock(&iommu->lock);
> +
> +	return ret;
> +}
> +
> +/*
>   * Attempt to pin pages.  We really don't want to track all the pfns and
>   * the iommu can only map chunks of consecutive pfns anyway, so get the
>   * first page and all consecutive pages with the same locking.
> @@ -997,6 +1020,9 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  
>  		info.flags = VFIO_IOMMU_INFO_PGSIZES;
>  
> +		if (vfio_domains_require_msi_mapping(iommu))
> +			info.flags |= VFIO_IOMMU_INFO_REQUIRE_MSI_MAP;
> +
>  		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
>  
>  		return copy_to_user((void __user *)arg, &info, minsz);
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 7d7a4c6..43e183b 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -400,6 +400,7 @@ struct vfio_iommu_type1_info {
>  	__u32	argsz;
>  	__u32	flags;
>  #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
> +#define VFIO_IOMMU_INFO_REQUIRE_MSI_MAP (1 << 1)/* MSI must be mapped */
>  	__u64	iova_pgsizes;		/* Bitmap of supported page sizes */
>  };
>  


FWIW:

Acked-by: Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>

	M.
-- 
Jazz is not dead. It just smells funny.
